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


NANDの出力を更にNOTすることで、ANDを作ることができます。

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

この式でもXORを表せてNANDも4個で済みます。式の導出がややこしく筆者も理解出来ていません、その為真理値表でXORになっていることだけ確かめて使います。


$$
y =
\overline{
\overline{a\overline{ab}}
\cdot
\overline{\overline{ab}b}
}
$$

| $a$ | $b$ | $\overline{ab}$ | $a\overline{ab}$ | $\overline{a\overline{ab}}$ | $\overline{ab}b$ | $\overline{\overline{ab}b}$ | $y$ |
|---|---|---|---|---|---|---|---|
| 0 | 0 | 1 | 0 | 1 | 0 | 1 | 0 |
| 0 | 1 | 1 | 0 | 1 | 1 | 0 | 1 |
| 1 | 0 | 1 | 1 | 0 | 0 | 1 | 1 |
| 1 | 1 | 0 | 0 | 1 | 0 | 1 | 0 |

<img width="366" height="136" alt="xor drawio" src="https://github.com/user-attachments/assets/0ded8422-ec84-49c7-b111-08019dc6d335" />


```v
module xor_gate (
    input a,
    input b,
    output y
);

    wire n1; // A NAND B
    wire n2; // A NAND n1
    wire n3; // B NAND n1
    
    nand_gate g1(a, b, n1);
    nand_gate g2(a, n1, n2);
    nand_gate g3(n1, b, n3);
    nand_gate g4(n2, n3, y);

endmodule
```

# 半加算器

真理値表
| a | b | c | s |10進数|
|---|---|---|---|------|
| 0 | 0 | 0 | 0 |   0  |
| 0 | 1 | 0 | 1 |   1  |
| 1 | 0 | 0 | 1 |   1  |
| 1 | 1 | 1 | 0 |   2  |

以下の回路は等価です。
<img width="517" height="273" alt="equal" src="https://github.com/user-attachments/assets/1b4164ac-f21a-4ad7-bdba-2a1b668ecd6a" />

1ビット同士の足し算ですが、和は最大で2ビットになります。
1の位がXOR、2の位がANDと丁度一致するのでこの特性を利用します。

コード可読性の為ここからはNANDをそのまま使用せず、NANDで構成したXORとANDを使います。

<img width="221" height="173" alt="inout" src="https://github.com/user-attachments/assets/a1044156-49ff-4001-905f-e24fc675b9d2" />

```v
module half_adder (
    input a,
    input b,
    output sum,
    output carry
);

    // 和 → XORで計算
    xor_gate u_xor (a, b, sum);
    
    // 桁上り → ANDで計算
    and_gate u_and (a, b, carry);

endmodule
```

# 全加算器

正直、筆者も原理を理解出来ておらず、定石の通りに回路を組んで真理値表の通りに動作することを確かめて使うに留めています。

真理値表
| A | B | Cin | Sum | Cout |
|---|---|-----|-----|------|
| 0 | 0 |  0  |  0  |  0   |
| 0 | 0 |  1  |  1  |  0   |
| 0 | 1 |  0  |  1  |  0   |
| 0 | 1 |  1  |  0  |  1   |
| 1 | 0 |  0  |  1  |  0   |
| 1 | 0 |  1  |  0  |  1   |
| 1 | 1 |  0  |  0  |  1   |
| 1 | 1 |  1  |  1  |  1   |


以下の回路をそのままコードへ落とし込みました。
<img width="655" height="270" alt="faddr" src="https://github.com/user-attachments/assets/757ef6d1-f5ac-4b61-94b6-491cac8c0e1a" />

```v
module full_adder (
    input A,
    input B,
    input Cin,
    output Sum,
    output Cout
);

    wire sum1;      // 1段目の half_adder の和
    wire carry1;    // 1段目の half_adder の桁上がり
    wire carry2;    // 2段目の half_adder の桁上がり

    // 1段目: A + B
    half_adder ha1 (
        .a(A),
        .b(B),
        .sum(sum1),
        .carry(carry1)
    );

    // 2段目: sum1 + Cin
    half_adder ha2 (
        .a(sum1),
        .b(Cin),
        .sum(Sum),
        .carry(carry2)
    );

    // ORの部分
    or_gate u_or (
        .a(carry1),
        .b(carry2),
        .y(Cout)
    );

endmodule
```

# 8bit加算器

ここからは長くなる為真理値表は書きません。

以下のような8ビット同士の値を加算する回路です。
| ビット | 7 | 6 | 5 | 4 | 3 | 2 | 1 | 0 |
|--------|---|---|---|---|---|---|---|---|
| A（50）| 0 | 0 | 1 | 1 | 0 | 0 | 1 | 0 |
| B（60）| 0 | 0 | 1 | 1 | 1 | 1 | 0 | 0 |
| S（110）| 0 | 1 | 1 | 0 | 1 | 1 | 1 | 0 |

全加算器と同じくなぜこの回路で動くのかを理解出来ておらず、真理値表の通りに動くことを確かめた上で、以下の回路をそのまま実装しています。
<img width="1481" height="965" alt="50+60" src="https://github.com/user-attachments/assets/a21f096d-c092-4041-89bb-933b81d19fd2" />

```v
module adder_8bit (
    input  [7:0] A,   // 8bit値(A+BのA)
    input  [7:0] B,   // 8bit値(A+BのB)
    input        Cin, // 初期キャリー
    output [7:0] Sum, // 結果
    output       Cout // オーバーフロー(Cフラグ)
);

    wire c1, c2, c3, c4, c5, c6, c7;
    // 各全加算器を繋ぐ

    full_adder fa0 (A[0], B[0], Cin, Sum[0], c1);
    full_adder fa1 (A[1], B[1], c1,   Sum[1], c2);
    full_adder fa2 (A[2], B[2], c2,   Sum[2], c3);
    full_adder fa3 (A[3], B[3], c3,   Sum[3], c4);
    full_adder fa4 (A[4], B[4], c4,   Sum[4], c5);
    full_adder fa5 (A[5], B[5], c5,   Sum[5], c6);
    full_adder fa6 (A[6], B[6], c6,   Sum[6], c7);
    full_adder fa7 (A[7], B[7], c7,   Sum[7], Cout);

endmodule
```

# Verilogの抽象化

今回はNAND素子から全加算器を組み立てていますが、`assign result = A + B + Cin;`のように書くと1行で済んでしまいます。
序で書きましたがこれが去年VerilogでCPUを設計した時に、自分で回路を組んだ気がしないと感じた違和感の正体でした。

~~こんな記事消してしまおうかとも思いますが~~

[Verilogで作る4ビットCPU入門：シミュレーションと回路図生成まで](https://qiita.com/earthen94/items/51bed33a6742dfe5fa90)

今回は原理を理解する為、効率を捨てて敢えて泥臭い書き方をしています。

以下は論理回路を意識せずに、Verilogの抽象化を利用して記述した場合の例です。
```bash
test@test-fujitsu:~/kaihatsu/nandcpu$ iverilog -o test.out adder_8bit_free.v
test@test-fujitsu:~/kaihatsu/nandcpu$ vvp test.out
VCD info: dumpfile wave.vcd opened for output.
Time |   A   |   B   | Cin |  Sum  | Cout
   0 | 00000000 | 00000000 |  0  | 00000000 |  0
10000 | 00110010 | 00111100 |  0  | 01101110 |  0
20000 | 11111111 | 00000001 |  0  | 00000000 |  1
30000 | 11111111 | 11111111 |  0  | 11111110 |  1
40000 | 01010101 | 10101010 |  0  | 11111111 |  0
50000 | 00000000 | 00000000 |  1  | 00000001 |  0
```

```adder_8bit_free.v
`timescale 1ns/1ps

module tb_adder_8bit;
    reg  [7:0] A, B;
    reg        Cin;
    wire [7:0] Sum;
    wire       Cout;

    adder_8bit uut (
        .A(A),
        .B(B),
        .Cin(Cin),
        .Sum(Sum),
        .Cout(Cout)
    );

    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0, tb_adder_8bit);

        $display("Time |   A   |   B   | Cin |  Sum  | Cout");
        $monitor("%4t | %b | %b |  %b  | %b |  %b",
                  $time, A, B, Cin, Sum, Cout);

        // 複数通り検証 切り替え
        A = 8'd0;   B = 8'd0;   Cin = 1'b0; #10;
        A = 8'd50;  B = 8'd60;  Cin = 1'b0; #10;
        A = 8'd255; B = 8'd1;   Cin = 1'b0; #10;
        A = 8'd255; B = 8'd255; Cin = 1'b0; #10;
        A = 8'd85;  B = 8'd170; Cin = 1'b0; #10;
        A = 8'd0;   B = 8'd0;   Cin = 1'b1; #10;

        $finish;
    end
endmodule

module adder_8bit (
    input  [7:0] A,    // 8bit値
    input  [7:0] B,    // 8bit値
    input        Cin, // 初期キャリー
    output [7:0] Sum,  // 和
    output       Cout  // 桁上がり
);

    // オーバーフロー検出用に1ビット広げた内部信号
    wire [8:0] result;

    // 9ビットとして計算することで、Coutを含めた結果が一気に求まる
    assign result = A + B + Cin;
    
    // 下位8ビットがSum
    assign Sum  = result[7:0];
    
    // 最上位ビットがCout
    assign Cout = result[8];

endmodule
```
