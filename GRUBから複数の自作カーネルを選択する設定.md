# 目的

`grub.cfg`を編集し、2つのOSを選択出来る様にします。
OSと言っても実験用に書いた画面に文字を表示するだけのプログラムですが。。。

[GRUBからCカーネルを起動する](https://qiita.com/earthen94/items/a99f9081cbfdd59eb8ea)

# 選択画面の設定

`grub.cfg`

`timeout`はOS選択画面を表示する時間を設定可能、`0`にすると非表示、`1`にすると選択しない限り永遠に表示し続けます。

`menuentry`で設定したOSがOS選択画面の選択肢となります。

```grub.cfg
set timeout=-1
set default=0

menuentry "mykernel 1" {
    multiboot /boot/kernel.bin
    boot
}

menuentry "mykernel 2" {
    multiboot /boot/kernel2.bin
    boot
}
```

# 実験用コード

```bash
rm -r tmp
mkdir tmp

; カーネル1
nasm -f elf32 start.asm -o tmp/start.o
gcc -m32 -ffreestanding -nostdlib -c kernel.c -o tmp/kernel.o
ld -m elf_i386 -T link.ld -o tmp/kernel.bin tmp/start.o tmp/kernel.o

; カーネル2
nasm -f elf32 start2.asm -o tmp/start2.o
gcc -m32 -ffreestanding -nostdlib -c kernel2.c -o tmp/kernel2.o
ld -m elf_i386 -T link.ld -o tmp/kernel2.bin tmp/start2.o tmp/kernel2.o

mkdir -p iso/boot/grub
cp tmp/kernel.bin iso/boot/kernel.bin
cp tmp/kernel2.bin iso/boot/kernel2.bin
cp grub.cfg iso/boot/grub/grub.cfg
grub-mkrescue -o myos.iso iso
```

<details>
<summary>start.asm</summary>

```start.asm
bits 32
global start
extern kmain

align 4
mb_header:
    dd 0x1BADB002        ; magic
    dd 0x0               ; flags
    dd -(0x1BADB002 + 0x0) ; checksum

start:
    cli
    mov esp, 0x90000     ; 適当なスタック
    call kmain
    hlt
```

</details>


<details>
<summary>start2.asm</summary>

```start2.asm
bits 32
global start
extern kmain2

align 4
mb_header:
    dd 0x1BADB002        ; magic
    dd 0x0               ; flags
    dd -(0x1BADB002 + 0x0) ; checksum

start:
    cli
    mov esp, 0x90000     ; 適当なスタック
    call kmain2
    hlt
```

</details>

<details>
<summary>kernel.c</summary>

```kernel.c
void kmain(void) {
    volatile unsigned char *vid = (unsigned char *)0xB8000;
    
    // 画面全体を空白（0x20）＋白文字／黒背景（0x07）で埋める
    for (int i = 0; i < 80 * 25 * 2; i += 2) {
        vid[i]     = ' ';   // 文字コード
        vid[i + 1] = 0x07;  // 属性（白／黒）
    }
    
    const char *msg = "GRUB: Kernel 1 Loaded OK";
    int i = 0;
    for (int j = 0; msg[j]; j++) {
        vid[i++] = msg[j];   // ASCII
        vid[i++] = 0x0A;     // 緑文字／黒背景
    }
    for (;;) asm ("hlt");
}
```

</details>

<details>
<summary>kernel2.c</summary>

```kernel2.c
void kmain2(void) {
    volatile unsigned char *vid = (unsigned char *)0xB8000;
    
    // 画面全体を空白（0x20）＋白文字／黒背景（0x07）で埋める
    for (int i = 0; i < 80 * 25 * 2; i += 2) {
        vid[i]     = ' ';   // 文字コード
        vid[i + 1] = 0x07;  // 属性（白／黒）
    }
    
    const char *msg = "GRUB: Kernel 2 Loaded OK";
    int i = 0;
    for (int j = 0; msg[j]; j++) {
        vid[i++] = msg[j];   // ASCII
        vid[i++] = 0x0C;     // 赤文字／黒背景
    }
    for (;;) asm ("hlt");
}
```

</details>


<details>
<summary>link.ld</summary>

```link.ld
OUTPUT_FORMAT(elf32-i386)
ENTRY(start)
SECTIONS {
    . = 0x100000;
    .text : { *(.text) }
    .data : { *(.data) }
    .bss  : { *(.bss) }
}
```

</details>

# 動作確認

## qemu

```
qemu-system-i386 -cdrom myos.iso
```
<img width="772" height="514" alt="截图 2026-08-12 20-24-23" src="https://github.com/user-attachments/assets/5d9acb73-5982-4edf-a2e9-6f55823b745f" />
<img width="772" height="514" alt="截图 2026-08-12 20-24-27" src="https://github.com/user-attachments/assets/c9f58a6e-038f-476d-a9e3-b78fe6e893cd" />
<img width="772" height="514" alt="截图 2026-08-12 20-24-39" src="https://github.com/user-attachments/assets/dbf41b92-fd4a-4f0c-8ed7-4c3b2d7bb00c" />


## dynabook SS M10 11L/2実機

```
sudo dvd+rw-format -blank=fast /dev/sr0
sudo growisofs -dvd-compat -Z /dev/sr0=myos.iso
```

<img width="4096" height="3072" alt="7129c1e6de648" src="https://github.com/user-attachments/assets/ed31d395-ac76-4606-8129-91226ca3a136" />
<img width="4096" height="3072" alt="430459d722f688" src="https://github.com/user-attachments/assets/82a38181-14cd-4f30-9e24-996c6111ba93" />
<img width="4096" height="3072" alt="18a66cb4fac58" src="https://github.com/user-attachments/assets/5dba192e-1455-4814-b65f-40cc758901d5" />



