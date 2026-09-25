# 目次
https://qiita.com/earthen94/items/28752ae240e9b1c6e116

# ANDとは

NANDの否定であり、両方が1の時だけ1を出力し、それ以外は0を出力します。

真理値表
| a | b | y |
|---|---|---|
| 0 | 0 | 0 |
| 0 | 1 | 0 |
| 1 | 0 | 0 |
| 1 | 1 | 1 |

ANDはNANDと逆の出力になればよいので、NAND出力の先にNOTを繋げるだけです。
前回の記事でNANDの入力両方に繋げばNOTが作れることを証明しました。
よってAND回路はNAND出力を二つに分岐させて2つ目のNANDの両方に繋げることで実現できます。

# LEDで動作を可視化

```bash
/opt/simulide-110sr0/simulide and.sim1
```

<details>
<summary>and.sim1</summary>

```and.sim1
<circuit version="1.1.0-SR0" rev="1917" stepSize="1000000" stepsPS="1000000" NLsteps="100000" reaStep="1000000" animate="0" >

<item itemtype="Fixed Voltage" CircId="Fixed Voltage-1" mainComp="false" Show_id="false" Show_Val="false" Pos="-928,-200" rotation="0" hflip="1" vflip="1" label="Fixed Voltage-1" idLabPos="-64,-24" labelrot="0" valLabPos="-16,8" valLabRot="0" Voltage="5 V" Out="false" />

<item itemtype="Fixed Voltage" CircId="Fixed Voltage-2" mainComp="false" Show_id="false" Show_Val="false" Pos="-928,-160" rotation="0" hflip="1" vflip="1" label="Fixed Voltage-2" idLabPos="-64,-24" labelrot="0" valLabPos="-16,8" valLabRot="0" Voltage="5 V" Out="false" />

<item itemtype="Resistor" CircId="Resistor-4" mainComp="false" ShowProp="Resistance" Show_id="false" Show_Val="true" Pos="-868,-232" rotation="0" hflip="1" vflip="1" label="Resistor-4" idLabPos="-16,-24" labelrot="0" valLabPos="-16,6" valLabRot="0" Resistance="70 Ω" />

<item itemtype="Resistor" CircId="Resistor-5" mainComp="false" ShowProp="Resistance" Show_id="false" Show_Val="true" Pos="-868,-136" rotation="0" hflip="1" vflip="1" label="Resistor-5" idLabPos="-16,-24" labelrot="0" valLabPos="-16,6" valLabRot="0" Resistance="70 Ω" />

<item itemtype="Led" CircId="Led-8" mainComp="false" Show_id="false" Show_Val="false" Pos="-820,-232" rotation="0" hflip="1" vflip="1" label="Led-8" idLabPos="-16,-24" labelrot="0" valLabPos="-16,20" valLabRot="0" Color="Yellow" Grounded="false" Threshold="2.4 V" MaxCurrent="30 mA" Resistance="0.6 Ω" />

<item itemtype="Led" CircId="Led-9" mainComp="false" Show_id="false" Show_Val="false" Pos="-820,-136" rotation="0" hflip="1" vflip="1" label="Led-9" idLabPos="-16,-24" labelrot="0" valLabPos="-16,20" valLabRot="0" Color="Yellow" Grounded="false" Threshold="2.4 V" MaxCurrent="30 mA" Resistance="0.6 Ω" />

<item itemtype="Ground" CircId="Ground-10" mainComp="false" Show_id="false" Show_Val="false" Pos="-792,-204" rotation="0" hflip="1" vflip="1" label="Ground-10" idLabPos="-16,8" labelrot="0" valLabPos="-16,20" valLabRot="0" />

<item itemtype="Ground" CircId="Ground-11" mainComp="false" Show_id="false" Show_Val="false" Pos="-792,-112" rotation="0" hflip="1" vflip="1" label="Ground-11" idLabPos="-16,8" labelrot="0" valLabPos="-16,20" valLabRot="0" />

<item itemtype="And Gate" CircId="And Gate-3" mainComp="false" Show_id="false" Show_Val="false" Pos="-852,-184" rotation="0" hflip="1" vflip="1" label="And Gate-3" idLabPos="-16,-24" labelrot="0" valLabPos="-16,20" valLabRot="0" Input_High_V="2.5 V" Input_Low_V="2.5 V" Input_Imped="1000 MΩ" Num_Inputs="2" Invert_Inputs="false" Out_High_V="5 V" Out_Low_V="0 V" Out_Imped="40 Ω" initHigh="false" Inverted="true" Open_Collector="false" Tpd_ps="10 ns" Tr_ps="3 ns" Tf_ps="4 ns" />

<item itemtype="And Gate" CircId="And Gate-13" mainComp="false" Show_id="false" Show_Val="false" Pos="-788,-184" rotation="0" hflip="1" vflip="1" label="And Gate-13" idLabPos="-16,-24" labelrot="0" valLabPos="-16,20" valLabRot="0" Input_High_V="2.5 V" Input_Low_V="2.5 V" Input_Imped="1000 MΩ" Num_Inputs="2" Invert_Inputs="false" Out_High_V="5 V" Out_Low_V="0 V" Out_Imped="40 Ω" initHigh="false" Inverted="true" Open_Collector="false" Tpd_ps="10 ns" Tr_ps="3 ns" Tf_ps="4 ns" />

<item itemtype="Led" CircId="Led-17" mainComp="false" Show_id="false" Show_Val="false" Pos="-700,-184" rotation="0" hflip="1" vflip="1" label="Led-17" idLabPos="-16,-24" labelrot="0" valLabPos="-16,20" valLabRot="0" Color="Yellow" Grounded="false" Threshold="2.4 V" MaxCurrent="30 mA" Resistance="0.6 Ω" />

<item itemtype="Resistor" CircId="Resistor-18" mainComp="false" ShowProp="Resistance" Show_id="false" Show_Val="true" Pos="-744,-184" rotation="0" hflip="1" vflip="1" label="Resistor-18" idLabPos="-16,-24" labelrot="0" valLabPos="-16,6" valLabRot="0" Resistance="50 Ω" />

<item itemtype="Ground" CircId="Ground-19" mainComp="false" Show_id="false" Show_Val="false" Pos="-664,-156" rotation="0" hflip="1" vflip="1" label="Ground-19" idLabPos="-16,8" labelrot="0" valLabPos="-16,20" valLabRot="0" />

<item itemtype="Node" CircId="Node-7" mainComp="false" Pos="-884,-180" />

<item itemtype="Node" CircId="Node-6" mainComp="false" Pos="-884,-188" />

<item itemtype="Node" CircId="Node-16" mainComp="false" Pos="-804,-184" />

<item itemtype="Connector" uid="Connector-10" startpinid="Resistor-4-rPin" endpinid="Led-8-lPin" pointList="-852,-232,-836,-232" />

<item itemtype="Connector" uid="Connector-11" startpinid="Resistor-5-rPin" endpinid="Led-9-lPin" pointList="-852,-136,-836,-136" />

<item itemtype="Connector" uid="Connector-12" startpinid="Led-8-rPin" endpinid="Ground-10-Gnd" pointList="-804,-232,-792,-232,-792,-220" />

<item itemtype="Connector" uid="Connector-13" startpinid="Led-9-rPin" endpinid="Ground-11-Gnd" pointList="-804,-136,-792,-136,-792,-128" />

<item itemtype="Connector" uid="Connector-8" startpinid="Node-7-2" endpinid="And Gate-3-in1" pointList="-884,-180,-868,-180" />

<item itemtype="Connector" uid="Connector-7" startpinid="Fixed Voltage-2-outnod" endpinid="Node-7-0" pointList="-912,-160,-912,-180,-884,-180" />

<item itemtype="Connector" uid="Connector-6" startpinid="Resistor-5-lPin" endpinid="Node-7-1" pointList="-884,-136,-884,-180" />

<item itemtype="Connector" uid="Connector-5" startpinid="Node-6-2" endpinid="And Gate-3-in0" pointList="-884,-188,-868,-188" />

<item itemtype="Connector" uid="Connector-4" startpinid="Fixed Voltage-1-outnod" endpinid="Node-6-0" pointList="-912,-200,-912,-188,-884,-188" />

<item itemtype="Connector" uid="Connector-3" startpinid="Resistor-4-lPin" endpinid="Node-6-1" pointList="-884,-232,-884,-188" />

<item itemtype="Connector" uid="Connector-26" startpinid="Node-16-1" endpinid="And Gate-13-in1" pointList="-804,-184,-804,-180" />

<item itemtype="Connector" uid="Connector-27" startpinid="And Gate-3-out" endpinid="Node-16-0" pointList="-836,-184,-804,-184" />

<item itemtype="Connector" uid="Connector-28" startpinid="Node-16-2" endpinid="And Gate-13-in0" pointList="-804,-184,-804,-188" />

<item itemtype="Connector" uid="Connector-29" startpinid="And Gate-13-out" endpinid="Resistor-18-lPin" pointList="-772,-184,-760,-184" />

<item itemtype="Connector" uid="Connector-31" startpinid="Resistor-18-rPin" endpinid="Led-17-lPin" pointList="-728,-184,-716,-184" />

<item itemtype="Connector" uid="Connector-32" startpinid="Led-17-rPin" endpinid="Ground-19-Gnd" pointList="-684,-184,-664,-184,-664,-172" />

</circuit>
```

</details>

- a=0 b=0の時、出力が0となり消える
  <img width="1281" height="573" alt="00" src="https://github.com/user-attachments/assets/9c08d96b-e126-403a-8acf-20cc130c2453" />

- a=0 b=1の時、出力が0となり消える
  <img width="1281" height="573" alt="01" src="https://github.com/user-attachments/assets/2e1bc190-77ea-43e9-83b9-d1c730169068" />

- a=1 b=0の時、出力が0となり消える
  <img width="1281" height="573" alt="10" src="https://github.com/user-attachments/assets/164d6c49-d5ad-49cf-a66c-5bb7b1c53eef" />

- a=1 b=1の時、出力が0となり消える
  <img width="1281" height="573" alt="11" src="https://github.com/user-attachments/assets/a1f3dd38-29d4-4275-b57f-9cff92614797" />


# VerilogでAND素子を作る

コンパイル及び実行
```bash
iverilog -o test.out nand_gate_lib.v tb_and.v
vvp test.out
```

ファイル構成
```
nandcpu/
├── nand_gate_lib.v # NAND構成の論理素子
└── tb_and.v   # 動作確認用
```

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
```

```tb_and.v
`timescale 1ns/1ps

module tb_and;
    reg a, b;
    wire y;
    
    and_gate uut ( .a(a), .b(b), .y(y)); //andを一個配置
    
    initial begin
        $dumpfile("wave.vcd"); // 出力する波形
        $dumpvars(0, tb_and); // 全階層の波形を記録
        
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
test@test-fujitsu:~/kaihatsu/nandcpu$ iverilog -o test.out nand_gate_lib.v tb_and.v
test@test-fujitsu:~/kaihatsu/nandcpu$ vvp test.out
VCD info: dumpfile wave.vcd opened for output.
A B | Y
0 0 | 0
0 1 | 0
1 0 | 0
1 1 | 1
test@test-fujitsu:~/kaihatsu/nandcpu$ 
```

波形
```bash
gtkwave wave.vcd
```
<img width="1020" height="390" alt="wave" src="https://github.com/user-attachments/assets/5d0a0724-823b-4ef6-8ffb-46d799d8fb3c" />


設計した回路の確認
```bash
yosys -p 'read_verilog nand_gate_lib.v; hierarchy -top and_gate; proc; opt; show -format dot -prefix and_gate'

dot -Tsvg and_gate.dot -o and_gate.svg
rsvg-convert and_gate.svg -o and_gate.png
```
<img width="795" height="162" alt="and_gate" src="https://github.com/user-attachments/assets/a9abf5d2-84e5-4f94-9594-67c81c854422" />
