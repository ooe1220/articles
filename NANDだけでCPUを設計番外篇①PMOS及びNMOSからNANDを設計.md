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

Nは接地側、Pは電源側にソースを接続することが多い。

# NOT の例

NOT回路はNANDより簡単で`pmos`及び`nmos`の動きを理解するのにちょうど良いのでまずはNOT回路を見てみます。

※本篇のNOTはNAND2つから設計していますが、これは説明の為に`pmos`及び`nmos`を使って設計しています。

入力の電源を入れると消え、電源を切ると光ります。

<img width="544" height="330" alt="截图 2026-09-28 22-06-55 - コピー" src="https://github.com/user-attachments/assets/366b6d78-5409-423f-9dc1-fca7cffa5ea0" />

<img width="544" height="330" alt="截图 2026-09-28 22-07-02 - コピー" src="https://github.com/user-attachments/assets/101a7988-1ba1-4638-a26c-08e0ca1f4903" />


# NAND


# 

本篇ではNANDを最小単位とすると言った手前`nand(y,a,b)`を使用していますが、Verilogでは更に下層の`pmos`及び`nmos`が用意されており、これらから`nand`を作ることも出来ます。
NAND以外の論理素子もNANDから構成しており、`nand_gate`の実装だけをPMOS及びNMOSに置き換えましたが、それらも問題なく動作しています。

引数は以下の通りです。
```
pmos p1 (ドレイン, ソース, ゲート);
nmos n1 (ドレイン, ソース, ゲート);
```

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

```

全体のコードはgithub上に上げています。

# 参考にしたサイト

https://www.eefocus.com/ask/1883143.html
https://www.qaqme.cn/nmos-pmos-difference-mosfet-guide/
https://zhuanlan.zhihu.com/p/1946610168000413849
