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

Verilogでは以下のように設計しました。
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

NANDの真理表
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

Verilogでは以下のように設計しました。
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

# OR

真理値表
| a | b | y |
|---|---|---|
| 0 | 0 | 0 |
| 0 | 1 | 1 |
| 1 | 0 | 1 |
| 1 | 1 | 1 |

NOTをNANDから組み立てられることは、NOTの節で証明しています。
そこで、$a$ と $b$ をそれぞれNOTに通し、その出力をNANDに入力します。
| a | b | $\overline{a}$ | $\overline{b}$ | $y=\overline{\overline{a}\cdot\overline{b}}$ |
|---|---|---|---|---|
| 0 | 0 | 1 | 1 | 0 |
| 0 | 1 | 1 | 0 | 1 |
| 1 | 0 | 0 | 1 | 1 |
| 1 | 1 | 0 | 0 | 1 |

これはド・モルガンの法則からも確認できます。

$$
y=\overline{\overline{a}\cdot\overline{b}}
$$

$$
\boxed{y=a+b}
$$

となり、OR（論理和）になります。

Verilogでは以下のように設計しました。
<img width="509" height="244" alt="OR drawio" src="https://github.com/user-attachments/assets/b98cdc54-a9ef-422d-a240-406b0884782a" />

```v
// ========================================
// OR素子
// ========================================
module or_gate (
    input a,
    input b,
    output y
);
    wire not_a;
    wire not_b;
    
    nand_gate u_not_a(a, a, not_a); // aを反転(NAND入力2本共a)
    nand_gate u_not_b(b, b, not_b); // bを反転(NAND入力2本共b)
    
    nand_gate nand_nota_notb(not_a, not_b, y); // NOT(a)とNOT(b)をNAND→OR
endmodule
```

# XOR

真理値表
| a | b | y |
|---|---|---|
| 0 | 0 | 0 |
| 0 | 1 | 1 |
| 1 | 0 | 1 |
| 1 | 1 | 0 |


## 方法①

y=1の行だけを見ると

| a | b |
|---|---|
| 0 | 1 |
| 1 | 0 |

この2つの条件をそれぞれ式にすると、

$$
\overline{a}\cdot b
$$

$$
a\cdot\overline{b}
$$

となります。

どちらか一方の条件を満たしたときに $y=1$ になるので、2つをORでつなぎます。

$$
y=(\overline{a}\cdot b)+(a\cdot\overline{b})
$$

したがって、

$$
\boxed{y=(\overline{a}\cdot b)+(a\cdot\overline{b})}
$$

となり、XOR（排他的論理和）の式が得られます。(この様に真理値表の $y=1$ の行を全て拾って式にする方法を、積和標準形といいます)

この式をそのまま回路にすると、XORの動作は理解しやすいですが、実現には9個のNANDが必要になります。

- NOT × 2 → NAND 2個
- AND × 2 → NAND 4個
- OR × 1 → NAND 3個
  
合計 9個
これではnandの無駄使いです。(nand縛りの時点でトランジスタの無駄使いだし、実際に製造する訳ではありませんが、)

そこで、今回はNAND 4個だけで構成できる回路を組みます。

## 方法②

この式でもXORを表せてNANDも4個で済みます。しかし式の導出がややこしく筆者も理解出来ていません。

$$
y =
\overline{
\overline{a\overline{ab}}
\cdot
\overline{\overline{ab}b}
}
$$

# 半加算器
