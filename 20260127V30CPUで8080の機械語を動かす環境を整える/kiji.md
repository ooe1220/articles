# 初めに

こちらは前回投稿した記事です。
[NEC V30で試す8080互換モードの検証](https://qiita.com/earthen94/items/4cc56aeab3913a31cca5)

今回は8080の機械語を書くプログラムを別のファイルとして分割し、NASMから一括でコンパイルできるようにしました。

# V30から8080モードを動かす処理

<details>
<summary>boot.asm</summary>

```boot.asm
[BITS 16]
[ORG 0x7C00]

%define TARGET_VECC 0x80
%define TARGET_ADDR (TARGET_VECC * 4)

buffer_addr equ 0x7000  ; 8080モード用の文字バッファ

start:
    cli
    xor ax, ax
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x7C00

    ; --- IVT 0x80 に 8080コードの開始地点を登録 ---
    ; ここで登録したアドレスが 8080モードの「PC=0」として解釈されます
    mov word [TARGET_ADDR], entry_8080_code ; オフセット
    mov word [TARGET_ADDR + 2], 0           ; セグメント(CS)

    mov si, msg_enter
    call print_string

    ; 8080モードへ突入 (指定したベクタ経由)
    db 0x0F, 0xFF, TARGET_VECC 

    ; --- RETEM実行後、ここに戻ってくる ---
    jmp after_8080

; 8080モード
entry_8080_code:
    
    %include "8080.asm"
    
    db 0xED, 0xFD   ; RETEM (8086へ復帰)

; 8086復帰
after_8080:
    xor ax, ax
    mov ds, ax
    mov ax, 0xB800
    mov es, ax
    
    ; --- バッファからVRAMに複製 ---
    mov si, buffer_addr
    mov di, 0x0000
    mov cx, 8    ; 4文字×2バイト
    rep movsb ; DS:SI → ES:DI
    
    mov si, msg_back
    call print_string
    
hang:
    jmp hang

print_string:
    lodsb
    or al, al
    jz .done
    mov ah, 0x0E
    int 0x10
    jmp print_string
.done:
    ret

msg_enter db "Entering 8080 mode...", 13, 10, 0
msg_back  db "Successfully returned!", 13, 10, 0

times 510-($-$$) db 0
dw 0xAA55
```
</details>

# NASMに直接8080の機械語を書く

```8080.asm
; 5-3をしてその結果をAに格納
db 0x3E, 0x05  ; MVI A, 5 
db 0x06, 0x03  ; MVI B, 3 
db 0x90        ; SUB B  (A=A-B) 
db 0xC6, 0x30  ; ADI 30H A←A+30H (ASCII '3' は 33H)
    
; VRAMへ渡すバッファにAレジスタを書き込む
db 0x32, 0x00, 0x70  ; STA 0x7000   [0x7000]←A
db 0x3E, 0x4F        ; MVI A, 0x4F 
db 0x32, 0x01, 0x70  ; STA 0x7001  
```

# 動作確認

```bash
nasm -f bin boot.asm -o boot.bin
lsblk
sudo dd if=boot.bin of=/dev/sdb bs=512 count=1 conv=notrunc
```

画面左上に計算結果の2が表示されました。
![V30.png](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/4054974/ebf32602-dc8a-4a09-ae59-52ad37ee4a30.png)

今後はNASMを用いてマクロ経由で`8080`の機械語を生成できるようにしたいと思います。

