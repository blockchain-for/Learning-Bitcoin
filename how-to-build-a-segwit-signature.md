# Segwit Algorithm:

## Segwit algorithm 相对于 Legacy algorithm的好处：

- 更高效 - 在构建用于签名的交易Hash时，交易数据被分离成单独的可重用部分。
- 需要输入金额 - 强调了解交易输入的价值，对计算费用有用。
1. 创建交易 - 交易必须包含 marker，flag，witness 字段。其中witness 字段暂为 空，最后将是最终签名的地方，scriptSig 字段 为空：
    
    ```
    Raw Transaction (Unsigned):
    
    version: 02000000
    marker: 00
    flag: 01
    inputs:  01
      txid: ac4994014aa36b7f53375658ef595b3cb2891e1735fe5b441686f5e53338e76a
      vout: 01000000
      scriptsigsize: 00
      scriptsig:
      sequence: ffffffff
    outputs: 01
      amount: 204e000000000000
      scriptpubkeysize: 19
      scriptpubkey: 76a914ce72abfd0e6d9354a660c18f2825eb392f060fdc88ac
    witness: 00
    locktime: 00000000
    ```
    
2. 构造原像和原像 hash - 这是 segwit signing algorithm 和 legacy signing algorigthm 的不同之处。
    
    不对交易数据原样进行hash处理，而是将其分为单独的片断，然后以特定方式重构，以创建可 用于签名的Hash 的新数据片断，原因是，如果交易有很多需要为其创建签名的输入数据，那么未签名交易数据的许多部分可以重用
    
    1). 抓取 version 字段 (可重用) - 从原始未签名交易中获取 version 字段
    
    version = 02000000
    
    2). 对 input 中的 txids 和 vouts 进行序列化和 hash 处理 (可重用) - 如果只有一个输入，那结果是hash26(txid+vout);如果有多个输入，则是hash256((txid+vout)+(txid+vout)+(txid+vout)+…)
    
    ```
    inputs          = ac4994014aa36b7f53375658ef595b3cb2891e1735fe5b441686f5e53338e76a01000000
    hash256(inputs) = cbfaca386d65ea7043aaac40302325d0dc7391a73b585571e28d3287d6b16203
    ```
    
    3). 对 input 中的 sequence 进行序列化和 hash (可重用)
    
    ```
    sequences          = ffffffff
    hash256(sequences) = 3bb13029ce7b1f559ef5e747fcac439f1455a2ec7c5f09b72290795e70665044
    ```
    
    4). 序列化要签名的 input 中的 txid 和vout （不可重用）
    `input = ac4994014aa36b7f53375658ef595b3cb2891e1735fe5b441686f5e53338e76a01000000`
    
    5). 为要签名的 input 创建 scriptcode - scriptcode 是被花费的 output 中 scriptPubKey 的修改版本
    `scriptcode = 1976a914{publickeyhash}88ac`
    
    ![Untitled](Segwit%20Algorithm%2080b914f31cf24d668a082326cc66d927/Untitled.png)
    
    6). 查找 input 金额 (不可重用) - 从 之前的交易 output 中找到金额，此例子中的金额是：30000 satoshis，以8字节小端表示
    
    `amount = 3075000000000000` 
    
    7). 获取 要签名 input 中 sequence (不可重用) 
    
    `sequence = ffffffff`
    
    8). 序列化 和 hash 所有 outputs (可重用) - hash256(amount+scriptpubkeysize+scriptpubkey)
    
    ```
    outputs          = 204e0000000000001976a914ce72abfd0e6d9354a660c18f2825eb392f060fdc88ac
    hash256(outputs) = 900a6c6ff6cd938bf863e50613a4ed5fb1661b78649fe354116edaf5d4abb952
    ```
    
    9). 获取 原始交易中的 locktime (可重用) 
    
    `locktime = 00000000`
    
    10). 组合创始 hash preimage (原像) - 连接之前的内容作为 preimage
    
    ```
    preimage = version + hash256(inputs) + hash256(sequences) + input + scriptcode + amount + sequence + hash256(outputs) + locktime
    
    preimage = 02000000cbfaca386d65ea7043aaac40302325d0dc7391a73b585571e28d3287d6b162033bb13029ce7b1f559ef5e747fcac439f1455a2ec7c5f09b72290795e70665044ac4994014aa36b7f53375658ef595b3cb2891e1735fe5b441686f5e53338e76a010000001976a914aa966f56de599b4094b61aa68a2b3df9e97e9c4888ac3075000000000000ffffffff900a6c6ff6cd938bf863e50613a4ed5fb1661b78649fe354116edaf5d4abb95200000000
    ```
    
    11). 在 hash preimage 末尾追加 signature hash type - 追加一个signature hash type 对应 4 字节的小端字段
    
    `preimage = 02000000cbfaca386d65ea7043aaac40302325d0dc7391a73b585571e28d3287d6b162033bb13029ce7b1f559ef5e747fcac439f1455a2ec7c5f09b72290795e70665044ac4994014aa36b7f53375658ef595b3cb2891e1735fe5b441686f5e53338e76a010000001976a914aa966f56de599b4094b61aa68a2b3df9e97e9c4888ac3075000000000000ffffffff900a6c6ff6cd938bf863e50613a4ed5fb1661b78649fe354116edaf5d4abb9520000000001000000`
    
    12). 对 preimage 进行 hash
    
    ```
    message = hash256(preimage)
    message = d7b60220e1b9b2c1ab40845118baf515203f7b6f0ad83cbb68d3c89b5b3098a6
    ```
    
3. 对 preimage hash 进行 签名
    
    ```
    nonce             (k): 75bcd15 (hex)
    hash256(preimage) (z): d7b60220e1b9b2c1ab40845118baf515203f7b6f0ad83cbb68d3c89b5b3098a6 (hex)
    private key       (d): 7306f5092467981e66eff98b6b03bfe925922c5ecfaf14c4257ef18e81becf1f (hex)
    
    random point (k*G = R): {
      x = 4051293998585674784991639592782214972820158391371785981004352359465450369227,
      y = 88166831356626186178414913298033275054086243781277878360288998796587140930350
    }
    
    signature: r = R[x], s = k⁻¹ * (z + r * d): {
      r = 4051293998585674784991639592782214972820158391371785981004352359465450369227,
      s = 22928756034338380041288899807245402174768928418361705349511346173579327129676
    }
    ```
    
4. 使用较低的 s 值
    
    ```
    s (high) = 92863333202977815382282085201442505678068635860713199033093816967938834364661
    s (low)  = 22928756034338380041288899807245402174768928418361705349511346173579327129676
    ```
    
5. 对 签名进行 DER 编码
    
    ```
    signature: {
      r = 4051293998585674784991639592782214972820158391371785981004352359465450369227,
      s = 22928756034338380041288899807245402174768928418361705349511346173579327129676
    }
    
    der encoded signature:
    type: 30
      length: 44
      type:   02
        length: 20
        r:      08f4f37e2d8f74e18c1b8fde2374d5f28402fb8ab7fd1cc5b786aa40851a70cb
      type:   02
        length: 20
        s:      32b1374d1a0f125eae4f69d1bc0b7f896c964cfdba329f38a952426cf427484c
    
    serialized: 3044022008f4f37e2d8f74e18c1b8fde2374d5f28402fb8ab7fd1cc5b786aa40851a70cb022032b1374d1a0f125eae4f69d1bc0b7f896c964cfdba329f38a952426cf427484c
    ```
    
6. 将 signature hash type 追加到 已经 DER 编码后的签名末尾 - 只追加 1 字节
    
    `der encoded signature (with sighash): 3044022008f4f37e2d8f74e18c1b8fde2374d5f28402fb8ab7fd1cc5b786aa40851a70cb022032b1374d1a0f125eae4f69d1bc0b7f896c964cfdba329f38a952426cf427484c01`
    
7. 构建 witness 字段
    
    ```
    signature:  3044022008f4f37e2d8f74e18c1b8fde2374d5f28402fb8ab7fd1cc5b786aa40851a70cb022032b1374d1a0f125eae4f69d1bc0b7f896c964cfdba329f38a952426cf427484c01
    public key: 03eed0d937090cae6ffde917de8a80dc6156e30b13edd5e51e2e50d52428da1c87
    
        witness = 02473044022008f4f37e2d8f74e18c1b8fde2374d5f28402fb8ab7fd1cc5b786aa40851a70cb022032b1374d1a0f125eae4f69d1bc0b7f896c964cfdba329f38a952426cf427484c012103eed0d937090cae6ffde917de8a80dc6156e30b13edd5e51e2e50d52428da1c87
    ```
    
8. 将整个 witness 字段插回到 transaction 中
    
    ```
    version: 02000000
    marker: 00
    flag: 01
    inputs:  01
      txid: ac4994014aa36b7f53375658ef595b3cb2891e1735fe5b441686f5e53338e76a
      vout: 01000000
      scriptsigsize: 00
      scriptsig:
      sequence: ffffffff
    outputs: 01
      amount: 204e000000000000
      scriptpubkeysize: 19
      scriptpubkey: 76a914ce72abfd0e6d9354a660c18f2825eb392f060fdc88ac
    witness: 02473044022008f4f37e2d8f74e18c1b8fde2374d5f28402fb8ab7fd1cc5b786aa40851a70cb022032b1374d1a0f125eae4f69d1bc0b7f896c964cfdba329f38a952426cf427484c012103eed0d937090cae6ffde917de8a80dc6156e30b13edd5e51e2e50d52428da1c87
    locktime: 00000000
    ```
    
    `02000000000101ac4994014aa36b7f53375658ef595b3cb2891e1735fe5b441686f5e53338e76a0100000000ffffffff01204e0000000000001976a914ce72abfd0e6d9354a660c18f2825eb392f060fdc88ac02473044022008f4f37e2d8f74e18c1b8fde2374d5f28402fb8ab7fd1cc5b786aa40851a70cb022032b1374d1a0f125eae4f69d1bc0b7f896c964cfdba329f38a952426cf427484c012103eed0d937090cae6ffde917de8a80dc6156e30b13edd5e51e2e50d52428da1c8700000000`
    
    可用 `bitcoin-cli` 发送 交易数据
    
    ```bash
    $ bitcoin-cli sendrawtransaction 02000000000101ac4994014aa36b7f53375658ef595b3cb2891e1735fe5b441686f5e53338e76a0100000000ffffffff01204e0000000000001976a914ce72abfd0e6d9354a660c18f2825eb392f060fdc88ac02473044022008f4f37e2d8f74e18c1b8fde2374d5f28402fb8ab7fd1cc5b786aa40851a70cb022032b1374d1a0f125eae4f69d1bc0b7f896c964cfdba329f38a952426cf427484c012103eed0d937090cae6ffde917de8a80dc6156e30b13edd5e51e2e50d52428da1c8700000000
    ```