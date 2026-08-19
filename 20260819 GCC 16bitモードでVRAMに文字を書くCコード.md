# コードと実行

```linker.ld
OUTPUT_FORMAT("binary")
SECTIONS
{
    . = 0xF0000;
    .text : {
        *(.text*)
        *(.rodata*)
    }
    .data : {
        *(.data*)
    }
    .bss : {
        *(.bss*)
        *(COMMON)
    }

    /* アライメントを強制解除 */
    /DISCARD/ : {
        *(.note*)
        *(.eh_frame*)
        *(.comment*)
    }
}
```

```boot.asm
[org 0x7C00]
bits 16

start:
    cli
    xor ax, ax
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x7C00
    sti
    
    ; --- INT 13h CHS 読み込み ---
    mov ah, 0x02         ; BIOS: Read Sectors
    mov al, 1            ; 読み込むセクタ数
    mov ch, 0            ; シリンダ = 0
    mov dh, 0            ; ヘッド = 0
    mov cl, 2            ; セクタ = 2 (ブートローダの次)
    mov dl, 0x80         ; ドライブ番号=HDD
    mov bx, 0x7E00       ; ES:BX = 読み込み先
    int 0x13
    jc disk_error
    
    jmp 0x0000:0x7E00

disk_error:
    hlt
    jmp disk_error

times 510-($-$$) db 0
dw 0xAA55
```

```entry.asm
bits 16
global start
extern main


start:
    cli
    xor ax, ax
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x7C00
    
    mov ax, 0x0003
    int 0x10 

    ; VGAリアルモード表示
    mov ax, 0xB800
    mov es, ax

    jmp main
```

```test.c
__asm__(".code16gcc\n");


#define VGA_PUT(c, attr, ofs)                      \
    __asm__ volatile (                             \
        "pushw %%es\n"                              \
        "mov $0xB800, %%ax\n"                      \
        "mov %%ax, %%es\n"                         \
        "movb %0, %%al\n"                          \
        "movb %1, %%ah\n"                          \
        "mov %%ax, %%es:(%2)\n"                    \
        "popw %%es\n"                               \
        :                                          \
        : "ir"(c), "ir"(attr), "r"(ofs)            \
        : "ax", "memory"                           \
    )

void main(void)
{
    char chr = 'B';
    char attr = 0x07;  // 白
    //char str[] = "Hello";

    // 画面左上（B800:0000）に書き込み
    VGA_PUT(chr, attr, 0x0000);
    VGA_PUT(chr, attr, 0x0002);
    VGA_PUT(chr, attr, 0x0004);
    
    /* 何も表示されない　原因調査中
    int i=0;
    while (str[i] != '\0') {
    VGA_PUT(str[i], attr, i * 2);
    i++;
    }
    */

    while (1) __asm__ volatile ("hlt");
}
```

```
nasm -f bin boot.asm -o boot.bin
nasm -f elf32 entry.asm -o entry.o
gcc -m16 -Os -ffreestanding -fno-pic -fno-pie -fno-stack-protector -c test.c -o test.o
ld -m elf_i386 -T linker.ld --oformat binary -o kernel.bin entry.o test.o

dd if=/dev/zero of=os.img bs=1024 count=1
dd if=boot.bin of=os.img bs=512 conv=notrunc seek=0
dd if=kernel.bin of=os.img bs=512 conv=notrunc seek=1

qemu-system-i386 -drive format=raw,file=os.img
```

<img width="772" height="514" alt="截图 2026-08-19 21-29-33" src="https://github.com/user-attachments/assets/94ae6f3e-10a5-4ba0-8de2-5ad43f357e4d" />


# 逆アセンブル

Bを３回表示しているのに1回しかしてない。
どうしたら正しく逆アセンブルできるのか分からない
`0x07`等も消えている

```
objcopy -O binary test.o test.bin
objdump -D -b binary -m i8086 -M intel test.bin
```

```
00000000 <.data>:
   0:	14 00                	adc    al,0x0
   2:	00 00                	add    BYTE PTR [bx+si],al
   4:	00 00                	add    BYTE PTR [bx+si],al
   6:	00 00                	add    BYTE PTR [bx+si],al
   8:	01 7a 52             	add    WORD PTR [bp+si+0x52],di
   b:	00 01                	add    BYTE PTR [bx+di],al
   d:	7c 08                	jl     0x17
   f:	01 1b                	add    WORD PTR [bp+di],bx
  11:	0c 04                	or     al,0x4
  13:	04 88                	add    al,0x88
  15:	01 00                	add    WORD PTR [bx+si],ax
  17:	00 10                	add    BYTE PTR [bx+si],dl
  19:	00 00                	add    BYTE PTR [bx+si],al
  1b:	00 1c                	add    BYTE PTR [si],bl
  1d:	00 00                	add    BYTE PTR [bx+si],al
  1f:	00 00                	add    BYTE PTR [bx+si],al
  21:	00 00                	add    BYTE PTR [bx+si],al
  23:	00 3f                	add    BYTE PTR [bx],bh
	...
  2d:	06                   	push   es
  2e:	b8 00 b8             	mov    ax,0xb800
  31:	8e c0                	mov    es,ax
  33:	b0 42                	mov    al,0x42
  35:	b4 07                	mov    ah,0x7
  37:	26 67 89 02          	mov    WORD PTR es:[edx],ax
  3b:	07                   	pop    es
  3c:	f4                   	hlt    
  3d:	eb fd                	jmp    0x3c

```

