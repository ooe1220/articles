# 起動CDの作成
```bash
nasm -f bin boot.asm -o boot.bin

mkdir iso
cp boot.bin iso/

#  -b boot.bin   : このファイルを起動用に使う
#  -c boot.cat   : 起動情報
#  -no-emul-boot : 先頭512バイトのMBR方式でなく、boot.catを参照して起動
#  -boot-load-size 1 : 1セクタ(2048バイト)読む
xorriso -as mkisofs \
  -o os.iso \
  -b boot.bin \
  -c boot.cat \
  -no-emul-boot \
  -boot-load-size 1 \
  iso
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

# 起動

## qemu
```bash
qemu-system-i386 -cdrom os.iso -m 512
```
<img width="724" height="462" alt="image" src="https://github.com/user-attachments/assets/3b57306c-34ec-4297-876c-f2848713c29f" />

## 実機

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

# 検証環境
機種 : VOSTRO 1540
CPU : Intel(R) Celeron(R) CPU P4600 @ 2.00GHz
MEM : 1.8Gi
OS : Linux Lite 6.6
NASM : 2.15.05
GDB : GNU gdb (Ubuntu 12.1-0ubuntu1~22.04.2) 12.1
※実家に帰省中。昔のパソコン。
