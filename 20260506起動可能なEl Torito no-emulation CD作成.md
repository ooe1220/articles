
```
nasm -f bin boot.asm -o boot.bin

mkdir iso
cp boot.bin iso/

xorriso -as mkisofs \
  -o os.iso \
  -b boot.bin \       # このファイルを起動用に使う
  -c boot.cat \       # 起動情報
  -no-emul-boot \     # フロッピーとして扱わない)~
  -boot-load-size 1 \ # 1セクタ(2048バイト)読む
  iso

qemu-system-i386 -cdrom os.iso -m 512
```

```boot.asm
BITS 16
ORG 0x7C00

start:
    mov ax, 0xB800
    mov es, ax
    xor di, di

    mov si, msg

.print:
    lodsb
    cmp al, 0
    je .hang

    mov ah, 0x07        ; 属性（白）
    stosw               ; [ES:DI] = AX (文字+属性)
    jmp .print

.hang:
    cli
    hlt
    jmp .hang

msg db "Hello------", 0

times 512-($-$$) db 0
```

