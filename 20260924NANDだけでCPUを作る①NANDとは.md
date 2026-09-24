# 目次
https://qiita.com/earthen94/items/28752ae240e9b1c6e116

# NANDとは

両方が1の時だけ0を出力し、それ以外は1を出力します。

真理値表
| a | b | y |
|---|---|---|
| 0 | 0 | 1 |
| 0 | 1 | 1 |
| 1 | 0 | 1 |
| 1 | 1 | 0 |

# 動きを見てみる

simlideというソフトでNAND回路にLEDを繋ぎ視覚的に観察します。※電気が流れていることを視覚的に見る為にLEDを接続しただけで通常は繋ぎません。
1の場合は電圧がかかりLEDが光り、0の時は消えます。
※入力にしか電源を繋いでおらず、両方0の時は電源が無いので実際の回路では光らない気もしますが、筆者は電子工作が得意でないので、ちょっと分かりません。NANDの説明にはこれで事足ります。

[simulideを導入](https://qiita.com/earthen94/items/37a4a18d94f4e4571754)

起動コマンド
```bash
/opt/simulide-110sr0/simulide
```

いつでも復元できるように回路をXMLで保存したもの

<details>
<summary>nand.sim1</summary>

```nand.sim1
<circuit version="1.1.0-SR0" rev="1917" stepSize="1000000" stepsPS="1000000" NLsteps="100000" reaStep="1000000" animate="0" >

<item itemtype="Switch" CircId="Switch-5" mainComp="false" Show_id="false" Show_Val="false" Pos="-464,-116" rotation="0" hflip="1" vflip="1" label="Switch-5" idLabPos="-16,-24" labelrot="0" valLabPos="-16,20" valLabRot="0" Norm_Close="false" DT="false" Poles="1" />

<item itemtype="Led" CircId="Led-6" mainComp="false" Show_id="false" Show_Val="false" Pos="-368,-220" rotation="0" hflip="1" vflip="1" label="Led-6" idLabPos="-16,-24" labelrot="0" valLabPos="-16,20" valLabRot="0" Color="Yellow" Grounded="false" Threshold="2.4 V" MaxCurrent="30 mA" Resistance="0.6 Ω" />

<item itemtype="Led" CircId="Led-7" mainComp="false" Show_id="false" Show_Val="false" Pos="-368,-64" rotation="0" hflip="1" vflip="1" label="Led-7" idLabPos="-16,-24" labelrot="0" valLabPos="-16,20" valLabRot="0" Color="Yellow" Grounded="false" Threshold="2.4 V" MaxCurrent="30 mA" Resistance="0.6 Ω" />

<item itemtype="Led" CircId="Led-8" mainComp="false" Show_id="false" Show_Val="false" Pos="-256,-140" rotation="0" hflip="1" vflip="1" label="Led-8" idLabPos="-16,-24" labelrot="0" valLabPos="-16,20" valLabRot="0" Color="Yellow" Grounded="false" Threshold="2.4 V" MaxCurrent="30 mA" Resistance="0.6 Ω" />

<item itemtype="And Gate" CircId="And Gate-9" mainComp="false" Show_id="false" Show_Val="false" Pos="-348,-140" rotation="0" hflip="1" vflip="1" label="And Gate-9" idLabPos="-16,-24" labelrot="0" valLabPos="-16,20" valLabRot="0" Input_High_V="2.5 V" Input_Low_V="2.5 V" Input_Imped="1000 MΩ" Num_Inputs="2" Invert_Inputs="false" Out_High_V="5 V" Out_Low_V="0 V" Out_Imped="40 Ω" initHigh="false" Inverted="true" Open_Collector="false" Tpd_ps="10 ns" Tr_ps="3 ns" Tf_ps="4 ns" />

<item itemtype="Fixed Voltage" CircId="Fixed Voltage-10" mainComp="false" Show_id="false" Show_Val="false" Pos="-520,-164" rotation="0" hflip="1" vflip="1" label="Fixed Voltage-10" idLabPos="-64,-24" labelrot="0" valLabPos="-16,8" valLabRot="0" Voltage="5 V" Out="true" />

<item itemtype="Fixed Voltage" CircId="Fixed Voltage-11" mainComp="false" Show_id="false" Show_Val="false" Pos="-520,-116" rotation="0" hflip="1" vflip="1" label="Fixed Voltage-11" idLabPos="-64,-24" labelrot="0" valLabPos="-16,8" valLabRot="0" Voltage="5 V" Out="true" />

<item itemtype="Resistor" CircId="Resistor-12" mainComp="false" ShowProp="Resistance" Show_id="false" Show_Val="true" Pos="-416,-220" rotation="0" hflip="1" vflip="1" label="Resistor-12" idLabPos="-16,-24" labelrot="0" valLabPos="-16,6" valLabRot="0" Resistance="70 Ω" />

<item itemtype="Resistor" CircId="Resistor-13" mainComp="false" ShowProp="Resistance" Show_id="false" Show_Val="true" Pos="-412,-64" rotation="0" hflip="1" vflip="1" label="Resistor-13" idLabPos="-16,-24" labelrot="0" valLabPos="-16,6" valLabRot="0" Resistance="70 Ω" />

<item itemtype="Ground" CircId="Ground-16" mainComp="false" Show_id="false" Show_Val="false" Pos="-348,-196" rotation="0" hflip="1" vflip="1" label="Ground-16" idLabPos="-16,8" labelrot="0" valLabPos="-16,20" valLabRot="0" />

<item itemtype="Switch" CircId="Switch-25" mainComp="false" Show_id="false" Show_Val="false" Pos="-464,-164" rotation="0" hflip="1" vflip="1" label="Switch-25" idLabPos="-16,-24" labelrot="0" valLabPos="-16,20" valLabRot="0" Norm_Close="false" DT="false" Poles="1" />

<item itemtype="Ground" CircId="Ground-29" mainComp="false" Show_id="false" Show_Val="false" Pos="-344,-44" rotation="0" hflip="1" vflip="1" label="Ground-29" idLabPos="-16,8" labelrot="0" valLabPos="-16,20" valLabRot="0" />

<item itemtype="Resistor" CircId="Resistor-32" mainComp="false" ShowProp="Resistance" Show_id="false" Show_Val="true" Pos="-300,-140" rotation="0" hflip="1" vflip="1" label="Resistor-32" idLabPos="-16,-24" labelrot="0" valLabPos="-16,6" valLabRot="0" Resistance="50 Ω" />

<item itemtype="Ground" CircId="Ground-33" mainComp="false" Show_id="false" Show_Val="false" Pos="-220,-104" rotation="0" hflip="1" vflip="1" label="Ground-33" idLabPos="-16,8" labelrot="0" valLabPos="-16,20" valLabRot="0" />

<item itemtype="Node" CircId="Node-26" mainComp="false" Pos="-432,-220" />

<item itemtype="Node" CircId="Node-27" mainComp="false" Pos="-436,-164" />

<item itemtype="Node" CircId="Node-30" mainComp="false" Pos="-428,-64" />

<item itemtype="Node" CircId="Node-31" mainComp="false" Pos="-428,-116" />

<item itemtype="Connector" uid="Connector-7" startpinid="Fixed Voltage-11-outnod" endpinid="Switch-5-pinP0" pointList="-504,-116,-480,-116" />

<item itemtype="Connector" uid="Connector-15" startpinid="Resistor-12-rPin" endpinid="Led-6-lPin" pointList="-400,-220,-384,-220" />

<item itemtype="Connector" uid="Connector-51" startpinid="Fixed Voltage-10-outnod" endpinid="Switch-25-pinP0" pointList="-504,-164,-480,-164" />

<item itemtype="Connector" uid="Connector-54" startpinid="Node-26-1" endpinid="Node-27-1" pointList="-432,-220,-432,-164,-436,-164" />

<item itemtype="Connector" uid="Connector-55" startpinid="Resistor-12-lPin" endpinid="Node-26-0" pointList="-432,-220,-432,-220" />

<item itemtype="Connector" uid="Connector-56" startpinid="Node-26-2" endpinid="Resistor-12-lPin" pointList="-432,-220,-432,-220" />

<item itemtype="Connector" uid="Connector-57" startpinid="Switch-25-switch0pinN" endpinid="Node-27-0" pointList="-448,-164,-436,-164" />

<item itemtype="Connector" uid="Connector-58" startpinid="Node-27-2" endpinid="And Gate-9-in0" pointList="-436,-164,-364,-164,-364,-144" />

<item itemtype="Connector" uid="Connector-62" startpinid="Led-6-rPin" endpinid="Ground-16-Gnd" pointList="-352,-220,-348,-220,-348,-212" />

<item itemtype="Connector" uid="Connector-63" startpinid="Led-7-rPin" endpinid="Ground-29-Gnd" pointList="-352,-64,-344,-64,-344,-60" />

<item itemtype="Connector" uid="Connector-64" startpinid="Resistor-13-rPin" endpinid="Led-7-lPin" pointList="-396,-64,-384,-64" />

<item itemtype="Connector" uid="Connector-66" startpinid="Node-30-1" endpinid="Node-31-1" pointList="-428,-64,-428,-116" />

<item itemtype="Connector" uid="Connector-67" startpinid="Resistor-13-lPin" endpinid="Node-30-0" pointList="-428,-64,-428,-64" />

<item itemtype="Connector" uid="Connector-68" startpinid="Node-30-2" endpinid="Resistor-13-lPin" pointList="-428,-64,-428,-64" />

<item itemtype="Connector" uid="Connector-69" startpinid="Switch-5-switch0pinN" endpinid="Node-31-0" pointList="-448,-116,-428,-116" />

<item itemtype="Connector" uid="Connector-70" startpinid="Node-31-2" endpinid="And Gate-9-in1" pointList="-428,-116,-364,-116,-364,-136" />

<item itemtype="Connector" uid="Connector-71" startpinid="And Gate-9-out" endpinid="Resistor-32-lPin" pointList="-332,-140,-316,-140" />

<item itemtype="Connector" uid="Connector-72" startpinid="Resistor-32-rPin" endpinid="Led-8-lPin" pointList="-284,-140,-272,-140" />

<item itemtype="Connector" uid="Connector-73" startpinid="Led-8-rPin" endpinid="Ground-33-Gnd" pointList="-240,-140,-220,-140,-220,-120" />

</circuit>
```

</details>

a=0 b=0の時、出力が1となり光る
<img width="1398" height="797" alt="00" src="https://github.com/user-attachments/assets/f4956854-2044-49b5-b777-3579590957e1" />

a=0 b=1の時、出力が1となり光る
<img width="1398" height="797" alt="01" src="https://github.com/user-attachments/assets/d9cafe52-3b20-4f08-b6f8-6ebfc3a671cb" />


a=1 b=0の時、出力が1となり光る
<img width="1398" height="797" alt="10" src="https://github.com/user-attachments/assets/9b3dddc5-c3de-44a1-8ee1-4d159e4a8e46" />


a=1 b=1の時、出力が0となり消える
<img width="1398" height="797" alt="11" src="https://github.com/user-attachments/assets/6200cb38-016c-4449-93c2-83e061fc02d8" />



# VerilogでNAND素子を作る

コンパイル及び実行
```bash
iverilog -o nand.out nand.v tb_nand.v
vvp nand.out
```

波形の確認
```
gtkwave nand.vcd
```

ファイル構成
```
nandcpu/
├── nand.v      # NAND 素子（最小単位）
└── tb_nand.v   # 動作確認用
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

```tb_nand.v
`timescale 1ns/1ps

module tb_nand;
    reg a, b;  // 入力
    wire y;    // 出力
    
    nand_gate uut (.a(a), .b(b), .y(y)); // NANDを一個配置する
    
    initial begin // ここから動作を記述
        $dumpfile("nand.vcd");  // 出力する波形ファイル
        $dumpvars(0, tb_nand);
        
        $display("A B | Y");
        $monitor("%d %d | %d", a, b, y);
        
        // 真理値表と同じように入力と出力を確認
        a = 0; b = 0; #10; // 10ns 時間を進める
        a = 0; b = 1; #10;
        a = 1; b = 0; #10;
        a = 1; b = 1; #10;
        
        $finish;
    end
endmodule
```

# 動作結果

入力と出力が本物のNANDと一致しています。
```bash
test@test-fujitsu:~/kaihatsu/nandcpu$ iverilog -o nand.out nand.v tb_nand.v
test@test-fujitsu:~/kaihatsu/nandcpu$ vvp nand.out
VCD info: dumpfile nand.vcd opened for output.
A B | Y
0 0 | 1
0 1 | 1
1 0 | 1
1 1 | 0
```

波形を確認します。
```
test@test-fujitsu:~/kaihatsu/nandcpu$ gtkwave nand.vcd
```
<img width="898" height="410" alt="波形" src="https://github.com/user-attachments/assets/2d12d4c5-e3f5-4edc-84f0-77534fbddb5c" />

