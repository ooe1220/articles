# 目次
https://qiita.com/earthen94/items/28752ae240e9b1c6e116

# XOR(排他的論理和)とは

aとbが異なる場合に出力は1となります。
※余談:様々なCPUのアセンブリでレジスタの中身を0にする時にも`xor reg, reg`と書きますが、各ビット同じ値同士のXORとなり、結果が全て0になります。

真理値表
| a | b | y |
|---|---|---|
| 0 | 0 | 0 |
| 0 | 1 | 1 |
| 1 | 0 | 1 |
| 1 | 1 | 0 |


以下のサイトを参考にしました、式変形は筆者も最後まで追えてません。
https://robo164.com/archives/606
https://stacked-tip.hateblo.jp/entry/20170826/1503737327

とにかく下の図のようにNANDを並べると、XORの真理値表に一致する回路を作れます。

# LEDで動作を可視化

```bash
/opt/simulide-110sr0/simulide xor.sim1
```

<details>
<summary>xor.sim1</summary>

```xor.sim1
<circuit version="1.1.0-SR0" rev="1917" stepSize="1000000" stepsPS="1000000" NLsteps="100000" reaStep="1000000" animate="0" >

<item itemtype="And Gate" CircId="And Gate-1" mainComp="false" Show_id="false" Show_Val="false" Pos="-156,-8" rotation="0" hflip="1" vflip="1" label="And Gate-1" idLabPos="-16,-24" labelrot="0" valLabPos="-16,20" valLabRot="0" Input_High_V="2.5 V" Input_Low_V="2.5 V" Input_Imped="1000 MΩ" Num_Inputs="2" Invert_Inputs="false" Out_High_V="5 V" Out_Low_V="0 V" Out_Imped="40 Ω" initHigh="false" Inverted="true" Open_Collector="false" Tpd_ps="10 ns" Tr_ps="3 ns" Tf_ps="4 ns" />

<item itemtype="And Gate" CircId="And Gate-2" mainComp="false" Show_id="false" Show_Val="false" Pos="-100,-36" rotation="0" hflip="1" vflip="1" label="And Gate-2" idLabPos="-16,-24" labelrot="0" valLabPos="-16,20" valLabRot="0" Input_High_V="2.5 V" Input_Low_V="2.5 V" Input_Imped="1000 MΩ" Num_Inputs="2" Invert_Inputs="false" Out_High_V="5 V" Out_Low_V="0 V" Out_Imped="40 Ω" initHigh="false" Inverted="true" Open_Collector="false" Tpd_ps="10 ns" Tr_ps="3 ns" Tf_ps="4 ns" />

<item itemtype="And Gate" CircId="And Gate-3" mainComp="false" Show_id="false" Show_Val="false" Pos="-96,16" rotation="0" hflip="1" vflip="1" label="And Gate-3" idLabPos="-16,-24" labelrot="0" valLabPos="-16,20" valLabRot="0" Input_High_V="2.5 V" Input_Low_V="2.5 V" Input_Imped="1000 MΩ" Num_Inputs="2" Invert_Inputs="false" Out_High_V="5 V" Out_Low_V="0 V" Out_Imped="40 Ω" initHigh="false" Inverted="true" Open_Collector="false" Tpd_ps="10 ns" Tr_ps="3 ns" Tf_ps="4 ns" />

<item itemtype="And Gate" CircId="And Gate-4" mainComp="false" Show_id="false" Show_Val="false" Pos="-40,-8" rotation="0" hflip="1" vflip="1" label="And Gate-4" idLabPos="-16,-24" labelrot="0" valLabPos="-16,20" valLabRot="0" Input_High_V="2.5 V" Input_Low_V="2.5 V" Input_Imped="1000 MΩ" Num_Inputs="2" Invert_Inputs="false" Out_High_V="5 V" Out_Low_V="0 V" Out_Imped="40 Ω" initHigh="false" Inverted="true" Open_Collector="false" Tpd_ps="10 ns" Tr_ps="3 ns" Tf_ps="4 ns" />

<item itemtype="Fixed Voltage" CircId="Fixed Voltage-5" mainComp="false" Show_id="false" Show_Val="false" Pos="-236,-40" rotation="0" hflip="1" vflip="1" label="Fixed Voltage-5" idLabPos="-64,-24" labelrot="0" valLabPos="-16,8" valLabRot="0" Voltage="5 V" Out="false" />

<item itemtype="Fixed Voltage" CircId="Fixed Voltage-6" mainComp="false" Show_id="false" Show_Val="false" Pos="-236,20" rotation="0" hflip="1" vflip="1" label="Fixed Voltage-6" idLabPos="-64,-24" labelrot="0" valLabPos="-16,8" valLabRot="0" Voltage="5 V" Out="false" />

<item itemtype="Resistor" CircId="Resistor-13" mainComp="false" ShowProp="Resistance" Show_id="false" Show_Val="true" Pos="-176,-88" rotation="0" hflip="1" vflip="1" label="Resistor-13" idLabPos="-16,-24" labelrot="0" valLabPos="-16,6" valLabRot="0" Resistance="70 Ω" />

<item itemtype="Led" CircId="Led-14" mainComp="false" Show_id="false" Show_Val="false" Pos="-132,-88" rotation="0" hflip="1" vflip="1" label="Led-14" idLabPos="-16,-24" labelrot="0" valLabPos="-16,20" valLabRot="0" Color="Yellow" Grounded="false" Threshold="2.4 V" MaxCurrent="30 mA" Resistance="0.6 Ω" />

<item itemtype="Ground" CircId="Ground-15" mainComp="false" Show_id="false" Show_Val="false" Pos="-104,-64" rotation="0" hflip="1" vflip="1" label="Ground-15" idLabPos="-16,8" labelrot="0" valLabPos="-16,20" valLabRot="0" />

<item itemtype="Led" CircId="Led-17" mainComp="false" Show_id="false" Show_Val="false" Pos="-132,56" rotation="0" hflip="1" vflip="1" label="Led-17" idLabPos="-16,-24" labelrot="0" valLabPos="-16,20" valLabRot="0" Color="Yellow" Grounded="false" Threshold="2.4 V" MaxCurrent="30 mA" Resistance="0.6 Ω" />

<item itemtype="Resistor" CircId="Resistor-18" mainComp="false" ShowProp="Resistance" Show_id="false" Show_Val="true" Pos="-176,56" rotation="0" hflip="1" vflip="1" label="Resistor-18" idLabPos="-16,-24" labelrot="0" valLabPos="-16,6" valLabRot="0" Resistance="70 Ω" />

<item itemtype="Ground" CircId="Ground-19" mainComp="false" Show_id="false" Show_Val="false" Pos="-104,80" rotation="0" hflip="1" vflip="1" label="Ground-19" idLabPos="-16,8" labelrot="0" valLabPos="-16,20" valLabRot="0" />

<item itemtype="Led" CircId="Led-21" mainComp="false" Show_id="false" Show_Val="false" Pos="48,-8" rotation="0" hflip="1" vflip="1" label="Led-21" idLabPos="-16,-24" labelrot="0" valLabPos="-16,20" valLabRot="0" Color="Yellow" Grounded="false" Threshold="2.4 V" MaxCurrent="30 mA" Resistance="0.6 Ω" />

<item itemtype="Resistor" CircId="Resistor-22" mainComp="false" ShowProp="Resistance" Show_id="false" Show_Val="true" Pos="4,-8" rotation="0" hflip="1" vflip="1" label="Resistor-22" idLabPos="-16,-24" labelrot="0" valLabPos="-16,6" valLabRot="0" Resistance="70 Ω" />

<item itemtype="Ground" CircId="Ground-23" mainComp="false" Show_id="false" Show_Val="false" Pos="76,16" rotation="0" hflip="1" vflip="1" label="Ground-23" idLabPos="-16,8" labelrot="0" valLabPos="-16,20" valLabRot="0" />

<item itemtype="Node" CircId="Node-8" mainComp="false" Pos="-172,-40" />

<item itemtype="Node" CircId="Node-9" mainComp="false" Pos="-172,20" />

<item itemtype="Node" CircId="Node-10" mainComp="false" Pos="-116,-8" />

<item itemtype="Node" CircId="Node-16" mainComp="false" Pos="-192,-40" />

<item itemtype="Node" CircId="Node-20" mainComp="false" Pos="-192,20" />

<item itemtype="Connector" uid="Connector-7" startpinid="Node-8-1" endpinid="And Gate-1-in0" pointList="-172,-40,-172,-12" />

<item itemtype="Connector" uid="Connector-9" startpinid="Node-8-2" endpinid="And Gate-2-in0" pointList="-172,-40,-116,-40" />

<item itemtype="Connector" uid="Connector-10" startpinid="And Gate-1-in1" endpinid="Node-9-1" pointList="-172,-4,-172,20" />

<item itemtype="Connector" uid="Connector-12" startpinid="Node-9-2" endpinid="And Gate-3-in1" pointList="-172,20,-112,20" />

<item itemtype="Connector" uid="Connector-14" startpinid="Node-10-1" endpinid="And Gate-3-in0" pointList="-116,-8,-116,12,-112,12" />

<item itemtype="Connector" uid="Connector-15" startpinid="And Gate-1-out" endpinid="Node-10-0" pointList="-140,-8,-116,-8" />

<item itemtype="Connector" uid="Connector-16" startpinid="Node-10-2" endpinid="And Gate-2-in1" pointList="-116,-8,-116,-32" />

<item itemtype="Connector" uid="Connector-25" startpinid="And Gate-2-out" endpinid="And Gate-4-in0" pointList="-84,-36,-56,-36,-56,-12" />

<item itemtype="Connector" uid="Connector-26" startpinid="And Gate-3-out" endpinid="And Gate-4-in1" pointList="-80,16,-56,16,-56,-4" />

<item itemtype="Connector" uid="Connector-28" startpinid="Resistor-13-rPin" endpinid="Led-14-lPin" pointList="-160,-88,-148,-88" />

<item itemtype="Connector" uid="Connector-29" startpinid="Led-14-rPin" endpinid="Ground-15-Gnd" pointList="-116,-88,-104,-88,-104,-80" />

<item itemtype="Connector" uid="Connector-30" startpinid="Resistor-13-lPin" endpinid="Node-16-1" pointList="-192,-88,-192,-40" />

<item itemtype="Connector" uid="Connector-31" startpinid="Fixed Voltage-5-outnod" endpinid="Node-16-0" pointList="-220,-40,-192,-40" />

<item itemtype="Connector" uid="Connector-32" startpinid="Node-16-2" endpinid="Node-8-0" pointList="-192,-40,-172,-40" />

<item itemtype="Connector" uid="Connector-33" startpinid="Resistor-18-lPin" endpinid="Node-20-1" pointList="-192,56,-192,20" />

<item itemtype="Connector" uid="Connector-34" startpinid="Fixed Voltage-6-outnod" endpinid="Node-20-0" pointList="-220,20,-192,20" />

<item itemtype="Connector" uid="Connector-35" startpinid="Node-20-2" endpinid="Node-9-0" pointList="-192,20,-172,20" />

<item itemtype="Connector" uid="Connector-36" startpinid="Resistor-18-rPin" endpinid="Led-17-lPin" pointList="-160,56,-148,56" />

<item itemtype="Connector" uid="Connector-37" startpinid="Led-17-rPin" endpinid="Ground-19-Gnd" pointList="-116,56,-104,56,-104,64" />

<item itemtype="Connector" uid="Connector-39" startpinid="And Gate-4-out" endpinid="Resistor-22-lPin" pointList="-24,-8,-12,-8" />

<item itemtype="Connector" uid="Connector-40" startpinid="Resistor-22-rPin" endpinid="Led-21-lPin" pointList="20,-8,32,-8" />

<item itemtype="Connector" uid="Connector-41" startpinid="Led-21-rPin" endpinid="Ground-23-Gnd" pointList="64,-8,76,-8,76,0" />

</circuit>
```

</details>

- a=0 b=0の時、出力が0となり光らない
<img width="1290" height="770" alt="00" src="https://github.com/user-attachments/assets/a50a51ad-814d-48c7-9014-9f81887277e8" />


- a=0 b=1の時、出力が1となり光る
<img width="1290" height="770" alt="01" src="https://github.com/user-attachments/assets/5aca7f57-037c-476d-831e-76a645074b0d" />


- a=1 b=0の時、出力が1となり光る
<img width="1290" height="770" alt="10" src="https://github.com/user-attachments/assets/3d9360c8-31a3-4367-8ae2-a41d02ffc808" />


- a=1 b=1の時、出力が0となり光らない
<img width="1290" height="770" alt="11" src="https://github.com/user-attachments/assets/45d2649f-7ee2-402d-abd4-c1f56deb87cc" />

# VerilogでAND素子を作る

コンパイル及び実行
```bash
iverilog -o test.out nand_gate_lib.v tb_xor.v
vvp test.out
```

ファイル構成
```
nandcpu/
├── nand_gate_lib.v # NAND構成の論理素子
└── tb_or.v   # 動作確認用
```

xorに関して、どこの部品がどこに対応するかを図で示しました。
<img width="346" height="184" alt="inout" src="https://github.com/user-attachments/assets/31c56ffe-8d7e-4a87-b75c-ce8a5cbd6019" />

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
```

```tb_xor.v
`timescale 1ns/1ps

module tb_xor;
    reg a, b;
    wire y;
    
    xor_gate uut ( .a(a), .b(b), .y(y)); //xorを一個配置
    
    initial begin
        $dumpfile("wave.vcd"); // 出力する波形
        $dumpvars(0, tb_xor); // 全階層の波形を記録
        
        $display("A B | Y");
        $monitor("%b %b | %b", a, b, y);
        
        a = 0; b = 0; #10; // 10ns 時間を進める
        a = 0; b = 1; #10;
        a = 1; b = 0; #10;
        a = 1; b = 1; #10;
        
        $finish;
    end
endmodule
```


# 動作結果

```bash
test@test-fujitsu:~/kaihatsu/nandcpu$ vvp test.out
VCD info: dumpfile wave.vcd opened for output.
A B | Y
0 0 | 0
0 1 | 1
1 0 | 1
1 1 | 0
```

波形
```bash
gtkwave wave.vcd
```
<img width="1020" height="521" alt="wave" src="https://github.com/user-attachments/assets/1664cbb8-d146-4fb4-bf1e-ecc89d83f69a" />

※AND記事では設計した回路を可視化していますが、何故かORの記事以降は回路を生成してもNAND単体の図しか生成されないので原因を調査中です。



