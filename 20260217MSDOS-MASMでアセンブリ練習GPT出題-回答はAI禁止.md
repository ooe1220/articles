# 目的
自分でアセンブリを書く練習をします。
出題にはAIを使いますが、回答時は技術書やWeb検索で調べるのみに留めます。
どうしてもコンパイルが通らない時には間接的に聞きます。


※細かい間違いは後から気づいても直していません。

# 問題1：レジスタ転送
次の値をレジスタ操作だけで作れ。
AX = 1234h
BX = AX の値
CX = BX + 10h
DX = CX - 4h

条件：
即値使用OK
メモリ使用禁止
最後 int 20h で終了
![c12854881bb4c8](https://github.com/user-attachments/assets/8414881f-269d-462a-8d89-b9eb25392efd)

```MONDAI1.ASM
.model small
.stack 100h
.data
.code
main: 
   mov ax,1234h
   mov bx,ax
   add bx,10h
   mov cx,bx
   xor al,al
   mov ah,4ch
   int 21h
end main
```

# 問題2：メモリ書き込み
.data に1バイト変数を作る。
変数に 55h を格納せよ
条件：
MOVのみ使用
レジスタ経由でもOK
![aae838df3d292](https://github.com/user-attachments/assets/b0b3d1c5-6228-406f-8a7f-6232c78d6d3b)

```MONDAI2.ASM
.model small
.stack 100h

.data
 hensu db 0

.code
main:
 mov al,55h
 mov [hensu],al
 mov ah,4ch
 int 21h
end main
```

# 問題3：カウンタループ
CXを使って
10回ループするだけのプログラム
条件：
LOOP命令を必ず使う
ループ中はNOPだけでよい
![8e0dacfe37a728](https://github.com/user-attachments/assets/2fcb5219-83bf-40d6-9997-becee146d5ed)

```MONDAI3.ASM
.model small
.stack 100h
.data
.code
main:
 mov cx,10        
 s:
 nop
 loop s

 mov ah,4ch
 int 21h
end main
```

# 問題4：合計値計算
1〜10までの合計をAXに求めよ。
条件：
ループ使用
変数使用禁止
AXに最終結果を残す
![5384024900c96](https://github.com/user-attachments/assets/281e2e32-da7a-41bc-8bfb-ee0f325ce6ae)

```MONDAI4.ASM
.model small
.stack 100h
.data
.code
main:
 xor ax,ax
 mov cx,10

sum:
 add ax,cx
 loop sum

mov ah,4ch
int 21h
end main
```

# 問題5：1文字表示（BIOS）
BIOSを使って
'A'
を画面表示せよ。
条件：
テキストモード前提
BIOS割り込み使用
DOS割り込み禁止
![44527f1f0dcc58](https://github.com/user-attachments/assets/3cf0260f-f754-41af-9636-5a6f37f23a44)

```MONDAI5.ASM
.model small
.stack 100h
.data
.code
main:
 mov al,'A'
 mov ah,0eh
 int 10h

 mov ah,4ch
 int 21h
end main
```

# 問題6：文字を10回表示
*を10個横に並べて表示せよ。
条件：
BIOS表示
ループ必須
![c54f3026625f38](https://github.com/user-attachments/assets/ab8f9662-d830-4071-93cf-9a1aec965a66)

```MONDAI6.ASM
.model small
.stack 100h
.data
.code
main:
 mov cx,10
 mov al,'*'
 mov ah,0eh
l:
 int 10h
 loop l

 mov ah,4ch
 int 21h
end main
```

# 問題7：キー入力待ち
BIOSで
キーを1回押すまで待つだけのプログラムを作れ。
条件：
入力値は保存不要
![d873d5a28f4e38](https://github.com/user-attachments/assets/2f737ac2-d64d-450f-a158-d2f4948536a7)

```MONDAI7.ASM
.model small
.stack 100h
.data
.code
main:
 mov ah,00h
 int 16h
 
 mov ah,4ch
 int 21h
end main
```

問題8：入力文字をそのまま表示
BIOSで1文字入力 → 同じ文字を表示
条件：
DOS表示禁止
BIOSのみ
![40ca41de8dd97](https://github.com/user-attachments/assets/2beab415-635d-41e5-ab6d-6c957a72299c)

```MONDAI8.ASM
.model small
.stack 100h
.data
.code
main:
 mov ah,00h
 int 16h

 mov ah,0eh
 int 10h ;al niha asciiga haitteiru

 mov ah,4ch
 int 21h
end main
```

# 問題9：文字列表示
DOS機能を使ってHELLOを表示せよ。
条件：
$ 終端文字列を使用
改行は自由
![3c4860f3e18708](https://github.com/user-attachments/assets/14005c44-0fff-477f-a58c-cc273dbabef0)

```MONDAI9.ASM
.model small
.stack 100h
.data
 msg db 'HELLO$'

.code
main:
 mov ah,09h
 lea dx,msg
 int 21h

 mov ah,4ch
 int 21h
end main
```

# 問題10：キーボード入力（DOS）
1文字入力して入力した文字を表示
条件：
DOSのみ使用
BIOS禁止

https://blog.csdn.net/mid_Faker/article/details/112271486
![cb3d0cf9bae89](https://github.com/user-attachments/assets/ca0ef377-a261-4465-ace7-a421082b2ca2)

```MONDAI10.ASM
.model small
.stack 100h
.data
.code
main:
 xor ax,ax
 mov ah,01h
 int 21h

 mov ah,4ch
 int 21h

end main
```

# 問題11：PCスピーカON/OFF
ポート操作を使ってスピーカを一瞬鳴らす
条件：
IN / OUT 使用
BIOS禁止
DOS禁止

？？？？？

# 問題12：ポート値の取得
任意のポートから値を読み取りALに保存するだけ
条件：
IN命令必須

https://www.toolify.ai/zh/hardwarecn/%E5%AD%A6%E4%B9%A08086%E5%BE%AE%E5%A4%84%E7%90%86%E5%99%A8%E7%9A%84in%E5%92%8Cout%E6%8C%87%E4%BB%A4-2979882
![fb0ada341f37a8](https://github.com/user-attachments/assets/c5bed13d-7e42-41a4-8095-ad816769fce6)

```MONDAI12.ASM
.model small
.stack 100h
.data
.code
main:
 
 ;8bit port
 in al,60h

 ;16bit port
 mov dx,1F7h
 in al,dx

 mov ah,4ch
 int 21h
end main
```

# 問題13：簡易エコープログラム

次の動作を作れ：
キー入力待ち
↓
入力された文字表示
↓
ESCなら終了 それ以外なら繰り返し
条件：
BIOSでもDOSでもOK
ループ必須
比較命令必須

## dos版
![b98bc94d55dba8](https://github.com/user-attachments/assets/ff570a64-818e-4b01-93a6-3fa6d0998517)

```MONDAI13.ASM
.model small
.stack 100h
.data
.code
main:
 
input:
 mov ah,07h ; keyboad->AL
 int 21h

 cmp al,1bh ; AL==ESC goto done
 je done

 mov dl,al
 mov ah,02h ; DL->VGA
 int 21h
 jmp input

done:
 mov ah,4ch
 int 21h
end main
```

## bios版

![c2b97975914078](https://github.com/user-attachments/assets/007164a3-81ef-487a-8165-3d46a686a256)

```MONDA132.ASM
.model small
.stack 100h
.data
.code
main:
 xor ax,ax

input:
 mov ah,00h ; keyboard->AL(ascii)
 int 16h

 cmp al,1bh ; AL==ESC GOTO DONE
 je done
 mov ah,0eh ; AL no nakamiwo hyouji
 int 10h
 jmp input

done:
 mov ah,4ch
 int 21h
end main
```

# 問題14：画面クリア

BIOSを使って画面をクリアせよ。

![ef3445f6f2e6d](https://github.com/user-attachments/assets/32b990af-36a3-494c-807e-43408be3c4a9)

```MONDAI14.ASM
.model small
.stack 100h
.data
.code
main:

 mov cx,2000 ; 80*25
 mov al,' '
 mov ah,0eh
cls:
 int 10h
loop cls

 mov ah,4ch
 int 21h
end main
```

# 問題15：カーソル移動
画面の10行目 20列目に文字を表示せよ。

![8c1729374bca4](https://github.com/user-attachments/assets/4d2d838a-360f-433b-836c-b242422f4e6a)

```MONDAI15.ASM
.model small
.stack 100h
.data
.code
main:
 ; cursor->10,20
 ; cursor_pos = 10*80+20 (820) =0x334
 ; kai4byte 0x34
 mov dx,03d4h
 mov ax,000fh
 out dx,al    ; out(0x3D4,0x0F)
 mov ax,0034h
 mov dx,03d5h
 out dx,al    ; out(0x3D5,0x34)
 ; joui4byte 34h
 mov dx,03d4h
 mov ax,000eh
 out dx,al    ; out(0x3D4,0x0E)
 mov dx,03d5h
 mov ax,0003h
 out dx,al    ; out(0x3D5,0x03)

 mov ah,4fh
 int 21h
end main
```

# Level 8：文字列とメモリ操作
問題16：NULL終端文字列表示（自作）

次の文字列を表示せよ：HELLO WORLD

条件
$ 終端は禁止
0 終端文字列を使用
1文字ずつ表示する
BIOS または DOS どちらでも可
ループ必須
![742841f62cc21](https://github.com/user-attachments/assets/31c34338-a548-42c9-9180-c80d839da9f1)

## bios版
```MONDAI16.ASM
.model small
.stack 100h
.data
 str db 'HELLO WORLD',0
.code
main:
 mov ax,@data ; ds wo data ni awasu
 mov ds,ax
 lea si,str

print:
 mov al,ds:[si]
 cmp al,0 ; AL==0 GOTO DONE
 je done

 mov ah,0eh
 int 10h
 inc si
 jmp print

done:
 mov ah,4ch
 int 21h
end main
```

## dos版
![4f2e32f8600c68](https://github.com/user-attachments/assets/60d921e9-9d76-47c9-9e21-92aa501399a6)

```MONDA162.ASM
.model small
.stack 100h
.data
 str db 'HELLO WORLD',0
.code
main:
 mov ax,@data ; ds wo data ni awasu
 mov ds,ax
 lea si,str

print:
 mov al,ds:[si]
 cmp al,0 ; AL==0 GOTO DONE
 je done

 mov dl,al
 mov ah,02h
 int 21h

 inc si
 jmp print

done:
 mov ah,4ch
 int 21h
end main
```

## loop版
![73020e98b10d58](https://github.com/user-attachments/assets/5a95946c-619e-4ae8-8dd9-97991d8c6067)

```MONDA163.ASM
.model small
.stack 100h
.data
 msg db 'HELLO WORLD',0
 len equ $ - msg
.code
main:
 mov cx,len
 mov ax,@data
 mov ds,ax
 lea si,msg
print:
 mov al,ds:[si]
 mov ah,0eh
 int 10h
 inc si
 loop print

 mov ah,4ch
 int 21h
end main
```

# 問題17：文字列長カウント

.data に NULL終端文字列を用意する。
ABCDE
要求
文字数を数えて CX に入れる
条件
SCAS / CMPS 使用禁止
1バイトずつ読む
文字列は書き換え禁止

## 疑似命令版
![6a76bd94c6194](https://github.com/user-attachments/assets/09239df6-edf4-4144-bd81-ff42110059c2)

```MONDAI17.ASM
.model small
.stack 100h
.data
msg db 'ABCDE',0
len equ $ - msg

.code
main:
 mov ax,@data
 mov ds,ax
 mov cl,len
 add cl,'0' ; suji->ascii
 mov ah,0eh
 mov al,cl
 int 10h

 mov ah,4ch
 int 21h
end main
```

## 1バイトずつ勘定版

![78fd9494fbeb](https://github.com/user-attachments/assets/777dd0e4-cb8f-4f56-8dc2-a6b2acd17575)

```MONDA172.ASM
.model small
.stack 100h
.data
msg db 'ABCDE',0
.code
main:
 mov ax,@data
 mov ds,ax
 lea si,msg
 mov cx,0
count:
 mov al,ds:[si]
 cmp al,0
 je done
 inc si
 inc cx
 jmp count

done:
 add cl,'0' ; suji->ascii
 mov al,cl
 mov ah,0eh
 int 10h
 mov ah,4ch
 int 21h
end main
```

# 問題18：レジスタ保存テスト

以下を満たせ：
AX = 1111h
BX = 2222h
CX = 3333h
その後
スタックに全部保存
↓
レジスタを全部ゼロにする
↓
スタックから復元
条件
PUSH / POP 使用
復元後の値が完全一致すること
![efca9c53248cf8](https://github.com/user-attachments/assets/34c3f428-b1e7-4512-a38c-4d5bbca63f4d)

```MONDAI18.ASM
.model small
.stack 100h
.data
.code
main:
 mov ax,1111h
 mov bx,2222h
 mov cx,3333h
 push ax
 push bx
 push cx
 mov ax,0000h
 mov bx,0000h
 mov cx,0000h
 pop cx
 pop bx
 pop ax 

 xor ax,ax ; debug mondai18.exe kokode tomeru.
 mov ah,4ch
 int 21h
end main
```

# 問題19：簡易関数呼び出し

次の構造を作れ：
main
 └ displayA  (Aを表示する関数)
条件
CALL / RET 使用
displayA は main を破壊してはいけない
![59b6ae09d23c68](https://github.com/user-attachments/assets/a67a2cee-125c-425b-8ae9-03d3fb781971)

```MONDAI19.ASM
.model small
.stack 100h
.data
.code
main:
 call displayA

 mov ah,4ch
 int 21h

displayA:
 push es
 ;mov ah,0eh
 ;mov al,'A'
 ;int 10h
 mov ax,0b800h
 mov es,ax
 xor di,di
 mov byte ptr es:[di],'A'
 inc di
 mov byte ptr es:[di],07h
 pop es
 ret

end main
```
# 問題20：VRAM直接文字表示

次の文字を表示：
Z
条件
BIOS禁止
DOS表示禁止
VRAM に直接書き込む
テキストモード前提
![5d853969103ae8](https://github.com/user-attachments/assets/0e866490-c889-45f5-afeb-1402f2ae83cf)
```MONDAI20.ASM
.model small
.stack 100h
.data
.code
main:
 push es
 mov ax,0b800h
 mov es,ax
 mov di,3780 ; (80*23+50)*2 migini yosenaito commando wo uwagaki suru
 mov word ptr es:[di],075ah

 mov ah,4ch
 int 21h

end main
```

# 問題21：画面中央に表示
HELLOを画面中央付近に VRAM 直接書き込みで表示。
条件
文字属性も設定する
BIOS禁止
DOS禁止
![e7a34bfae0b88](https://github.com/user-attachments/assets/9d7dd221-3d95-4996-bdd1-ad09d161747d)
![31b69af556d068](https://github.com/user-attachments/assets/372e405c-db66-42ba-b76b-33283167ca16)

```MONDAI21.ASM
.model small
.stack 100h
.data
 str db 'HELLO',0
.code
main:
 ; str=DS:SI
 mov ax,@data
 mov ds,ax
 lea si,str
 ; vram=ES:DI
 mov ax,0b800h
 mov es,ax
 mov di,2000  ; tyuuou 80*25*2/2=2000
 
print:
 mov al,ds:[si]
 cmp al,0 ; IF STR==0 GOTO DONE
 je done
 mov es:[di],al
 inc di
 mov byte ptr es:[di],07h
 inc di
 inc si
 jmp print
done:
 mov ah,4ch
 int 21h
end main
```

# 問題22：配列合計
.data に次の配列を作る：
1,2,3,4,5,6,7,8,9,10
要求
合計を AX に入れる
条件
配列長を即値で使ってよい
ループ必須
![14b2a815c742e8](https://github.com/user-attachments/assets/865a2c50-68f6-44b6-a1ce-9d8319c51397)
```MONDAI22.ASM
.model small
.stack 100h
.data 
 array db 1,2,3,4,5,6,7,8,9,10
 arrlen equ $-array
.code
main:
 mov ax,@data
 mov ds,ax
 mov cx,arrlen
 mov ax,0
 lea si,array
count:
 add al,byte ptr ds:[si]
 inc si
 loop count

 mov ah,4ch ; kokode tomeru
 int 21h
end main
```
