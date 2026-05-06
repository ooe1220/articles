# 起動CDの作成

```bash
nasm -f bin boot.asm -o boot.bin

mkdir iso
cp boot.bin iso/

xorriso -as mkisofs \
  -o os.iso \
  -b boot.bin \
  -c boot.cat \
  -no-emul-boot \
  -boot-load-size 4 \
  iso

qemu-system-i386 -cdrom os.iso -m 512
```

```boot.asm
BITS 16
ORG 0

start:
    cli
    cld

    xor ax, ax
    mov ss, ax
    mov sp, 0x7C00

    push cs
    pop ds

    call here
here:
    pop si
    add si, msg - here

    mov ax, 0xB800
    mov es, ax
    xor di, di

.print:
    lodsb
    test al, al
    jz .hang

    mov ah, 0x07        ; 属性（白）
    stosw               ; [ES:DI] = AX (文字+属性)
    jmp .print

.hang:
    cli
    hlt
    jmp .hang

msg db "Hello------", 0

times 2048-($-$$) db 0
```

# 起動

## qemu
```bash
qemu-system-i386 -cdrom os.iso -m 512
```
<img width="724" height="462" alt="image" src="https://github.com/user-attachments/assets/3b57306c-34ec-4297-876c-f2848713c29f" />


## 実機

前回書き込んだデータが残っている場合は一旦初期化する。
```
 linuxlite  ~  kaihatsu  sudo dvd+rw-format -blank=fast /dev/sr0
[sudo] password for linuxlite: 
* BD/DVD±RW/-RAM format utility by <appro@fy.chalmers.se>, version 7.1.
* 4.7GB DVD-RW media in Sequential mode detected.
* blanking 100.0%
```

`-dry-run`をつけて試してから、DVDに書き込む。

```bash
 linuxlite  ~  kaihatsu  sudo growisofs -dry-run -dvd-compat -Z /dev/sr0=os.iso
Executing 'builtin_dd if=os.iso of=/dev/sr0 obs=32k seek=0'
 linuxlite  ~  kaihatsu  sudo growisofs -dvd-compat -Z /dev/sr0=os.iso
Executing 'builtin_dd if=os.iso of=/dev/sr0 obs=32k seek=0'
/dev/sr0: "Current Write Speed" is 2.0x1352KBps.
builtin_dd: 192*2KB out @ average infx1352KBps
/dev/sr0: flushing cache
/dev/sr0: updating RMA
/dev/sr0: closing disc
/dev/sr0: reloading tray
```
※CDに書き込む場合は以下を試す
[PuppyLinuxを試す](https://qiita.com/earthen94/items/9e8a843d9da3e6bd6032)

<img width="2359" height="1769" alt="c65630911699b" src="https://github.com/user-attachments/assets/591a3169-cda5-4469-86d8-ff3c24352865" />


# 検証環境
機種 : VOSTRO 1540
CPU : Intel(R) Celeron(R) CPU P4600 @ 2.00GHz
MEM : 1.8Gi
OS : Linux Lite 6.6
NASM : 2.15.05
GDB : GNU gdb (Ubuntu 12.1-0ubuntu1~22.04.2) 12.1
※実家に帰省中。昔のパソコン。

<img width="2359" height="1769" alt="903464b4cc64a" src="https://github.com/user-attachments/assets/94b00e9c-15c7-49ff-b4ae-b41948bc3afb" />

