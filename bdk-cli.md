
## Bitcoin Dev Kit

### Generate wallet 

- `bdk-cli key generate | tee key.json` 
  ```json
  {
    "fingerprint": "5bc9684e",
    "mnemonic": "tornado horror useful opinion matrix velvet impact scrap display banner cattle foster approve net asset spare link soft label pitch clock crawl list bunker",
    "xprv": "tprv8ZgxMBicQKsPdu21KoXBBGHffZYcAva2istupSaWTR4nCQe5yZAAEo9mpJo7swpVNCA4dFHyKfCuHkTSaBHDpDTKZHSZ8JG7aR92rUX44ks"
  }
  ```

  - `export XPRV_00=$(cat key.json | jq -r .xprv)`
- 
- `env | rg XPRV`
  `XPRV_00=tprv8ZgxMBicQKsPdu21KoXBBGHffZYcAva2istupSaWTR4nCQe5yZAAEo9mpJo7swpVNCA4dFHyKfCuHkTSaBHDpDTKZHSZ8JG7aR92rUX44ks`

- `export my_descriptor="wpkh($XPRV_00/84h/1h/0h/0/*)"` 设置派生路径
- `env | rg my_descriptor`
  `my_descriptor=wpkh(tprv8ZgxMBicQKsPdu21KoXBBGHffZYcAva2istupSaWTR4nCQe5yZAAEo9mpJo7swpVNCA4dFHyKfCuHkTSaBHDpDTKZHSZ8JG7aR92rUX44ks/84h/1h/0h/0/*)`

- `bdk-cli wallet --wallet bdk-cli-test --descriptor $my_descriptor get_new_address | jq`
  ```json
  {
    "address": "tb1qwukquqz762lm22742mt3zdaqtpseer8l6c54zt"
  }
  ```

- `bdk-cli wallet -w bdk-cli-test -d $my_descriptor get_balance`
  ```json
  {
    "satoshi": {
        "confirmed": 0,
        "immature": 0,
        "trusted_pending": 0,
        "untrusted_pending": 0
    }
    }
  ```

- `bdk-cli wallet -w bdk-cli-test -d $my_descriptor sync`   # can't work
