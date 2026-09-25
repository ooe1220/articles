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

今後CPUを設計する際はこのNANDを最小単位として、構成していきます。
NANDがトランジスタをどう組み合わせて実現しているかはここでは触れません。

# 動きを見てみる

SimulIDEというソフトでNAND回路にLEDを繋ぎ視覚的に観察します。※電気が流れていることを視覚的に見る為にLEDを接続しただけで通常は繋ぎません。
1の場合は電圧がかかりLEDが光り、0の時は消えます。
※入力にしか電源を繋いでおらず、両方0の時は電源が無いので実際の回路では光らない気もしますが、筆者は電子工作が得意でないので、ちょっと分かりません。NANDの説明にはこれで事足りるので深入りしません。

[SimulIDEを導入](https://qiita.com/earthen94/items/37a4a18d94f4e4571754)

起動コマンド
```bash
/opt/simulide-110sr0/simulide nand.sim1
```

<details>
<summary>nand.sim1</summary>

```nand.sim1
<circuit version="1.1.0-SR0" rev="1917" stepSize="1000000" stepsPS="1000000" NLsteps="100000" reaStep="1000000" animate="0" >

<item itemtype="Led" CircId="Led-6" mainComp="false" Show_id="false" Show_Val="false" Pos="-364,-188" rotation="0" hflip="1" vflip="1" label="Led-6" idLabPos="-16,-24" labelrot="0" valLabPos="-16,20" valLabRot="0" Color="Yellow" Grounded="false" Threshold="2.4 V" MaxCurrent="30 mA" Resistance="0.6 Ω" />

<item itemtype="Led" CircId="Led-7" mainComp="false" Show_id="false" Show_Val="false" Pos="-372,-104" rotation="0" hflip="1" vflip="1" label="Led-7" idLabPos="-16,-24" labelrot="0" valLabPos="-16,20" valLabRot="0" Color="Yellow" Grounded="false" Threshold="2.4 V" MaxCurrent="30 mA" Resistance="0.6 Ω" />

<item itemtype="Led" CircId="Led-8" mainComp="false" Show_id="false" Show_Val="false" Pos="-256,-140" rotation="0" hflip="1" vflip="1" label="Led-8" idLabPos="-16,-24" labelrot="0" valLabPos="-16,20" valLabRot="0" Color="Yellow" Grounded="false" Threshold="2.4 V" MaxCurrent="30 mA" Resistance="0.6 Ω" />

<item itemtype="And Gate" CircId="And Gate-9" mainComp="false" Show_id="false" Show_Val="false" Pos="-348,-140" rotation="0" hflip="1" vflip="1" label="And Gate-9" idLabPos="-16,-24" labelrot="0" valLabPos="-16,20" valLabRot="0" Input_High_V="2.5 V" Input_Low_V="2.5 V" Input_Imped="1000 MΩ" Num_Inputs="2" Invert_Inputs="false" Out_High_V="5 V" Out_Low_V="0 V" Out_Imped="40 Ω" initHigh="false" Inverted="true" Open_Collector="false" Tpd_ps="10 ns" Tr_ps="3 ns" Tf_ps="4 ns" />

<item itemtype="Fixed Voltage" CircId="Fixed Voltage-10" mainComp="false" Show_id="false" Show_Val="false" Pos="-460,-152" rotation="0" hflip="1" vflip="1" label="Fixed Voltage-10" idLabPos="-64,-24" labelrot="0" valLabPos="-16,8" valLabRot="0" Voltage="5 V" Out="false" />

<item itemtype="Fixed Voltage" CircId="Fixed Voltage-11" mainComp="false" Show_id="false" Show_Val="false" Pos="-460,-124" rotation="0" hflip="1" vflip="1" label="Fixed Voltage-11" idLabPos="-64,-24" labelrot="0" valLabPos="-16,8" valLabRot="0" Voltage="5 V" Out="false" />

<item itemtype="Resistor" CircId="Resistor-12" mainComp="false" ShowProp="Resistance" Show_id="false" Show_Val="true" Pos="-412,-188" rotation="0" hflip="1" vflip="1" label="Resistor-12" idLabPos="-16,-24" labelrot="0" valLabPos="-16,6" valLabRot="0" Resistance="70 Ω" />

<item itemtype="Resistor" CircId="Resistor-13" mainComp="false" ShowProp="Resistance" Show_id="false" Show_Val="true" Pos="-416,-104" rotation="0" hflip="1" vflip="1" label="Resistor-13" idLabPos="-16,-24" labelrot="0" valLabPos="-16,6" valLabRot="0" Resistance="70 Ω" />

<item itemtype="Ground" CircId="Ground-16" mainComp="false" Show_id="false" Show_Val="false" Pos="-348,-164" rotation="0" hflip="1" vflip="1" label="Ground-16" idLabPos="-16,8" labelrot="0" valLabPos="-16,20" valLabRot="0" />

<item itemtype="Ground" CircId="Ground-29" mainComp="false" Show_id="false" Show_Val="false" Pos="-348,-84" rotation="0" hflip="1" vflip="1" label="Ground-29" idLabPos="-16,8" labelrot="0" valLabPos="-16,20" valLabRot="0" />

<item itemtype="Resistor" CircId="Resistor-32" mainComp="false" ShowProp="Resistance" Show_id="false" Show_Val="true" Pos="-300,-140" rotation="0" hflip="1" vflip="1" label="Resistor-32" idLabPos="-16,-24" labelrot="0" valLabPos="-16,6" valLabRot="0" Resistance="50 Ω" />

<item itemtype="Ground" CircId="Ground-33" mainComp="false" Show_id="false" Show_Val="false" Pos="-220,-104" rotation="0" hflip="1" vflip="1" label="Ground-33" idLabPos="-16,8" labelrot="0" valLabPos="-16,20" valLabRot="0" />

<item itemtype="Node" CircId="Node-43" mainComp="false" Pos="-432,-152" />

<item itemtype="Node" CircId="Node-65" mainComp="false" Pos="-432,-124" />

<item itemtype="Connector" uid="Connector-15" startpinid="Resistor-12-rPin" endpinid="Led-6-lPin" pointList="-396,-188,-380,-188" />

<item itemtype="Connector" uid="Connector-62" startpinid="Led-6-rPin" endpinid="Ground-16-Gnd" pointList="-348,-188,-348,-180" />

<item itemtype="Connector" uid="Connector-63" startpinid="Led-7-rPin" endpinid="Ground-29-Gnd" pointList="-356,-104,-348,-104,-348,-100" />

<item itemtype="Connector" uid="Connector-64" startpinid="Resistor-13-rPin" endpinid="Led-7-lPin" pointList="-400,-104,-388,-104" />

<item itemtype="Connector" uid="Connector-71" startpinid="And Gate-9-out" endpinid="Resistor-32-lPin" pointList="-332,-140,-316,-140" />

<item itemtype="Connector" uid="Connector-72" startpinid="Resistor-32-rPin" endpinid="Led-8-lPin" pointList="-284,-140,-272,-140" />

<item itemtype="Connector" uid="Connector-73" startpinid="Led-8-rPin" endpinid="Ground-33-Gnd" pointList="-240,-140,-220,-140,-220,-120" />

<item itemtype="Connector" uid="Connector-118" startpinid="Resistor-12-lPin" endpinid="Node-43-1" pointList="-428,-188,-428,-152,-432,-152" />

<item itemtype="Connector" uid="Connector-119" startpinid="Fixed Voltage-10-outnod" endpinid="Node-43-0" pointList="-444,-152,-432,-152" />

<item itemtype="Connector" uid="Connector-120" startpinid="Node-43-2" endpinid="And Gate-9-in0" pointList="-432,-152,-364,-152,-364,-144" />

<item itemtype="Connector" uid="Connector-154" startpinid="Resistor-13-lPin" endpinid="Node-65-1" pointList="-432,-104,-432,-124" />

<item itemtype="Connector" uid="Connector-155" startpinid="Fixed Voltage-11-outnod" endpinid="Node-65-0" pointList="-444,-124,-432,-124" />

<item itemtype="Connector" uid="Connector-156" startpinid="Node-65-2" endpinid="And Gate-9-in1" pointList="-432,-124,-364,-124,-364,-136" />

</circuit>
```

</details>

a=0 b=0の時、出力が1となり光る
<img width="1423" height="596" alt="00" src="https://github.com/user-attachments/assets/df9ea7f3-99e6-4c07-964f-a58fe8fa4177" />

a=0 b=1の時、出力が1となり光る
<img width="1423" height="596" alt="01" src="https://github.com/user-attachments/assets/1a308857-cb77-4117-a3a4-d758a04105b6" />

a=1 b=0の時、出力が1となり光る
<img width="1423" height="596" alt="10" src="https://github.com/user-attachments/assets/75e10e3d-7457-4f24-984f-e99936b8f870" />

a=1 b=1の時、出力が0となり消える
<img width="1423" height="596" alt="11" src="https://github.com/user-attachments/assets/0c1f8f56-74cb-459a-9f50-5d22521c8bda" />


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

入力と出力が真理値表と一致しています
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

