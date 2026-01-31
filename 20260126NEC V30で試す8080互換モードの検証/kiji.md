# v30とは

現在のx86系の始祖となった一番初めのCPU、8086の完全互換製品。
PC-98だけでなく組み込みのように電化製品にも使われていた模様。

参考:
https://ja.wikipedia.org/wiki/NEC_V%E3%82%B7%E3%83%AA%E3%83%BC%E3%82%BA
https://www.shmj.or.jp/museum2010/exhibi703.htm
https://bitsavers.org/components/nec/V-Series/V20_V30_Users_Manual_Oct86.pdf

# 検証内容
v30はNECが製造していた8086互換CPUですが、インテルの本家`8086`とは違い、8ビットの`8080`CPUを動かせる様になっています。
そこで今回は`V30`CPUを使い、8080互換モードに入ってから8086モードへ戻る検証を行います。

筆者は`Pocket 8086`と呼ばれる復刻機を所有しているため、これを使います。
`Pocket 8086`という製品名ではありますが、裏蓋を開けるとCPUの表にうっすらと`V30`と印字されています。

![v30.png](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/4054974/9e3f3820-ef5d-479a-8af2-c6a33294d267.png)


以下の手順で行います。
1. ブートローダ上でBIOSの機能を借りて"Entering 8080 mode..."と表示し、16ビットモードで起動したことを確認する。
2. `0x0F, 0xFF`を実行し、8080互換モードへ移行する。
3. `8080`用の機械語で0x7000からの領域(バッファ)に VGA VRAMのテキストモードの決まりに従い、赤背景で`8080`と設定する。
4. `0xED, 0xFD`を実行し、8086モードへ復帰する。
5. バッファからVRAM(0xB8000〜)へ8080モードで書き込んだデータを複製する(画面左上に8086と表示される)
6. BIOSの機能を借りてSuccessfully returned!"と表示する。

あいにく本家`8086`は所有していないため、QEMUを利用。
QEMUで実行した場合はNECが追加した`0x0F, 0xFF`が正常に動かず"Entering 8080 mode..."と表示した後に固まり、
V30実機で実行した場合は6まで正常に動作するはずです。

# 検証用コード

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
    
    ; '8','0','8','0' を書く
    db 0x3E, '8'         ; MVI A, '8'
    db 0x32, 0x00, 0x70  ; STA 0x7000
    db 0x3E, 0x4F        ; MVI A, 0x4F
    db 0x32, 0x01, 0x70  ; STA 0x7001

    db 0x3E, '0'
    db 0x32, 0x02, 0x70
    db 0x3E, 0x4F
    db 0x32, 0x03, 0x70

    db 0x3E, '8'
    db 0x32, 0x04, 0x70
    db 0x3E, 0x4F
    db 0x32, 0x05, 0x70

    db 0x3E, '0'
    db 0x32, 0x06, 0x70
    db 0x3E, 0x4F
    db 0x32, 0x07, 0x70
    
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

# 動作結果

## QEMU(80386の16ビットモード、8086相当)

```bash
nasm -f bin boot.asm -o boot.bin
qemu-system-i386 -hda boot.bin -boot a -no-reboot
```
NECが拡張した部分は動かないので途中で固まります。
![qemu.png](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/4054974/a539aa08-1ef3-4401-824e-e07c2f5afbf3.png)

## V30実機

CFカードへ書き込む
```bash
lsblk
sudo dd if=boot.bin of=/dev/sdb bs=512 count=1 conv=notrunc
```

画面左上に`8080`と表示されました。
![boot.png](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/4054974/1c701f9f-eb41-4b19-bcad-4c563447c921.png)

