#!/usr/bin/env bash

set -euo pipefail

which elementsd || exit 1
which xxd || exit 1
which jq || exit 1

datadir="$(pwd)/data"
cli="elements-cli -datadir=$datadir "

# when run in dev mode try stop elementsd and delete datadir
if [[ ${1:-""} == "dev" ]]; then
    $cli stop || true
    sleep 2
    rm -rf $datadir  || true
fi

echo "- setup $datadir/elements.conf"
mkdir -p $datadir || true
echo -n "chain=elementsregtest
rpcuser=user1
rpcpassword=password1
daemon=1
server=1
listen=1
txindex=1
validatepegin=0
initialfreecoins=2100000000000000
fallbackfee=0.0002
[elementsregtest]
rpcport=18884
port=18886
anyonecanspendaremine=1
" > "$datadir/elements.conf"

echo "- start elementsd regtest"
elementsd -datadir=$datadir
sleep 2

echo "- create wallet"
$cli createwallet asdf

echo "- rescan blockchain"
$cli rescanblockchain

echo "- get address"
addr=$($cli getnewaddress)

echo "- send to self"
$cli sendtoaddress $addr 1000000

echo "- generate block"
$cli -generate 1

echo "- get balance"
$cli getbalance

data=$(head -c32 </dev/urandom|xxd -p -c 256)
echo "- data for op_return is: $data"

echo "- create data transaction"
tx=$($cli createrawtransaction "[]" "[{\"$addr\":1.0, \"data\":\"$data\"}]")

echo "- fund data transaction"
ftx=$($cli fundrawtransaction $tx | jq -r .hex)

echo "- blind data transaction"
btx=$($cli blindrawtransaction $ftx)

echo "- sign data transaction"
stx=$($cli signrawtransactionwithwallet $btx | jq -r .hex)

echo "- send data transaction"
txid=$($cli sendrawtransaction $stx)
echo "- txid is: $txid"

echo "- generate block"
$cli -generate 1

echo "- find the op_return from the transaction"
vout=$($cli getrawtransaction $txid true | jq .vout)
out=$(echo $vout | jq ".[]|select(.scriptPubKey.asm == \"OP_RETURN $data\")")
op=$(echo $out | jq -r .scriptPubKey.asm)

echo "$op"
echo "- should match data: $data"

$cli stop

# test equality
if [[ $op = "OP_RETURN $data" ]]; then
    echo "success!"
    exit 0
else
    echo "fail."
    exit 1
fi
