
# まずは一部配線

<img width="1281" height="755" alt="z80_1" src="https://github.com/user-attachments/assets/3ad6f1b4-22f9-4c6b-81b9-ebbd4a53c2d7" />

```z80_1.sim1
<circuit version="1.1.0-SR0" rev="1917" stepSize="1000000" stepsPS="1000000" NLsteps="100000" reaStep="1000000" animate="0" >

<item itemtype="MCU" CircId="Z80-1" mainComp="false" Show_id="true" Show_Val="false" Pos="-172,-92" rotation="0" hflip="1" vflip="1" label="Z80-1" idLabPos="0,-20" labelrot="0" valLabPos="-16,20" valLabRot="0" Logic_Symbol="false" Producer="Zilog" CMOS="false" Single cycle I/O="false" Int_Vector="false" />

<item itemtype="Memory" CircId="Memory-2" mainComp="false" Show_id="false" Show_Val="false" Pos="-36,-24" rotation="0" hflip="1" vflip="1" label="Memory-2" idLabPos="-16,-24" labelrot="0" valLabPos="-16,20" valLabRot="0" Address_Bits="8 _bits" Data_Bits="8 _bits" Persistent="true" Asynch="true" Input_High_V="2.5 V" Input_Low_V="2.5 V" Input_Imped="1000 MΩ" Out_High_V="5 V" Out_Low_V="0 V" Out_Imped="40 Ω" Inverted="false" Open_Collector="true" pd_n="1 _Gates" Tpd_ps="10 ns" Tr_ps="3 ns" Tf_ps="4 ns" />

<item itemtype="Connector" uid="Connector-1" startpinid="Memory-2-in0" endpinid="Z80-1-PORTA0" pointList="-60,-56,-116,-56,-116,-4" />

<item itemtype="Connector" uid="Connector-2" startpinid="Memory-2-out0" endpinid="Z80-1-PORTD0" pointList="-12,-56,-180,-56,-180,20" />

<item itemtype="Connector" uid="Connector-3" startpinid="Memory-2-Pin_We" endpinid="Z80-1-CPORT0WR" pointList="-60,8,-116,8,-116,60" />

<item itemtype="Connector" uid="Connector-4" startpinid="Memory-2-Pin_outEnable" endpinid="Z80-1-CPORT0RD" pointList="-60,16,-60,68,-116,68" />

<item itemtype="Connector" uid="Connector-5" startpinid="Memory-2-Pin_Cs" endpinid="Z80-1-CPORT0MREQ" pointList="-12,16,-12,60,-180,60" />

</circuit>
```

# 各ピンのXML上の名前を調べる

`startpinid` `endpinid`の名称はチップの`CircId` + `-` + 各ピンの名称となっている。

メモリ側のピン
A0-A7 : `in0`～
D0-D7 : `out0`～
WE : `Pin_We`
OE : `Pin_outEnable`
CS : `Pin_Cs`

Z80側のピン
A0-A7 : `PORTA0`～
D0-D7 : `PORTD0`～
WR : `CPORT0WR`
RD : `CPORT0RD`
MREQ : `CPORT0MREQ`
