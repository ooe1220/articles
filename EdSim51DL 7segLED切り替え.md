
[8051エミュレータEdSim51DL導入手順](https://qiita.com/earthen94/items/bb2e134a2b0130f7732a)

`P3.3`及び`P3.4`で切り替える。

```led.asm
start:

    CLR P3.3
    CLR P3.4
    MOV P1,#0
    ACALL delay

    SETB P3.3
    CLR P3.4
    ;MOV P1,#0
    ACALL delay

    CLR P3.3
    SETB P3.4
    ;MOV P1,#0
    ACALL delay

    SETB P3.3
    SETB P3.4
    ;MOV P1,#0
    ACALL delay

    SJMP start

delay:
    MOV R7,#1
d1:
    DJNZ R7,d1
    RET
```

<img width="1552" height="1087" alt="image" src="https://github.com/user-attachments/assets/80a8ae21-2122-4c71-9c24-84fcfb4bc9b8" />
