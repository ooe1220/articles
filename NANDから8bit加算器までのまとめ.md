https://app.diagrams.net/

# NAND

今回設計するCPUに於ける最小単位としています。
全ての回路はこのNANDを積み上げて設計しています。

$$
Y = \overline{A \cdot B}
$$

真理値表
| a | b | y |
|---|---|---|
| 0 | 0 | 1 |
| 0 | 1 | 1 |
| 1 | 0 | 1 |
| 1 | 1 | 0 |

# NOT

NANDのabの入力を同じにすると反転する性質を利用します。
a=bの行を見ると、入力と出力が反転しており、NOT（論理否定）になっています。

NANDの真理表
| a | b | y |a=b|
|---|---|---|---|
| 0 | 0 | 1 |← |
| 0 | 1 | 1 |   |
| 1 | 0 | 1 |   |
| 1 | 1 | 0 |← |

これは式でも確認できます。

NANDの式は

$$
y=\overline{a\cdot b}
$$

ここで $a=b$ とすると、

$$
y=\overline{a\cdot a}
$$

同じ値同士のANDはその値自身なので、

$$
a\cdot a=a
$$

したがって、

$$
\boxed{y=\overline{a}}
$$

となり、NOT（論理否定）になります。

VerilogにてNANDを用いてNOT回路を設計します。
<img width="311" height="82" alt="NOT drawio" src="https://github.com/user-attachments/assets/8ddaa44a-dcc0-420a-8f39-58ae131f557e" />

```v
`timescale 1ns/1ps

module not_gate (
    input a, // 入力
    output y // 出力
);

    nand_gate u_not (
        .a(a), // 入力aをNANDのAに繋ぐ
        .b(a), // 入力aをNANDのBにも繋ぐ
        .y(y)  // NANDの出力をそのままNOTの出力とする
    );

endmodule
```

# AND

AND真理値表
| a | b | y |
|---|---|---|
| 0 | 0 | 0 |
| 0 | 1 | 0 |
| 1 | 0 | 0 |
| 1 | 1 | 1 |


ANDの真理値表はNANDの真理表から導出できます。

| a | b | y |$\overline{y}$|
|---|---|---|------|
| 0 | 0 | 1 |  0   |
| 0 | 1 | 1 |  0   |
| 1 | 0 | 1 |  0   |
| 1 | 1 | 0 |  1   |


NANDの式は

$$
y=\overline{a\cdot b}
$$

NANDの出力をNOTすると、

$$
y=\overline{\overline{a\cdot b}}
$$

二重否定を取り除くと、

$$
\boxed{y=a\cdot b}
$$

となり、AND（論理積）になります。

VerilogにてNANDを用いてAND回路を設計します。
<img width="449" height="116" alt="AND drawio" src="https://github.com/user-attachments/assets/e658224b-7b57-42a2-9beb-061e627f8f5a" />

```v
module and_gate (
    input a,
    input b,
    output y
);

    wire n;
    nand_gate g1(a, b, n); // 一つ目のNANDの出力を
    nand_gate g2(n, n, y); // NOTに繋ぐ(NANDの入力両方に繋ぐ)
endmodule
```
