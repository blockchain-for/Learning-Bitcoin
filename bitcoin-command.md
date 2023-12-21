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
    ```
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
        ...
    ]
    ```

- `utxo_txid="da5a6dcaef07437ced41c5f5f6363790b5ceb71170003dc876b325f6ba9dfaa6"`
-  `utxo_vout=1`
-  `recipient="2Mz87LWo5GgbHVZhx48nxZQfCh84opc9rzn"`

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
```

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
  