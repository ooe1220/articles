# 目次

https://qiita.com/earthen94/items/28752ae240e9b1c6e116

https://github.com/ooe1220/nandcpu/tree/master

# 初めに

本篇ではNANDを積み上げてCPUを設計していますが、この番外編ではNANDから下へ掘り進めます。
筆者も勉強しながら書いているので間違っていたらすみません。

Verilogにはnandだけでなく、更に下の階層としてpmosやnmosが用意されています。
そこで今回はPMOS及びNMOSを使ってNAND素子を設計してみます。

NMOS、PMOSのことを調べると、燐や硼素を添加する説明や、電子が移動する説明ばかりで、まだ十分に理解できていません。

今回は「どのような入力に対してどのような出力をするのか」のみを考えます。
そして、それらをどの様に組み合わせたらNAND回路が実現できるのかに焦点を絞ります。

NMOS、PMOSの内部がどうなっているのかは次回の課題とします。
本編と同じく今調べている階層以外は一旦考えない方針で進めます。

# MOSFET

|種類| 動作               |
|----|--------------------|
|NMOS| ゲートに高電圧(1)で通電|
|PMOS| ゲートに低電圧(0)で通電|

Nは接地側、Pは電源側にソースを接続することが多いようです。

# NOT の例

NOT回路はNANDより簡単で`pmos`及び`nmos`の動きを理解するのにちょうど良いのでまずはNOT回路を見てみます。

※本篇のNOTはNAND2つから設計していますが、これは説明の為に`pmos`及び`nmos`を使って設計しています。

入力の電源を入れると消え、電源を切ると光ります。

<img width="1077" height="330" alt="660370377-f1e8825f-657f-4ff5-97b3-7bf8b0217621" src="https://github.com/user-attachments/assets/36e6ac6f-6266-411f-be32-f9a56526d9d3" />

※ソースを接地に繋いだら電気の入口になれず源(Source)ではない気がしますが、どうなんでしょう

# NAND

本篇ではNANDを最小単位とすると言った手前`nand(y,a,b)`を使用していますが、Verilogでは更に下層の`pmos`及び`nmos`が用意されており、これらから`nand`を作ることも出来ます。
NAND以外の論理素子もNANDから構成しており、`nand_gate`の実装だけをPMOS及びNMOSに置き換えましたが、それらも問題なく動作しています。

引数は以下の通りです。
```
pmos p1 (ドレイン, ソース, ゲート);
nmos n1 (ドレイン, ソース, ゲート);
```

設計した回路は以下の通りです。
本来の記号で書くと複雑なので四角で簡略化しました。

<img width="266" height="381" alt="nand_cmos drawio" src="https://github.com/user-attachments/assets/39694fb0-6c00-4c8e-a340-3c0a5f36378a" />

```src/gates.v
module nand_gate (
    input a,
    input b,
    output y
);

    wire net1;

    //nand(y,a,b); // 本篇    <----- コメントアウト
    
    // MOSFET版 番外篇    <----- 追加
    supply1 VDD; // 電源
    supply0 GND; // 接地

    // PMOS: a または b が 低電圧 なら y を 高電圧 に引き上げ
    pmos p1 (y, VDD, a);
    pmos p2 (y, VDD, b);

    // NMOS: a と b が両方 高電圧 なら y を 低電圧 に引き下げ
    nmos n1 (y, net1, a);
    nmos n2 (net1, GND, b);
    
endmodule
```

既成の`nand(y,a,b)`と同じように動作しました。
NAND以外の素子もNANDから構成しており、それらも問題なく動作しています。

```
A B | NAND NOT AND OR XOR
0 0 |  1    1   0  0  0
0 1 |  1    1   0  1  1
1 0 |  1    0   0  1  1
1 1 |  0    0   1  1  0
```

全体のコードはgithub上に上げています。

# 参考にしたサイト

https://www.eefocus.com/ask/1883143.html
https://www.qaqme.cn/nmos-pmos-difference-mosfet-guide/
https://zhuanlan.zhihu.com/p/1946610168000413849
