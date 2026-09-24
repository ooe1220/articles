# 目的

simulide上でZ80を他の機器と接続して組み込み的に使いたいと思っています。
GUIで配線をすると線が重なり、どのピンに繋がっているか分からなくなります。
回路はXML形式で保存されるので、配線の法則を見つけ出してXMLで配線できないかを調査します。

[simulideを導入](https://qiita.com/earthen94/items/37a4a18d94f4e4571754)

# 配線

# 1本
z80 A0 → RAM A0
<img width="1281" height="755" alt="截图 2026-09-23 22-36-10" src="https://github.com/user-attachments/assets/fc9a5da6-d8c5-461b-87bf-dd43bdf179c1" />


```xml
<circuit version="1.1.0-SR0" rev="1917" stepSize="1000000" stepsPS="1000000" NLsteps="100000" reaStep="1000000" animate="0" >

<item itemtype="Memory" CircId="Memory-1" mainComp="false" Show_id="false" Show_Val="false" Pos="-132,-168" rotation="0" hflip="1" vflip="1" label="Memory-1" idLabPos="-16,-24" labelrot="0" valLabPos="-16,20" valLabRot="0" Address_Bits="8 _bits" Data_Bits="8 _bits" Persistent="true" Asynch="true" Input_High_V="2.5 V" Input_Low_V="2.5 V" Input_Imped="1000 MΩ" Out_High_V="5 V" Out_Low_V="0 V" Out_Imped="40 Ω" Inverted="false" Open_Collector="false" pd_n="1 _Gates" Tpd_ps="10 ns" Tr_ps="3 ns" Tf_ps="4 ns" />

<item itemtype="MCU" CircId="Z80-2" mainComp="false" Show_id="true" Show_Val="false" Pos="-252,-208" rotation="0" hflip="1" vflip="1" label="Z80-2" idLabPos="0,-20" labelrot="0" valLabPos="-16,20" valLabRot="0" Logic_Symbol="false" Producer="Zilog" CMOS="false" Single cycle I/O="false" Int_Vector="false" />

<item itemtype="Connector" uid="Connector-24" startpinid="Memory-1-in0" endpinid="Z80-2-PORTA0" pointList="-156,-200,-196,-200,-196,-120" />

</circuit>
```

`Memory-1` : メモリ
`Z80-2` : Z80CPU
`Connector-24` : 配線

配線の要素を見ると`startpinid="Memory-1-in0" endpinid="Z80-2-PORTA0"`と書いてあります。
これが始点と終点でしょう。

# 2本

z80 A0 → RAM A0
z80 A1 → RAM A1
<img width="1281" height="755" alt="截图 2026-09-23 22-48-52" src="https://github.com/user-attachments/assets/875817f4-5218-484a-a988-36d15ead5a63" />

```xml
<circuit version="1.1.0-SR0" rev="1917" stepSize="1000000" stepsPS="1000000" NLsteps="100000" reaStep="1000000" animate="0" >

<item itemtype="Memory" CircId="Memory-1" mainComp="false" Show_id="false" Show_Val="false" Pos="-132,-168" rotation="0" hflip="1" vflip="1" label="Memory-1" idLabPos="-16,-24" labelrot="0" valLabPos="-16,20" valLabRot="0" Address_Bits="8 _bits" Data_Bits="8 _bits" Persistent="true" Asynch="true" Input_High_V="2.5 V" Input_Low_V="2.5 V" Input_Imped="1000 MΩ" Out_High_V="5 V" Out_Low_V="0 V" Out_Imped="40 Ω" Inverted="false" Open_Collector="false" pd_n="1 _Gates" Tpd_ps="10 ns" Tr_ps="3 ns" Tf_ps="4 ns" />

<item itemtype="MCU" CircId="Z80-2" mainComp="false" Show_id="true" Show_Val="false" Pos="-252,-208" rotation="0" hflip="1" vflip="1" label="Z80-2" idLabPos="0,-20" labelrot="0" valLabPos="-16,20" valLabRot="0" Logic_Symbol="false" Producer="Zilog" CMOS="false" Single cycle I/O="false" Int_Vector="false" />

<item itemtype="Node" CircId="Node-3" mainComp="false" Pos="-196,-128" />

<item itemtype="Connector" uid="Connector-25" startpinid="Memory-1-in1" endpinid="Node-3-1" pointList="-156,-192,-196,-192,-196,-128" />

<item itemtype="Connector" uid="Connector-26" startpinid="Memory-1-in0" endpinid="Node-3-0" pointList="-156,-200,-196,-200,-196,-128" />

<item itemtype="Connector" uid="Connector-27" startpinid="Node-3-2" endpinid="Z80-2-PORTA0" pointList="-196,-128,-196,-120" />

</circuit>
```
ピン同士を繋ぎたいのに分岐になってしまっているようです。
GUIで配線すると、どうしてもくっついてしまいます。
そこで直接ピン同士を繋ぐようにXMLを変更してみます。

# XMLを直接編集

以下のようにA1からA4を直結するように手動で編集しました。
```xml
<circuit version="1.1.0-SR0" rev="1917" stepSize="1000000" stepsPS="1000000" NLsteps="100000" reaStep="1000000" animate="0" >

<item itemtype="Memory" CircId="Memory-1" mainComp="false" Show_id="false" Show_Val="false" Pos="-132,-168" rotation="0" hflip="1" vflip="1" label="Memory-1" idLabPos="-16,-24" labelrot="0" valLabPos="-16,20" valLabRot="0" Address_Bits="8 _bits" Data_Bits="8 _bits" Persistent="true" Asynch="true" Input_High_V="2.5 V" Input_Low_V="2.5 V" Input_Imped="1000 MΩ" Out_High_V="5 V" Out_Low_V="0 V" Out_Imped="40 Ω" Inverted="false" Open_Collector="false" pd_n="1 _Gates" Tpd_ps="10 ns" Tr_ps="3 ns" Tf_ps="4 ns" />

<item itemtype="MCU" CircId="Z80-2" mainComp="false" Show_id="true" Show_Val="false" Pos="-252,-208" rotation="0" hflip="1" vflip="1" label="Z80-2" idLabPos="0,-20" labelrot="0" valLabPos="-16,20" valLabRot="0" Logic_Symbol="false" Producer="Zilog" CMOS="false" Single cycle I/O="false" Int_Vector="false" />

<item itemtype="Connector" uid="Connector-24" startpinid="Memory-1-in0" endpinid="Z80-2-PORTA0" pointList="-156,-200,-196,-200,-196,-120" />

<item itemtype="Connector" uid="Connector-25" startpinid="Memory-1-in1" endpinid="Z80-2-PORTA1" pointList="-156,-200,-196,-200,-196,-120" />

<item itemtype="Connector" uid="Connector-26" startpinid="Memory-1-in2" endpinid="Z80-2-PORTA2" pointList="-156,-200,-196,-200,-196,-120" />

<item itemtype="Connector" uid="Connector-27" startpinid="Memory-1-in3" endpinid="Z80-2-PORTA3" pointList="-156,-200,-196,-200,-196,-120" />

<item itemtype="Connector" uid="Connector-28" startpinid="Memory-1-in4" endpinid="Z80-2-PORTA4" pointList="-156,-200,-196,-200,-196,-120" />

</circuit>
```

編集後に開いた回路は、XMLに応じて配線されています。
<img width="1281" height="755" alt="截图 2026-09-23 22-59-09" src="https://github.com/user-attachments/assets/ab360350-9b16-44b6-b74e-3c20963a5b6f" />

# 最後に

座標の規則は分かりませんが、始点と終点のピンを指定してXMLを編集すると配線できることが分かりました。
この方法で配線した回路が意図したように動作するかは次回確かめます。

# 20260924 追記

 折れ曲がる座標と思われる`pointList`を0へ変更しても動作に影響はありませんでした。

`led1.sim`: 保存したまま
`led2.sim`: `pointList`を全て0に変更

<img width="1281" height="755" alt="led1" src="https://github.com/user-attachments/assets/ad37616d-27cb-485c-be63-60cd54167a6f" />

```led1.sim
<circuit version="1.1.0-SR0" rev="1917" stepSize="1000000" stepsPS="1000000" NLsteps="100000" reaStep="1000000" animate="0" >

<item itemtype="Fixed Voltage" CircId="Fixed Voltage-1" mainComp="false" Show_id="false" Show_Val="false" Pos="-200,-52" rotation="0" hflip="1" vflip="1" label="Fixed Voltage-1" idLabPos="-64,-24" labelrot="0" valLabPos="-16,8" valLabRot="0" Voltage="5 V" Out="true" />

<item itemtype="Resistor" CircId="Resistor-2" mainComp="false" ShowProp="Resistance" Show_id="false" Show_Val="true" Pos="-148,-52" rotation="0" hflip="1" vflip="1" label="Resistor-2" idLabPos="-16,-24" labelrot="0" valLabPos="-16,6" valLabRot="0" Resistance="100 Ω" />

<item itemtype="Led" CircId="Led-3" mainComp="false" Show_id="false" Show_Val="false" Pos="-96,-52" rotation="0" hflip="1" vflip="1" label="Led-3" idLabPos="-16,-24" labelrot="0" valLabPos="-16,20" valLabRot="0" Color="Yellow" Grounded="false" Threshold="2.4 V" MaxCurrent="30 mA" Resistance="0.6 Ω" />

<item itemtype="Ground" CircId="Ground-4" mainComp="false" Show_id="false" Show_Val="false" Pos="-64,-16" rotation="0" hflip="1" vflip="1" label="Ground-4" idLabPos="-16,8" labelrot="0" valLabPos="-16,20" valLabRot="0" />

<item itemtype="Connector" uid="Connector-1" startpinid="Fixed Voltage-1-outnod" endpinid="Resistor-2-lPin" pointList="-184,-52,-164,-52" />

<item itemtype="Connector" uid="Connector-2" startpinid="Resistor-2-rPin" endpinid="Led-3-lPin" pointList="-132,-52,-112,-52" />

<item itemtype="Connector" uid="Connector-3" startpinid="Led-3-rPin" endpinid="Ground-4-Gnd" pointList="-80,-52,-64,-52,-64,-32" />

</circuit>
```


<img width="1281" height="755" alt="led2" src="https://github.com/user-attachments/assets/80c676a1-8d58-49eb-93ce-db0baa610e6b" />

```led2.sim
<circuit version="1.1.0-SR0" rev="1917" stepSize="1000000" stepsPS="1000000" NLsteps="100000" reaStep="1000000" animate="0" >

<item itemtype="Fixed Voltage" CircId="Fixed Voltage-1" mainComp="false" Show_id="false" Show_Val="false" Pos="-200,-52" rotation="0" hflip="1" vflip="1" label="Fixed Voltage-1" idLabPos="-64,-24" labelrot="0" valLabPos="-16,8" valLabRot="0" Voltage="5 V" Out="true" />

<item itemtype="Resistor" CircId="Resistor-2" mainComp="false" ShowProp="Resistance" Show_id="false" Show_Val="true" Pos="-148,-52" rotation="0" hflip="1" vflip="1" label="Resistor-2" idLabPos="-16,-24" labelrot="0" valLabPos="-16,6" valLabRot="0" Resistance="100 Ω" />

<item itemtype="Led" CircId="Led-3" mainComp="false" Show_id="false" Show_Val="false" Pos="-96,-52" rotation="0" hflip="1" vflip="1" label="Led-3" idLabPos="-16,-24" labelrot="0" valLabPos="-16,20" valLabRot="0" Color="Yellow" Grounded="false" Threshold="2.4 V" MaxCurrent="30 mA" Resistance="0.6 Ω" />

<item itemtype="Ground" CircId="Ground-4" mainComp="false" Show_id="false" Show_Val="false" Pos="-64,-16" rotation="0" hflip="1" vflip="1" label="Ground-4" idLabPos="-16,8" labelrot="0" valLabPos="-16,20" valLabRot="0" />

<item itemtype="Connector" uid="Connector-1" startpinid="Fixed Voltage-1-outnod" endpinid="Resistor-2-lPin" pointList="0,0,0,0" />

<item itemtype="Connector" uid="Connector-2" startpinid="Resistor-2-rPin" endpinid="Led-3-lPin" pointList="0,0,0,0" />

<item itemtype="Connector" uid="Connector-3" startpinid="Led-3-rPin" endpinid="Ground-4-Gnd" pointList="0,0,0,0,0,0" />

</circuit>
```

