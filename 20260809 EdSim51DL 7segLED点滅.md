[8051エミュレータEdSim51DL導入手順](https://qiita.com/earthen94/items/bb2e134a2b0130f7732a)

```asm
start:
    MOV P1,#0       ; 点灯
    ACALL delay
    MOV P1,#0FFH    ; 消灯
    ACALL delay
    SJMP start

delay:
    MOV R7,#1
d1:
    DJNZ R7,d1
    RET
```

8が点滅している
a



