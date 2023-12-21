


**Introducing Bitcoin**

- Date: December 12, 2023
- Tags: Bitcoin, tech


### About Bitcoin

比特币网络是一个货币（比特币）发行、转账、交易的程序化系统，一套去信任化的所有权记录系统。它是由去中心化的点对点节点系统实现，其中包括完整节点、钱包和矿工。比特币网络使用PoW（Power of Work，工作量证明）决定哪个节点出块，使用累计最大难度（最长链）决定活跃链（有效链）。

- How are Coins Transferred？
    
    比特币是一系列所有权重新分配的过程，Coins转账是记录其所有权交易的交易。
    
- Who can you send coins To？
    
    绝大多数比特币交易都是将Coin发送给个人（地址），或者P2PKH,multisg,P2SH
    
- How are transactions stored？
    
    交易组织成区块(block)的形式由Miners写入ledger，Bitcoin是概率链，区别可能会被替换，一般在多个（>6）区块确认后就很难修改，这个时候可以确定区块或交易成功。
    
- How are transactions protected？
    
    比特币交易中包含的资金被密码谜题锁定，交易受到签名的保护，该签名证明您是交易发送到的公钥的所有者：这种所有权证明是正在解决的难题。
    
    通过使用哈希来进一步保护资金。在资金用完之前，公钥实际上不会存储在区块链中：只有公钥哈希值才会存储在区块链中。这意味着即使量子计算机出现，比特币交易仍将受到第二层密码学的保护。
    
- How are transactoins created？
    
    每笔比特币交易的核心是一种类似 FORTH 的脚本语言，用于锁定交易。为了重新花这笔钱，接收者需要向脚本提供特定信息（一般是私钥签名），以证明他是预期的接收者。
    
- Bitcoin — In Short 比特币——简而言之
    
    将比特币视为一系列原子交易的一种方式。每笔交易均由发送者通过存储为脚本的先前密码难题的解决方案进行身份验证。新交易通过新的密码谜题为接收者锁定，该谜题也存储为脚本。每笔交易都记录在不可变的全球分类账中。
    

### About Public-Key Cryptography 关于公钥密码学

- What is Public Key？
    
    在典型的公钥系统中，用户生成公钥和私钥，然后公钥提供给所有人（公开）。交易发送者可以用接收者的公钥对信息进行加密，加密后的数据只能由加密时的公钥的私钥才有解密，公钥本身对数据进行解密，这属于非对称密码学。
    
- What is Private Key？
    
    私钥与密钥对中的公钥相关联。在典型的公钥系统中，用户保证其私钥的安全，并使用它来解密在发送给他之前使用其公钥加密的消息。
    
- What is Signature？
    
    使用私钥对消息（或更常见的是消息的哈希值）进行签名，从而创建签名。然后，任何拥有相应公钥的人都可以验证签名，从而验证签名者是否拥有该公钥关联的私钥，证明所有权。
    
- What is Hash Function？
    
    哈希函数是密码学中经常使用的一种算法。这是一种将大量任意数据映射到少量固定数据的方法。密码学中使用的哈希函数是单向且抗碰撞的，这意味着哈希可以可靠地链接到原始数据，但无法从哈希重新生成原始数据。
    
- **Public-Key Cryptography — In Short**
    
    一种任何人都可以保护数据的方法，以便只有授权人员才能访问它，并且授权人员可以证明他将具有该访问权限。
    

### **About ECC 关于ECC**

ECC 代表椭圆曲线密码学(Elliptic Curve Cryptography)。它是公钥密码学的一个特定分支，依赖于使用在有限域上定义的椭圆曲线进行的数学计算。它比经典的公钥密码学（使用素数）更复杂、更难解释，但它有一些很好的优点。

- ***What is an Elliptic Curve？***
    
    椭圆曲线是一种几何曲线，其形式为 $y 2 = x 3  + ax + b$ 。通过选择 `a` 和 `b` 的特定值来选择特定的椭圆曲线。然后必须仔细检查该曲线以确定它是否适用于密码学。例如，比特币使用的 secp256k1 曲线定义为 `a=0` 和 `b=7` 。
    
    任何与椭圆曲线相交的线都会在 1 或 3 个点处相交……这就是椭圆曲线密码学的基础
    
- ***What are Finite Fields？***
    
    有限域是一组有限的数字，其中定义所有加法、减法、乘法和除法，以便在同一有限域中产生其他数字。创建有限域的一种简单方法是使用模函数。
    
    有限域中元素需要满足：
    封闭性、加法恒等、乘法恒等、加法逆和乘法逆。
    
- ***How is an Elliptic Curve Defined Over a Finite Field?***
    
    在有限域上定义的椭圆曲线的曲线上的所有点均来自特定的有限域。其形式为： $y^2$ % field-size = ($x^3$  + ax + b) % field-size 用于 secp256k1 的有限域为 $2^{256}$ - $2^{32}$ - $2^9$ - $2^{87}$ - $2^6$ - $2^4$ - 1
    
- ***How are Elliptic Curve Used in Cryptography？***
    
    在椭圆曲线加密中，用户选择一个非常大（256 位）的数字作为他的私钥。然后，他将曲线上的设定基点添加到自身多次。（在 secp256k1 中，基点是 `G = 04 79BE667E F9DCBBAC 55A06295 CE870B07 029BFCDB 2DCE28D9 59F2815B 16F81798 483ADA77 26A3C465 5DA4FBFC 0E1108A8 FD17B448 A6855419 9C47D08F FB10D4B8` ，它在元组的两个部分前面加上 `04` 前缀，表示数据点处于未压缩形式。如果您更喜欢直线几何定义，这是点“0x79BE667EF9DCBBAC55A06295CE870B07029BFCDB2DCE28D959F2815B16F81798,0x483ADA7726A3C4655DA4FBFC0E1108A8FD17B448A68554199C47D08FFB10D 4B8"）得到的数字就是公钥。然后，在给定私钥的情况下，可以使用各种数学公式来证明公钥的所有权。与任何加密函数一样，这个函数是一个活板门：从私钥到公钥很容易，但从公钥到私钥几乎不可能。
    
    这种特殊的方法也解释了为什么在椭圆曲线中使用有限域：它确保私钥不会变得太大。请注意，secp256k1 的有限字段略小于 256 位，这意味着所有公钥的长度均为 256 位，就像私钥一样。
    
- ***What are the Advantages of ECC ?***
    
    ECC 的主要优点是它可以使用更小的密钥实现与经典公钥加密相同的安全性。 256 位椭圆曲线公钥对应于 3072 位传统 (RSA) 公钥。
    
- ***ECC - in Short***
    
    一种使用非常小的密钥和非常隐蔽的数学来启用公钥加密的方法。
    

### **About Blockchains**

区块链是比特币用于创建分布式全球账本的方法的概括。

- ***Why is it Called a Chain？***
    
    区块链中的每个块都存储其之前块的哈希值。这通过一条不间断的链将当前块一直链接回原始的“创世块”。这是一种在可能冲突的数据之间创建绝对顺序的方法。
    
- ***What is a Fork?***
    
    有时，两个区块会同时创建。这会暂时创建一个单块分叉，其中当前块可能是“真实”块。每隔一段时间，一个分叉可能会扩展为两个块、三个块，甚至四个块长，但很快分叉的一侧被确定为真正的一侧，而另一侧是“孤立的”。
    
- ***Blockchain — In Short***
    
    一系列链接的不可更改的数据块，可以追溯到过去，一系列链接的块对可能发生冲突的数据进行绝对排序。
    

### About Lightning network

闪电网络是一种与比特币交互的第 2 层协议，允许用户“链下”交换比特币。与单独使用比特币相比，它既有优点也有缺点。

- ***What is a Layer-2 Protocol?***
    
    运行在比特币之上的第二层比特币协议。在这种情况下，闪电网络在比特币之上运行，通过智能合约与其进行交互。
    
- ***What is a Lightning Channel?***
    
    闪电通道是两个闪电网络用户之间的点对点连接。每个用户都使用双方签名的多重签名在比特币区块链上锁定一定数量的比特币。然后，两个用户可以通过他们的闪电通道交换比特币，而无需立即写入比特币区块链。只有当他们想要关闭通道时，他们才会根据比特币的最终分配来结算比特币。
    
- ***What is a Lightning Network?***
    
    将多个闪电通道组合在一起创建闪电网络。通过闪电网络的路由功能，允许尚未在其之间创建通道的两个用户使用闪电网络交换比特币：该协议在两个用户之间形成通道链，然后使用时间锁定交易通过该链交换比特币。
    
- ***What are the Advantages of Lightning?***
    
    闪电网络可以以更低的费用实现更快的交易。这创造了比特币资助的小额支付的真正可能性。它还提供了更好的隐私性，因为它是链下的，只有交易的第一个和最后一个状态被写入不可变的比特币账本中。
    
- ***What are the Disadvantages of Lightning?***
    
    闪电网络仍然是一项相对较新的技术，尚未像比特币那样经过彻底的测试，每个通道的建立都需要锁定一定数量的比特币，闪电网络目前主要应用场景是快速和小额支付。
    
- ***Lightning network - In Short***
    
    一种在人与人之间使用链外通道进行比特币交易的方式，这样只需将第一状态和最终状态写入区块链，典型的Bitcoin Layer2。