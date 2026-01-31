 NASMで8080用機械語を生成する
  
    アセンブリ言語
    8080
    8086
    機械語
    V30

# 初めに

V30はNECが製造していた`8086`互換CPUです。`8086`とは違い、`8080`のコードも実行できます。
現在V30を搭載したパソコン上で8080の実験が出来るように環境を整えています。

これまでの記事を以下に貼っておきます。

[NEC V30で試す8080互換モードの検証](https://qiita.com/earthen94/items/4cc56aeab3913a31cca5)
[V30CPUで8080の機械語を動かす環境を整える](https://qiita.com/earthen94/items/ae38835bc70ec4b5eb9d)


# 検証用コード

以下の順序で動作します。
1. ブートローダから第2セクタを呼び出す
2. IVT80hに`8080`用コードの開始アドレスを登録する。
3. 8080では0-64KBまでのメモリ領域しか指定できず、VGAのVRAMには届かないので`0x6000`を文字データの仮置場(バッファ)とする。
4. `0x6000`から4000バイト(80文字×25行×2バイト)を`0x0720`(AH=属性, AL=' ')で埋める
5. 8080モードへ切り替える
6. バッファ領域に文字を書き込む(8080用コードは8080.asmに切り分けている)
7. `8086`モードへ切り替える
8. バッファからVRAMへデータを複製

```boot.asm
; nasm -f bin boot.asm -o boot.bin
; qemu-system-i386 -hda boot.bin -boot a -no-reboot
; lsblk
; sudo dd if=boot.bin of=/dev/sdb bs=512 count=2 conv=notrunc

org 0x7C00

start:
    xor ax, ax
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x7C00

    ; ディスクから第2セクタを 0x7E00 に読み込む
    mov ah, 0x02        ; INT 13h 2: 読み込み
    mov al, 1           ; 読み込むセクタ数 = 1
    mov ch, 0           ; シリンダ = 0
    mov cl, 2           ; セクタ番号 = 2（1始まり）
    mov dh, 0           ; ヘッド = 0
    mov dl, 0x80        ; ドライブ番号
    mov bx, 0x7E00      ; 読み込み先アドレス
    int 0x13
    jc disk_error       ; エラー時に無限ループ

    ; 読み込んだコードへ跳ぶ（第2セクタ）
    jmp 0x0000:0x7E00

disk_error:
    jmp $

times 510-($-$$) db 0
dw 0xAA55


%define TARGET_VECC 0x80
%define TARGET_ADDR (TARGET_VECC * 4)

BUFFER_ADDR equ 0x6000  ; 8080モード用の文字バッファ

start2:
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
    
    call init_8080buffer

    ;mov si, msg_enter
    ;call print_string

    ; 8080モードへ移行
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
    call copy_8080buffer_to_vram
    
    ;mov si, msg_back
    ;call print_string
    
hang:
    jmp hang

    
;-----------------------
; 8080用画面バッファからVRAMへ複製
;-----------------------
copy_8080buffer_to_vram:
    push ax
    push cx
    push si
    push di
    push ds
    push es

    xor ax, ax
    mov ds, ax
    mov si, BUFFER_ADDR

    mov ax, 0B800h
    mov es, ax
    xor di, di

    mov cx, 4000          ; 80*25*2
    rep movsb ; DS:SI → ES:DI

    pop es
    pop ds
    pop di
    pop si
    pop cx
    pop ax
    ret
    
;-----------------------
; 8080画面出力用BUFFER初期化
;-----------------------
init_8080buffer:
    push ax
    push cx
    push es
    push di

    ; ES=0x0000 DI=0x6000
    xor ax, ax
    mov es, ax
    mov di, BUFFER_ADDR

    mov cx, 80*25
    mov ax, 0x0720    ; AH=属性, AL=' '
    cld
    rep stosw ; ES:[DI] ← AX , DI ← DI + 2

    pop di
    pop es
    pop cx
    pop ax
    ret

;-----------------------
; 文字列出力
;-----------------------
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

times 512-($-start2) db 0
```

```8080.asm
; --- MVI ---
%macro MVI 2
%ifidni %1,A
    db 0x3E, %2
%elifidni %1,B
    db 0x06, %2
%elifidni %1,C
    db 0x0E, %2
%elifidni %1,D
    db 0x16, %2
%elifidni %1,E
    db 0x1E, %2
%elifidni %1,H
    db 0x26, %2
%elifidni %1,L
    db 0x2E, %2
%else
    %error "Unsupported MVI register"
%endif
%endmacro


; --- STA addr ---
%macro STA 1
    db 0x32, (%1 & 0xFF), ((%1 >> 8) & 0xFF)
%endmacro

; '8','0','8','0' を書く
MVI A, '8'
STA 6000h
MVI A, 4Fh
STA 6001h

MVI A, '0'
STA 6002h
MVI A, 4Fh
STA 6003h

MVI A, '8'
STA 6004h
MVI A, 4Fh
STA 6005h

MVI A, '0'
STA 6006h
MVI A, 4Fh
STA 6007h
```

# 動作

![0abc12f8620c18.jpg](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/4054974/a476e047-66d1-439a-9643-533b44ea9b1c.jpeg)


