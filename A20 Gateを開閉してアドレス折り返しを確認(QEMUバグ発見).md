
# 目的
`8086`時代はメモリのアドレスが最大0x00000～0xFFFFFの1MBまでしか指定出来ませんでした。
20本のアドレス線しかないため、21bit目に相当するA20を利用できず、アドレスが1MiB(0x100000)以上になると折り返して0x0に戻ってしまいます。
32bitアドレス空間を持つ386では最大4GiBの物理アドレスを扱えるようになりましたが、8086時代に1MBの折り返しを利用したプログラムもあったらしく、互換性の為に`A20`という仕組みが作られました。
CPU通電直後ではA20が無効になっており、明示的にA20を有効化する必要があります。

今回はこのA20の開放について実験をします。

# A20開放の方法

A20を直接操作する代表的な方法として、`FAST A20`と呼ばれる方式と8042キーボードコントローラを利用する方法があります。
BIOSによっては以下で紹介しているようにA20開放の機能を実装しているものもありますが、内部的にはどちらかの方法で開放することになります。

難しい話は抜きにして、以下のどちらかのポートのビット1を立てると1MBよりも大きいメモリ空間を使用できるようになります。
Fast A20 方式 : ポート`0x92`のビット1が `1`:ON `0`:OFF
キーボードコントローラから制御する方法 : ポート`0x60`のビット1が `1`:ON `0`:OFF

# BIOS INT 15h / AX=2401h

```
grep -Rni "A20" src/
```

## `AX`レジスタを元に分岐する部分

```
INT 15h
  │
  └─ AH=24h
      │
      └─ AL=01h
          │
          └─ handle_152401()
               │
               └─ set_a20(1)
                    │
                    ├─ inb(0x92)
                    │
                    └─ outb(..., 0x92)
```

```src/system.c

...省略...

static void
handle_152401(struct bregs *regs)
{
    set_a20(1);
    set_code_success(regs);
}

...省略...

static void
handle_1524(struct bregs *regs)
{
    switch (regs->al) {
    case 0x00: handle_152400(regs); break;
    case 0x01: handle_152401(regs); break;
    case 0x02: handle_152402(regs); break;
    case 0x03: handle_152403(regs); break;
    default:   handle_1524XX(regs); break;
    }
}

...省略...

// INT 15h System Services Entry Point
void VISIBLE16
handle_15(struct bregs *regs)
{
    debug_enter(regs, DEBUG_HDL_15);
    switch (regs->ah) {
    case 0x24: handle_1524(regs); break;
    case 0x4f: handle_154f(regs); break;
    case 0x52: handle_1552(regs); break;
    case 0x53: handle_1553(regs); break;
    case 0x5f: handle_155f(regs); break;
    case 0x7f: handle_157f(regs); break;
    case 0x83: handle_1583(regs); break;
    case 0x86: handle_1586(regs); break;
    case 0x87: handle_1587(regs); break;
    case 0x88: handle_1588(regs); break;
    case 0x90: handle_1590(regs); break;
    case 0x91: handle_1591(regs); break;
    case 0xc0: handle_15c0(regs); break;
    case 0xc1: handle_15c1(regs); break;
    case 0xc2: handle_15c2(regs); break;
    case 0xe8: handle_15e8(regs); break;
    default:   handle_15XX(regs); break;
    }
}
```

## キーボード方式は未実装

```
grep -Rni "set_a20" src/
```

```src/x86.h

// PORT_A20 bitdefs
#define PORT_A20 0x0092
#define A20_ENABLE_BIT 0x02

...省略...

static inline u8 set_a20(u8 cond) {
    u8 val = inb(PORT_A20), a20_enabled = (val & A20_ENABLE_BIT) != 0;
    if (a20_enabled != !!cond)
        outb(val ^ A20_ENABLE_BIT, PORT_A20);
    return a20_enabled;
}
```

SeaBIOSのA20開放機能で8042方式は使っていないようです 。定義はありますが、どこからも参照されていません。
```
test@test-fujitsu:~/kaihatsu/seabios$ grep -Rni "A20Kybd" src/
src/std/LegacyBios.h:501:  UINT32                            A20Kybd : 1;      ///< A20 controller by keyboard controller.
test@test-fujitsu:~/kaihatsu/seabios$ 
```

# GRUB

https://gitlab.freedesktop.org/gnu-grub/grub/-/tree/master

GRUBではBIOS→0x92→キーボードの順番でA20の開放を試しています。
成功した時点で後続の処理は飛ばします。
GRUBが起動した時点では既にBIOSが開放している事が殆どだと思うので恐らくこの処理を通ることは少ないと思われます。

```grub-core/boot/i386/pc/startup_raw.S


```
sudo apt install build-essential gnu-efi qemu-system-x86 ovmf
```


```bash

gcc \
  -I/usr/include/efi -I/usr/include/efi/x86_64 \
  -fno-stack-protector -fpic -fshort-wchar \
  -c hello.c -o hello.o
  
ld \
  -nostdlib -shared -Bsymbolic \
  -L/usr/lib \
  -T /usr/lib/elf_x86_64_efi.lds \
  /usr/lib/crt0-efi-x86_64.o hello.o \
  -o hello.so -lgnuefi
  
  
objcopy --target=pei-x86-64 hello.so BOOTX64.EFI
```

```
mkdir -p esp/EFI/BOOT
cp BOOTX64.EFI esp/EFI/BOOT/
```

/*
 * grub_gate_a20(void)
 *
 * Gate address-line 20 for high memory.
 *
 * This routine is probably overconservative in what it does, but so what?
 *
 * It also eats any keystrokes in the keyboard buffer.  :-(
 */

grub_gate_a20:	
gate_a20_test_current_state:/* 既にA20が開放されていないか確認 */
	/* first of all, test if already in a good state */
	call	gate_a20_check_state
	testb	%al, %al
	jnz	gate_a20_try_bios
	ret

/* BIOS INT 15h / AX=2401hdeで開放出来るかを試す */
gate_a20_try_bios:
	/* second, try a BIOS call */
	pushl	%ebp
	call	prot_to_real

	.code16
	movw	$0x2401, %ax
	int	$0x15

	calll	real_to_prot
	.code32

	popl	%ebp
	call	gate_a20_check_state
	testb	%al, %al
	jnz	gate_a20_try_system_control_port_a
	ret

/* BIOSが対応していなければポート0x92から開放を試す */
gate_a20_try_system_control_port_a:
	/*
	 * In macbook, the keyboard test would hang the machine, so we move
	 * this forward.
	 */
	/* fourth, try the system control port A */
	inb	$0x92
	andb	$(~0x03), %al
	orb	$0x02, %al
	outb	$0x92

	call	gate_a20_check_state
	testb	%al, %al
	jnz	gate_a20_try_keyboard_controller
	ret

gate_a20_flush_keyboard_buffer:
gate_a20_flush_keyboard_buffer:
	inb	$0x64
	andb	$0x02, %al
	jnz	gate_a20_flush_keyboard_buffer
2:
	inb	$0x64
	andb	$0x01, %al
	jz	3f
	inb	$0x60
	jmp	2b
3:
	ret

/* それでも失敗したら8042(キーボードコントローラ)から開放を試す*/
gate_a20_try_keyboard_controller:
	/* third, try the keyboard controller */
	call    gate_a20_flush_keyboard_buffer

	movb	$0xd1, %al
	outb	$0x64
4:
	inb	$0x64
	andb	$0x02, %al
	jnz	4b

	movb	$0xdf, %al
	outb	$0x60
	call    gate_a20_flush_keyboard_buffer

	/* output a dummy command (USB keyboard hack) */
	movb	$0xff, %al
	outb	$0x64
	call    gate_a20_flush_keyboard_buffer

	call	gate_a20_check_state
	testb	%al, %al
	/* everything failed, so restart from the beginning */
	jnz	gate_a20_try_bios
	ret

gate_a20_check_state:
	/* iterate the checking for a while */
	movl	$100, %ecx
1:
	call	3f
	testb	%al, %al
	jz	2f
	loop	1b
2:
	ret
3:
	pushl	%ebx
	pushl	%ecx
	xorl	%eax, %eax
	/* compare the byte at 0x8000 with that at 0x108000 */
	movl	$GRUB_BOOT_MACHINE_KERNEL_ADDR, %ebx
	pushl	%ebx
	/* save the original byte in CL */
	movb	(%ebx), %cl
	/* store the value at 0x108000 in AL */
	addl	$0x100000, %ebx
	movb	(%ebx), %al
	/* try to set one less value at 0x8000 */
	popl	%ebx
	movb	%al, %ch
	decb	%ch
	movb	%ch, (%ebx)
	/* serialize */
	outb	%al, $0x80
	outb	%al, $0x80
	/* obtain the value at 0x108000 in CH */
	pushl	%ebx
	addl	$0x100000, %ebx
	movb	(%ebx), %ch
	/* this result is 0 if A20 is on or 1 if it is off */
	subb	%ch, %al
	/* restore the original */
	popl	%ebx
	movb	%cl, (%ebx)
	popl	%ecx
	popl	%ebx
	ret
```

# linux 0.11

https://github.com/jinghang/Linux011/blob/master/src/V0.11/boot/setup.s

初期のLinuxはキーボード方式を採用しているようです。

```boot/setup.s
! that was painless, now we enable A20

	call	empty_8042
	mov	al,#0xD1		! command write
	out	#0x64,al
	call	empty_8042
	mov	al,#0xDF		! A20 on
	out	#0x60,al
	call	empty_8042
```

# OvmfPkg(UEFIファームウェア)

https://github.com/tianocore/edk2/tree/master

```
git clone https://github.com/tianocore/edk2.git
cd edk2
git submodule update --init
```


# QEMUの問題

## 不具合

`A20=0`となっているのに折り返していない不具合を発見しました。

2022-06 のコミットで修正されています。
https://github.com/qemu/qemu/commit/9f9dcb96a46a60fcf95f7baebafa3ec5e2a1b5ce

英語は読めないので機械翻訳ですが
> これまで、ページング有効時（プロテクトモード）では正しくA20がマスクされていましたが、リアルモードの処理ではこのマスキングが行われていませんでした。
> そのため、BIOSなどでA20ラインを無効化した後、正しくアドレスが折り返さないという不具合が発生していました。
と書いてあります。

`0x000500`には`0xAA`の値、`0x100500には`0x55`の値を入れました。
本来ならば`0x1000000`で折り返す為、両者は同じアドレスになる筈ですがそれぞれ別の値が入っています。
```
(qemu) info registers
EAX=00000e00 EBX=00000000 ECX=00000000 EDX=00000080
ESI=00007c7c EDI=00000500 EBP=00000000 ESP=00007c00
EIP=00007c69 EFL=00000046 [---Z-P-] CPL=0 II=0 A20=0 SMM=0 HLT=1

...省略

(qemu) xp /1bx 0x500
0000000000000500: 0xaa
(qemu) xp /1bx 0x100500
0000000000100500: 0x55
```

筆者の使用しているQEMU
```
test@test-fujitsu:~/kaihatsu$ qemu-system-i386 --version
QEMU emulator version 6.2.0 (Debian 1:6.2+dfsg-2ubuntu6.31)
Copyright (c) 2003-2021 Fabrice Bellard and the QEMU Project developers
```

ついでなのでどんな不具合だったか見てみます

変更前
```c
paddr = addr;
```

変更後
```c
20_mask = x86_get_a20_mask(env); 
paddr = addr & a20_mask;
```

深追いしませんが、A20が無効の時はアドレスをマスクしてアドレスが折り返すようにしているのでしょう。

## QEMU最新版を入れる

面倒なのでQEMU最新版を導入することにします。
https://www.qemu.org/download/#source
 
makeしてから完了まで10分以上かかりました。
```bash
wget https://download.qemu.org/qemu-11.1.0.tar.xz
tar xvJf qemu-11.1.0.tar.xz
cd qemu-11.1.0
./configure
make -j$(nproc)
```

※筆者の環境に不足しておりビルドの為に追加で入れたソフト
```bash
sudo apt install python3-tomli ninja-build
```

自分でビルドしたQEMUはインストールしていません。
以下のコマンドを実行すると不具合のあるインストールしたQEMUを使ってしまうので
```bash
qemu-system-i386 -hda boot.bin -monitor stdio
```

以下のようにビルドしたQEMUのフォルダを指定して起動します。
```bash
~/kaihatsu/qemu-11.1.0/build/qemu-system-i386 -hda boot.bin -monitor stdio
```

# 動作確認

以下の流れでA20の開閉実験を行います。
※不具合のあるQEMUを使わないように注意

```
FAST A20 OFF
    ↓
8042 A20 OFF
    ↓
A20判定 → OFF

FAST A20 ON
    ↓
A20判定 → ON

FAST A20 OFF
    ↓
A20判定 → OFF

8042 A20 ON
    ↓
A20判定 → ON
```

```bash
nasm -f bin boot.asm -o boot.bin
~/kaihatsu/qemu-11.1.0/build/qemu-system-i386 -hda boot.bin -monitor stdio
```

<img width="740" height="455" alt="截图 2026-08-16 16-20-51" src="https://github.com/user-attachments/assets/7d1d3e46-5f49-4cbe-b117-5ebf4a3a74be" />

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
    
    ; [FAST A20] A20を閉じる
    and al,0xFD ;  0xFD=1111 1101 
    out 0x92,al
    
    ; キーボード A20を閉じる
    ; 8042 IBF=0
    .wait_ibf:
        in   al, 0x64
        test al, 2
        jnz  .wait_ibf

    ; D1 = Write Output Port
    mov  al, 0xD1
    out  0x64, al

    ; bit0 = 1 : RESET解除
    ; bit1 = 0 : A20 OFF
    mov  al, 0xDD ; 0xDD = 11011101
    out  0x60, al
    
    call print_a20_status
    
    ; [FAST A20] A20 ON
    in  al, 0x92
    or  al, 0x02 ; 0x02=00000010
    out 0x92, al
    
    call print_a20_status
    
    ; [FAST A20] A20を閉じる
    and al,0xFD
    out 0x92,al
    
    call print_a20_status
    
    ; キーボード A20 を開ける
    ; 8042 IBF=0
    .wait_ibf2:
        in   al, 0x64
        test al, 2
        jnz  .wait_ibf2

    ; D1 = Write Output Port
    mov  al, 0xD1
    out  0x64, al

    ; bit0 = 1 : RESET解除
    ; bit1 = 1 : A20 ON
    mov  al, 0xDF ; 0xDF = 11011111
    out  0x60, al
    
    call print_a20_status
    
hlt_loop:
    cli
    hlt
    jmp hlt_loop

; ------------------------------
; A20 の状態を確認して表示する
; ------------------------------
print_a20_status:
    push ax
    push si
    push es
    push ds
    push di

    ; 0x0000:0x0500 = 0xAA
    xor ax, ax
    mov es, ax
    mov di, 0x0500
    mov byte [es:di], 0xAA

    ; 0xFFFF:0x0510 = 0x55
    mov ax, 0xFFFF
    mov es, ax
    mov di, 0x0510
    mov byte [es:di], 0x55

    ; 0x0000:0x0500 を読み出し
    xor ax, ax
    mov ds, ax
    mov di, 0x0500
    mov al, [ds:di]

    ; 比較
    cmp al, 0x55
    je .a20_off

    mov si, msg_on
    jmp .print

.a20_off:
    mov si, msg_off

.print:
    call putstr

    pop di
    pop ds
    pop es
    pop si
    pop ax
    ret

; ----------------------
; void putstr(char *si)
; ----------------------
putstr:
    lodsb           ; AL = [DS:SI], SI++
    test al, al     ; 終端(0)なら終了
    jz .done

    cmp al, 0x0A    ; '\n' ?
    je .newline

    mov ah, 0x0E    ; TTY出力機能
    int 0x10
    jmp putstr

.newline:
    ; 改行 = CR + LF
    mov ah, 0x0E
    mov al, 0x0D    ; CR
    int 0x10
    mov al, 0x0A    ; LF
    int 0x10
    jmp putstr

.done:
    ret

msg_on:  db 'A20 ON', 0x0D, 0x0A, 0
msg_off: db 'A20 OFF', 0x0D, 0x0A, 0
    
times 510-($-$$) db 0
dw 0xAA55
```

