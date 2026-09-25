# 目次
https://qiita.com/earthen94/items/28752ae240e9b1c6e116

# ORとは

aとbいずれかが1であれば出力は1となります。

真理値表
| a | b | y |
|---|---|---|
| 0 | 0 | 0 |
| 0 | 1 | 1 |
| 1 | 0 | 1 |
| 1 | 1 | 1 |


# LEDで動作を可視化

※ドモルガンの法則を使って式変形をすると何故この回路になるのか証明できますが、説明しているサイトは五万とあるので割愛します。NANDを以下の様に並べたらOR回路になります。

式変形としてはこうなります。
$Y = \overline{\overline{A} \cdot \overline{B}} = A + B$

NOTは前の記事でNANDで作れることを証明しているので、これを組み合わせればOR回路が作れます。

```bash
/opt/simulide-110sr0/simulide or.sim1
```

<details>
<summary>or.sim1</summary>

```or.sim1
<circuit version="1.1.0-SR0" rev="1917" stepSize="1000000" stepsPS="1000000" NLsteps="100000" reaStep="1000000" animate="0" >

<item itemtype="And Gate" CircId="And Gate-1" mainComp="false" Show_id="false" Show_Val="false" Pos="-80,-24" rotation="0" hflip="1" vflip="1" label="And Gate-1" idLabPos="-16,-24" labelrot="0" valLabPos="-16,20" valLabRot="0" Input_High_V="2.5 V" Input_Low_V="2.5 V" Input_Imped="1000 MΩ" Num_Inputs="2" Invert_Inputs="false" Out_High_V="5 V" Out_Low_V="0 V" Out_Imped="40 Ω" initHigh="false" Inverted="true" Open_Collector="false" Tpd_ps="10 ns" Tr_ps="3 ns" Tf_ps="4 ns" />

<item itemtype="And Gate" CircId="And Gate-2" mainComp="false" Show_id="false" Show_Val="false" Pos="-80,8" rotation="0" hflip="1" vflip="1" label="And Gate-2" idLabPos="-16,-24" labelrot="0" valLabPos="-16,20" valLabRot="0" Input_High_V="2.5 V" Input_Low_V="2.5 V" Input_Imped="1000 MΩ" Num_Inputs="2" Invert_Inputs="false" Out_High_V="5 V" Out_Low_V="0 V" Out_Imped="40 Ω" initHigh="false" Inverted="true" Open_Collector="false" Tpd_ps="10 ns" Tr_ps="3 ns" Tf_ps="4 ns" />

<item itemtype="And Gate" CircId="And Gate-3" mainComp="false" Show_id="false" Show_Val="false" Pos="-36,-8" rotation="0" hflip="1" vflip="1" label="And Gate-3" idLabPos="-16,-24" labelrot="0" valLabPos="-16,20" valLabRot="0" Input_High_V="2.5 V" Input_Low_V="2.5 V" Input_Imped="1000 MΩ" Num_Inputs="2" Invert_Inputs="false" Out_High_V="5 V" Out_Low_V="0 V" Out_Imped="40 Ω" initHigh="false" Inverted="true" Open_Collector="false" Tpd_ps="10 ns" Tr_ps="3 ns" Tf_ps="4 ns" />

<item itemtype="Fixed Voltage" CircId="Fixed Voltage-4" mainComp="false" Show_id="false" Show_Val="false" Pos="-200,-24" rotation="0" hflip="1" vflip="1" label="Fixed Voltage-4" idLabPos="-64,-24" labelrot="0" valLabPos="-16,8" valLabRot="0" Voltage="5 V" Out="true" />

<item itemtype="Led" CircId="Led-5" mainComp="false" Show_id="false" Show_Val="false" Pos="-112,-68" rotation="0" hflip="1" vflip="1" label="Led-5" idLabPos="-16,-24" labelrot="0" valLabPos="-16,20" valLabRot="0" Color="Yellow" Grounded="false" Threshold="2.4 V" MaxCurrent="30 mA" Resistance="0.6 Ω" />

<item itemtype="Resistor" CircId="Resistor-6" mainComp="false" ShowProp="Resistance" Show_id="false" Show_Val="true" Pos="-152,-68" rotation="0" hflip="1" vflip="1" label="Resistor-6" idLabPos="-16,-24" labelrot="0" valLabPos="-16,6" valLabRot="0" Resistance="70 Ω" />

<item itemtype="Ground" CircId="Ground-7" mainComp="false" Show_id="false" Show_Val="false" Pos="-84,-52" rotation="0" hflip="1" vflip="1" label="Ground-7" idLabPos="-16,8" labelrot="0" valLabPos="-16,20" valLabRot="0" />

<item itemtype="Fixed Voltage" CircId="Fixed Voltage-11" mainComp="false" Show_id="false" Show_Val="false" Pos="-200,8" rotation="0" hflip="1" vflip="1" label="Fixed Voltage-11" idLabPos="-64,-24" labelrot="0" valLabPos="-16,8" valLabRot="0" Voltage="5 V" Out="true" />

<item itemtype="Resistor" CircId="Resistor-16" mainComp="false" ShowProp="Resistance" Show_id="false" Show_Val="true" Pos="-152,52" rotation="0" hflip="1" vflip="1" label="Resistor-16" idLabPos="-16,-24" labelrot="0" valLabPos="-16,6" valLabRot="0" Resistance="70 Ω" />

<item itemtype="Led" CircId="Led-17" mainComp="false" Show_id="false" Show_Val="false" Pos="-112,52" rotation="0" hflip="1" vflip="1" label="Led-17" idLabPos="-16,-24" labelrot="0" valLabPos="-16,20" valLabRot="0" Color="Yellow" Grounded="false" Threshold="2.4 V" MaxCurrent="30 mA" Resistance="0.6 Ω" />

<item itemtype="Ground" CircId="Ground-18" mainComp="false" Show_id="false" Show_Val="false" Pos="-84,68" rotation="0" hflip="1" vflip="1" label="Ground-18" idLabPos="-16,8" labelrot="0" valLabPos="-16,20" valLabRot="0" />

<item itemtype="Led" CircId="Led-20" mainComp="false" Show_id="false" Show_Val="false" Pos="44,-8" rotation="0" hflip="1" vflip="1" label="Led-20" idLabPos="-16,-24" labelrot="0" valLabPos="-16,20" valLabRot="0" Color="Yellow" Grounded="false" Threshold="2.4 V" MaxCurrent="30 mA" Resistance="0.6 Ω" />

<item itemtype="Resistor" CircId="Resistor-21" mainComp="false" ShowProp="Resistance" Show_id="false" Show_Val="true" Pos="4,-8" rotation="0" hflip="1" vflip="1" label="Resistor-21" idLabPos="-16,-24" labelrot="0" valLabPos="-16,6" valLabRot="0" Resistance="50 Ω" />

<item itemtype="Ground" CircId="Ground-22" mainComp="false" Show_id="false" Show_Val="false" Pos="72,8" rotation="0" hflip="1" vflip="1" label="Ground-22" idLabPos="-16,8" labelrot="0" valLabPos="-16,20" valLabRot="0" />

<item itemtype="Node" CircId="Node-9" mainComp="false" Pos="-96,-24" />

<item itemtype="Node" CircId="Node-10" mainComp="false" Pos="-168,-24" />

<item itemtype="Node" CircId="Node-15" mainComp="false" Pos="-96,8" />

<item itemtype="Node" CircId="Node-19" mainComp="false" Pos="-168,8" />

<item itemtype="Connector" uid="Connector-1" startpinid="And Gate-1-out" endpinid="And Gate-3-in0" pointList="-64,-24,-64,-12,-52,-12" />

<item itemtype="Connector" uid="Connector-2" startpinid="And Gate-2-out" endpinid="And Gate-3-in1" pointList="-64,8,-64,-4,-52,-4" />

<item itemtype="Connector" uid="Connector-8" startpinid="Node-9-1" endpinid="And Gate-1-in1" pointList="-96,-24,-96,-20" />

<item itemtype="Connector" uid="Connector-10" startpinid="Node-9-2" endpinid="And Gate-1-in0" pointList="-96,-24,-96,-28" />

<item itemtype="Connector" uid="Connector-11" startpinid="Resistor-6-lPin" endpinid="Node-10-1" pointList="-168,-68,-168,-24" />

<item itemtype="Connector" uid="Connector-12" startpinid="Fixed Voltage-4-outnod" endpinid="Node-10-0" pointList="-184,-24,-168,-24" />

<item itemtype="Connector" uid="Connector-13" startpinid="Node-10-2" endpinid="Node-9-0" pointList="-168,-24,-96,-24" />

<item itemtype="Connector" uid="Connector-14" startpinid="Resistor-6-rPin" endpinid="Led-5-lPin" pointList="-136,-68,-128,-68" />

<item itemtype="Connector" uid="Connector-15" startpinid="Led-5-rPin" endpinid="Ground-7-Gnd" pointList="-96,-68,-84,-68" />

<item itemtype="Connector" uid="Connector-29" startpinid="Node-15-1" endpinid="And Gate-2-in1" pointList="-96,8,-96,12" />

<item itemtype="Connector" uid="Connector-31" startpinid="Node-15-2" endpinid="And Gate-2-in0" pointList="-96,8,-96,4" />

<item itemtype="Connector" uid="Connector-32" startpinid="Led-17-rPin" endpinid="Ground-18-Gnd" pointList="-96,52,-84,52" />

<item itemtype="Connector" uid="Connector-33" startpinid="Resistor-16-rPin" endpinid="Led-17-lPin" pointList="-136,52,-128,52" />

<item itemtype="Connector" uid="Connector-34" startpinid="Resistor-16-lPin" endpinid="Node-19-1" pointList="-168,52,-168,8" />

<item itemtype="Connector" uid="Connector-35" startpinid="Fixed Voltage-11-outnod" endpinid="Node-19-0" pointList="-184,8,-168,8" />

<item itemtype="Connector" uid="Connector-36" startpinid="Node-19-2" endpinid="Node-15-0" pointList="-168,8,-96,8" />

<item itemtype="Connector" uid="Connector-37" startpinid="Led-20-rPin" endpinid="Ground-22-Gnd" pointList="60,-8,72,-8" />

<item itemtype="Connector" uid="Connector-38" startpinid="Resistor-21-rPin" endpinid="Led-20-lPin" pointList="20,-8,28,-8" />

<item itemtype="Connector" uid="Connector-39" startpinid="And Gate-3-out" endpinid="Resistor-21-lPin" pointList="-20,-8,-12,-8" />

</circuit>
```

</details>

- a=0 b=0の時、出力が0となり光らない
<img width="1373" height="857" alt="00" src="https://github.com/user-attachments/assets/811914ca-f3b3-4b25-a129-31b30e9a3f90" />

- a=0 b=1の時、出力が1となり光る
<img width="1373" height="857" alt="01" src="https://github.com/user-attachments/assets/d1afc728-65ca-4cc7-907a-8e32edac7cb5" />

- a=1 b=0の時、出力が1となり光る
<img width="1373" height="857" alt="10" src="https://github.com/user-attachments/assets/beabc4cb-5bc5-4756-8cce-836bcfdca035" />

- a=1 b=1の時、出力が1となり光る
<img width="1373" height="857" alt="11" src="https://github.com/user-attachments/assets/70f60d41-be9e-4a94-9232-0b468a9e1992" />


# VerilogでOR素子を作る

コンパイル及び実行
```bash
iverilog -o test.out nand_gate_lib.v tb_or.v
vvp test.out
```

ファイル構成
```
nandcpu/
├── nand_gate_lib.v # NAND構成の論理素子
└── tb_or.v   # 動作確認用
```

orに関して、どこの部品がどこに対応するかを図で示しました。
<img width="262" height="160" alt="inut" src="https://github.com/user-attachments/assets/c15a89be-9c28-4e79-8586-97699c0205ff" />

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
```

```tb_or.v
`timescale 1ns/1ps

module tb_or;
    reg a, b;
    wire y;
    
    or_gate uut ( .a(a), .b(b), .y(y)); //orを一個配置
    
    initial begin
        $dumpfile("wave.vcd"); // 出力する波形
        $dumpvars(0, tb_or); // 全階層の波形を記録
        
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
test@test-fujitsu:~/kaihatsu/nandcpu$ iverilog -o test.out nand_gate_lib.v tb_or.v
test@test-fujitsu:~/kaihatsu/nandcpu$ vvp test.out
VCD info: dumpfile wave.vcd opened for output.
A B | Y
0 0 | 0
0 1 | 1
1 0 | 1
1 1 | 1

```

波形
```bash
gtkwave wave.vcd
```

<img width="907" height="390" alt="wave" src="https://github.com/user-attachments/assets/7f5438c8-e62b-40ea-97ae-99d2af5b15ed" />

※AND記事では設計した回路を可視化していますが、何故かORからは回路を生成してもNAND単体の図しか生成されないので原因を調査中です。



