
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

### Multisig descriptor wallet 

- # Create keys for multisig
```bash
mkdir bdk-key
bdk-cli key generate | tee bdk-key/alice-key.json
bdk-cli key generate | tee bdk-key/bob-key.json
bdk-cli key generate | tee bdk-key/carol-key.json
```

- # Extract extended private keys and export to env
```
export ALICE_XPRV=$(cat bdk-key/alice-key.json | jq -r .xprv)
export BOB_XPRV=$(cat bdk-key/bob-key.json | jq -r .xprv)
export CAROL_XPRV=$(cat bdk-key/carol-key.json | jq -r .xprv)
```

- # Generate extended public keys
```bash
bdk-cli key derive --xprv $ALICE_XPRV --path "m/84'/1'/0'/0" | tee bdk-key/alice-derive.json
export ALICE_XPUB=$(cat bdk-key/alice-derive.json | jq -r .xpub)

bdk-cli key derive --xprv $BOB_XPRV --path "m/84'/1'/0'/0" | tee bdk-key/bob-derive.json
export BOB_XPUB=$(cat bdk-key/bob-derive.json | jq -r .xpub)
_
bdk-cli key derive --xprv $CAROL_XPRV --path "m/84'/1'/0'/0" | tee bdk-key/carol-derive.json
export CAROL_XPUB=$(cat bdk-key/carol-derive.json | jq -r .xpub)
```bash

- # Create wallet descriptors
```bash
export ALICE_DESCRIPTOR="wsh(thresh(3,pk($ALICE_XPRV/84'/1'/0'/0/*),s:pk($BOB_XPUB),s:pk($CAROL_XPUB),snl:older(2)))"
export BOB_DESCRIPTOR="wsh(thresh(3,pk($ALICE_XPUB),s:pk($BOB_XPRV/84'/1'/0'/0/*),s:pk($CAROL_XPUB),snl:older(2)))"
export CAROL_DESCRIPTOR="wsh(thresh(3,pk($ALICE_XPUB),s:pk($BOB_XPUB),s:pk($CAROL_XPRV/84'/1'/0'/0/*),snl:older(2)))"
```

- # Create a recipient
```bash
bdk-cli wallet -w bob -d $BOB_DESCRIPTOR get_new_address
```
- # result
```json
{
  "address": "tb1q9cvs8pfj6mjyxn92xjq2xs66chcdpge27fc5fmp3zeyztlwh886qkc95gl"
}
```

- # Sync wallet & confrimed balance
```bash
bdk-cli wallet -w alice -d $ALICE_DESCRIPTOR sync
bdk-cli wallet -w alice -d $ALICE_DESCRIPTOR get_balance

bdk-cli wallet -w bob -d $BOB_DESCRIPTOR sync
bdk-cli wallet -w bob -d $BOB_DESCRIPTOR get_balance

bdk-cli wallet -w carol -d $CAROL_DESCRIPTOR sync
bdk-cli wallet -w carol -d $CAROL_DESCRIPTOR get_balance
```

- # View wallet spend policies
```bash
bdk-cli wallet -w alice -d $ALICE_DESCRIPTOR policies

bdk-cli wallet -w bob -d $BOB_DESCRIPTOR policie
bdk-cli wallet -w carol -d $CAROL_DESCRIPTOR policies
```

- # alice policies
```json
{
  "external": {
    "contribution": {
      "conditions": {
        "0": [
          {}
        ],
        "3": [
          {
            "csv": 2
          }
        ]
      },
      "items": [
        0,
        3
      ],
      "m": 3,
      "n": 4,
      "type": "PARTIAL"
    },
    "id": "tllfyqfa",
    "items": [
      {
        "contribution": {
          "condition": {},
          "type": "COMPLETE"
        },
        "fingerprint": "2469893c",
        "id": "92z4wsla",
        "satisfaction": {
          "type": "NONE"
        },
        "type": "ECDSASIGNATURE"
      },
      {
        "contribution": {
          "type": "NONE"
        },
        "fingerprint": "bc76e71e",
        "id": "mcmgwnjy",
        "satisfaction": {
          "type": "NONE"
        },
        "type": "ECDSASIGNATURE"
      },
      {
        "contribution": {
          "type": "NONE"
        },
        "fingerprint": "5f620060",
        "id": "ffmmetsf",
        "satisfaction": {
          "type": "NONE"
        },
        "type": "ECDSASIGNATURE"
      },
      {
        "contribution": {
          "condition": {
            "csv": 2
          },
          "type": "COMPLETE"
        },
        "id": "8kel7sdw",
        "satisfaction": {
          "type": "NONE"
        },
        "type": "RELATIVETIMELOCK",
        "value": 2
      }
    ],
    "satisfaction": {
      "items": [],
      "m": 3,
      "n": 4,
      "type": "PARTIAL"
    },
    "threshold": 3,
    "type": "THRESH"
  },
  "internal": null
}
```

- # bob policies
```json
{
  "external": {
    "contribution": {
      "conditions": {
        "1": [
          {}
        ],
        "3": [
          {
            "csv": 2
          }
        ]
      },
      "items": [
        1,
        3
      ],
      "m": 3,
      "n": 4,
      "type": "PARTIAL"
    },
    "id": "fk34dr4k",
    "items": [
      {
        "contribution": {
          "type": "NONE"
        },
        "fingerprint": "2469893c",
        "id": "92z4wsla",
        "satisfaction": {
          "type": "NONE"
        },
        "type": "ECDSASIGNATURE"
      },
      {
        "contribution": {
          "condition": {},
          "type": "COMPLETE"
        },
        "fingerprint": "bc76e71e",
        "id": "mcmgwnjy",
        "satisfaction": {
          "type": "NONE"
        },
        "type": "ECDSASIGNATURE"
      },
      {
        "contribution": {
          "type": "NONE"
        },
        "fingerprint": "5f620060",
        "id": "ffmmetsf",
        "satisfaction": {
          "type": "NONE"
        },
        "type": "ECDSASIGNATURE"
      },
      {
        "contribution": {
          "condition": {
            "csv": 2
          },
          "type": "COMPLETE"
        },
        "id": "8kel7sdw",
        "satisfaction": {
          "type": "NONE"
        },
        "type": "RELATIVETIMELOCK",
        "value": 2
      }
    ],
    "satisfaction": {
      "items": [],
      "m": 3,
      "n": 4,
      "type": "PARTIAL"
    },
    "threshold": 3,
    "type": "THRESH"
  },
  "internal": null
}
```

- # carol policies
```json
{
  "external": {
    "contribution": {
      "conditions": {
        "2": [
          {}
        ],
        "3": [
          {
            "csv": 2
          }
        ]
      },
      "items": [
        2,
        3
      ],
      "m": 3,
      "n": 4,
      "type": "PARTIAL"
    },
    "id": "4972p489",
    "items": [
      {
        "contribution": {
          "type": "NONE"
        },
        "fingerprint": "2469893c",
        "id": "92z4wsla",
        "satisfaction": {
          "type": "NONE"
        },
        "type": "ECDSASIGNATURE"
      },
      {
        "contribution": {
          "type": "NONE"
        },
        "fingerprint": "bc76e71e",
        "id": "mcmgwnjy",
        "satisfaction": {
          "type": "NONE"
        },
        "type": "ECDSASIGNATURE"
      },
      {
        "contribution": {
          "condition": {},
          "type": "COMPLETE"
        },
        "fingerprint": "5f620060",
        "id": "ffmmetsf",
        "satisfaction": {
          "type": "NONE"
        },
        "type": "ECDSASIGNATURE"
      },
      {
        "contribution": {
          "condition": {
            "csv": 2
          },
          "type": "COMPLETE"
        },
        "id": "8kel7sdw",
        "satisfaction": {
          "type": "NONE"
        },
        "type": "RELATIVETIMELOCK",
        "value": 2
      }
    ],
    "satisfaction": {
      "items": [],
      "m": 3,
      "n": 4,
      "type": "PARTIAL"
    },
    "threshold": 3,
    "type": "THRESH"
  },
  "internal": null
}
```

- # Sign psbt
```bash
export UNSIGNED_PSBT=$(bdk-cli wallet -w alice -d $ALICE_DESCRIPTOR create_tx -a --to tb1q9cvs8pfj6mjyxn92xjq2xs66chcdpge27fc5fmp3zeyztlwh886qkc95gl:0 --external_policy "{\"tllfyqfa\": [0,1,3]}" | jq -r ".psbt")
echo $USIGNED_PSBT

export ALICE_SIGNED_PSBT=$(bdk-cli wallet -w alice -d $ALICE_DESCRIPTOR sign --psbt $UNSIGNED_PSBT | jq -r ".psbt")
export FINAL_PSBT=$(bdk-cli wallet -w bob -d $BOB_DESCRIPTOR sign --psbt $ALICE_SIGNED_PSBT | jq -r ".psbt")

bdk-cli wallet -w bob -d $BOB_DESCRIPTOR broadcast --psbt $FINAL_PSBT
```

```json
{
  "txid": "25a1471df45a6fb083c6be1b18ce079991eaeaf2126811a9a94ec62dda683153"
}
```
