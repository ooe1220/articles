# 目次
https://qiita.com/earthen94/items/28752ae240e9b1c6e116

# NOTとは

入力が1の時に0となり、0の時に1となります。

真理値表
| a | y |
|---|---|
| 0 | 1 |
| 1 | 0 |


入力をNANDの2つの入力に繋ぐと実現できます。
a=b=0 の行を見ると y=1（0が反転して1）、a=b=1 の行を見ると y=0（1が反転して0）となっています。

NANDの真理値表を見てみます。
| a | b | y |
|---|---|---|
| 0 | 0 | 1 |
| 0 | 1 | 1 |
| 1 | 0 | 1 |
| 1 | 1 | 0 |

a=bの時はyがaとbを反転させた結果になっています。

# 動きを見てみる

a=0 時、出力が1となりLEDが光る
<img width="1281" height="797" alt="0" src="https://github.com/user-attachments/assets/915dea5f-b4c6-4afd-8a90-f48bf7dc5c66" />

a=1 時、出力が0となりLEDは光らない
<img width="1281" height="797" alt="1" src="https://github.com/user-attachments/assets/875dced1-a59b-473a-8ce6-5b9d11045f13" />

回路のXML
<details>
<summary>not.sim1</summary>

```not.sim1
<circuit version="1.1.0-SR0" rev="1917" stepSize="1000000" stepsPS="1000000" NLsteps="100000" reaStep="1000000" animate="0" >

<item itemtype="Fixed Voltage" CircId="Fixed Voltage-1" mainComp="false" Show_id="false" Show_Val="false" Pos="8,-4" rotation="0" hflip="1" vflip="1" label="Fixed Voltage-1" idLabPos="-64,-24" labelrot="0" valLabPos="-16,8" valLabRot="0" Voltage="5 V" Out="true" />

<item itemtype="Switch" CircId="Switch-2" mainComp="false" Show_id="false" Show_Val="false" Pos="56,-4" rotation="0" hflip="1" vflip="1" label="Switch-2" idLabPos="-16,-24" labelrot="0" valLabPos="-16,20" valLabRot="0" Norm_Close="false" DT="false" Poles="1" />

<item itemtype="And Gate" CircId="And Gate-4" mainComp="false" Show_id="false" Show_Val="false" Pos="104,-4" rotation="0" hflip="1" vflip="1" label="And Gate-4" idLabPos="-16,-24" labelrot="0" valLabPos="-16,20" valLabRot="0" Input_High_V="2.5 V" Input_Low_V="2.5 V" Input_Imped="1000 MΩ" Num_Inputs="2" Invert_Inputs="false" Out_High_V="5 V" Out_Low_V="0 V" Out_Imped="40 Ω" initHigh="false" Inverted="true" Open_Collector="false" Tpd_ps="10 ns" Tr_ps="3 ns" Tf_ps="4 ns" />

<item itemtype="Led" CircId="Led-5" mainComp="false" Show_id="false" Show_Val="false" Pos="192,-4" rotation="0" hflip="1" vflip="1" label="Led-5" idLabPos="-16,-24" labelrot="0" valLabPos="-16,20" valLabRot="0" Color="Yellow" Grounded="false" Threshold="2.4 V" MaxCurrent="30 mA" Resistance="0.6 Ω" />

<item itemtype="Ground" CircId="Ground-6" mainComp="false" Show_id="false" Show_Val="false" Pos="216,28" rotation="0" hflip="1" vflip="1" label="Ground-6" idLabPos="-16,8" labelrot="0" valLabPos="-16,20" valLabRot="0" />

<item itemtype="Resistor" CircId="Resistor-12" mainComp="false" ShowProp="Resistance" Show_id="false" Show_Val="true" Pos="148,-4" rotation="0" hflip="1" vflip="1" label="Resistor-12" idLabPos="-16,-24" labelrot="0" valLabPos="-16,6" valLabRot="0" Resistance="50 Ω" />

<item itemtype="Node" CircId="Node-10" mainComp="false" Pos="88,-4" />

<item itemtype="Connector" uid="Connector-8" startpinid="Fixed Voltage-1-outnod" endpinid="Switch-2-pinP0" pointList="24,-4,40,-4" />

<item itemtype="Connector" uid="Connector-19" startpinid="Switch-2-switch0pinN" endpinid="Node-10-1" pointList="72,-4,88,-4" />

<item itemtype="Connector" uid="Connector-20" startpinid="And Gate-4-in1" endpinid="Node-10-0" pointList="88,0,88,-4" />

<item itemtype="Connector" uid="Connector-21" startpinid="Node-10-2" endpinid="And Gate-4-in0" pointList="88,-4,88,-8" />

<item itemtype="Connector" uid="Connector-26" startpinid="And Gate-4-out" endpinid="Resistor-12-lPin" pointList="120,-4,132,-4" />

<item itemtype="Connector" uid="Connector-27" startpinid="Resistor-12-rPin" endpinid="Led-5-lPin" pointList="164,-4,176,-4" />

<item itemtype="Connector" uid="Connector-28" startpinid="Led-5-rPin" endpinid="Ground-6-Gnd" pointList="208,-4,216,-4,216,12" />

</circuit>
```

</details>


# VerilogでNOT素子を作る

コンパイル及び実行
```bash
iverilog -o not_tb.out nand.v not.v tb_not.v
vvp not_tb.out
```

波形の確認
```
gtkwave nand.vcd
```

ファイル構成

```
nandcpu/
├── nand.v     # NAND素子（最小単位）
├── not.v      # NANDで作ったNOT
└── tb_not.v   # NOTの動作確認
```

```nand.v
`timescale 1ns/1ps

// NAND素子の定義(これを最小単位とする)
module nand_gate (
    input a,
    input b,
    output y
);

    nand(y,a,b);
endmodule
```

```not.v
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

```tb_not.v
`timescale 1ns/1ps

module tb_not;
    reg a;
    wire y;
    
    not_gate uut ( .a(a), .y(y)); //notを一個配置
    
    initial begin
        $dumpfile("not.vcd"); // 出力する波形
        $dumpvars(0, tb_not); // 全階層の波形を記録
        
        $display("A | Y");
        $monitor("%d | %d", a, y);
        
        a=0;#10
        a=1;#10
        
        $finish;
    end
endmodule
```

# 動作結果

```bash
test@test-fujitsu:~/kaihatsu/nandcpu$ vvp not_tb.out
VCD info: dumpfile not.vcd opened for output.
A | Y
0 | 1
1 | 0
```

波形を確認します。
```
test@test-fujitsu:~/kaihatsu/nandcpu$ gtkwave not.vcd
```

<img width="1020" height="399" alt="wave" src="https://github.com/user-attachments/assets/63867773-fe91-44b1-83a5-b12bf2240e91" />
