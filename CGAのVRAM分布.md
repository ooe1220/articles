<img width="692" height="514" alt="截图 2026-04-27 21-05-48" src="https://github.com/user-attachments/assets/11d3a3fa-5bab-42ad-a0d2-7eb2f8edf5cc" /><img width="692" height="514" alt="截图 2026-04-27 21-05-48" src="https://github.com/user-attachments/assets/c6345059-9b46-46e9-a79c-bc99d43a6e7e" /># 

VRAMは`0xB8000`から`320×200/4(1バイト4ピクセル)=16000()`の領域。

VRAMの分布は以下の様になっている。
```
偶数行:
B800:0000 → y=0
B800:0050 → y=2
B800:00A0 → y=4
...

奇数行:
B800:2000 → y=1
B800:2050 → y=3
B800:20A0 → y=5
...
```

```
偶数行（y=0,2,4…）
`0xB8000 ～ 0xB8000 + 0x1F40 - 1 = 0xB8000 ～ 0xB9F3F`

奇数行（y=1,3,5…）
`0xBA000 ～ 0xBA000 + 0x1F40 - 1 = 0xBA000 ～ 0xBBF3F`
```

# 偶数行にだけ書き込む

```bash
nasm -f bin test.asm -o test.bin
qemu-system-i386 -hda test.bin -boot a -no-reboot
 
lsblk
sudo dd if=test.bin of=/dev/sdb bs=512 count=2 conv=notrunc
```

奇数行には書き込んでおらず、偶数行のみ描画されており、縞模様が出来ている。
<img width="692" height="514" alt="截图 2026-04-27 21-05-48" src="https://github.com/user-attachments/assets/d4699fe0-b295-4bfd-908c-a26304f45827" />
<img width="2359" height="1769" alt="3eb380dc1ce538" src="https://github.com/user-attachments/assets/2b49bcaa-a138-4ac1-b754-28a887c3ed7f" />


<details>
<summary>test.asm</summary>

```test.asm 
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
    jc disk_error       ; エラー時

    ; 読み込んだコードへ跳ぶ（第2セクタ）
    jmp 0x0000:0x7E00

disk_error:
    cli
    hlt

times 510-($-$$) db 0
dw 0xAA55

    ; CGA互換 320x200 4色
    mov ax, 0x0004
    int 0x10

    ; VRAM = (es:di)B800:0000
    mov ax, 0xB800
    mov es, ax
    xor di, di
    
    mov cx,4000
draw01:
    mov al ,01010101b
    mov byte [es:di],al
    inc di
    loop draw01
    
    mov cx,4000
draw10:
    mov al ,10101010b
    mov byte [es:di],al
    inc di
    loop draw10

hlt_loop:
    cli
    hlt
    jmp hlt_loop

times 1024-($-$$) db 0
```

</details>
