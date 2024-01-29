# elements data demo

a bash script demo to create transactions with op_return data using the elements rpc

### prerequisites

linux or macos. you must have `elementsd`, `jq`, and `xxd` installed and in your path. or install nix and run `nix-shell`.

### run the demo

```bash
$ ./demo.sh
```

### example output

```
- setup elements.conf
- start elementsd regtest
Elements Core starting
- create wallet
{
  "name": "asdf",
  "warning": ""
}
- rescan blockchain
{
  "start_height": 0,
  "stop_height": 0
}
- get address
- send to self
c5c8097258e7adf46eb31f38f6549b789fef1458022e6c78a9889604abbd10f3
- generate block
{
  "address": "el1qqtl685qpp0kkhydhcrap84n3n97r60fu3vnzens290q7srh9e2683kr57y39jcvfm39lwkvjxlqd9shmses8xlzvdvvue2r9g",
  "blocks": [
    "d6bd02b50acac62e6a9b22cc847ca24b36d898f95b31cdb61181b44160ebb47f"
  ]
}
- get balance
{
  "bitcoin": 20999999.99950720
}
- data for op_return is: 271ce4f2b4312ee0636656031eb5bc891ba422e1fbdc1d725d762236338d8946
- create data transaction
- fund data transaction
- blind data transaction
- sign data transaction
- send data transaction
- txid is: eefe70c75e2742e0c9a5afea60f809ba7a508fe7a5821204742c8600c9d6cf16
- generate block
{
  "address": "el1qq2jyruv8agwacnm3vwyap8wxa2907tzt2lphk3xsj7pt3a3pu0u9a0ppmq08skfdnmkzhkzv3t7j5hf0lp45ylvrmydkuzyva",
  "blocks": [
    "375271e25a2015be69babfd579a64d1834f3cb365eb9fc8a366549d446b51a13"
  ]
}
- find the op_return from the transaction
OP_RETURN 271ce4f2b4312ee0636656031eb5bc891ba422e1fbdc1d725d762236338d8946
- should match data: 271ce4f2b4312ee0636656031eb5bc891ba422e1fbdc1d725d762236338d8946
Elements Core stopping
success!

```
