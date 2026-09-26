
# 8bit加算器

全加算器を連ねることでNビットの加算器を作ることができます。
下位ビットの桁上がりを、次のビットの全加算器のCinへ渡します。

例えば`50+60=110 (00110010 + 00111100 = 01101110)`のような計算をするとします。

`Z80`でこう書くとすると
```
LD A, 50
LD B, 60
ADD A, B
```

AレジスタとBレジスタの各ビットを、それぞれ対応する全加算器の入力に接続します。

| ビット | 7 | 6 | 5 | 4 | 3 | 2 | 1 | 0 |
|--------|---|---|---|---|---|---|---|---|
| A（50）| 0 | 0 | 1 | 1 | 0 | 0 | 1 | 0 |
| B（60）| 0 | 0 | 1 | 1 | 1 | 1 | 0 | 0 |
| S（110）| 0 | 1 | 1 | 0 | 1 | 1 | 1 | 0 |


```bash
/opt/simulide-110sr0/simulide 8bitadder.sim1
```


<details>
<summary>fadder.sim1</summary>

```fadder.sim1
```

</details>

<img width="1481" height="965" alt="50+60" src="https://github.com/user-attachments/assets/a21f096d-c092-4041-89bb-933b81d19fd2" />


# Verilogで8bit加算器を作る

```bash
iverilog -o test.out nand_gate_lib.v tb_adder_8bit.v
vvp test.out
```

<details>
<summary>tb_adder_8bit.v</summary>

```tb_adder_8bit.v
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
```

</details>

<details>
<summary>nand_gate_lib.v</summary>

```nand_gate_lib.v
`timescale 1ns/1ps

// ========================================
// NAND素子の定義(これを最小単位とする)
// ========================================
module nand_gate (
    input a,
    input b,
    output y
);

    nand(y,a,b);
endmodule


// ========================================
// NOT素子
// ========================================
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

// ========================================
// AND素子
// ========================================
module and_gate (
    input a,
    input b,
    output y
);

    wire n;
    nand_gate g1(a, b, n); // 一つ目のNANDの出力を
    nand_gate g2(n, n, y); // NOTに繋ぐ(NANDの入力両方に繋ぐ)
endmodule

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

// ========================================
// XOR素子
// ========================================
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

// ========================================
// 半加算器 (Half Adder)
// 自分で作ったXORとANDを使用
// ========================================
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

// ========================================
// 全加算器 (Full Adder)
// half_adder を2つと or_gate で構成
// 入力: A, B, Cin
// 出力: Sum, Cout
// ========================================
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

// ========================================
// 8ビット加算器 (Ripple Carry Adder)
// full_adder を8個連結
// 入力: A[7:0], B[7:0], Cin
// 出力: Sum[7:0], Cout
// ========================================
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

</details>

```
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

```
50 + 60 = 110    (01101110)
255 + 1 = 0       Cout=1（オーバーフロー）
255 + 255 = 254   Cout=1
85 + 170 = 255    Cout=0
0 + 0 + Cin=1 = 1 
```

波形を確認しますが、入力と出力が増えすぎて、確認が難しくなってしました。
```
gtkwave wave.vcd
```

<img width="1134" height="955" alt="wave1" src="https://github.com/user-attachments/assets/c7718a4f-555b-4d84-9ebe-8a9546444a37" />
<img width="1134" height="955" alt="wave2" src="https://github.com/user-attachments/assets/6b43e49b-1fb4-4bd3-a4b0-2c8186868ab6" />
