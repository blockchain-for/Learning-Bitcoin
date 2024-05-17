## Bitcoin command

### 启动Bitcoin core 服务 
- `bitcoind -testnet` 启动测试网全节点
  - `bitcoind -testnet -daemon` 启动bitcoind后台守护进程
  
- `ps auxww | grep bitcoind` 验证是否启动成功
  - 详细配置查看 `~/.bitcoin/bitcoin.conf`文件
        
    配置文件： ~/.bitcoin/bitcoin.conf 
    
    ```bash
    prune=1000 # file size max if value > 500
    minrelaytxfee=0.00005
    limitfreerelay=0
    alertnotify=myemailscript.sh "Alert: %s"
    # blocksonly=1
    mintxfee=0.001
    txconfirmtarget=1
    fallbackfee=0.00001
    dbcache=150
    maxmempool=150
    maxorphantx=10
    
    user=user
    password=password
    zmqpubrawblock=tcp://127.0.0.1:28332
    zmqpubrawtx=tcp://127.0.0.1:28333
    # if you want to run several different sorts of nodes simultaneously, 
    # you should leave the testnet (or regtest) flag out of your configuration file 
    # testnet=1  # start with testnet mode
    # regtest=1  # start with regtest mode 
    ```
        

### Bitcoin Cli 

#### Network

- `bitcoin-cli -testnet getblockcount` 获取测试网络的区块数量
- `bitcoin-cli -testnet getblockchaininfo` 获取测试网络的信息
- `curl -s [https://blockstream.info/testnet/api/blocks/tip/height](https://blockstream.info/testnet/api/blocks/tip/height)` 获取测试网络其他节点的区块高度
- `curl -s [https://blockchain.info/q/getblockcount](https://blockchain.info/q/getblockcount)`获取主网区块当前高度
- `bitcoin-cli help [command]` 查看bitcoin-cli 命令帮助
- `bitcoin-cli -testnet -getinfo` 查看testnet 信息
   
#### Wallets

- `bitcoin-cli -testnet getwalletinfo` 查看钱包信息
- `bitcoin-cli -testnet createwallet "testwallet"` 创建testwallet钱包
- `bitcoin-cli -testnet loadwallet "testwallet"` 从文件加载旧钱包
- `bitcoin-cli -testnet getnewaddress` 生成地址（bech32，Native SegWit地址，也叫P2WPKH）
    
    `# tb1qxeqhem3z6gwatqr2a3ah03pyqgamq4lsdkrsh4` 测试一般以 `tb1` 开头，主网以 `bc1` 开头
- `bitcoin-cli createwallet "mainwallet"` 创建主网钱包
- `bitcoin-cli getnewaddress`
  `bc1qdzr25fzawj55jkzdg86kh8l7sdg7pcdcl95afk`
- `bitcoin-cli getaddressinfo bc1qdzr25fzawj55jkzdg86kh8l7sdg7pcdcl95afk`
  
- `bitcoin-cli listaddressgroupings` 分组地址列表
    
- `bitcoin-cli -testnet getnewaddress --addresstype legacy` 创建早期`legacy` （P2PKH)格式地址，测试网一般是 `m` 或 `n` 开头，主网以 `1` 开头，P2SH地址一般是 `3` 开头
    
    `# mvdZMfdZVLPogTfM35pDZNapx52TGwJ7Eu`
    
- `bitcoin-cli -testnet signmessage "mvdZMfdZVLPogTfM35pDZNapx52TGwJ7Eu" "hello world!"` 签名信息，返回结果
    
     `H89LVin7oVJ0GJ4snHCkvUaYPboX3lHC/eS7FYqdFzVlZanvQf/r5ZJpnhDxeCNR2npUXwOpY2RUmCPiKWVkkVA=`
    
- `bitcoin-cli -testnet verifymessage "mvdZMfdZVLPogTfM35pDZNapx52TGwJ7Eu" "H89LVin7oVJ0GJ4snHCkvUaYPboX3lHC/eS7FYqdFzVlZanvQf/r5ZJpnhDxeCNR2npUXwOpY2RUmCPiKWVkkVA=" "hello world!”` 验证消息，并返回结果
    
    `true`
    
- `bitcoin-cli dumpwallet ~/mywallet.txt` 把钱包导出来文本文件，只支持legacy 地址，bitcoin core 24.0之后版本默认是descriptor钱包，而descriptor钱包不支持 `dumpwallet` 和 `dumpprivkey`命令
- `bitcoin-cli -testnet importwallet ~/mywallet.txt` 从导出我钱包文件中恢复钱包，只支持legacy 钱包，只能在不配置数据剪裁的节点上运行
- `bitcoin-cli -testnet dumpprivkey "mvdZMfdZVLPogTfM35pDZNapx52TGwJ7Eu"` 导出指定 legacy 地址的私钥
- `bitcoin-cli -testnet importprivkey cW4s4MdW7BkUmqiKgYzSJdmvnzq8QDrf6gszPMC7eLmfcdoRHtHh` 导入私钥
   
#### Generate blocks
- `bitcoin-cli generatetoaddress 1 bc1qdzr25fzawj55jkzdg86kh8l7sdg7pcdcl95afk`  # Generate 1 blocks to the given address
  
#### Command Variables：

- `unset NEW_ADDRESS_01` 生成一个没赋值的变量
- `NEW_ADDRESS_1=$(bitcoin-cli -testnet getnewaddress "" legacy)` 生成一个旧地址并赋值给变量 `NEW_ADDRESS_1`
- `echo $NEW_ADDRESS_1`
    
    `# my8HHm3SAeCvDoz54iSuL6GoVKhbpnyCwe`
    
- `NEW_ADDRESS_2=$(bitcoin-cli -testnet getnewaddress "" legacy)`
- `NEW_SIG_1=$(bitcoin-cli -testnet signmessage $NEW_ADDRESS_1 "Hello, World")`
- `echo $NEW_SIG_1`
    
    `IOej2TfQRP7J3qQIPPawYwWS8i2vOUN6bHblwu7jiJ4TNzfjuK5iz2sKQAw3UJ0f01/z43K2H5XNtkaGERyDMVE=`
    
#### Transactions:

- `bitcoin-cli -testnet getbalance` 获取当前钱包的余额
    
    `0.00108000`
    
- `bitcoin-cli -testnet getunconfirmedbalance`
- `bitcoin-cli -testnet getbalance "*" 1` 已确认一个区块（深度）的余额
- `bitcoin-cli getwalletinfo` 查看钱包信息
- `bitcoin-cli -testnet listtransactions` 列出本地钱包经手的交易
- `bitcoin-cli -testnet listunspent` 列出没花费的交易
- `bitcoin-cli -testnet gettransaction 'b00de623fefd5a7ae90a6926912f35aef658f0c49dfd0ef80f5eed8b0c75b01f'` 查看指定交易id的交易明细
- `bitcoin-cli -conf=$(pwd)/bitcoin.conf getrawtransaction 'b132d47c2b4a44f2a32f9ea53be739febdf0c079f8820b20eb60ddc0a46f1aaa' 1` 查看非本地钱包的交易，注意最后加一个以参数 `1`
  
  ```json
  {
    "amount": 0.00100000,
    "confirmations": 605,
    "blockhash": "000000000000000169c33a1c96ddf635957be69313c5de8d5789a57a62d4e76b",
    "blockheight": 2543574,
    "blockindex": 83,
    "blocktime": 1703129493,
    "txid": "b00de623fefd5a7ae90a6926912f35aef658f0c49dfd0ef80f5eed8b0c75b01f",
    "wtxid": "56ee7754a54a1b4c8eb6a35b248e17dcf16e0e92ea21006930d1810bc38c6af2",
    "walletconflicts": [
    ],
    "time": 1703129493,
    "timereceived": 1703129195,
    "bip125-replaceable": "no",
    "details": [
      {
        "address": "tb1qxeqhem3z6gwatqr2a3ah03pyqgamq4lsdkrsh4",
        "parent_descs": [
          "wpkh(tpubD6NzVbkrYhZ4WdbQsDoaZZSvE18CuK3QoUCafEWZ8jFjdCgYyYK6dqQq3d7ygdcFQHgkgubbmVtcvUC5mPwpAGsfN2emgE8uwLDrXSNxk4G/84h/1h/0h/0/*)#csns54qh"
        ],
        "category": "receive",
        "amount": 0.00100000,
        "label": "",
        "vout": 0,
        "abandoned": false
      }
    ],
    "hex": "020000000001014147cdbea0d2a1b946acad78c8a739077b0e4629a44865deefe4c67577f0a6790000000000fdffffff02a08601000000000016001436417cee22d21dd5806aec7b77c424023bb057f09f0f3e9108000000160014da68cc34477b119caa6921c633fe93003292fc040247304402206bec056c4cd8e9ce0c11c350e5f3ffc597ee52b922f9eb2f5e18e88222d0acb7022060477e73c49d03f60c4b75a755804b3b114fef9b9005b406d4bf2d468e571e7d01210213f24a5d07bababc02eafc723dcf0b4fd0158604627b3e7a7117bcc220c4e4d2d5cf2600",
    "lastprocessedblock": {
      "hash": "00000000000079bbc48f039cd09b8beaaa2755f5c752bd44d49f0c14e75427ed",
      "height": 2544178
    }
  }
  ```
#### Descriptor
- `bitcoin-cli -testnet getaddressinfo mvdZMfdZVLPogTfM35pDZNapx52TGwJ7Eu` 查看指定地址的信息
    ```json
    {
        "address": "mvdZMfdZVLPogTfM35pDZNapx52TGwJ7Eu",
        "scriptPubKey": "76a914a5c9a6ab6f08980063f39e7bae1e838d50dddd4488ac",
        "ismine": true,
        "solvable": true,
        "desc": "pkh([9881a23b/44h/1h/0h/0/0]03f8d1e4a2c58991ad7a55a07d1f15b5e59848f05588a65a57d266064bba8611e3)#mgvmu7fm",
        "parent_desc": "pkh([9881a23b/44h/1h/0h]tpubDCh4imKVpYNmR94RwQmCMnyJGqz6Cyb1tDqJM3kgeYjHtqWvAooCoP1zfRkVRT3Z5iSdbjLEG1B63vdM2U4LRUx5bZehrzXvHWx8Xkzzh9b/0/*)#gdpc4654",
        "iswatchonly": false,
        "isscript": false,
        "iswitness": false,
        "pubkey": "03f8d1e4a2c58991ad7a55a07d1f15b5e59848f05588a65a57d266064bba8611e3",
        "iscompressed": true,
        "ischange": false,
        "timestamp": 1703084395,
        "hdkeypath": "m/44h/1h/0h/0/0",
        "hdseedid": "0000000000000000000000000000000000000000",
        "hdmasterfingerprint": "9881a23b",
        "labels": [
            "--addresstype"
        ]
    }
    ```
- `bitcoin-cli -testnet getaddressinfo tb1qxeqhem3z6gwatqr2a3ah03pyqgamq4lsdkrsh4` 查看指定地址的信息
    ```json
    {
        "address": "tb1qxeqhem3z6gwatqr2a3ah03pyqgamq4lsdkrsh4",
        "scriptPubKey": "001436417cee22d21dd5806aec7b77c424023bb057f0",
        "ismine": true,
        "solvable": true,
        "desc": "wpkh([9881a23b/84h/1h/0h/0/0]02c8e635189af1f051d8c49dae65395056344e87041e7680d85d0ecc78915dcd92)#myj60eqx",
        "parent_desc": "wpkh([9881a23b/84h/1h/0h]tpubDDaLgHUhanxR7Roh9oDpXN44MwANGABFgjexEpWXmE5rUjrfSNL5h1rJXEBo3Yk23bC5xj7J5DMiQPooW4jSjMkQQ67enJg2mxKAzsSWyQA/0/*)#7t0k200x",
        "iswatchonly": false,
        "isscript": false,
        "iswitness": true,
        "witness_version": 0,
        "witness_program": "36417cee22d21dd5806aec7b77c424023bb057f0",
        "pubkey": "02c8e635189af1f051d8c49dae65395056344e87041e7680d85d0ecc78915dcd92",
        "ischange": false,
        "timestamp": 1703084396,
        "hdkeypath": "m/84h/1h/0h/0/0",
        "hdseedid": "0000000000000000000000000000000000000000",
        "hdmasterfingerprint": "9881a23b",
        "labels": [
            ""
        ]
    }
    ```
- `bitcoin-cli -testnet getdescriptorinfo "pkh([9881a23b/44h/1h/0h/0/0]03f8d1e4a2c58991ad7a55a07d1f15b5e59848f05588a65a57d266064bba8611e3)#mgvmu7fm"` 检查描述符
    ```json
    {
        "descriptor": "pkh([9881a23b/44h/1h/0h/0/0]03f8d1e4a2c58991ad7a55a07d1f15b5e59848f05588a65a57d266064bba8611e3)#mgvmu7fm",
        "checksum": "mgvmu7fm",
        "isrange": false,
        "issolvable": true,
        "hasprivatekeys": false
    }
    ```

- `bitcoin-cli -testnet getdescriptorinfo "wpkh([9881a23b/84h/1h/0h/0/0]02c8e635189af1f051d8c49dae65395056344e87041e7680d85d0ecc78915dcd92)#myj60eqx"` 检查描述符
    ```json
    {
        "descriptor": "wpkh([9881a23b/84h/1h/0h/0/0]02c8e635189af1f051d8c49dae65395056344e87041e7680d85d0ecc78915dcd92)#myj60eqx",
        "checksum": "myj60eqx",
        "isrange": false,
        "issolvable": true,
        "hasprivatekeys": false
    }
    ```
- `bitcoin-cli -testnet importmulti '[{"desc": "wpkh([9881a23b/84h/1h/0h/0/0]02c8e635189af1f051d8c49dae65395056344e87041e7680d85d0ecc78915dcd92)#myj60eqx", "timestamp": "now", "watchonly": true}]'` 导入descriptor
  
#### Send Coins to address

- `bitcoin-cli -testnet sendtoaddress 2Mz87LWo5GgbHVZhx48nxZQfCh84opc9rzn 0.001` 发送 `0.001` btc，并返回txid，需要在 `bitcoin.conf` 中配置 `fallbackfee=0.00001` 才能成功，条目 blocksonly=1 将导致您的 bitcoind 无法估算费用
    `# fea4e9861a458087c0fd5da03c6b63a91e8cfacc6f8658b9d7e17114bd5c2f70` 

- `bitcoin-cli -testnet gettransaction fea4e9861a458087c0fd5da03c6b63a91e8cfacc6f8658b9d7e17114bd5c2f70` 查看交易信息
    ```json
    {
        "amount": -0.00100000,
        "fee": -0.00036800,
        "confirmations": 0,
        "trusted": false,
        "txid": "fea4e9861a458087c0fd5da03c6b63a91e8cfacc6f8658b9d7e17114bd5c2f70",
        "wtxid": "fea4e9861a458087c0fd5da03c6b63a91e8cfacc6f8658b9d7e17114bd5c2f70",
        "walletconflicts": [
        ],
        "time": 1703156301,
        "timereceived": 1703156301,
        "bip125-replaceable": "yes",
        "details": [
            {
            "address": "2Mz87LWo5GgbHVZhx48nxZQfCh84opc9rzn",
            "category": "send",
            "amount": -0.00100000,
            "vout": 0,
            "fee": -0.00036800,
            "abandoned": false
            }
        ],
        "hex": "02000000024fed174daf693949672b8ba07ce231e239b44dd1a03ac854c925d9c8729251e2010000006a473044022001dbf9e084301ea350c7eb47ecd4f66715802341784cf2b3071032c3ab7d629802203bf92eea115b54e024f23f92d0f4c84c1b3c293cf6bf85d64e3a46b30bdfc7fe012103f8d1e4a2c58991ad7a55a07d1f15b5e59848f05588a65a57d266064bba8611e3fdffffff98c9c9eba3b96799acc765757dd2128b438376b3e858bbcebe47c5dc777fa20d010000006a47304402206e173428fcada013ef72f75c5727d7da5be035a0bf1ed368e005d73d9f2094e10220531beee208968aceb28afd9aecc619ccbbd5c0369c26aab72add6005434c17ee012103f8d1e4a2c58991ad7a55a07d1f15b5e59848f05588a65a57d266064bba8611e3fdffffff02a08601000000000017a9144b706aa73844328b09f8f70a8c45a5e89c48b08387e0f600000000000017a91431e2f7ae4b1e95ca8af8dd27b0cc905cc5e4f50b870cd02600",
        "lastprocessedblock": {
            "hash": "000000000000001c1a5b9a5a9b6c2f58a8cd3d73647f94398b456e3022a1d575",
            "height": 2543629
        }
    }
    ```

#### Create a Raw transaction

- `bitcoin-cli -testnet listunspent`
    ```json
    [
        {
            "txid": "3acf7a4b39f26818de6543fe9b1fe7770cf82bcb14a817c709d50dafca4f526e",
            "vout": 0,
            "address": "mvdZMfdZVLPogTfM35pDZNapx52TGwJ7Eu",
            "label": "--addresstype",
            "scriptPubKey": "76a914a5c9a6ab6f08980063f39e7bae1e838d50dddd4488ac",
            "amount": 0.00100000,
            "confirmations": 3,
            "spendable": true,
            "solvable": true,
            "desc": "pkh([9881a23b/44h/1h/0h/0/0]03f8d1e4a2c58991ad7a55a07d1f15b5e59848f05588a65a57d266064bba8611e3)#mgvmu7fm",
            "parent_descs": [
            "pkh(tpubD6NzVbkrYhZ4WdbQsDoaZZSvE18CuK3QoUCafEWZ8jFjdCgYyYK6dqQq3d7ygdcFQHgkgubbmVtcvUC5mPwpAGsfN2emgE8uwLDrXSNxk4G/44h/1h/0h/0/*)#phn2dj78"
            ],
            "safe": true
        },
        
    ]
    ```

- `utxo_txid="da5a6dcaef07437ced41c5f5f6363790b5ceb71170003dc876b325f6ba9dfaa6"`
- `utxo_vout=1`
- `recipient="2Mz87LWo5GgbHVZhx48nxZQfCh84opc9rzn"`

- `rawtxhex=$(bitcoin-cli -testnet createrawtransaction '''[ { "txid": "'$utxo_txid'", "vout": '$utxo_vout' } ]''' '''{ "'$recipient'": 0.00005 }''')`
- `echo $rawtxhex`
  `0200000001a6fa9dbaf625b376c83d007011b7ceb5903736f6f5c541ed7c4307efca6d5ada0100000000fdffffff01881300000000000017a9144b706aa73844328b09f8f70a8c45a5e89c48b0838700000000`

- `bitcoin-cli -testnet decoderawtransaction $rawtxhex` # 验证交易
  ```json
  {
    "txid": "0192d9e7fa69788b5867de7e0ee1fa8c6198e0d80fa411f5fcd8ccce82c17f86",
    "hash": "0192d9e7fa69788b5867de7e0ee1fa8c6198e0d80fa411f5fcd8ccce82c17f86",
    "version": 2,
    "size": 83,
    "vsize": 83,
    "weight": 332,
    "locktime": 0,
    "vin": [
        {
        "txid": "da5a6dcaef07437ced41c5f5f6363790b5ceb71170003dc876b325f6ba9dfaa6",
        "vout": 1,
        "scriptSig": {
            "asm": "",
            "hex": ""
        },
        "sequence": 4294967293
        }
    ],
    "vout": [
        {
        "value": 0.00005000,
        "n": 0,
        "scriptPubKey": {
            "asm": "OP_HASH160 4b706aa73844328b09f8f70a8c45a5e89c48b083 OP_EQUAL",
            "desc": "addr(2Mz87LWo5GgbHVZhx48nxZQfCh84opc9rzn)#gmmyhmsp",
            "hex": "a9144b706aa73844328b09f8f70a8c45a5e89c48b08387",
            "address": "2Mz87LWo5GgbHVZhx48nxZQfCh84opc9rzn",
            "type": "scripthash"
        }
        }
    ]
  }


- `bitcoin-cli -testnet signrawtransactionwithwallet $rawtxhex` 签名交易
```json
  {
    "hex": "02000000000101a6fa9dbaf625b376c83d007011b7ceb5903736f6f5c541ed7c4307efca6d5ada0100000000fdffffff01881300000000000017a9144b706aa73844328b09f8f70a8c45a5e89c48b083870247304402207bebe7203a0c1f7c1d1ff5e14d8f6116e1d90d8faaeed6d84a8de6f78477b19302202e7dfe636bddeaa4124630db7542d6745dd8013a5ce701fd4e5ed764b2d92901012102c8e635189af1f051d8c49dae65395056344e87041e7680d85d0ecc78915dcd9200000000",
    "complete": true
  }
```

- `signedtx="02000000000101a6fa9dbaf625b376c83d007011b7ceb5903736f6f5c541ed7c4307efca6d5ada0100000000fdffffff01881300000000000017a9144b706aa73844328b09f8f70a8c45a5e89c48b083870247304402207bebe7203a0c1f7c1d1ff5e14d8f6116e1d90d8faaeed6d84a8de6f78477b19302202e7dfe636bddeaa4124630db7542d6745dd8013a5ce701fd4e5ed764b2d92901012102c8e635189af1f051d8c49dae65395056344e87041e7680d85d0ecc78915dcd9200000000"`
  
- `bitcoin-cli -testnet sendrawtransaction $signedtx` # 发送交易
  `# 0192d9e7fa69788b5867de7e0ee1fa8c6198e0d80fa411f5fcd8ccce82c17f86`
  
#### Creating a Raw Transaction with Named Arguments

- `bitcoin-cli -named getbalance minconf=1`

- `utxo_txid=$(bitcoin-cli -testnet listunspent | jq -r '.[0] | .txid')`
- `utxo_vout=$(bitcoin-cli -testnet listunspent | jq -r '.[0] | .vout')`
- `recipient="2Mz87LWo5GgbHVZhx48nxZQfCh84opc9rzn"`
- `rawtxhex=$(bitcoin-cli -testnet -named createrawtransaction inputs='''[ { "txid": "'$utxo_txid'", "vout": '$utxo_vout' } ]''' outputs='''{ "'$recipient'": 0.00001 }''')`
  `02000000016e524fcaaf0dd509c717a814cb2bf80c77e71f9bfe4365de1868f2394b7acf3a0000000000fdffffff01e80300000000000017a9144b706aa73844328b09f8f70a8c45a5e89c48b0838700000000`
  
- `bitcoin-cli -named -testnet decoderawtransaction hexstring=$rawtxhex` 

- `signedtx=$(bitcoin-cli -named -testnet signrawtransactionwithwallet hexstring=$rawtxhex | jq -r '.hex')`

- `bitcoin-cli -named -testnet sendrawtransaction hexstring=$signedtx`
    `bef6ea45ce55df6a38c744e405af72c6f8ec2a97de5798e7f218618ccc495e36`

#### Sending Coins with a Raw transaction

- `changeaddress=$(bitcoin-cli -testnet getrawchangeaddress legacy)`
- `bitcoin-cli -testnet getrawchangeaddress`
  `tb1q7ka2hsd0m58mxrqc9zs36nxqwwhmmmpqdngcjv`
- `echo $changeaddress`
  `mzoQJFgc5HUhAfqWjGcLsyUzRbxFV3SHAN`
- `echo $recipient`
  
- `utxo_txid_1=$(bitcoin-cli -testnet listunspent | jq -r '.[0] | .txid')`
- `utxo_vout_1=$(bitcoin-cli -testnet listunspent | jq -r '.[0] | .vout')`
- `utxo_txid_2=$(bitcoin-cli -testnet listunspent | jq -r '.[2] | .txid')`
- `utxo_vout_2=$(bitcoin-cli -testnet listunspent | jq -r '.[2] | .vout')`
- 
- `rawtxhex2=$(bitcoin-cli -named -testnet createrawtransaction inputs='''[ { "txid": "'$utxo_txid_1'", "vout": '$utxo_vout_1' }, { "txid": "'$utxo_txid_2'", "vout": '$utxo_vout_2' } ]''' outputs='''{ "'$recipient'": 0.00102, "'$changeaddress'": 0.00001 }''')`
- `signedtx2=$(bitcoin-cli -named -testnet signrawtransactionwithwallet hexstring=$rawtxhex2 | jq -r '.hex')`
  
- `raw_tx_id=$(bitcoin-cli -named -testnet sendrawtransaction hexstring=$signedtx2)`
- `echo $raw_tx_id`
  `2c92ee1c7274c5e55f19c103634b46e6d3726c11aaeb4f683e720a875d28dbd2`

- `curl --user user:password --data-binary '{"jsonrpc": "1.0", "id":"curltest", "method": "getmininginfo", "params": [] }' -H 'content-type: text/plain;' http://127.0.0.1:18332/` 用 `curl` 代替 `bitcoin-cli -testnet getmininginfo`
  
#### Sending Coins with Automated Raw Transactions

- `recipient=mzoQJFgc5HUhAfqWjGcLsyUzRbxFV3SHAN`
- `unfinishedtx=$(bitcoin-cli -testnet -named createrawtransaction inputs='''[]''' outputs='''{"'$recipient'": 0.0002}''')`
- `bitcoin-cli -named -testnet fundrawtransaction hexstring=$unfinishedtx`
  ```json
  {
    "hex": "02000000011fb0750c8bed5e0ff80efd9dc4f058f6ae352f9126690ae97a5afdfe23e60db00000000000fdffffff02204e0000000000001976a914d386c07a3bdb74ee891b220242cbac908a713fb288ac14ff0000000000001976a914dd4bf95e93b0b9cb857157749bc3d1717a73a8ae88ac00000000",
    "fee": 0.00014700,
    "changepos": 1
    }
  ```
- `rawtxhex3="02000000011fb0750c8bed5e0ff80efd9dc4f058f6ae352f9126690ae97a5afdfe23e60db00000000000fdffffff02204e0000000000001976a914d386c07a3bdb74ee891b220242cbac908a713fb288ac14ff0000000000001976a914dd4bf95e93b0b9cb857157749bc3d1717a73a8ae88ac00000000"` or
- `rawtxhex3=$(bitcoin-cli -named -testnet fundrawtransaction hexstring=$unfinishedtx | jq -r '.hex')`
- `bitcoin-cli -named -testnet decoderawtrawtransaction hexstring=$rawtxhex3` 
    ```json
  {
    "txid": "8c199fd594e06021db30c0ed4e6bf1e74a475204c8df6636e69d19696b53bdd3",
    "hash": "8c199fd594e06021db30c0ed4e6bf1e74a475204c8df6636e69d19696b53bdd3",
    "version": 2,
    "size": 119,
    "vsize": 119,
    "weight": 476,
    "locktime": 0,
    "vin": [
        {
        "txid": "b00de623fefd5a7ae90a6926912f35aef658f0c49dfd0ef80f5eed8b0c75b01f",
        "vout": 0,
        "scriptSig": {
            "asm": "",
            "hex": ""
        },
        "sequence": 4294967293
        }
    ],
    "vout": [
        {
        "value": 0.00020000,
        "n": 0,
        "scriptPubKey": {
            "asm": "OP_DUP OP_HASH160 d386c07a3bdb74ee891b220242cbac908a713fb2 OP_EQUALVERIFY OP_CHECKSIG",
            "desc": "addr(mzoQJFgc5HUhAfqWjGcLsyUzRbxFV3SHAN)#zhpjn3w5",
            "hex": "76a914d386c07a3bdb74ee891b220242cbac908a713fb288ac",
            "address": "mzoQJFgc5HUhAfqWjGcLsyUzRbxFV3SHAN",
            "type": "pubkeyhash"
        }
        },
        {
        "value": 0.00065300,
        "n": 1,
        "scriptPubKey": {
            "asm": "OP_DUP OP_HASH160 dd4bf95e93b0b9cb857157749bc3d1717a73a8ae OP_EQUALVERIFY OP_CHECKSIG",
            "desc": "addr(n1h4eDoRG1X341LUw3nZUrACxC7ZE6Ee1L)#2w0cruau",
            "hex": "76a914dd4bf95e93b0b9cb857157749bc3d1717a73a8ae88ac",
            "address": "n1h4eDoRG1X341LUw3nZUrACxC7ZE6Ee1L",
            "type": "pubkeyhash"
        }
        }
    ]
  }
  ```

- `bitcoin-cli -named -testnet getaddressinfo address=n1h4eDoRG1X341LUw3nZUrACxC7ZE6Ee1L`  检查收零地址是否属于自己，`ismine` 中的值是 `true` 
  ```json
  {
    "address": "n1h4eDoRG1X341LUw3nZUrACxC7ZE6Ee1L",
    "scriptPubKey": "76a914dd4bf95e93b0b9cb857157749bc3d1717a73a8ae88ac",
    "ismine": true,
    "solvable": true,
    "desc": "pkh([9881a23b/44h/1h/0h/1/3]0321bc3415ed8eaa40c805781d6fc1cb5abf14c2768823078456a865c634d30ee1)#yfs9xxhx",
    "parent_desc": "pkh([9881a23b/44h/1h/0h]tpubDCh4imKVpYNmR94RwQmCMnyJGqz6Cyb1tDqJM3kgeYjHtqWvAooCoP1zfRkVRT3Z5iSdbjLEG1B63vdM2U4LRUx5bZehrzXvHWx8Xkzzh9b/1/*)#eeyeg0yd",
    "iswatchonly": false,
    "isscript": false,
    "iswitness": false,
    "pubkey": "0321bc3415ed8eaa40c805781d6fc1cb5abf14c2768823078456a865c634d30ee1",
    "iscompressed": true,
    "ischange": true,
    "timestamp": 1703084396,
    "hdkeypath": "m/44h/1h/0h/1/3",
    "hdseedid": "0000000000000000000000000000000000000000",
    "hdmasterfingerprint": "9881a23b",
    "labels": [
    ]
  }
  ```
- `signedtx3=$(bitcoin-cli -named -testnet signrawtransactionwithwallet hexstring=$rawtxhex3 | jq -r '.hex')`
- `txid_3=$(bitcoin-cli -named -testnet sendrawtransaction hexstring=$signedtx3)`
- `echo $txid_3`
  `8b9dd66c999966462a3d88d6ac9405d09e2aa409c0aa830bdd08dbcbd34a36fa`
- `bitcoin-cli -testnet listunspent`

#### Creating a SegWit Transaction

- `bitcoin-cli -named -testnet getnewaddress address_type=p2sh-segwit` 创建 `p2sh-segwit` 地址，2开始表示测试网，3开头表示主网，这是由于有些地址不能发送到最新的 SegWit 地址
  `2MxVqMTpjZ4h46tzQZKoM9J4iEyNqeXeQ93`
- `bitcoin-cli -testnet getnewaddress` 创建默认的 Bech32 SegWit 地址, 测试网以 `tb1`开头，主网以 `bc1`开头
  `tb1qqapg4e009c4leghl0fzuxr22g7kueea36v333s`
- `bitcoin-cli -testnet listaddressgroupings`
- `bitcoin-cli -testnet sendtoaddress tb1qqapg4e009c4leghl0fzuxr22g7kueea36v333s 0.0007`
  `bc4ce37c70609d54ac3fbc7238b26bc24dc4fafdd81e9e3f3d0cb58592f7f64c`
  
#### Watching for Stuck Transactions

- `bitcoin-cli -testnet -named gettransaction txid=8c199fd594e06021db30c0ed4e6bf1e74a475204c8df6636e69d19696b53bdd3`

#### Resending a Transaction with RBF

- `rawtxhex=$(bitcoin-cli -named createrawtransaction inputs='''[ { "txid": "'$utxo_txid'", "vout": '$utxo_vout', "sequence": 1 } ]''' outputs='''{ "'$recipient'": 0.00007658, "'$changeaddress'": 0.00000001 }''')` adding a sequence variable and value is `1` to your UTXO inputs:
- `signedtx=$(bitcoin-cli -named signrawtransactionwithwallet hexstring=$rawtxhex | jq -r '.hex')` 重新签名交易
- `bitcoin-cli -named sendrawtransaction hexstring=$signedtx` 重新发送交易
  
#### Replace a Transaction the Easy Way: By bumpfee

- `bitcoin-cli -testnet -named bumpfee txid=8c199fd594e06021db30c0ed4e6bf1e74a475204c8df6636e69d19696b53bdd3`
  
#### Funding a Transaction with CPFP

- `bitcoin-cli -testnet getrawmempool` 查看当前mempool中的交易
- `bitcoin-cli getrawtransaction bc4ce37c70609d54ac3fbc7238b26bc24dc4fafdd81e9e3f3d0cb58592f7f64c true` 查找未确认交易的 txid 和 vout，找到与您的地址匹配的对象
- `rawtxhex=$(bitcoin-cli -testnet -named createrawtransaction inputs='''[ { "txid": "'$utxo_txid'", "vout": '$utxo_vout' } ]''' outputs='''{ "'$recipient2'": 0.03597 }''')` 使用您的未确认交易作为输入创建一个原始交易，将交易费用加倍（或更多）。

- `signedtx=$(bitcoin-cli -testnet -named signrawtransaction hexstring=$rawtxhex | jq -r '.hex')` 签名交易
- `bitcoin-cli -testnet -named sendrawtransaction hexstring=$signedtx` 发送交易
  
#### Create a Multisig Address

- `address1=$(bitcoin-cli getnewaddress)` on machine1
- `address2=$(bitcoin-cli getnewaddress)` on machine2
- `echo $address1`
  `tb1qxeqhem3z6gwatqr2a3ah03pyqgamq4lsdkrsh4`
- `echo $address2`
  `tb1qqapg4e009c4leghl0fzuxr22g7kueea36v333s`
  
- `bitcoin-cli -testnet -named getaddressinfo address=$address2` 找到 pubkey的值就是公钥并复制，每个机器上的地址执行同样操作
  ```json
  {
    "address": "tb1qqapg4e009c4leghl0fzuxr22g7kueea36v333s",
    "scriptPubKey": "001407428ae5ef2e2bfca2ff7a45c30d4a47adcce7b1",
    "ismine": true,
    "solvable": true,
    "desc": "wpkh([9881a23b/84h/1h/0h/0/1]0248d2d720f5d9c2aa0cb2246ac0eff59e9590a37e05e299ebad4230f40ca58ad1)#sxnz74w5",
    "parent_desc": "wpkh([9881a23b/84h/1h/0h]tpubDDaLgHUhanxR7Roh9oDpXN44MwANGABFgjexEpWXmE5rUjrfSNL5h1rJXEBo3Yk23bC5xj7J5DMiQPooW4jSjMkQQ67enJg2mxKAzsSWyQA/0/*)#7t0k200x",
    "iswatchonly": false,
    "isscript": false,
    "iswitness": true,
    "witness_version": 0,
    "witness_program": "07428ae5ef2e2bfca2ff7a45c30d4a47adcce7b1",
    "pubkey": "0248d2d720f5d9c2aa0cb2246ac0eff59e9590a37e05e299ebad4230f40ca58ad1",
    "ischange": false,
    "timestamp": 1703084396,
    "hdkeypath": "m/84h/1h/0h/0/1",
    "hdseedid": "0000000000000000000000000000000000000000",
    "hdmasterfingerprint": "9881a23b",
    "labels": [
      ""
    ]
  }
  ```

- `pubkey1=$(bitcoin-cli -testnet -named getaddressinfo address=$address1 | jq -r '.pubkey')` on machine1
  `# 02c8e635189af1f051d8c49dae65395056344e87041e7680d85d0ecc78915dcd92`

- `bitcoin-cli -testnet -named createmultisig nrequired=2 keys='''["'$pubkey1'", "0248d2d720f5d9c2aa0cb2246ac0eff59e9590a37e05e299ebad4230f40ca58ad1"]'''` on machine1, create multisig, and remember the address order
  ```json
  {
    "address": "2NEzu2nkNTyXqnE5gKzCSDy1hyNyNyiX7rT",
    "redeemScript": "522102c8e635189af1f051d8c49dae65395056344e87041e7680d85d0ecc78915dcd92210248d2d720f5d9c2aa0cb2246ac0eff59e9590a37e05e299ebad4230f40ca58ad152ae",
    "descriptor": "sh(multi(2,02c8e635189af1f051d8c49dae65395056344e87041e7680d85d0ecc78915dcd92,0248d2d720f5d9c2aa0cb2246ac0eff59e9590a37e05e299ebad4230f40ca58ad1))#gld440s5"
  }
  ```

- `recipient_multisig="2NEzu2nkNTyXqnE5gKzCSDy1hyNyNyiX7rT"` remember and send to the sender
- `redeem_script="522102c8e635189af1f051d8c49dae65395056344e87041e7680d85d0ecc78915dcd92210248d2d720f5d9c2aa0cb2246ac0eff59e9590a37e05e299ebad4230f40ca58ad152ae"`
- `multisig_descritor="sh(multi(2,02c8e635189af1f051d8c49dae65395056344e87041e7680d85d0ecc78915dcd92,0248d2d720f5d9c2aa0cb2246ac0eff59e9590a37e05e299ebad4230f40ca58ad1))#gld440s5"`
  
- `utxo_txid=$(bitcoin-cli -testnet listunspent | jq -r '.[0] | .txid')`
- `utxo_vout=$(bitcoin-cli -testnet listunspent | jq -r '.[0] | .vout')`
- `rawtxhex=$(bitcoin-cli -testnet -named createrawtransaction inputs='''[ { "txid": "'$utxo_txid'", "vout": '$utxo_vout' } ]''' outputs='''{ "'$recipient_multisig'": 0.000065}''')` 创建交易，和普通交易一样

- `echo $rawtxhex`
  `0200000001f66d4df26d059f9fe8db6479f01eee5371db259b5d7640ae95dba77f581584960000000000fdffffff01641900000000000017a914ee9d1e938724dcfaa09398415673889d5cc5cc258700000000`

- `bitcoin-cli -testnet -named decoderawtransaction hexstring=$rawtxhex `
  ```json
  {
    "txid": "ffa3c1b2dab8804983c00b9c5ae9310eb3eb375f384cd383750ad9059d5a2c7b",
    "hash": "ffa3c1b2dab8804983c00b9c5ae9310eb3eb375f384cd383750ad9059d5a2c7b",
    "version": 2,
    "size": 83,
    "vsize": 83,
    "weight": 332,
    "locktime": 0,
    "vin": [
      {
        "txid": "968415587fa7db95ae40765d9b25db7153ee1ef07964dbe89f9f056df24d6df6",
        "vout": 0,
        "scriptSig": {
          "asm": "",
          "hex": ""
        },
        "sequence": 4294967293
      }
    ],
    "vout": [
      {
        "value": 0.00006500,
        "n": 0,
        "scriptPubKey": {
          "asm": "OP_HASH160 ee9d1e938724dcfaa09398415673889d5cc5cc25 OP_EQUAL",
          "desc": "addr(2NEzu2nkNTyXqnE5gKzCSDy1hyNyNyiX7rT)#emjwvzpl",
          "hex": "a914ee9d1e938724dcfaa09398415673889d5cc5cc2587",
          "address": "2NEzu2nkNTyXqnE5gKzCSDy1hyNyNyiX7rT",
          "type": "scripthash"
        }
      }
    ]
  }
  ```

- `signedtx=$(bitcoin-cli -testnet -named signrawtransactionwithwallet hexstring=$rawtxhex | jq -r '.hex')` 签名交易
- `txid_multisig=$(bitcoin-cli -testnet -named sendrawtransaction hexstring=$signedtx)`
- `echo $txid_mutisig`
  `195b06fd3ee1e7c5ca9453af37cefc8dc3b40fb3ed34fb21a0c04f26eea03784`

- `bitcoin-cli -testnet -named gettransaction txid=$txid_multisig`
  ```json
  {
    "amount": -0.00006500,
    "fee": -0.00093500,
    "confirmations": 0,
    "trusted": true,
    "txid": "195b06fd3ee1e7c5ca9453af37cefc8dc3b40fb3ed34fb21a0c04f26eea03784",
    "wtxid": "195b06fd3ee1e7c5ca9453af37cefc8dc3b40fb3ed34fb21a0c04f26eea03784",
    "walletconflicts": [
    ],
    "time": 1703479090,
    "timereceived": 1703479090,
    "bip125-replaceable": "yes",
    "details": [
      {
        "address": "2NEzu2nkNTyXqnE5gKzCSDy1hyNyNyiX7rT",
        "category": "send",
        "amount": -0.00006500,
        "vout": 0,
        "fee": -0.00093500,
        "abandoned": false
      }
    ],
    "hex": "0200000001f66d4df26d059f9fe8db6479f01eee5371db259b5d7640ae95dba77f58158496000000006a4730440220538bbf5e0c24c06dbaf0b11e25b1f7e829e55e322e2f20c5952f6dd8b1f87be3022028e6213af55e987ecd9f34ad0d58a65e88b40712444a7500b66b5e29f903578c012103f8d1e4a2c58991ad7a55a07d1f15b5e59848f05588a65a57d266064bba8611e3fdffffff01641900000000000017a914ee9d1e938724dcfaa09398415673889d5cc5cc258700000000",
    "lastprocessedblock": {
      "hash": "0000000000000006d083da505777eb48326fb47c08456463193f487b7609111f",
      "height": 2544071
    }
  }
  ```
- `utxo_multisig_vout=0`
  
#### Spending a Transaction with a Multisig

- `bitcoin-cli -testnet -named importaddress address=2NAGfA4nW6nrZkD5je8tSiAcYB9xL2xYMCz rescan="false"` 
- `bitcoin-cli -testnet importmulti '[{"desc": "sh(multi(2,02c8e635189af1f051d8c49dae65395056344e87041e7680d85d0ecc78915dcd92,0248d2d720f5d9c2aa0cb2246ac0eff59e9590a37e05e299ebad4230f40ca58ad1))#gld440s5", "timestamp": "now", "watchonly": true}]'`

- `utxo_multisig_spk=`
- `recipient_multisig_new=$(bitcoin-cli -testnet getrawchangeaddress)`
- `echo $recipient_multisig_new`
  `tb1qlex8x3edh40wg2v086w864ujntkc2lh73etj72`

- `rawtxhex_multisig=$(bitcoin-cli -testnet -named createrawtransaction inputs='''[ { "txid": "'$txid_multisig'", "vout": '$utxo_multisig_vout' } ]''' outputs='''{ "'$recipient_multisig_new'": 0.00005}''')` 创建交易
  
- `echo $rawtxhex_multisig`
  `02000000018437a0ee264fc0a021fb34edb30fb4c38dfcce37af5394cac5e7e13efd065b190000000000fdffffff018813000000000000160014fe4c73472dbd5ee4298f3e9c7d57929aed857efe00000000`

#### Sending & Spending an Automated Multisig

- `address3=$(bitcoin-cli -testnet getnewaddress)` on machine1
- `echo address3`
  `tb1q9f6h2qedshzm3asqnqa77yq2j7gn4wycpy0rrp`

- `pubkey3=$(bitcoin-cli -testnet -named getaddressinfo address=$address3 | jq -r '.pubkey')`

- `address4=$(bitcoin-cli -testnet getnewaddress)` on machine2
- `echo address4`
  `tb1qp7zlvst7mxepweam950dpajl9a206f0lnvy8ah`

- `pubkey4=$(bitcoin-cli -testnet -named getaddressinfo address=$address4 | jq -r '.pubkey')`

- `bitcoin-cli -testnet -named addmultisigaddress nrequired=2 keys='''["'$address3'","'$pubkey4'"]'''` on machine1
  ```json
  {
    "address": "tb1q9as46kupwcxancdx82gw65365svlzdwmjal4uxs23t3zz3rgg3wqpqlhex",
    "redeemScript": "52210297e681bff16cd4600138449e2527db4b2f83955c691a1b84254ecffddb9bfbfc2102a0d96e16458ff0c90db4826f86408f2cfa0e960514c0db547ff152d3e567738f52ae",
    "descriptor": "wsh(multi(2,[d6043800/0'/0'/15']0297e681bff16cd4600138449e2527db4b2f83955c691a1b84254ecffddb9bfbfc,[e9594be8]02a0d96e16458ff0c90db4826f86408f2cfa0e960514c0db547ff152d3e567738f))#wxn4tdju"
  }
  ```
- `bitcoin-cli -testnet -named addmultisigaddress nrequired=2 keys='''["'$pubkey3'","'$address4'"]'''` on machine2
  ```json
  {
    "address": "tb1q9as46kupwcxancdx82gw65365svlzdwmjal4uxs23t3zz3rgg3wqpqlhex",
    "redeemScript": "52210297e681bff16cd4600138449e2527db4b2f83955c691a1b84254ecffddb9bfbfc2102a0d96e16458ff0c90db4826f86408f2cfa0e960514c0db547ff152d3e567738f52ae",
    "descriptor": "wsh(multi(2,[ae42a66f]0297e681bff16cd4600138449e2527db4b2f83955c691a1b84254ecffddb9bfbfc,[fe6f2292/0'/0'/2']02a0d96e16458ff0c90db4826f86408f2cfa0e960514c0db547ff152d3e567738f))#cc96c5n6"
  }
  ```

- `bitcoin-cli -testnet -named importaddress address=tb1q9as46kupwcxancdx82gw65365svlzdwmjal4uxs23t3zz3rgg3wqpqlhex rescan="false"` on machine1
- `bitcoin-cli -testnet -named importaddress address=tb1q9as46kupwcxancdx82gw65365svlzdwmjal4uxs23t3zz3rgg3wqpqlhex rescan="false"` on machine2

#### Creating a Partially Signed Bitcoin Transaction

- `utxo_txid_1=$(bitcoin-cli -testnet listunspent | jq -r '.[0] .txid')`
- `echo $utxo_txid_1`
  `74faae74913f109b8e00a3f206c012282121ad198c5c6fe7eeed09e8b1ff43c6`
- `utxo_vout_1=$(bitcoin-cli -testnet listunspent | jq -r '.[0] .vout')`
- `echo $utxo_vout_1`
  `0`
- `utxo_txid_2=$(bitcoin-cli -testnet listunspent | jq -r '.[1] .txid')`
- `echo $utxo_txid_2`
  `2dccce25cdbbd62427a4f1df77c72dd4ba0c0a1c1ccc778d044c12bd389536b6`
- `utxo_vout_2=$(bitcoin-cli -testnet listunspent | jq -r '.[1] .vout')`
- `echo $utxo_vout_2`
  `0`

- `recipient="tb1qxeqhem3z6gwatqr2a3ah03pyqgamq4lsdkrsh4"`

##### Create a PSBT the Old-Fashioned Way

- `rawtxhex=$(bitcoin-cli -testnet -named createrawtransaction inputs='''[ { "txid": "'$utxo_txid_1'", "vout": '$utxo_vout_1' }, { "txid": "'$utxo_txid_2'", "vout": '$utxo_vout_2' }]''' outputs='''{ "'$recipient'": 0.0000065 }''')`
- `echo rawtxhex`
  `0200000002c643ffb1e809edeee76f5c8c19ad21212812c006f2a3008e9b103f9174aefa740000000000fdffffffb6369538bd124c048d77cc1c1c0a0cbad42dc777dff1a42724d6bbcd25cecc2d0000000000fdffffff018a0200000000000016001436417cee22d21dd5806aec7b77c424023bb057f000000000`

- `psbt=$(bitcoin-cli -testnet -named converttopsbt hexstring=$rawtxhex)`
- `echo $psbt`
  `cHNidP8BAHsCAAAAAsZD/7HoCe3u529cjBmtISEoEsAG8qMAjpsQP5F0rvp0AAAAAAD9////tjaVOL0STASNd8wcHAoMutQtx3ff8aQnJNa7zSXOzC0AAAAAAP3///8BigIAAAAAAAAWABQ2QXzuItId1YBq7Ht3xCQCO7BX8AAAAAAAAAAA`

##### Create a PSBT the Hard Way

- `psbt_1=$(bitcoin-cli -testnet -named createpsbt inputs='''[ { "txid": "'$utxo_txid_1'", "vout": '$utxo_vout_1' }, { "txid": "'$utxo_txid_2'", "vout": '$utxo_vout_2' } ]''' outputs='''{ "'$recipient'": 0.0000065 }''')`
- `echo $psbt_1`
  `cHNidP8BAHsCAAAAAsZD/7HoCe3u529cjBmtISEoEsAG8qMAjpsQP5F0rvp0AAAAAAD9////tjaVOL0STASNd8wcHAoMutQtx3ff8aQnJNa7zSXOzC0AAAAAAP3///8BigIAAAAAAAAWABQ2QXzuItId1YBq7Ht3xCQCO7BX8AAAAAAAAAAA`

- `if [ "$psbt" == "$psbt_1" ]; then     echo "PSBTs are equal"; else     echo "PSBTs are not equal"; fi` compare the tow psbts are same or not
  `PSBTs are equal` the two methods are same

- `bitcoin-cli -testnet -named decodepsbt psbt=$psbt` decode the psbt tx
  ```json
  {
    "tx": {
      "txid": "5289ba065e1f593b2b3fc2b08a2173ce3ab32c7fbd469d02348f29b2dad31868",
      "hash": "5289ba065e1f593b2b3fc2b08a2173ce3ab32c7fbd469d02348f29b2dad31868",
      "version": 2,
      "size": 123,
      "vsize": 123,
      "weight": 492,
      "locktime": 0,
      "vin": [
        {
          "txid": "74faae74913f109b8e00a3f206c012282121ad198c5c6fe7eeed09e8b1ff43c6",
          "vout": 0,
          "scriptSig": {
            "asm": "",
            "hex": ""
          },
          "sequence": 4294967293
        },
        {
          "txid": "2dccce25cdbbd62427a4f1df77c72dd4ba0c0a1c1ccc778d044c12bd389536b6",
          "vout": 0,
          "scriptSig": {
            "asm": "",
            "hex": ""
          },
          "sequence": 4294967293
        }
      ],
      "vout": [
        {
          "value": 0.00000650,
          "n": 0,
          "scriptPubKey": {
            "asm": "0 36417cee22d21dd5806aec7b77c424023bb057f0",
            "desc": "addr(tb1qxeqhem3z6gwatqr2a3ah03pyqgamq4lsdkrsh4)#q2acrcrq",
            "hex": "001436417cee22d21dd5806aec7b77c424023bb057f0",
            "address": "tb1qxeqhem3z6gwatqr2a3ah03pyqgamq4lsdkrsh4",
            "type": "witness_v0_keyhash"
          }
        }
      ]
    },
    "global_xpubs": [
    ],
    "psbt_version": 0,
    "proprietary": [
    ],
    "unknown": {
    },
    "inputs": [
      {
      },
      {
      }
    ],
    "outputs": [
      {
      }
    ]
  }
  ```

- `bitcoin-cli -testnet -named analyzepsbt psbt=$psbt` 分析 psbt
  ```json
  {
    "inputs": [
      {
        "has_utxo": false,
        "is_final": false,
        "next": "updater"
      },
      {
        "has_utxo": false,
        "is_final": false,
        "next": "updater"
      }
    ],
    "next": "updater"
  }
  ```

- `bitcoin-cli -testnet walletprocesspsbt $psbt` 用钱包 Update，Sign and Finalize PSBT
  ```json
  {
    "psbt": "cHNidP8BAHsCAAAAAsZD/7HoCe3u529cjBmtISEoEsAG8qMAjpsQP5F0rvp0AAAAAAD9////tjaVOL0STASNd8wcHAoMutQtx3ff8aQnJNa7zSXOzC0AAAAAAP3///8BigIAAAAAAAAWABQ2QXzuItId1YBq7Ht3xCQCO7BX8AAAAAAAAQB3AgAAAAFtbA77vmUbqc8Q14c3J6WKIyJ/c9sC/vhZIxgTY/IQNQEAAAAA/f///wKghgEAAAAAABl2qRSlyaarbwiYAGPznnuuHoONUN3dRIis3ObxSgIAAAAZdqkUP03o9G3DzqDDnavvKfVBSh2/We+IrNbQJgABB2pHMEQCICU8UPVv/nrVH4/SILJhcA/c1aiThl2BanAgUBCvRaKyAiAzdlg9ldvumFpao0OeOiuyj0SrGZvAcpwGHE7Q/MLYzgEhA/jR5KLFiZGtelWgfR8VteWYSPBViKZaV9JmBku6hhHjAAEAdwIAAAABZ8MlD9ZoLLbjbcbQ1op40Cd9iNigrpCWKO7Wmb/rzLEBAAAAAP3///8CoIYBAAAAAAAZdqkUpcmmq28ImABj8557rh6DjVDd3USIrCm9OJAIAAAAGXapFEIMLWyggN+yqGHBmF7oAXIH0T9CiKxv0SYAAQdqRzBEAiBP0vuKDFA7tO7I1CgQNScKsqiMwSa2fcTtP8hatpfSdwIgGs7fBeqCzLMubfR03+38NMqtx0OKUAynY2oLTDarE0ABIQP40eSixYmRrXpVoH0fFbXlmEjwVYimWlfSZgZLuoYR4wAiAgLI5jUYmvHwUdjEna5lOVBWNE6HBB52gNhdDsx4kV3NkhiYgaI7VAAAgAEAAIAAAACAAAAAAAAAAAAA",
    "complete": true,
    "hex": "0200000002c643ffb1e809edeee76f5c8c19ad21212812c006f2a3008e9b103f9174aefa74000000006a4730440220253c50f56ffe7ad51f8fd220b261700fdcd5a893865d816a70205010af45a2b202203376583d95dbee985a5aa3439e3a2bb28f44ab199bc0729c061c4ed0fcc2d8ce012103f8d1e4a2c58991ad7a55a07d1f15b5e59848f05588a65a57d266064bba8611e3fdffffffb6369538bd124c048d77cc1c1c0a0cbad42dc777dff1a42724d6bbcd25cecc2d000000006a47304402204fd2fb8a0c503bb4eec8d4281035270ab2a88cc126b67dc4ed3fc85ab697d27702201acedf05ea82ccb32e6df474dfedfc34caadc7438a500ca7636a0b4c36ab1340012103f8d1e4a2c58991ad7a55a07d1f15b5e59848f05588a65a57d266064bba8611e3fdffffff018a0200000000000016001436417cee22d21dd5806aec7b77c424023bb057f000000000"
  }
  ```
- `psbt_f="cHNidP8BAHsCAAAAAsZD/7HoCe3u529cjBmtISEoEsAG8qMAjpsQP5F0rvp0AAAAAAD9////tjaVOL0STASNd8wcHAoMutQtx3ff8aQnJNa7zSXOzC0AAAAAAP3///8BigIAAAAAAAAWABQ2QXzuItId1YBq7Ht3xCQCO7BX8AAAAAAAAQB3AgAAAAFtbA77vmUbqc8Q14c3J6WKIyJ/c9sC/vhZIxgTY/IQNQEAAAAA/f///wKghgEAAAAAABl2qRSlyaarbwiYAGPznnuuHoONUN3dRIis3ObxSgIAAAAZdqkUP03o9G3DzqDDnavvKfVBSh2/We+IrNbQJgABB2pHMEQCICU8UPVv/nrVH4/SILJhcA/c1aiThl2BanAgUBCvRaKyAiAzdlg9ldvumFpao0OeOiuyj0SrGZvAcpwGHE7Q/MLYzgEhA/jR5KLFiZGtelWgfR8VteWYSPBViKZaV9JmBku6hhHjAAEAdwIAAAABZ8MlD9ZoLLbjbcbQ1op40Cd9iNigrpCWKO7Wmb/rzLEBAAAAAP3///8CoIYBAAAAAAAZdqkUpcmmq28ImABj8557rh6DjVDd3USIrCm9OJAIAAAAGXapFEIMLWyggN+yqGHBmF7oAXIH0T9CiKxv0SYAAQdqRzBEAiBP0vuKDFA7tO7I1CgQNScKsqiMwSa2fcTtP8hatpfSdwIgGs7fBeqCzLMubfR03+38NMqtx0OKUAynY2oLTDarE0ABIQP40eSixYmRrXpVoH0fFbXlmEjwVYimWlfSZgZLuoYR4wAiAgLI5jUYmvHwUdjEna5lOVBWNE6HBB52gNhdDsx4kV3NkhiYgaI7VAAAgAEAAIAAAACAAAAAAAAAAAAA"`
- `psbt_f=$(bitcoin-cli -testnet walletprocesspsbt $psbt | jq -r '.psbt')` or 
- `bitcoin-cli -testnet -named decodepsbt psbt=$psbt_f`
  ```json
  {
    "tx": {
      "txid": "5289ba065e1f593b2b3fc2b08a2173ce3ab32c7fbd469d02348f29b2dad31868",
      "hash": "5289ba065e1f593b2b3fc2b08a2173ce3ab32c7fbd469d02348f29b2dad31868",
      "version": 2,
      "size": 123,
      "vsize": 123,
      "weight": 492,
      "locktime": 0,
      "vin": [
        {
          "txid": "74faae74913f109b8e00a3f206c012282121ad198c5c6fe7eeed09e8b1ff43c6",
          "vout": 0,
          "scriptSig": {
            "asm": "",
            "hex": ""
          },
          "sequence": 4294967293
        },
        {
          "txid": "2dccce25cdbbd62427a4f1df77c72dd4ba0c0a1c1ccc778d044c12bd389536b6",
          "vout": 0,
          "scriptSig": {
            "asm": "",
            "hex": ""
          },
          "sequence": 4294967293
        }
      ],
      "vout": [
        {
          "value": 0.00000650,
          "n": 0,
          "scriptPubKey": {
            "asm": "0 36417cee22d21dd5806aec7b77c424023bb057f0",
            "desc": "addr(tb1qxeqhem3z6gwatqr2a3ah03pyqgamq4lsdkrsh4)#q2acrcrq",
            "hex": "001436417cee22d21dd5806aec7b77c424023bb057f0",
            "address": "tb1qxeqhem3z6gwatqr2a3ah03pyqgamq4lsdkrsh4",
            "type": "witness_v0_keyhash"
          }
        }
      ]
    },
    "global_xpubs": [
    ],
    "psbt_version": 0,
    "proprietary": [
    ],
    "unknown": {
    },
    "inputs": [
      {
        "non_witness_utxo": {
          "txid": "74faae74913f109b8e00a3f206c012282121ad198c5c6fe7eeed09e8b1ff43c6",
          "hash": "74faae74913f109b8e00a3f206c012282121ad198c5c6fe7eeed09e8b1ff43c6",
          "version": 2,
          "size": 119,
          "vsize": 119,
          "weight": 476,
          "locktime": 2543830,
          "vin": [
            {
              "txid": "3510f26313182359f8fe02db737f22238aa5273787d710cfa91b65befb0e6c6d",
              "vout": 1,
              "scriptSig": {
                "asm": "",
                "hex": ""
              },
              "sequence": 4294967293
            }
          ],
          "vout": [
            {
              "value": 0.00100000,
              "n": 0,
              "scriptPubKey": {
                "asm": "OP_DUP OP_HASH160 a5c9a6ab6f08980063f39e7bae1e838d50dddd44 OP_EQUALVERIFY OP_CHECKSIG",
                "desc": "addr(mvdZMfdZVLPogTfM35pDZNapx52TGwJ7Eu)#s5ce2mu3",
                "hex": "76a914a5c9a6ab6f08980063f39e7bae1e838d50dddd4488ac",
                "address": "mvdZMfdZVLPogTfM35pDZNapx52TGwJ7Eu",
                "type": "pubkeyhash"
              }
            },
            {
              "value": 98.47301852,
              "n": 1,
              "scriptPubKey": {
                "asm": "OP_DUP OP_HASH160 3f4de8f46dc3cea0c39dabef29f5414a1dbf59ef OP_EQUALVERIFY OP_CHECKSIG",
                "desc": "addr(mmHgCRHsyvDsacapJY9SWvENywAKKeV9qy)#fzrq8nn6",
                "hex": "76a9143f4de8f46dc3cea0c39dabef29f5414a1dbf59ef88ac",
                "address": "mmHgCRHsyvDsacapJY9SWvENywAKKeV9qy",
                "type": "pubkeyhash"
              }
            }
          ]
        },
        "final_scriptSig": {
          "asm": "30440220253c50f56ffe7ad51f8fd220b261700fdcd5a893865d816a70205010af45a2b202203376583d95dbee985a5aa3439e3a2bb28f44ab199bc0729c061c4ed0fcc2d8ce[ALL] 03f8d1e4a2c58991ad7a55a07d1f15b5e59848f05588a65a57d266064bba8611e3",
          "hex": "4730440220253c50f56ffe7ad51f8fd220b261700fdcd5a893865d816a70205010af45a2b202203376583d95dbee985a5aa3439e3a2bb28f44ab199bc0729c061c4ed0fcc2d8ce012103f8d1e4a2c58991ad7a55a07d1f15b5e59848f05588a65a57d266064bba8611e3"
        }
      },
      {
        "non_witness_utxo": {
          "txid": "2dccce25cdbbd62427a4f1df77c72dd4ba0c0a1c1ccc778d044c12bd389536b6",
          "hash": "2dccce25cdbbd62427a4f1df77c72dd4ba0c0a1c1ccc778d044c12bd389536b6",
          "version": 2,
          "size": 119,
          "vsize": 119,
          "weight": 476,
          "locktime": 2543983,
          "vin": [
            {
              "txid": "b1ccebbf99d6ee289690aea0d8887d27d0788ad6d0c66de3b62c68d60f25c367",
              "vout": 1,
              "scriptSig": {
                "asm": "",
                "hex": ""
              },
              "sequence": 4294967293
            }
          ],
          "vout": [
            {
              "value": 0.00100000,
              "n": 0,
              "scriptPubKey": {
                "asm": "OP_DUP OP_HASH160 a5c9a6ab6f08980063f39e7bae1e838d50dddd44 OP_EQUALVERIFY OP_CHECKSIG",
                "desc": "addr(mvdZMfdZVLPogTfM35pDZNapx52TGwJ7Eu)#s5ce2mu3",
                "hex": "76a914a5c9a6ab6f08980063f39e7bae1e838d50dddd4488ac",
                "address": "mvdZMfdZVLPogTfM35pDZNapx52TGwJ7Eu",
                "type": "pubkeyhash"
              }
            },
            {
              "value": 367.79375913,
              "n": 1,
              "scriptPubKey": {
                "asm": "OP_DUP OP_HASH160 420c2d6ca080dfb2a861c1985ee8017207d13f42 OP_EQUALVERIFY OP_CHECKSIG",
                "desc": "addr(mmYBUpQNE4XBMHb4UQaAETTVn8iee57Z6d)#3r9pj8gg",
                "hex": "76a914420c2d6ca080dfb2a861c1985ee8017207d13f4288ac",
                "address": "mmYBUpQNE4XBMHb4UQaAETTVn8iee57Z6d",
                "type": "pubkeyhash"
              }
            }
          ]
        },
        "final_scriptSig": {
          "asm": "304402204fd2fb8a0c503bb4eec8d4281035270ab2a88cc126b67dc4ed3fc85ab697d27702201acedf05ea82ccb32e6df474dfedfc34caadc7438a500ca7636a0b4c36ab1340[ALL] 03f8d1e4a2c58991ad7a55a07d1f15b5e59848f05588a65a57d266064bba8611e3",
          "hex": "47304402204fd2fb8a0c503bb4eec8d4281035270ab2a88cc126b67dc4ed3fc85ab697d27702201acedf05ea82ccb32e6df474dfedfc34caadc7438a500ca7636a0b4c36ab1340012103f8d1e4a2c58991ad7a55a07d1f15b5e59848f05588a65a57d266064bba8611e3"
        }
      }
    ],
    "outputs": [
      {
        "bip32_derivs": [
          {
            "pubkey": "02c8e635189af1f051d8c49dae65395056344e87041e7680d85d0ecc78915dcd92",
            "master_fingerprint": "9881a23b",
            "path": "m/84h/1h/0h/0/0"
          }
        ]
      }
    ],
    "fee": 0.00199350
  }
  ```

 ##### Create a PSBT the Easy Way

- `bitcoin-cli -testnet -named walletcreatefundedpsbt inputs='''[ { "txid": "'$utxo_txid_1'", "vout": '$utxo_vout_1' }, { "txid": "'$utxo_txid_2'", "vout": '$utxo_vout_2' }]''' outputs='''{ "'$recipient'": 0.0000065 }'''` 
  ```json
  {
    "psbt": "cHNidP8BAJoCAAAAAsZD/7HoCe3u529cjBmtISEoEsAG8qMAjpsQP5F0rvp0AAAAAAD9////tjaVOL0STASNd8wcHAoMutQtx3ff8aQnJNa7zSXOzC0AAAAAAP3///8CvnsCAAAAAAAWABSWrKv4RT3SAOnB29odoHVgp3p5JYoCAAAAAAAAFgAUNkF87iLSHdWAaux7d8QkAjuwV/AAAAAAAAEAdwIAAAABbWwO+75lG6nPENeHNyeliiMif3PbAv74WSMYE2PyEDUBAAAAAP3///8CoIYBAAAAAAAZdqkUpcmmq28ImABj8557rh6DjVDd3USIrNzm8UoCAAAAGXapFD9N6PRtw86gw52r7yn1QUodv1nviKzW0CYAIgYD+NHkosWJka16VaB9HxW15ZhI8FWIplpX0mYGS7qGEeMYmIGiOywAAIABAACAAAAAgAAAAAAAAAAAAAEAdwIAAAABZ8MlD9ZoLLbjbcbQ1op40Cd9iNigrpCWKO7Wmb/rzLEBAAAAAP3///8CoIYBAAAAAAAZdqkUpcmmq28ImABj8557rh6DjVDd3USIrCm9OJAIAAAAGXapFEIMLWyggN+yqGHBmF7oAXIH0T9CiKxv0SYAIgYD+NHkosWJka16VaB9HxW15ZhI8FWIplpX0mYGS7qGEeMYmIGiOywAAIABAACAAAAAgAAAAAAAAAAAACICAghqRvs3MBppTy7S6s2+wrocfte4YdxZjGIXQviL30vZGJiBojtUAACAAQAAgAAAAIABAAAAAwAAAAAiAgLI5jUYmvHwUdjEna5lOVBWNE6HBB52gNhdDsx4kV3NkhiYgaI7VAAAgAEAAIAAAACAAAAAAAAAAAAA",
    "fee": 0.00036600,
    "changepos": 0
  }
  ```

- `psbt_new=$(bitcoin-cli -testnet -named walletcreatefundedpsbt inputs='''[]''' outputs='''{ "'$recipient'": 0.0000065 }''' | jq -r '.psbt')`
- `bitcoin-cli -testnet decodepsbt $psbt_new`

- `psbt_new_f=$(bitcoin-cli walletprocesspsbt $psbt_new | jq -r '.psbt')`
- `bitcoin-cli -testnet analyzepsbt $psbt_new_f`
  ```json
  {
    "inputs": [
      {
        "has_utxo": true,
        "is_final": true,
        "next": "extractor"
      }
    ],
    "estimated_vsize": 188,
    "estimated_feerate": 0.00102925,
    "fee": 0.00019350,
    "next": "extractor"
  }
  ```

- `bitcoin-cli -testnet finalizepsbt $psbt_f`
  ```json
  {
    "hex": "0200000002c643ffb1e809edeee76f5c8c19ad21212812c006f2a3008e9b103f9174aefa74000000006a4730440220253c50f56ffe7ad51f8fd220b261700fdcd5a893865d816a70205010af45a2b202203376583d95dbee985a5aa3439e3a2bb28f44ab199bc0729c061c4ed0fcc2d8ce012103f8d1e4a2c58991ad7a55a07d1f15b5e59848f05588a65a57d266064bba8611e3fdffffffb6369538bd124c048d77cc1c1c0a0cbad42dc777dff1a42724d6bbcd25cecc2d000000006a47304402204fd2fb8a0c503bb4eec8d4281035270ab2a88cc126b67dc4ed3fc85ab697d27702201acedf05ea82ccb32e6df474dfedfc34caadc7438a500ca7636a0b4c36ab1340012103f8d1e4a2c58991ad7a55a07d1f15b5e59848f05588a65a57d266064bba8611e3fdffffff018a0200000000000016001436417cee22d21dd5806aec7b77c424023bb057f000000000",
    "complete": true
  }
  ```
- `psbt_hex=$(bitcoin-cli -testnet finalizepsbt $psbt_f | jq -r '.hex')`
- `psbt_txid=$(bitcoin-cli -testnet -named sendrawtransaction hexstring=$psbt_hex)`
- `echo $psbt_txid`
  `17bcef84b95467dc2de2dea66f007b1ce793d691f58fc2172d35f2031e28b43c`

#### Use a PSBT to Spend MultiSig Funds
- `split1=$(bitcoin-cli -testnet getnewaddress)`
- `split2=$(bitcoin-cli -testnet getnewaddress)`
- `utxo_txid=$(bitcoin-cli -testnet listunspent | jq -r '.[1] .txid')`
- `utxo_vout=$(bitcoin-cli -testnet listunspent | jq -r '.[1] .vout')`
- `psbt=$(bitcoin-cli -testnet -named createpsbt inputs='''[ { "txid": "'$utxo_txid'", "vout": '$utxo_vout' }]''' outputs='''{"'$split1'": 0.0004, "'$split2'": 0.0004 }''')`
- `echo $psbt`
  `cHNidP8BAHECAAAAAVw1Rdw+SQTbwRqE6ckrt4OTu4uGhgoGPc8/5EszFIjvAQAAAAD9////AkCcAAAAAAAAFgAUnRjg25nuZMldEuLUmvjmYpVWEbJAnAAAAAAAABYAFMt4p7vLkwkrPW8rapx9zXczfX6IAAAAAAAAAAA=`

- `psbt_p1=$(bitcoin-cli -testnet walletprocesspsbt $psbt | jq -r '.psbt')` on machine1
- `bitcoin-cli -testnet decodepsbt $psbt_p1`
- `bitcoin-cli -testnet analyzepsbt $psbt_p1`
  
- `psbt="cHNidP8BAHECAAAAAVw1Rdw+SQTbwRqE6ckrt4OTu4uGhgoGPc8/5EszFIjvAQAAAAD9////AkCcAAAAAAAAFgAUnRjg25nuZMldEuLUmvjmYpVWEbJAnAAAAAAAABYAFMt4p7vLkwkrPW8rapx9zXczfX6IAAAAAAAAAAA="` on machine2
- `psbt_p2=$(bitcoin-cli -testnet walletprocesspsbt $psbt | jq -r '.psbt')` on machine2
- `psbt_c=$(bitcoin-cli -testnet combinepsbt '''["'$psbt_p1'", "'$psbt_p2'"]''')` on machine2
- `bitcoin-cli -testnet decodepsbt $psbt_c`
- `bitcoin-cli -testnet analyzepsbt $psbt_c`
- `psbt_c_hex=$(bitcoin-cli -testnet finalizepsbt $psbt_c | jq -r '.hex')` on machine2
- `bitcoin-cli -testnet -named sendrawtransaction hexstring=$psbt_c_hex`
  
#### Use a PSBT to Pool Money

- `utxo_txid_1=$(bitcoin-cli -testnet listunspent | jq -r '.[2] .txid')` on machine1
- `utxo_vout_1=$(bitcoin-cli -testnet listunspent | jq -r '.[2] .vout')`
- `utxo_txid_2=$(bitcoin-cli -testnet listunspent | jq -r '.[4] .txid')` on machine2
- `utxo_vout_2=$(bitcoin-cli -testnet listunspent | jq -r '.[4] .vout')`
- `echo $utxo_txid_2`
  `e2ce7e21638e39adf17f8bef482f4ba4cbc4d1cfd6635ae39177c7345d5f9309`
- `echo $utxo_vout_2`
  `0`

- `utxo_txid_2="e2ce7e21638e39adf17f8bef482f4ba4cbc4d1cfd6635ae39177c7345d5f9309"` on machine1
- `utxo_vout_2=0`
- `multisig=$(bitcoin-cli -testnet getnewaddress)`
- `echo $multisig`
  `tb1qltvpduwfgp6ulune3sl56pamq7zw0uk6cmsfwq`

- `psbt=$(bitcoin-cli -testnet -named createpsbt inputs='''[ { "txid": "'$utxo_txid_1'", "vout": '$utxo_vout_1' }, { "txid": "'$utxo_txid_2'", "vout": '$utxo_vout_2' } ]''' outputs='''{ "'$multisig'": 0.0019998 }''')`

- `bitcoin-cli -testnet decodepsbt $psbt`
- `bitcoin-cli -testnet analyzepsbt $psbt`
  ```json
  {
    "inputs": [
      {
        "has_utxo": false,
        "is_final": false,
        "next": "updater"
      },
      {
        "has_utxo": false,
        "is_final": false,
        "next": "updater"
      }
    ],
    "next": "updater"
  }```

- `bitcoin-cli -testnet walletprocesspsbt $psbt` 
  ```json
  {
    "psbt": "cHNidP8BAHsCAAAAAm+dbjpB2bt0L0gFHyQxLkNljXEMURWT42jYfPZmfbAlAAAAAAD9////CZNfXTTHd5HjWmPWz9HEy6RLL0jvi3/xrTmOYyF+zuIAAAAAAP3///8BLA0DAAAAAAAWABT62BbxyUB1z/J5jD9NB7sHhOfy2gAAAAAAAQB3AgAAAAFBRf5fL2aZbaNz1iZ+hvefn+yjF+00uaSETu3t/t57RQAAAAAA/f///wKghgEAAAAAABl2qRSlyaarbwiYAGPznnuuHoONUN3dRIisdcxvkAgAAAAZdqkU+5NfaQPUdMV7EdG0eBc0xZwEQCSIrN/QJgABB2pHMEQCIEcmYekd7GkvmTZqdk2JaO8mQqYZDxwI8eqw0TThMVIeAiAFiaU6osJ98iS94ZeHiviwGhmLsNx6LAmDoNOkLmltBwEhA/jR5KLFiZGtelWgfR8VteWYSPBViKZaV9JmBku6hhHjAAEAdwIAAAABqPdWblSHDdlPVa2WhFeAsjzJAYDTYC3YBwnnIsIr7CQAAAAAAP3///8CoIYBAAAAAAAZdqkUpcmmq28ImABj8557rh6DjVDd3USIrI9AmUoCAAAAGXapFBnCNB7CJsd3/2sOkh6ehXoRQuVbiKxL0SYAAQdqRzBEAiBinkA59k6khbkwy7NONzbggMSRn/vLoc7x7nJMjX2WNQIgBLZutfK7pgUH5NtuBIqkHf3OmbLp1g3Qt2+bHwQI1joBIQP40eSixYmRrXpVoH0fFbXlmEjwVYimWlfSZgZLuoYR4wAiAgOcb0kjfcB86PvdFAhT2Rmbe9D1v0fCROJVB27jvhBTxBiYgaI7VAAAgAEAAIAAAACAAAAAAAYAAAAA",
    "complete": true,
    "hex": "02000000026f9d6e3a41d9bb742f48051f24312e43658d710c511593e368d87cf6667db025000000006a4730440220472661e91dec692f99366a764d8968ef2642a6190f1c08f1eab0d134e131521e02200589a53aa2c27df224bde197878af8b01a198bb0dc7a2c0983a0d3a42e696d07012103f8d1e4a2c58991ad7a55a07d1f15b5e59848f05588a65a57d266064bba8611e3fdffffff09935f5d34c77791e35a63d6cfd1c4cba44b2f48ef8b7ff1ad398e63217ecee2000000006a4730440220629e4039f64ea485b930cbb34e3736e080c4919ffbcba1cef1ee724c8d7d9635022004b66eb5f2bba60507e4db6e048aa41dfdce99b2e9d60dd0b76f9b1f0408d63a012103f8d1e4a2c58991ad7a55a07d1f15b5e59848f05588a65a57d266064bba8611e3fdffffff012c0d030000000000160014fad816f1c94075cff2798c3f4d07bb0784e7f2da00000000"
  }
  ```

- `psbt_p="cHNidP8BAHsCAAAAAm+dbjpB2bt0L0gFHyQxLkNljXEMURWT42jYfPZmfbAlAAAAAAD9////CZNfXTTHd5HjWmPWz9HEy6RLL0jvi3/xrTmOYyF+zuIAAAAAAP3///8BLA0DAAAAAAAWABT62BbxyUB1z/J5jD9NB7sHhOfy2gAAAAAAAQB3AgAAAAFBRf5fL2aZbaNz1iZ+hvefn+yjF+00uaSETu3t/t57RQAAAAAA/f///wKghgEAAAAAABl2qRSlyaarbwiYAGPznnuuHoONUN3dRIisdcxvkAgAAAAZdqkU+5NfaQPUdMV7EdG0eBc0xZwEQCSIrN/QJgABB2pHMEQCIEcmYekd7GkvmTZqdk2JaO8mQqYZDxwI8eqw0TThMVIeAiAFiaU6osJ98iS94ZeHiviwGhmLsNx6LAmDoNOkLmltBwEhA/jR5KLFiZGtelWgfR8VteWYSPBViKZaV9JmBku6hhHjAAEAdwIAAAABqPdWblSHDdlPVa2WhFeAsjzJAYDTYC3YBwnnIsIr7CQAAAAAAP3///8CoIYBAAAAAAAZdqkUpcmmq28ImABj8557rh6DjVDd3USIrI9AmUoCAAAAGXapFBnCNB7CJsd3/2sOkh6ehXoRQuVbiKxL0SYAAQdqRzBEAiBinkA59k6khbkwy7NONzbggMSRn/vLoc7x7nJMjX2WNQIgBLZutfK7pgUH5NtuBIqkHf3OmbLp1g3Qt2+bHwQI1joBIQP40eSixYmRrXpVoH0fFbXlmEjwVYimWlfSZgZLuoYR4wAiAgOcb0kjfcB86PvdFAhT2Rmbe9D1v0fCROJVB27jvhBTxBiYgaI7VAAAgAEAAIAAAACAAAAAAAYAAAAA"` on machine2
- `psbt_f=$(bitcoin-cli -testnet walletprocesspsbt $psbt_p | jq -r '.psbt')`
- `psbt_hex=$(bitcoin-cli -testnet finalizepsbt $psbt_f | jq -r '.hex')`
- `multisig_txid=$(bitcoin-cli -testnet -named sendrawtransaction hexstring=$psbt_hex)`

#### Sending a Transaction with a Locktime
- `rawtxhex=$(bitcoin-cli =estnet -named createrawtransaction inputs='''[ { "txid": "'$utxo_txid'", "vout": '$utxo_vout' } ]''' outputs='''{ "'$recipient'": 0.001, "'$changeaddress'": 0.00095 }''' locktime=1774650)`

- `signedtx=$(bitcoin-cli testnet -named signrawtransactionwithwallet hexstring=$rawtxhex | jq -r '.hex')`
- `bitcoin-cli -testnet -named sendrawtransaction hexstring=$signedtx` Since 2013, you generally can't place the timelocked transaction into the mempool until its lock has expired, otherwise will got an error
  
#### Sending a Transaction with Data
- `sha256sum contract.jpg`
  `efb335158c77dbc659c6115769de0d1c3f0dc6dc92a7e864fcf83ff098460233`
- `op_return_data="efb335158c77dbc659c6115769de0d1c3f0dc6dc92a7e864fcf83ff098460233"`
- `utxo_txid=$(bitcoin-cli -testnet listunspent | jq -r '.[0] | .txid')`
- `utxo_vout=$(bitcoin-cli -testnet listunspent | jq -r '.[0] | .vout')`
- `changeaddress=$(bitcoin-cli -testnet getrawchangeaddress)`
  
- `rawtxhex=$(bitcoin-cli -testnet -named createrawtransaction inputs='''[ { "txid": "'$utxo_txid'", "vout": '$utxo_vout' } ]''' outputs='''{ "data": "'$op_return_data'", "'$changeaddress'": 0.0000146 }''')`

- `signedtx=$(bitcoin-cli -testnet -named signrawtransactionwithwallet hexstring=$rawtxhex | jq -r '.hex')`
- `bitcoin-cli -testnet -named sendrawtransaction hexstring=$signedtx`

#### Understanding the Foundation of Transactions

- `utxo_txid=$(bitcoin-cli -testnet listunspent | jq -r '.[1] | .txid')`
- `utxo_vout=$(bitcoin-cli -testnet listunspent | jq -r '.[1] | .vout')`
- `recipient=$(bitcoin-cli -testnet -named getrawchangeaddress address_type=legacy)`
- `rawtxhex=$(bitcoin-cli -testnet -named createrawtransaction inputs='''[ { "txid": "'$utxo_txid'", "vout": '$utxo_vout' } ]''' outputs='''{ "'$recipient'": 0.0009 }''')`
- `signedtx=$(bitcoin-cli -testnet -named signrawtransactionwithwallet hexstring=$rawtxhex | jq -r '.hex')`
- `bitcoin-cli -testnet -named decoderawtransaction hexstring=$signedtx`
  ```json
  {
    "txid": "a1b8ad9de75137ed64679ffacc3751ef5806075e09cb30d378e04b069609db79",
    "hash": "a1b8ad9de75137ed64679ffacc3751ef5806075e09cb30d378e04b069609db79",
    "version": 2,
    "size": 191,
    "vsize": 191,
    "weight": 764,
    "locktime": 0,
    "vin": [
      {
        "txid": "ef8814334be43fcf3d060a86868bbb9383b72bc9e9841ac1db04493edc45355c",
        "vout": 1,
        "scriptSig": {
          "asm": "304402202c059160674162ea445bd5ee039b2e6e090a5c8cd68f267e2d6b1f6d8987421b022027501f2d2673d9768d2a373c6913c3a2f005ed2b45d199024d61420bd23650a2[ALL] 03f8d1e4a2c58991ad7a55a07d1f15b5e59848f05588a65a57d266064bba8611e3",
          "hex": "47304402202c059160674162ea445bd5ee039b2e6e090a5c8cd68f267e2d6b1f6d8987421b022027501f2d2673d9768d2a373c6913c3a2f005ed2b45d199024d61420bd23650a2012103f8d1e4a2c58991ad7a55a07d1f15b5e59848f05588a65a57d266064bba8611e3"
        },
        "sequence": 4294967293
      }
    ],
    "vout": [
      {
        "value": 0.00090000,
        "n": 0,
        "scriptPubKey": {
          "asm": "OP_DUP OP_HASH160 c03b4d65296b2542d13432280d4036f6d97c505c OP_EQUALVERIFY OP_CHECKSIG",
          "desc": "addr(my3P5HP2rMPuXyPiJAinAZHPCxEmNF1wuA)#3jxdcs5g",
          "hex": "76a914c03b4d65296b2542d13432280d4036f6d97c505c88ac",
          "address": "my3P5HP2rMPuXyPiJAinAZHPCxEmNF1wuA",
          "type": "pubkeyhash"
        }
      }
    ]
  }
  ``

#### Scripting a P2PKH

- `hex=$(bitcoin-cli -testnet -named gettransaction txid="ef8814334be43fcf3d060a86868bbb9383b72bc9e9841ac1db04493edc45355c" | jq -r '.hex')`
- `bitcoin-cli -testnet -named decoderawtransaction hexstring=$hex`
  ```json
  {
    "txid": "ef8814334be43fcf3d060a86868bbb9383b72bc9e9841ac1db04493edc45355c",
    "hash": "7b462cb5ea33da425c8137f96c37010e4dacba929e518a48460f0e8340593415",
    "version": 2,
    "size": 228,
    "vsize": 147,
    "weight": 585,
    "locktime": 2547148,
    "vin": [
      {
        "txid": "b52d5170b4e63fe80b45de11312b3c5e58e644a18eb950716760e4a3ca2eb920",
        "vout": 1,
        "scriptSig": {
          "asm": "",
          "hex": ""
        },
        "txinwitness": [
          "30440220399a8cdd4549e52a399b481179b49a3ddb21a14e73d56ea99bec0db4d43476e1022064cc73c9001528ba9f1de056e6657fd92226215160dd1d97fdc830ee3326c20601",
          "03939495de9bea9ad95eb72cadb6fbbaeeb6aa2db1e017abd7e400d6d42a7e670c"
        ],
        "sequence": 4294967293
      }
    ],
    "vout": [
      {
        "value": 98.12745764,
        "n": 0,
        "scriptPubKey": {
          "asm": "OP_DUP OP_HASH160 8218e133bcb7f61f3c41a8054684ca43c8441adb OP_EQUALVERIFY OP_CHECKSIG",
          "desc": "addr(msNqwfSPw71fAWdMbTpHtPh1N7o6qAnzqv)#ncjutp4j",
          "hex": "76a9148218e133bcb7f61f3c41a8054684ca43c8441adb88ac",
          "address": "msNqwfSPw71fAWdMbTpHtPh1N7o6qAnzqv",
          "type": "pubkeyhash"
        }
      },
      {
        "value": 0.00100000,
        "n": 1,
        "scriptPubKey": {
          "asm": "OP_DUP OP_HASH160 a5c9a6ab6f08980063f39e7bae1e838d50dddd44 OP_EQUALVERIFY OP_CHECKSIG",
          "desc": "addr(mvdZMfdZVLPogTfM35pDZNapx52TGwJ7Eu)#s5ce2mu3",
          "hex": "76a914a5c9a6ab6f08980063f39e7bae1e838d50dddd4488ac",
          "address": "mvdZMfdZVLPogTfM35pDZNapx52TGwJ7Eu",
          "type": "pubkeyhash"
        }
      }
    ]
  }
  ```

- `btcdeb '[304402202c059160674162ea445bd5ee039b2e6e090a5c8cd68f267e2d6b1f6d8987421b022027501f2d2673d9768d2a373c6913c3a2f005ed2b45d199024d61420bd23650a2 03f8d1e4a2c58991ad7a55a07d1f15b5e59848f05588a65a57d266064bba8611e3 OP_DUP OP_HASH160 a5c9a6ab6f08980063f39e7bae1e838d50dddd44 OP_EQUALVERIFY OP_CHECKSIG]'` 用本次交易的vins中的scriptSig里的asm中的前半部分([ALL]前面)当成私签名， 后半部分为公钥，连接上一次对应的vout中的scriptPubKey中的asm字段内容形成解锁脚本


#### Understand a P2SH-Segwit Script
- `bitcoin-cli -testnet getnewaddress -addresstype p2sh-segwit`
  `2MsyMNBAkrrtHsYz9nWWWWCyE3GbVEEFjTe` 测试网地址以 `2` 开头，主网以 `3` 开头

#### Writing Puzzle Scripts

- `3x + 7 = 13` `OP_DUP OP_DUP OP_ADD OP_ADD 7 OP_ADD 13 OP_EQUAL`
- `btcdeb '[2 OP_DUP OP_DUP OP_ADD OP_ADD 7 OP_ADD 13 OP_EQUAL]'` when `x` is `2`