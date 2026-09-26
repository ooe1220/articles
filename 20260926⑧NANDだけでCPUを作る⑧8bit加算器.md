
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
<circuit version="1.1.0-SR0" rev="1917" stepSize="1000000" stepsPS="1000000" NLsteps="100000" reaStep="1000000" animate="0" >

<item itemtype="FullAdder" CircId="FullAdder-1" mainComp="false" Show_id="false" Show_Val="false" Pos="-448,-252" rotation="0" hflip="1" vflip="1" label="FullAdder-1" idLabPos="-16,-24" labelrot="0" valLabPos="-16,20" valLabRot="0" Input_High_V="2.5 V" Input_Low_V="2.5 V" Input_Imped="1000 MΩ" Out_High_V="5 V" Out_Low_V="0 V" Out_Imped="40 Ω" pd_n="1 _Gates" Tpd_ps="10 ns" Tr_ps="3 ns" Tf_ps="4 ns" />

<item itemtype="Fixed Voltage" CircId="Fixed Voltage-2" mainComp="false" Show_id="false" Show_Val="false" Pos="-492,-260" rotation="0" hflip="1" vflip="1" label="Fixed Voltage-2" idLabPos="-64,-24" labelrot="0" valLabPos="-16,8" valLabRot="0" Voltage="5 V" Out="false" />

<item itemtype="Fixed Voltage" CircId="Fixed Voltage-3" mainComp="false" Show_id="false" Show_Val="false" Pos="-492,-244" rotation="0" hflip="1" vflip="1" label="Fixed Voltage-3" idLabPos="-64,-24" labelrot="0" valLabPos="-16,8" valLabRot="0" Voltage="5 V" Out="false" />

<item itemtype="Resistor" CircId="Resistor-4" mainComp="false" ShowProp="Resistance" Show_id="false" Show_Val="true" Pos="-384,-252" rotation="0" hflip="1" vflip="1" label="Resistor-4" idLabPos="-16,-24" labelrot="0" valLabPos="-16,6" valLabRot="0" Resistance="100 Ω" />

<item itemtype="Led" CircId="Led-5" mainComp="false" Show_id="false" Show_Val="false" Pos="-340,-252" rotation="0" hflip="1" vflip="1" label="Led-5" idLabPos="-16,-24" labelrot="0" valLabPos="-16,20" valLabRot="0" Color="Yellow" Grounded="false" Threshold="2.4 V" MaxCurrent="30 mA" Resistance="0.6 Ω" />

<item itemtype="Ground" CircId="Ground-6" mainComp="false" Show_id="false" Show_Val="false" Pos="-312,-232" rotation="0" hflip="1" vflip="1" label="Ground-6" idLabPos="-16,8" labelrot="0" valLabPos="-16,20" valLabRot="0" />

<item itemtype="Ground" CircId="Ground-7" mainComp="false" Show_id="false" Show_Val="false" Pos="-408,-264" rotation="0" hflip="1" vflip="1" label="Ground-7" idLabPos="-16,8" labelrot="0" valLabPos="-16,20" valLabRot="0" />

<item itemtype="FullAdder" CircId="FullAdder-9" mainComp="false" Show_id="false" Show_Val="false" Pos="-448,-216" rotation="0" hflip="1" vflip="1" label="FullAdder-9" idLabPos="-16,-24" labelrot="0" valLabPos="-16,20" valLabRot="0" Input_High_V="2.5 V" Input_Low_V="2.5 V" Input_Imped="1000 MΩ" Out_High_V="5 V" Out_Low_V="0 V" Out_Imped="40 Ω" pd_n="1 _Gates" Tpd_ps="10 ns" Tr_ps="3 ns" Tf_ps="4 ns" />

<item itemtype="Fixed Voltage" CircId="Fixed Voltage-10" mainComp="false" Show_id="false" Show_Val="false" Pos="-492,-224" rotation="0" hflip="1" vflip="1" label="Fixed Voltage-10" idLabPos="-64,-24" labelrot="0" valLabPos="-16,8" valLabRot="0" Voltage="5 V" Out="true" />

<item itemtype="Fixed Voltage" CircId="Fixed Voltage-11" mainComp="false" Show_id="false" Show_Val="false" Pos="-492,-208" rotation="0" hflip="1" vflip="1" label="Fixed Voltage-11" idLabPos="-64,-24" labelrot="0" valLabPos="-16,8" valLabRot="0" Voltage="5 V" Out="false" />

<item itemtype="Ground" CircId="Ground-12" mainComp="false" Show_id="false" Show_Val="false" Pos="-312,-196" rotation="0" hflip="1" vflip="1" label="Ground-12" idLabPos="-16,8" labelrot="0" valLabPos="-16,20" valLabRot="0" />

<item itemtype="Led" CircId="Led-13" mainComp="false" Show_id="false" Show_Val="false" Pos="-340,-216" rotation="0" hflip="1" vflip="1" label="Led-13" idLabPos="-16,-24" labelrot="0" valLabPos="-16,20" valLabRot="0" Color="Yellow" Grounded="false" Threshold="2.4 V" MaxCurrent="30 mA" Resistance="0.6 Ω" />

<item itemtype="Resistor" CircId="Resistor-14" mainComp="false" ShowProp="Resistance" Show_id="false" Show_Val="true" Pos="-384,-216" rotation="0" hflip="1" vflip="1" label="Resistor-14" idLabPos="-16,-24" labelrot="0" valLabPos="-16,6" valLabRot="0" Resistance="100 Ω" />

<item itemtype="Led" CircId="Led-15" mainComp="false" Show_id="false" Show_Val="false" Pos="-340,-180" rotation="0" hflip="1" vflip="1" label="Led-15" idLabPos="-16,-24" labelrot="0" valLabPos="-16,20" valLabRot="0" Color="Yellow" Grounded="false" Threshold="2.4 V" MaxCurrent="30 mA" Resistance="0.6 Ω" />

<item itemtype="Fixed Voltage" CircId="Fixed Voltage-16" mainComp="false" Show_id="false" Show_Val="false" Pos="-492,-188" rotation="0" hflip="1" vflip="1" label="Fixed Voltage-16" idLabPos="-64,-24" labelrot="0" valLabPos="-16,8" valLabRot="0" Voltage="5 V" Out="false" />

<item itemtype="FullAdder" CircId="FullAdder-17" mainComp="false" Show_id="false" Show_Val="false" Pos="-448,-180" rotation="0" hflip="1" vflip="1" label="FullAdder-17" idLabPos="-16,-24" labelrot="0" valLabPos="-16,20" valLabRot="0" Input_High_V="2.5 V" Input_Low_V="2.5 V" Input_Imped="1000 MΩ" Out_High_V="5 V" Out_Low_V="0 V" Out_Imped="40 Ω" pd_n="1 _Gates" Tpd_ps="10 ns" Tr_ps="3 ns" Tf_ps="4 ns" />

<item itemtype="Ground" CircId="Ground-18" mainComp="false" Show_id="false" Show_Val="false" Pos="-312,-160" rotation="0" hflip="1" vflip="1" label="Ground-18" idLabPos="-16,8" labelrot="0" valLabPos="-16,20" valLabRot="0" />

<item itemtype="Resistor" CircId="Resistor-19" mainComp="false" ShowProp="Resistance" Show_id="false" Show_Val="true" Pos="-384,-180" rotation="0" hflip="1" vflip="1" label="Resistor-19" idLabPos="-16,-24" labelrot="0" valLabPos="-16,6" valLabRot="0" Resistance="100 Ω" />

<item itemtype="Fixed Voltage" CircId="Fixed Voltage-20" mainComp="false" Show_id="false" Show_Val="false" Pos="-492,-172" rotation="0" hflip="1" vflip="1" label="Fixed Voltage-20" idLabPos="-64,-24" labelrot="0" valLabPos="-16,8" valLabRot="0" Voltage="5 V" Out="true" />

<item itemtype="Led" CircId="Led-21" mainComp="false" Show_id="false" Show_Val="false" Pos="-340,-144" rotation="0" hflip="1" vflip="1" label="Led-21" idLabPos="-16,-24" labelrot="0" valLabPos="-16,20" valLabRot="0" Color="Yellow" Grounded="false" Threshold="2.4 V" MaxCurrent="30 mA" Resistance="0.6 Ω" />

<item itemtype="Fixed Voltage" CircId="Fixed Voltage-22" mainComp="false" Show_id="false" Show_Val="false" Pos="-492,-152" rotation="0" hflip="1" vflip="1" label="Fixed Voltage-22" idLabPos="-64,-24" labelrot="0" valLabPos="-16,8" valLabRot="0" Voltage="5 V" Out="false" />

<item itemtype="FullAdder" CircId="FullAdder-23" mainComp="false" Show_id="false" Show_Val="false" Pos="-448,-144" rotation="0" hflip="1" vflip="1" label="FullAdder-23" idLabPos="-16,-24" labelrot="0" valLabPos="-16,20" valLabRot="0" Input_High_V="2.5 V" Input_Low_V="2.5 V" Input_Imped="1000 MΩ" Out_High_V="5 V" Out_Low_V="0 V" Out_Imped="40 Ω" pd_n="1 _Gates" Tpd_ps="10 ns" Tr_ps="3 ns" Tf_ps="4 ns" />

<item itemtype="Ground" CircId="Ground-24" mainComp="false" Show_id="false" Show_Val="false" Pos="-312,-124" rotation="0" hflip="1" vflip="1" label="Ground-24" idLabPos="-16,8" labelrot="0" valLabPos="-16,20" valLabRot="0" />

<item itemtype="Resistor" CircId="Resistor-25" mainComp="false" ShowProp="Resistance" Show_id="false" Show_Val="true" Pos="-384,-144" rotation="0" hflip="1" vflip="1" label="Resistor-25" idLabPos="-16,-24" labelrot="0" valLabPos="-16,6" valLabRot="0" Resistance="100 Ω" />

<item itemtype="Fixed Voltage" CircId="Fixed Voltage-26" mainComp="false" Show_id="false" Show_Val="false" Pos="-492,-136" rotation="0" hflip="1" vflip="1" label="Fixed Voltage-26" idLabPos="-64,-24" labelrot="0" valLabPos="-16,8" valLabRot="0" Voltage="5 V" Out="true" />

<item itemtype="Fixed Voltage" CircId="Fixed Voltage-27" mainComp="false" Show_id="false" Show_Val="false" Pos="-492,-8" rotation="0" hflip="1" vflip="1" label="Fixed Voltage-27" idLabPos="-64,-24" labelrot="0" valLabPos="-16,8" valLabRot="0" Voltage="5 V" Out="false" />

<item itemtype="Ground" CircId="Ground-28" mainComp="false" Show_id="false" Show_Val="false" Pos="-312,-52" rotation="0" hflip="1" vflip="1" label="Ground-28" idLabPos="-16,8" labelrot="0" valLabPos="-16,20" valLabRot="0" />

<item itemtype="Fixed Voltage" CircId="Fixed Voltage-29" mainComp="false" Show_id="false" Show_Val="false" Pos="-492,-100" rotation="0" hflip="1" vflip="1" label="Fixed Voltage-29" idLabPos="-64,-24" labelrot="0" valLabPos="-16,8" valLabRot="0" Voltage="5 V" Out="true" />

<item itemtype="Ground" CircId="Ground-30" mainComp="false" Show_id="false" Show_Val="false" Pos="-312,-16" rotation="0" hflip="1" vflip="1" label="Ground-30" idLabPos="-16,8" labelrot="0" valLabPos="-16,20" valLabRot="0" />

<item itemtype="Resistor" CircId="Resistor-31" mainComp="false" ShowProp="Resistance" Show_id="false" Show_Val="true" Pos="-384,0" rotation="0" hflip="1" vflip="1" label="Resistor-31" idLabPos="-16,-24" labelrot="0" valLabPos="-16,6" valLabRot="0" Resistance="100 Ω" />

<item itemtype="Led" CircId="Led-32" mainComp="false" Show_id="false" Show_Val="false" Pos="-340,-72" rotation="0" hflip="1" vflip="1" label="Led-32" idLabPos="-16,-24" labelrot="0" valLabPos="-16,20" valLabRot="0" Color="Yellow" Grounded="false" Threshold="2.4 V" MaxCurrent="30 mA" Resistance="0.6 Ω" />

<item itemtype="Fixed Voltage" CircId="Fixed Voltage-33" mainComp="false" Show_id="false" Show_Val="false" Pos="-492,-28" rotation="0" hflip="1" vflip="1" label="Fixed Voltage-33" idLabPos="-64,-24" labelrot="0" valLabPos="-16,8" valLabRot="0" Voltage="5 V" Out="false" />

<item itemtype="Fixed Voltage" CircId="Fixed Voltage-34" mainComp="false" Show_id="false" Show_Val="false" Pos="-492,8" rotation="0" hflip="1" vflip="1" label="Fixed Voltage-34" idLabPos="-64,-24" labelrot="0" valLabPos="-16,8" valLabRot="0" Voltage="5 V" Out="false" />

<item itemtype="Fixed Voltage" CircId="Fixed Voltage-35" mainComp="false" Show_id="false" Show_Val="false" Pos="-492,-44" rotation="0" hflip="1" vflip="1" label="Fixed Voltage-35" idLabPos="-64,-24" labelrot="0" valLabPos="-16,8" valLabRot="0" Voltage="5 V" Out="false" />

<item itemtype="Led" CircId="Led-36" mainComp="false" Show_id="false" Show_Val="false" Pos="-340,-108" rotation="0" hflip="1" vflip="1" label="Led-36" idLabPos="-16,-24" labelrot="0" valLabPos="-16,20" valLabRot="0" Color="Yellow" Grounded="false" Threshold="2.4 V" MaxCurrent="30 mA" Resistance="0.6 Ω" />

<item itemtype="Fixed Voltage" CircId="Fixed Voltage-38" mainComp="false" Show_id="false" Show_Val="false" Pos="-492,-64" rotation="0" hflip="1" vflip="1" label="Fixed Voltage-38" idLabPos="-64,-24" labelrot="0" valLabPos="-16,8" valLabRot="0" Voltage="5 V" Out="true" />

<item itemtype="Ground" CircId="Ground-39" mainComp="false" Show_id="false" Show_Val="false" Pos="-312,-88" rotation="0" hflip="1" vflip="1" label="Ground-39" idLabPos="-16,8" labelrot="0" valLabPos="-16,20" valLabRot="0" />

<item itemtype="Led" CircId="Led-40" mainComp="false" Show_id="false" Show_Val="false" Pos="-340,-36" rotation="0" hflip="1" vflip="1" label="Led-40" idLabPos="-16,-24" labelrot="0" valLabPos="-16,20" valLabRot="0" Color="Yellow" Grounded="false" Threshold="2.4 V" MaxCurrent="30 mA" Resistance="0.6 Ω" />

<item itemtype="Resistor" CircId="Resistor-41" mainComp="false" ShowProp="Resistance" Show_id="false" Show_Val="true" Pos="-384,-108" rotation="0" hflip="1" vflip="1" label="Resistor-41" idLabPos="-16,-24" labelrot="0" valLabPos="-16,6" valLabRot="0" Resistance="100 Ω" />

<item itemtype="Fixed Voltage" CircId="Fixed Voltage-42" mainComp="false" Show_id="false" Show_Val="false" Pos="-492,-80" rotation="0" hflip="1" vflip="1" label="Fixed Voltage-42" idLabPos="-64,-24" labelrot="0" valLabPos="-16,8" valLabRot="0" Voltage="5 V" Out="true" />

<item itemtype="FullAdder" CircId="FullAdder-43" mainComp="false" Show_id="false" Show_Val="false" Pos="-448,0" rotation="0" hflip="1" vflip="1" label="FullAdder-43" idLabPos="-16,-24" labelrot="0" valLabPos="-16,20" valLabRot="0" Input_High_V="2.5 V" Input_Low_V="2.5 V" Input_Imped="1000 MΩ" Out_High_V="5 V" Out_Low_V="0 V" Out_Imped="40 Ω" pd_n="1 _Gates" Tpd_ps="10 ns" Tr_ps="3 ns" Tf_ps="4 ns" />

<item itemtype="Led" CircId="Led-44" mainComp="false" Show_id="false" Show_Val="false" Pos="-340,0" rotation="0" hflip="1" vflip="1" label="Led-44" idLabPos="-16,-24" labelrot="0" valLabPos="-16,20" valLabRot="0" Color="Yellow" Grounded="false" Threshold="2.4 V" MaxCurrent="30 mA" Resistance="0.6 Ω" />

<item itemtype="FullAdder" CircId="FullAdder-45" mainComp="false" Show_id="false" Show_Val="false" Pos="-448,-36" rotation="0" hflip="1" vflip="1" label="FullAdder-45" idLabPos="-16,-24" labelrot="0" valLabPos="-16,20" valLabRot="0" Input_High_V="2.5 V" Input_Low_V="2.5 V" Input_Imped="1000 MΩ" Out_High_V="5 V" Out_Low_V="0 V" Out_Imped="40 Ω" pd_n="1 _Gates" Tpd_ps="10 ns" Tr_ps="3 ns" Tf_ps="4 ns" />

<item itemtype="Resistor" CircId="Resistor-46" mainComp="false" ShowProp="Resistance" Show_id="false" Show_Val="true" Pos="-384,-72" rotation="0" hflip="1" vflip="1" label="Resistor-46" idLabPos="-16,-24" labelrot="0" valLabPos="-16,6" valLabRot="0" Resistance="100 Ω" />

<item itemtype="Fixed Voltage" CircId="Fixed Voltage-47" mainComp="false" Show_id="false" Show_Val="false" Pos="-492,-116" rotation="0" hflip="1" vflip="1" label="Fixed Voltage-47" idLabPos="-64,-24" labelrot="0" valLabPos="-16,8" valLabRot="0" Voltage="5 V" Out="true" />

<item itemtype="FullAdder" CircId="FullAdder-48" mainComp="false" Show_id="false" Show_Val="false" Pos="-448,-108" rotation="0" hflip="1" vflip="1" label="FullAdder-48" idLabPos="-16,-24" labelrot="0" valLabPos="-16,20" valLabRot="0" Input_High_V="2.5 V" Input_Low_V="2.5 V" Input_Imped="1000 MΩ" Out_High_V="5 V" Out_Low_V="0 V" Out_Imped="40 Ω" pd_n="1 _Gates" Tpd_ps="10 ns" Tr_ps="3 ns" Tf_ps="4 ns" />

<item itemtype="Ground" CircId="Ground-49" mainComp="false" Show_id="false" Show_Val="false" Pos="-312,20" rotation="0" hflip="1" vflip="1" label="Ground-49" idLabPos="-16,8" labelrot="0" valLabPos="-16,20" valLabRot="0" />

<item itemtype="Resistor" CircId="Resistor-50" mainComp="false" ShowProp="Resistance" Show_id="false" Show_Val="true" Pos="-384,-36" rotation="0" hflip="1" vflip="1" label="Resistor-50" idLabPos="-16,-24" labelrot="0" valLabPos="-16,6" valLabRot="0" Resistance="100 Ω" />

<item itemtype="FullAdder" CircId="FullAdder-51" mainComp="false" Show_id="false" Show_Val="false" Pos="-448,-72" rotation="0" hflip="1" vflip="1" label="FullAdder-51" idLabPos="-16,-24" labelrot="0" valLabPos="-16,20" valLabRot="0" Input_High_V="2.5 V" Input_Low_V="2.5 V" Input_Imped="1000 MΩ" Out_High_V="5 V" Out_Low_V="0 V" Out_Imped="40 Ω" pd_n="1 _Gates" Tpd_ps="10 ns" Tr_ps="3 ns" Tf_ps="4 ns" />

<item itemtype="Resistor" CircId="Resistor-55" mainComp="false" ShowProp="Resistance" Show_id="false" Show_Val="true" Pos="-384,32" rotation="0" hflip="1" vflip="1" label="Resistor-55" idLabPos="-16,-24" labelrot="0" valLabPos="-16,6" valLabRot="0" Resistance="100 Ω" />

<item itemtype="Led" CircId="Led-56" mainComp="false" Show_id="false" Show_Val="false" Pos="-340,32" rotation="0" hflip="1" vflip="1" label="Led-56" idLabPos="-16,-24" labelrot="0" valLabPos="-16,20" valLabRot="0" Color="Yellow" Grounded="false" Threshold="2.4 V" MaxCurrent="30 mA" Resistance="0.6 Ω" />

<item itemtype="Ground" CircId="Ground-57" mainComp="false" Show_id="false" Show_Val="false" Pos="-312,52" rotation="0" hflip="1" vflip="1" label="Ground-57" idLabPos="-16,8" labelrot="0" valLabPos="-16,20" valLabRot="0" />

<item itemtype="Node" CircId="Node-52" mainComp="false" Pos="-424,-136" />

<item itemtype="Connector" uid="Connector-1" startpinid="Fixed Voltage-2-outnod" endpinid="FullAdder-1-in0" pointList="-476,-260,-464,-260" />

<item itemtype="Connector" uid="Connector-2" startpinid="Fixed Voltage-3-outnod" endpinid="FullAdder-1-in1" pointList="-476,-244,-464,-244" />

<item itemtype="Connector" uid="Connector-4" startpinid="FullAdder-1-out0" endpinid="Resistor-4-lPin" pointList="-424,-252,-400,-252" />

<item itemtype="Connector" uid="Connector-5" startpinid="Resistor-4-rPin" endpinid="Led-5-lPin" pointList="-368,-252,-356,-252" />

<item itemtype="Connector" uid="Connector-6" startpinid="Led-5-rPin" endpinid="Ground-6-Gnd" pointList="-324,-252,-312,-252,-312,-248" />

<item itemtype="Connector" uid="Connector-7" startpinid="FullAdder-1-in2" endpinid="Ground-7-Gnd" pointList="-424,-260,-424,-280,-408,-280" />

<item itemtype="Connector" uid="Connector-8" startpinid="Fixed Voltage-11-outnod" endpinid="FullAdder-9-in1" pointList="-476,-208,-464,-208" />

<item itemtype="Connector" uid="Connector-9" startpinid="Fixed Voltage-10-outnod" endpinid="FullAdder-9-in0" pointList="-476,-224,-464,-224" />

<item itemtype="Connector" uid="Connector-11" startpinid="FullAdder-1-out1" endpinid="FullAdder-9-in2" pointList="-424,-244,-424,-224" />

<item itemtype="Connector" uid="Connector-12" startpinid="Resistor-14-rPin" endpinid="Led-13-lPin" pointList="-368,-216,-356,-216" />

<item itemtype="Connector" uid="Connector-13" startpinid="FullAdder-9-out0" endpinid="Resistor-14-lPin" pointList="-424,-216,-400,-216" />

<item itemtype="Connector" uid="Connector-14" startpinid="Led-13-rPin" endpinid="Ground-12-Gnd" pointList="-324,-216,-312,-216,-312,-212" />

<item itemtype="Connector" uid="Connector-15" startpinid="Fixed Voltage-16-outnod" endpinid="FullAdder-17-in0" pointList="-476,-188,-464,-188" />

<item itemtype="Connector" uid="Connector-16" startpinid="Fixed Voltage-20-outnod" endpinid="FullAdder-17-in1" pointList="-476,-172,-464,-172" />

<item itemtype="Connector" uid="Connector-17" startpinid="FullAdder-17-out0" endpinid="Resistor-19-lPin" pointList="-424,-180,-400,-180" />

<item itemtype="Connector" uid="Connector-19" startpinid="Resistor-19-rPin" endpinid="Led-15-lPin" pointList="-368,-180,-356,-180" />

<item itemtype="Connector" uid="Connector-20" startpinid="Led-15-rPin" endpinid="Ground-18-Gnd" pointList="-324,-180,-312,-180,-312,-176" />

<item itemtype="Connector" uid="Connector-21" startpinid="Fixed Voltage-22-outnod" endpinid="FullAdder-23-in0" pointList="-476,-152,-464,-152" />

<item itemtype="Connector" uid="Connector-22" startpinid="Fixed Voltage-26-outnod" endpinid="FullAdder-23-in1" pointList="-476,-136,-464,-136" />

<item itemtype="Connector" uid="Connector-23" startpinid="FullAdder-23-out0" endpinid="Resistor-25-lPin" pointList="-424,-144,-400,-144" />

<item itemtype="Connector" uid="Connector-25" startpinid="Resistor-25-rPin" endpinid="Led-21-lPin" pointList="-368,-144,-356,-144" />

<item itemtype="Connector" uid="Connector-26" startpinid="Led-21-rPin" endpinid="Ground-24-Gnd" pointList="-324,-144,-312,-144,-312,-140" />

<item itemtype="Connector" uid="Connector-27" startpinid="Led-44-rPin" endpinid="Ground-49-Gnd" pointList="-324,0,-312,0,-312,4" />

<item itemtype="Connector" uid="Connector-28" startpinid="FullAdder-43-out0" endpinid="Resistor-31-lPin" pointList="-424,0,-400,0" />

<item itemtype="Connector" uid="Connector-29" startpinid="Fixed Voltage-47-outnod" endpinid="FullAdder-48-in0" pointList="-476,-116,-464,-116" />

<item itemtype="Connector" uid="Connector-30" startpinid="FullAdder-48-out0" endpinid="Resistor-41-lPin" pointList="-424,-108,-400,-108" />

<item itemtype="Connector" uid="Connector-31" startpinid="Fixed Voltage-42-outnod" endpinid="FullAdder-51-in0" pointList="-476,-80,-464,-80" />

<item itemtype="Connector" uid="Connector-32" startpinid="Led-32-rPin" endpinid="Ground-28-Gnd" pointList="-324,-72,-312,-72,-312,-68" />

<item itemtype="Connector" uid="Connector-33" startpinid="Led-36-rPin" endpinid="Ground-39-Gnd" pointList="-324,-108,-312,-108,-312,-104" />

<item itemtype="Connector" uid="Connector-34" startpinid="FullAdder-48-out1" endpinid="FullAdder-51-in2" pointList="-424,-100,-424,-80" />

<item itemtype="Connector" uid="Connector-35" startpinid="Fixed Voltage-35-outnod" endpinid="FullAdder-45-in0" pointList="-476,-44,-464,-44" />

<item itemtype="Connector" uid="Connector-37" startpinid="Fixed Voltage-29-outnod" endpinid="FullAdder-48-in1" pointList="-476,-100,-464,-100" />

<item itemtype="Connector" uid="Connector-38" startpinid="FullAdder-51-out0" endpinid="Resistor-46-lPin" pointList="-424,-72,-400,-72" />

<item itemtype="Connector" uid="Connector-39" startpinid="Resistor-31-rPin" endpinid="Led-44-lPin" pointList="-368,0,-356,0" />

<item itemtype="Connector" uid="Connector-40" startpinid="Fixed Voltage-33-outnod" endpinid="FullAdder-45-in1" pointList="-476,-28,-464,-28" />

<item itemtype="Connector" uid="Connector-41" startpinid="Fixed Voltage-27-outnod" endpinid="FullAdder-43-in0" pointList="-476,-8,-464,-8" />

<item itemtype="Connector" uid="Connector-42" startpinid="Fixed Voltage-34-outnod" endpinid="FullAdder-43-in1" pointList="-476,8,-464,8" />

<item itemtype="Connector" uid="Connector-43" startpinid="Resistor-41-rPin" endpinid="Led-36-lPin" pointList="-368,-108,-356,-108" />

<item itemtype="Connector" uid="Connector-44" startpinid="Resistor-46-rPin" endpinid="Led-32-lPin" pointList="-368,-72,-356,-72" />

<item itemtype="Connector" uid="Connector-45" startpinid="FullAdder-45-out0" endpinid="Resistor-50-lPin" pointList="-424,-36,-400,-36" />

<item itemtype="Connector" uid="Connector-46" startpinid="Resistor-50-rPin" endpinid="Led-40-lPin" pointList="-368,-36,-356,-36" />

<item itemtype="Connector" uid="Connector-47" startpinid="Led-40-rPin" endpinid="Ground-30-Gnd" pointList="-324,-36,-312,-36,-312,-32" />

<item itemtype="Connector" uid="Connector-48" startpinid="Fixed Voltage-38-outnod" endpinid="FullAdder-51-in1" pointList="-476,-64,-464,-64" />

<item itemtype="Connector" uid="Connector-50" startpinid="FullAdder-48-in2" endpinid="Node-52-0" pointList="-424,-116,-424,-136" />

<item itemtype="Connector" uid="Connector-58" startpinid="Node-52-2" endpinid="Node-52-1" pointList="-424,-136,-424,-136" />

<item itemtype="Connector" uid="Connector-60" startpinid="FullAdder-9-out1" endpinid="FullAdder-17-in2" pointList="-424,-208,-424,-188" />

<item itemtype="Connector" uid="Connector-61" startpinid="FullAdder-17-out1" endpinid="FullAdder-23-in2" pointList="-424,-172,-424,-152" />

<item itemtype="Connector" uid="Connector-62" startpinid="FullAdder-51-out1" endpinid="FullAdder-45-in2" pointList="-424,-64,-424,-44" />

<item itemtype="Connector" uid="Connector-63" startpinid="FullAdder-45-out1" endpinid="FullAdder-43-in2" pointList="-424,-28,-424,-8" />

<item itemtype="Connector" uid="Connector-64" startpinid="Led-56-rPin" endpinid="Ground-57-Gnd" pointList="-324,32,-312,32,-312,36" />

<item itemtype="Connector" uid="Connector-65" startpinid="Resistor-55-rPin" endpinid="Led-56-lPin" pointList="-368,32,-356,32" />

<item itemtype="Connector" uid="Connector-67" startpinid="Resistor-55-lPin" endpinid="FullAdder-43-out1" pointList="-400,32,-424,32,-424,8" />

</circuit>
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
