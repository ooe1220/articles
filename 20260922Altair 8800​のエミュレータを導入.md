# 導入

```bash
sudo apt install simh
```


# 実行対象の機械語を生成

```bash
z80asm -o alta8080.bin alta8080.asm
```

8080向けですが、z80のニーモニックに慣れているのでz80のアセンブラを使用しています。
z80固有命令を使用していないので8080でも動作します。
```alta8080.asm
org 0
    ld sp, 0x1000
    ld hl, msg
    
loop:
    ld a, (hl) ; 表示する文字
    cp 0       ; 末尾なら終了
    jp z, done
    call putchar
    inc hl
    jp loop
    
done:
    jp done
    
putchar:
wait:
    ld b, a
    in a, (0x10)
    and 0x02
    jp z, wait
    ld a, b
    out (0x11), a
    ret
    
msg: db "Hello, ALTAIR8080",13,10,0
```

機械語のバイナリは以下の通りです。
```
test@test-fujitsu:~/kaihatsu$ xxd alta8080.bin | head
00000000: 3100 1021 2200 7efe 00ca 1300 cd16 0023  1..!".~........#
00000010: c306 00c3 1300 47db 10e6 02ca 1600 78d3  ......G.......x.
00000020: 11c9 4865 6c6c 6f2c 2041 4c54 4149 5238  ..Hello, ALTAIR8
00000030: 3038 300d 0a00                           080...                                 ...
```

# altairz80の起動

```bash
altairz80
```

`sim>`と表示されたら以下の用に入力します
```
reset all
set cpu 8080
set sio ansi
load alta8080.bin
run
```

実行結果は以下の通りです
```bash
test@test-fujitsu:~/kaihatsu$ z80asm -o alta8080.bin alta8080.asm
test@test-fujitsu:~/kaihatsu$ altairz80

Altair 8800 (Z80) simulator V3.8-1
sim> reset all
sim> set cpu 8080
sim> set sio ansi
sim> load alta8080.bin
54 bytes [1 page] loaded at 0.
sim> run
Hello, ALTAIR8080
```
