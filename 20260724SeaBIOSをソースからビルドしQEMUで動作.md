

# 目的
SeaBIOSを自分のパソコン上でビルドして動作させる手順を書きます。

# ソースの取得及びビルド

```
git clone --depth 1 https://git.seabios.org/seabios.git
cd seabios
make
```

以下が表示されれば成功
```bash
Total size: 181792  Fixed: 90560  Free: 80352 (used 69.3% of 256KiB rom)
  Creating out/bios.bin
```

## ビルドエラーが出てやったこと

pythonが見つからなかった。

```bash
/bin/sh: 1: python: not found
make: *** [Makefile:168：out/romlayout16.lds] 错误 127
```

```
# python3 の場所を確認
ls -l /usr/bin/python*

# python -> python3 のシンボリックリンクを作成
sudo ln -sf /usr/bin/python3 /usr/bin/python

# 確認
python --version
```

# 動作確認

## ビルドしたBIOSが立ち上がるかを確認

```bash
qemu-system-i386 -bios out/bios.bin
```

<img width="772" height="514" alt="截图 2026-07-24 20-10-59" src="https://github.com/user-attachments/assets/079ab377-16c7-48c2-851b-7c97c141c7b7" />



## QEMUの画面は表示が多く流れてしまいログが追えない為、Linuxの端末上に出す。

```bash
qemu-system-i386 -bios out/bios.bin -nographic
```

```bash
SeaBIOS (version f93d9a4)


iPXE (https://ipxe.org) 00:03.0 CA00 PCI2.10 PnP PMM+06FCBAC0+06F0BAC0 CA00
                                                                               


Booting from Hard Disk...
Boot failed: could not read the boot disk

Booting from Floppy...
Boot failed: could not read the boot disk

Booting from DVD/CD...
Boot failed: Could not read from CDROM (code 0003)
Booting from ROM...
iPXE (PCI 00:03.0) starting execution...ok
iPXE initialising devices...ok



iPXE 1.21.1+git-20220113.fbbdc3926-0ubuntu1 -- Open Source Network Boot Firmware
 -- https://ipxe.org
Features: DNS HTTP HTTPS iSCSI NFS TFTP VLAN AoE ELF MBOOT PXE bzImage Menu PXEX
T

net0: 52:54:00:12:34:56 using 82540em on 0000:00:03.0 (Ethernet) [open]
  [Link:up, TX:0 TXE:0 RX:0 RXE:0]
Configuring (net0 52:54:00:12:34:56)...... ok
net0: 10.0.2.15/255.255.255.0 gw 10.0.2.2
net0: fec0::5054:ff:fe12:3456/64 gw fe80::2
net0: fe80::5054:ff:fe12:3456/64
Nothing to boot: No such file or directory (https://ipxe.org/2d03e13b)
No more network devices

No bootable device.            
```

# ソースを少し変えてからビルドして実行

変更前
```src/bootsplash.c
/****************************************************************
 * VGA text / graphics console
 ****************************************************************/

void
enable_vga_console(void)
{
    dprintf(1, "Turning on vga text mode console\n");
    struct bregs br;

    /* Enable VGA text mode */
    memset(&br, 0, sizeof(br));
    br.ax = 0x0003;
    call16_int10(&br);

    // Write to screen.
    printf("SeaBIOS (version %s)\n", VERSION);
    display_uuid();
}
```

変更後

`SeaBIOS`→`SeaBIOSabcd`へ変更した。

```src/bootsplash.c
/****************************************************************
 * VGA text / graphics console
 ****************************************************************/

void
enable_vga_console(void)
{
    dprintf(1, "Turning on vga text mode console\n");
    struct bregs br;

    /* Enable VGA text mode */
    memset(&br, 0, sizeof(br));
    br.ax = 0x0003;
    call16_int10(&br);

    // Write to screen.
    printf("SeaBIOSabcd (version %s)\n", VERSION);
    display_uuid();
}
```

QEMUを起動した時の表示が変わった為、ビルドしたBIOSが立ち上がっている事が分かる。
```bash
SeaBIOSabcd (version rel-1.17.0-16-gf93d9a49-dirty-20260724_203512-test-fujitsu)



iPXE (https://ipxe.org) 00:03.0 CA00 PCI2.10 PnP PMM+06FCBAC0+06F0BAC0 CA00
                                                                               


Booting from Hard Disk...
Boot failed: could not read the boot disk

...(省略)...
```

# ビルドしたSeaBIOSからブートローダを立ち上げてみる

自分でビルドした`SeaBIOS`から自作ブートローダを起動することに成功した。
起動失敗のエラー文言が減り、`QEMU`の`GUI`ウインドウからも`SeaBIOSabcd`の表示が確認でき、
自分でビルドしたBIOSが動いていることが証明された。

```bash
nasm -f bin boot.asm -o boot.bin
qemu-system-i386 -bios out/bios.bin -drive file=boot.bin,format=raw 
```

<img width="772" height="514" alt="截图 2026-07-24 20-47-58" src="https://github.com/user-attachments/assets/c5e5ec87-fb35-4bce-9c49-14a89e626dac" />

```boot.asm
org 0x7C00

start:
    ; セグメント初期化
    xor ax, ax
    mov ds, ax
    mov es, ax

    ; スタック設定
    mov ss, ax
    mov sp, 0x7C00
    
    ; ===== 文字列表示 =====
    mov si, msg
print_loop:
    lodsb               ; SI から 1 文字 AL に読み込む
    cmp al, 0
    je hlt_loop         ; NULL なら終了
    mov ah, 0x0E        ; INT 10h: Teletype output
    mov bh, 0x00        ; page 0
    int 0x10
    jmp print_loop

hlt_loop:
    hlt
    jmp hlt_loop
    
msg:
    db "System booted from custom-built SeaBIOS via INT10.", 0

times 510-($-$$) db 0
dw 0xAA55
```

