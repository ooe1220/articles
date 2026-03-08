# 初めに

# 検証用カーネル起動までの儀式

<details>
<summary>boot.asm</summary>

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
    mov al, 2            ; 読み込むセクタ数
    mov ch, 0            ; シリンダ = 0
    mov dh, 0            ; ヘッド = 0
    mov cl, 2            ; セクタ = 2 (ブートローダの次)
    mov dl, 0x80         ; ドライブ番号=HDD
    mov bx, 0x7E00       ; ES:BX = 読み込み先
    int 0x13
    jc disk_error
    
    jmp 0x0000:0x7E00    ; 読み込んだコードへジャンプ

disk_error:
    hlt
    jmp disk_error

times 510-($-$$) db 0
dw 0xAA55
```

</details>

<details>
<summary>16to32.asm</summary>

```16to32.asm
bits 16
global start
extern kernel_main


start:
    cli
    xor ax, ax
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x7C00
    
    mov ax, 0x0003
    int 0x10 

    ; GDTロード
    lgdt [gdt_descriptor]

    ; プロテクトモード有効化
    mov eax, cr0
    or eax, 1
    mov cr0, eax

    ; 32ビットコードへ移行
    jmp 0x08:pm_start

; -----------------------------
gdt_start:
    dq 0x0000000000000000            ; NULL

gdt_code:
    dw 0xFFFF                        ; limit 0-15
    dw 0x0000                        ; base 0-15
    db 0x00                          ; base 16-23
    db 0x9A                          ; code segment
    db 0xCF                          ; flags
    db 0x00                          ; base 24-31

gdt_data:
    dw 0xFFFF
    dw 0x0000
    db 0x00
    db 0x92                          ; data segment
    db 0xCF
    db 0x00
gdt_end:

gdt_descriptor:
    dw gdt_end - gdt_start - 1
    dd gdt_start

; -----------------------------
[bits 32]
pm_start:
    ; データセグメント設定
    mov ax, 0x10
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ss, ax
    mov esp, 0x9FC00
    
    call kernel_main

.hlt_loop:
    hlt
    jmp .hlt_loop
```

</details>

<details>
<summary>linker.ld</summary>

```linker.ld
ENTRY(start)

SECTIONS {
    . = 0x7E00;

    .text : {
        *(.text*)
    }

    .rodata : {
        *(.rodata*)
    }

    .data : {
        *(.data*)
    }

    .bss : {
        *(.bss*)
        *(COMMON)
    }
}
```

</details>

# CPU例外
```kernel.c
typedef unsigned int uint32_t;
typedef unsigned short uint16_t;
typedef unsigned char uint8_t;

void putc(char c) {
    static int pos = 0;
    volatile unsigned short* vram = (unsigned short*)0xB8000;
    vram[pos++] = 0x0F00 | c; //属性 背景色 = 0x0 = 黒 文字色 = 0xF = 白
}

void puts(const char* s) {
    while (*s) putc(*s++);
}

/*
 IDT 1個分の構造体
*/
struct idt_entry {
    uint16_t offset_low;  // ISR アドレス下位 16bit
    uint16_t selector;     // コードセグメント
    uint8_t  zero;         // 常に 0
    uint8_t  type_attr;
    uint16_t offset_high;  // ISR アドレス上位 16bit
} __attribute__((packed));

/*
 * IDTR に渡す構造体
 * lidt 命令は
 *   limit : IDT 全体の大きさ - 1
 *   base  : IDT 配列の先頭アドレス
 *  が必要
 */
struct idt_ptr {
    uint16_t limit;
    uint32_t base;
} __attribute__((packed));


/*
 * IDT 本体
 * 256 個分（CPU 仕様）
 *
 * 0〜31   : CPU 例外
 * 32〜47  : IRQ (PIC)
 * 48〜255 : 
 */
static struct idt_entry idt[256];

/*
 * IDTに1個分処理を設定する関数
 *
 * n       : IDT 番号（例外番号 / IRQ 番号）
 * handler : ISR のアドレス
 */
void idt_set_gate(int n, uint32_t handler) {
    idt[n].offset_low  = handler & 0xFFFF;
    idt[n].selector    = 0x08; // CS(カーネル)の選択子
    idt[n].zero        = 0;
    idt[n].type_attr   = 0x8E;
    idt[n].offset_high = handler >> 16;
}

/*
 * IDTの空表をCPUへ登録
 */
void idt_init(void) {
    struct idt_ptr idtp; // lidt は「値」を読むだけ。ローカル変数で問題無し
    idtp.limit = sizeof(idt) - 1;
    idtp.base  = (uint32_t)&idt;

    asm volatile("lidt (%0)" :: "r"(&idtp));
    //asm volatile("lidt %0" : : "m"(idtp));
}

void isr0_handler()
{
    puts("DIVIDE ERROR");
    while(1);
}

void isr6_handler()
{
    puts("INVALID OPCODE");
    while(1);
}

void isr13_handler(uint32_t error)
{
    puts("GENERAL PROTECTION");
    while(1);
}

void isr14_handler(uint32_t error)
{
    puts("PAGE FAULT");
    while(1);
}

int kernel_main() {
    asm volatile("cli"); 
    idt_set_gate(0, (uint32_t)isr0_handler);
    idt_set_gate(6, (uint32_t)isr6_handler);
    idt_set_gate(13, (uint32_t)isr13_handler);
    idt_set_gate(14, (uint32_t)isr14_handler);
    idt_init();
    asm volatile("sti"); 
    
    int a=1;
    int b=0;
    int c=a/b;

    //asm volatile ("ud2");
    
    while(1);
}
```

# 実行

コンパイルして起動用imgを作成

```bash
nasm -f bin boot.asm -o boot.bin
gcc -m32 -ffreestanding -c kernel.c -o kernel.o
nasm -f elf32 16to32.asm -o 16to32.o
ld -m elf_i386 -T linker.ld -o kernel.elf 16to32.o kernel.o
objcopy -O binary kernel.elf kernel.bin
cat boot.bin kernel.bin > disk.img
```

## QEMU上で実行

```bash
qemu-system-i386 -hda disk.img
```
<img width="772" height="514" alt="图片" src="https://github.com/user-attachments/assets/71f65248-0312-4c94-9710-d5bc9793bfa8" />


## 実機上で実行

```bash
sudo dd if=disk.img of=/dev/sdb
```
![e1de739ad77e88](https://github.com/user-attachments/assets/d6d310fe-f581-442f-bc3b-114f0c7c82ee)
![c40e60cebc9fa8](https://github.com/user-attachments/assets/3b3b480e-95f0-4ac0-931e-d75ba2d21d73)

