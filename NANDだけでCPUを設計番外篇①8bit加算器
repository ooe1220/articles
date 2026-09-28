# 目次

https://qiita.com/earthen94/items/28752ae240e9b1c6e116

https://github.com/ooe1220/nandcpu/tree/master

# 初めに

本篇ではNANDを積み上げてCPUを設計していますが、この番外編ではNANDから下へ掘り進めます。
筆者も勉強しながら書いているので間違っていたらすみません。

NMOS、PMOSのことを調べると燐や硼酸を混ぜる説明や、電子が動く説明ばかりでよく理解ができません。
今回はこの2つをどう組み合わせてNANDを作るかに焦点を当てたいので、どんな入力をしたらどんな出力になるのかのみを調べ、内部がどうなっているかには触れません。(筆者もまだ理解できてません)

NMOS、PMOSの内部がどうなっているのかは次回調べます。

# MOSFET

|種類| 動作               |
|----|--------------------|
|NMOS| ゲートに高電圧(1)で通電|
|PMOS| ゲートに低電圧(0)で通電|


# NOT の例

NOT回路はNANDより簡単で`pmos`及び`nmos`の動きを理解するのにちょうど良いのでまずはNOT回路を見てみます。
※本篇のNOTはNAND2つから設計していますが、`pmos`及び`nmos`を使って設計することもできます。




# NAND


# 

本篇ではNANDを最小単位とすると言った手前`nand(y,a,b)`を使用していますが、Verilogでは更に下層の`pmos`及び`nmos`が用意されており、これらから`nand`を作ることも出来ます。

他の論理素子は全てNANDで設計しているので、`nand_gate`の中身だけ`pmos`及び`nmos`から構成するように書き換えました。

```src/gates.v
module nand_gate (
    input a,
    input b,
    output y
);

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

```
A B | NAND NOT AND OR XOR
0 0 |  1    1   0  0  0
0 1 |  1    1   0  1  1
1 0 |  1    0   0  1  1
1 1 |  0    0   1  1  0
```

全体のコードはgithub上に上げています。

# 参考にしたサイと

https://www.eefocus.com/ask/1883143.html
https://www.qaqme.cn/nmos-pmos-difference-mosfet-guide/
https://zhuanlan.zhihu.com/p/1946610168000413849
