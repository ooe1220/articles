
# 仕様
`MSDOS`向けの`COM`ファイルをLinux上で実行する為のエミュレータの雛形を作りました。
今回は下に掲載している`hello.asm`を実行することだけを目的としているため機能はかなり省いています。
`IVT`は実装せず`INT`命令が呼ばれたらCASE文で分岐して直接実装しています。

今回の実装は以下の命令のみです。
- `mov r, imm8`
- `mov r, imm16`
- `int 21h`

# 実行するCOMファイル

```bash
nasm -f bin hello.asm -o hello.com
ndisasm -b 16 -o 0x100 hello.com
```

```hello.asm
org 0x100
mov ah, 0009h
mov dx, msg
int 21h

mov ax, 4C00h ; AH:DOS機能番号 AL:終了番号
int 21h

msg db 'Hello, World!$'
```

## MS-DOSで検証

MS-DOSで動作させ、正しいCOMが生成されていることを確認
<img width="4096" height="3072" alt="6d931eeb6c514" src="https://github.com/user-attachments/assets/d37c3612-17e0-4694-8b34-617d1d84d1ec" />

# 逆アセンブルして命令長を確認

```
test@test-fujitsu:~/kaihatsu$ ndisasm -b 16 -o 0x100 hello.com
00000100  B409              mov ah,0x9
00000102  BA0C01            mov dx,0x10c
00000105  CD21              int 0x21
00000107  B8004C            mov ax,0x4c00
0000010A  CD21              int 0x21
```

# MOV r8, imm8(8ビットレジスタへの即値転送)のオペコードを調べる

命令長:2バイト
オペコードの範囲:B0-B7

```movtest.asm
mov al, 0aah
mov cl, 0aah
mov dl, 0aah
mov bl, 0aah
mov ah, 0aah
mov ch, 0aah
mov dh, 0aah
mov bh, 0aah
```

```bash
test@test-fujitsu:~/kaihatsu$ nasm -f bin movtest.asm -o movtest.com
test@test-fujitsu:~/kaihatsu$ ndisasm -b 16 -o 0x100 movtest.com
00000100  B0AA              mov al,0xaa
00000102  B1AA              mov cl,0xaa
00000104  B2AA              mov dl,0xaa
00000106  B3AA              mov bl,0xaa
00000108  B4AA              mov ah,0xaa
0000010A  B5AA              mov ch,0xaa
0000010C  B6AA              mov dh,0xaa
0000010E  B7AA              mov bh,0xaa
```

# MOV r16, imm16(16ビットレジスタへの即値転送)のオペコードを調べる

命令長:3バイト
オペコードの範囲:B8-BF

```movtest.asm
mov ax, 0aah
mov cx, 0aah
mov dx, 0aah
mov bx, 0aah
mov sp, 0aah
mov bp, 0aah
mov si, 0aah
mov di, 0aah
```

```bash
test@test-fujitsu:~/kaihatsu$ nasm -f bin movtest.asm -o movtest.com
test@test-fujitsu:~/kaihatsu$ ndisasm -b 16 -o 0x100 movtest.com
00000100  B8AA00            mov ax,0xaa
00000103  B9AA00            mov cx,0xaa
00000106  BAAA00            mov dx,0xaa
00000109  BBAA00            mov bx,0xaa
0000010C  BCAA00            mov sp,0xaa
0000010F  BDAA00            mov bp,0xaa
00000112  BEAA00            mov si,0xaa
00000115  BFAA00            mov di,0xaa
```

# C言語実装

以下の様に動作します。
```bash
test@test-fujitsu:~/kaihatsu$ gcc dosvm.c -o dosvm
test@test-fujitsu:~/kaihatsu$ ./dosvm hello.com
Hello, World!test@test-fujitsu:~/kaihatsu$ 
```

```dosvm.c
/*
 * dosvm.c
 * gcc dosvm.c -o dosvm
 * ./dosvm hello.com
 * 
 * CS,DSは常時0としている
 */
 
 
#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>

#define MEM_SIZE  65536 // 1セグメント分のメモリ 65,536 バイト = 64 KB​
#define LOAD_ADDR 0x100 // DOSはCS:IP = xxxx:0100へCOMを読み込む

static uint8_t mem[MEM_SIZE];

typedef union {
    uint16_t w;                     // 16ビットとして読む
    struct { uint8_t lo, hi; } b;   // 8ビットとして読む
} reg_t;

/* レジスタ群 */
static reg_t AX, BX, CX, DX, SI, DI, BP, SP;
static uint16_t IP;

/* レジスタ番号 → 実体”に変換する表(8086の命令セット仕様で決まっている順番) */
static reg_t *R16[8] = { &AX, &CX, &DX, &BX, &SP, &BP, &SI, &DI };

/* 8bit レジスタ（AL / CL / DL / BL / AH / CH / DH / BH）​ へのポインタ表 */
static uint8_t *R8[8] = {
    &AX.b.lo, &CX.b.lo, &DX.b.lo, &BX.b.lo,
    &AX.b.hi, &CX.b.hi, &DX.b.hi, &BX.b.hi
};

/* INT 21h — MS-DOS API 模倣 */
static void int21(void) {
    switch (AX.b.hi) {
    case 0x09: { /* AH=09h : 末端'$'の文字列を表示 DS:DX */
        uint16_t off = DX.w;
        while (mem[off] != '$')
            putchar(mem[off++]);
        break;
    }
    case 0x4C: /* AH=4ch DOSへ返る */
        exit(AX.b.lo); // 実際には エミュレータごと終了させる
        break;
    default:
        fprintf(stderr, "INT 21h AH=%02X not implemented\n", AX.b.hi);
        exit(1);
    }
}

/* 実行ループ */
static void run(void) {
    for (;;) {
        uint8_t op = mem[IP++];//オペコードの命令長分IPを進める(1バイトを越える場合は個別の分岐内で進める)

        /* MOV r8, imm8のオペコード範囲 */
        if (op >= 0xB0 && op <= 0xB7) { 
            *R8[op - 0xB0] = mem[IP++]; // レジスタに即値を読み込む
        }
        
        /* MOV r16, imm16のオペコード範囲 */
        else if (op >= 0xB8 && op <= 0xBF) {
        /* レジスタに即値を読み込む。00AAHならAA00Hの様に低8バイト→高8ビットの順に並んでいる為loから先 */
            uint8_t lo = mem[IP++];
            uint8_t hi = mem[IP++];
            R16[op - 0xB8]->w = (hi << 8) | lo; // 低8バイトと高8バイトの順番を入れ替えレジスタへ格納
        }
        
        /* int命令 */
        else if (op == 0xCD) { 
            uint8_t n = mem[IP++]; // 機能番号を取得
            if (n == 0x21)  /* MSDOS API呼び出し */
                int21();
            else {
                fprintf(stderr, "Unsupported INT %02X\n", n);
                exit(1);
            }
        }
        
        /* 未実装の命令 */
        else {
            fprintf(stderr, "Unknown opcode %02X @ %04X\n", op, IP - 1);
            exit(1);
        }
    }
}

int main(int argc, char *argv[]) {

    // COMファイル名が指定されていない場合
    if (argc < 2) {
        fprintf(stderr, "Usage: %s program.com\n", argv[0]);
        return 1;
    }

    // COMファイルを開く
    FILE *f = fopen(argv[1], "rb");
    if (!f) {
        perror("fopen");
        return 1;
    }

    // ファイルの大きさを計算
    fseek(f, 0, SEEK_END);
    long sz = ftell(f);
    rewind(f); // ファイルポインタを 先頭に戻す

    if (sz > MEM_SIZE - LOAD_ADDR) { // メモリの大きさを越えていたらエラー
        fprintf(stderr, "COM file too large\n");
        fclose(f);
        return 1;
    }

    fread(&mem[LOAD_ADDR], 1, sz, f); // COM ファイルの中身をメモリに読み込む
    fclose(f);

    IP = LOAD_ADDR; // COMを実行する為にIP=0x100に合わせる。(CSは実装しておらず常に0)
    SP.w = 0xFFFE; // スタックポインタ初期化(今回は未使用)

    run();
    return 0;
}
```


