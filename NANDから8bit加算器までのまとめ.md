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
        .b(a), // 同じくNANDのBにも繋ぐ
        .y(y)
    );

endmodule
```
