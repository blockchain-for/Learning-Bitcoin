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
- 