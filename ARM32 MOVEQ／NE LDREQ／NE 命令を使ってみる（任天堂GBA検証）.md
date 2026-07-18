
# 目的
筆者はARM32のアセンブリを勉強しています。
今回は`MOVEQ/NE LDREQ/NE` 命令を使ってみます。
これらの命令を使うと分岐が消え、アセンブリのコードが飛び飛びになるのを防げます。

`mov`と`ldr`の違いは過去の記事で検証しています。
[32ビットARMアセンブリのMOV命令で使える即値の仕組みを理解する](https://qiita.com/earthen94/items/abb68a6bc83819084696)

# 検証

```main.c
extern int cmp_eq_mov(int a, int b);
extern int cmp_eq_ldr(int a, int b);

#include "gfx.h"

void main(void)
{
    gfx_init();
    
    int res = 9999;
    
    putchar('\n');
    print("MOV TEST EQ=0 NE=1");
    
    putchar('\n');
    res = cmp_eq_mov(10,10);
    print("10 10 RES=");
    print_dec(res);
    
    putchar('\n');
    res = cmp_eq_mov(10,11);
    print("10 11 RES=");
    print_dec(res);
    
    putchar('\n');
    putchar('\n');
    print("LDR TEST EQ=10000 NE=20000");
    
    res = cmp_eq_ldr(10,10);
    print("10 10 RES=");
    print_dec(res);
    
    putchar('\n');
    res = cmp_eq_ldr(10,11);
    print("10 11 RES=");
    print_dec(res);

    while (1);
};
```

```asmtest.s
.text
    .global cmp_eq_mov
    .global cmp_eq_ldr

cmp_eq_mov:
    cmp r0, r1
    moveq r0, #0
    movne r0, #1
    
    mov pc, lr
    
cmp_eq_ldr:
    cmp r0, r1
    ldreq r0, =10000
    ldrne r0, =20000
    
    mov pc, lr
```

# 動作確認

<img width="2048" height="1536" alt="460b5e34d2c98" src="https://github.com/user-attachments/assets/5e3846d0-9498-4a63-bd6f-e8f4f45ce7c2" />

# ビルドコマンド

```
rm -rf tmp
mkdir tmp

arm-none-eabi-as header.s -o tmp/header.o
arm-none-eabi-as asmtest.s -o tmp/asmtest.o
arm-none-eabi-gcc -c main.c -o tmp/main.o -nostdlib -ffreestanding
arm-none-eabi-gcc -c font.c -o tmp/font.o -nostdlib -ffreestanding
arm-none-eabi-gcc -c gfx.c -o tmp/gfx.o -nostdlib -ffreestanding
arm-none-eabi-ld tmp/header.o tmp/asmtest.o tmp/main.o tmp/font.o tmp/gfx.o -T link.ld -o tmp/out.elf
arm-none-eabi-objcopy -O binary tmp/out.elf tmp/out.gba
```

# GBA上でデバッグする為の土台

※`logo.bin`は以下の記事を参照して用意して下さい。
(GBA自作コードを実機で動作させる手順)[https://qiita.com/earthen94/items/6ca53e74ea3833c63575]

<details>
<summary>link.ld</summary>

```link.ld
ENTRY(_start)

SECTIONS
{
    . = 0x08000000;

    .text :
    {
        *(.text)
        *(.rodata)
    }

    .data :
    {
        *(.data)
    }

    .bss :
    {
        *(.bss)
        *(COMMON)
    }
}
```

</details>

<details>
<summary>header.s</summary>

```header.s
.arm
.section .text
.global _start
.global ResetHandler

.org 0x00000000
_start:
    b ResetHandler

    /* 商標 */
    .incbin "logo.bin"    @ 0x0004-0x009F

/* --- ゲームに関する情報(0x00A0〜0x00BF) --- */
.org 0x000000A0
.ascii "GBADEMO     "       @ 名前 12文字
.byte 0x00,0x00,0x00,0x00     @ ゲームコード 4バイト
.byte 0x00,0x00               @ メーカーコード 2バイト
.byte 0x96                    @ 固定値
.byte 0x00                    @ メインユニットコード
.byte 0x00                    @ 機器の種類
.space 7                     @ 予約領域
.byte 0x00,0x00               @ 補完チェック・マスクROMバージョン
.space 2                     @ 残り予約領域


.align 2

ResetHandler:
    ldr sp, =0x03007F00
    bl main      @ Cへ 跳ぶ

InfiniteLoop:
    b InfiniteLoop
```

</details>

<details>
<summary>gfx.h</summary>

```gfx.h
#pragma once

#define REG_DISPCNT (*(volatile uint16_t*)0x04000000) // 画面制御レジスタ
#define VRAM ((volatile uint16_t*)0x06000000)

// 字体の大きさ
#define FONT_WIDTH  8
#define FONT_HEIGHT 8

// 表示する文字同士の幅(隣り合う文字は1ビット空けて表示)
#define CHAR_SPACING 1

// GBA画面解像度
#define SCREEN_WIDTH  240
#define SCREEN_HEIGHT 160

// 表示色
#define COLOR_WHITE 0xFFFF
#define COLOR_RED    0x001F

typedef unsigned char  uint8_t;
typedef unsigned short uint16_t;
typedef unsigned int   uint32_t;

void gfx_init(void);
void putchar(char c);
void print(const char *s);
void println(const char *s);
void print_dec(int v);
void gfx_set_text_color(uint16_t color);
```

</details>

<details>
<summary>link.ld</summary>

```link.ld


```

</details>

<details>
<summary>gfx.c</summary>

```gfx.c
#include "gfx.h"
#include "font.h"

// 文字座標位置(広域変数がROM領域に置かれてしまい更新不可な為強引な暫定措置)
volatile int *text_pos_x=(volatile int*)0x03000000;
volatile int *text_pos_y=(volatile int*)0x03000004;

// 表示する文字の色
volatile uint16_t *draw_color=(volatile uint16_t*)0x03000008;

static inline void putpixel(int x, int y) {
    if (x < 0 || x >= SCREEN_WIDTH ||
        y < 0 || y >= SCREEN_HEIGHT)
        return;
    //VRAM[y * SCREEN_WIDTH + x] = c;
    VRAM[y * SCREEN_WIDTH + x] = *draw_color;
}

void gfx_set_text_color(uint16_t color) {
    *draw_color = color;
}

void printfont(int x, int y, int c) {
    for (int row = 0; row < FONT_HEIGHT; row++) {
        uint8_t bits = font[c][row];

        for (int col = 0; col < FONT_WIDTH; col++) {
            if (bits & (1 << (7 - col))) {
                putpixel(x + col, y + row);
            }
        }
    }
}

void putchar(char c) {

    // 改行処理
    if (c == '\n') {
        *text_pos_x = 1;                       // 左端へ
        *text_pos_y += FONT_HEIGHT + 2;        // 1 行下げる
        return;
    }

    printfont(*text_pos_x, *text_pos_y, c);
    *text_pos_x += FONT_WIDTH + CHAR_SPACING;
    
    /* 画面右端で折り返す */
    if (*text_pos_x + FONT_WIDTH >= SCREEN_WIDTH) {
        *text_pos_x = 1;
        *text_pos_y += FONT_HEIGHT + 2;
    }
}

void print(const char *str) {
    while (*str) {
        putchar(*str++);
    }
}

void println(const char *str) {
    print(str);
    putchar('\n');
}

void print_dec(int value)
{
    char buf[12]; // 符号 + 最大10桁 + '\0'
    int i = 0;
    int sign = 0;

    // 負数対応
    if (value < 0) {
        sign = 1;
        value = -value;
    }

    // 数値を逆順でバッファに格納
    do {
        buf[i++] = '0' + (value % 10);
        value /= 10;
    } while (value > 0);

    // 符号
    if (sign) {
        buf[i++] = '-';
    }

    // 逆順出力
    while (i > 0) {
        putchar(buf[--i]);
    }
}


void gfx_init(void) {
    // Mode3 + BG2
    REG_DISPCNT = 0x0403;
    
    // 文字表示位置初期化
    *text_pos_x=1;
    *text_pos_y=1;
    
    //初期文字色=白
    *draw_color=COLOR_WHITE;
}
```

</details>

<details>
<summary>font.h</summary>

```font.h
#ifndef FONT_H
#define FONT_H

typedef unsigned char  u8;

extern const u8 font[128][8];

#endif
```

</details>

<details>
<summary>font.c</summary>

```font.c
#include "font.h"

const u8 font[128][8] = {

    // 0 0x30=48
    ['0'] = 
    {0b00111100,  //   ████
     0b01100110,  // ██    ██
     0b01100110,  // ██    ██
     0b01100110,  // ██    ██
     0b01100110,  // ██    ██
     0b01100110,  // ██    ██
     0b00111100,  //   ████
     0b00000000}, // 

    // 1 0x31=49
    ['1'] = 
    {0b00011000,  //    ██
     0b00111000,  //   ███
     0b00011000,  //    ██
     0b00011000,  //    ██
     0b00011000,  //    ██
     0b00011000,  //    ██
     0b00111100,  //   ████
     0b00000000}, // 
    
    // 2 0x32=50
    ['2'] = 
    {0b00111100,  //  ██████
     0b01100110,  // ██    ██
     0b00000110,  //      ██
     0b00011100,  //    ██
     0b00110000,  //   ██
     0b01100000,  //  ██
     0b01111110,  // ████████
     0b00000000}, //
    
    // 3 0x33=51
    ['3'] = 
    {0b00111100,  //  ██████
     0b01100110,  // ██    ██
     0b00000110,  //      ██
     0b00011100,  //    ███
     0b00000110,  //      ██
     0b01100110,  // ██    ██
     0b00111100,  //  ██████
     0b00000000}, // 
    
    // 4 0x34=52
    ['4'] = 
    {0b00001100,  //     ██
     0b00011100,  //    ███
     0b00111100,  //   ████
     0b01101100,  //  ██ ██
     0b01111110,  // ████████
     0b00001100,  //     ██
     0b00001100,  //     ██
     0b00000000}, // 
     
    // 5 0x35=53
    ['5'] = 
    {0b01111110,  // ████████
     0b01100000,  // ██
     0b01111100,  // ██████
     0b00000110,  //       ██
     0b00000110,  //       ██
     0b01100110,  // ██   ██
     0b00111100,  //  ██████
     0b00000000}, // 
     
    // 6 0x36=54
    ['6'] = 
    {0b00011100,  //    ████
     0b00110000,  //   ██
     0b01100000,  //  ██
     0b01111100,  // ██████
     0b01100110,  // ██    ██
     0b01100110,  // ██    ██
     0b00111100,  //  ██████
     0b00000000}, // 
     
    // 7 0x37=55
    ['7'] = 
    {0b01111110,  // ████████
     0b00000110,  //      ██
     0b00001100,  //     ██
     0b00011000,  //    ██
     0b00110000,  //   ██
     0b00110000,  //   ██
     0b00110000,  //   ██
     0b00000000}, //
     
    // 8 0x38=56
    ['8'] = 
    {0b00111100,  //  ██████
     0b01100110,  // ██    ██
     0b01100110,  // ██    ██
     0b00111100,  //  ██████
     0b01100110,  // ██    ██
     0b01100110,  // ██    ██
     0b00111100,  //  ██████
     0b00000000}, // 
    
    // 9 0x39=57
    ['9'] = 
    {0b00111100,  //  ██████
     0b01100110,  // ██    ██
     0b01100110,  // ██    ██
     0b00111110,  //  ██████
     0b00000110,  //      ██
     0b00001100,  //     ██
     0b00111000,  //  ████
     0b00000000}, // 

    // = 0x3D=61
    [0x3D] =  // '='
    {0b00000000,  //
     0b00000000,  //
     0b01111110,  // ████████
     0b00000000,  //
     0b01111110,  // ████████
     0b00000000,  //
     0b00000000,  //
     0b00000000}, //


    // A 0x41=65
    ['A'] = 
    {0b00011000,  //   ██
     0b00111100,  //  ████
     0b01100110,  // ██  ██
     0b01100110,  // ██  ██
     0b01111110,  // ██████
     0b01100110,  // ██  ██
     0b01100110,  // ██  ██
     0b00000000}, // 
    
    // B 0x42=66
    ['B'] = 
    {0b01111100,  // █████
     0b01100110,  // ██  ██
     0b01100110,  // ██  ██
     0b01111100,  // █████
     0b01100110,  // ██  ██
     0b01100110,  // ██  ██
     0b01111100,  // █████
     0b00000000}, // 
    
    // C 0x43=67
    ['C'] = 
    {0b00111100,  //  ██████
     0b01100110,  // ██    ██
     0b01100000,  // ██
     0b01100000,  // ██
     0b01100000,  // ██
     0b01100110,  // ██    ██
     0b00111100,  //  ██████
     0b00000000}, //
    
    // D 0x44=68
    ['D'] = 
    {0b01111000,  // █████
     0b01101100,  // ██   ██
     0b01100110,  // ██    ██
     0b01100110,  // ██    ██
     0b01100110,  // ██    ██
     0b01101100,  // ██  ██
     0b01111000,  // █████
     0b00000000}, // 
    
    // E 0x45=69
    ['E'] = 
    {0b01111110,  // ████████
     0b01100000,  // ██
     0b01100000,  // ██
     0b01111100,  // ██████
     0b01100000,  // ██
     0b01100000,  // ██
     0b01111110,  // ████████
     0b00000000}, // 
    
    // F 0x46=70
    ['F'] = 
    {0b01111110,  // ████████
     0b01100000,  // ██
     0b01100000,  // ██
     0b01111100,  // ██████
     0b01100000,  // ██
     0b01100000,  // ██
     0b01100000,  // ██
     0b00000000}, //
    
// G 0x47=71
    ['G'] = 
    {0b00111100,  //  ██████
     0b01100110,  // ██    ██
     0b01100000,  // ██
     0b01100000,  // ██
     0b01101110,  // ██  ███
     0b01100110,  // ██    ██
     0b00111110,  //  ██████
     0b00000000}, //

    // H 0x48=72
    ['H'] = 
    {0b01100110,  // ██    ██
     0b01100110,  // ██    ██
     0b01100110,  // ██    ██
     0b01111110,  // ████████
     0b01100110,  // ██    ██
     0b01100110,  // ██    ██
     0b01100110,  // ██    ██
     0b00000000}, //

    // I 0x49=73
    ['I'] = 
    {0b00111100,  //  ██████
     0b00011000,  //    ██
     0b00011000,  //    ██
     0b00011000,  //    ██
     0b00011000,  //    ██
     0b00011000,  //    ██
     0b00111100,  //  ██████
     0b00000000}, //

    // J 0x4A=74
    ['J'] = 
    {0b00001110,  //     ███
     0b00000110,  //      ██
     0b00000110,  //      ██
     0b00000110,  //      ██
     0b01100110,  // ██    ██
     0b01100110,  // ██    ██
     0b00111100,  //  ██████
     0b00000000}, //

    // K 0x4B=75
    ['K'] = 
    {0b01100110,  // ██    ██
     0b01101100,  // ██   ██
     0b01111000,  // ████
     0b01110000,  // ███
     0b01111000,  // ████
     0b01101100,  // ██   ██
     0b01100110,  // ██    ██
     0b00000000}, //
     
// L 0x4C=76
    ['L'] = 
    {0b01100000,  // ██
     0b01100000,  // ██
     0b01100000,  // ██
     0b01100000,  // ██
     0b01100000,  // ██
     0b01100000,  // ██
     0b01111110,  // ████████
     0b00000000}, //

    // M 0x4D = 77
    ['M'] =
    {0b11000110,  // █     █
     0b11000110,  // ██    ██
     0b11000110,  // ██    ██
     0b11101110,  // ███  ███
     0b11111110,  // ████████
     0b11000110,  // ██    ██
     0b11000110,  // █     █
     0b00000000},

    // N 0x4E=78
    ['N'] = 
    {0b11000110,  // ██    ██
     0b11100110,  // ███   ██
     0b11110110,  // ████  ██
     0b11111110,  // █████ ██
     0b11011110,  // ██ █████
     0b11001110,  // ██   ███
     0b11000110,  // ██    ██
     0b00000000}, //

    // O 0x4F=79
    ['O'] = 
    {0b00111100,  //  ██████
     0b01100110,  // ██    ██
     0b01100110,  // ██    ██
     0b01100110,  // ██    ██
     0b01100110,  // ██    ██
     0b01100110,  // ██    ██
     0b00111100,  //  ██████
     0b00000000}, //

    // P 0x50=80
    ['P'] = 
    {0b01111100,  // ██████
     0b01100110,  // ██    ██
     0b01100110,  // ██    ██
     0b01111100,  // ██████
     0b01100000,  // ██
     0b01100000,  // ██
     0b01100000,  // ██
     0b00000000}, //

    // Q 0x51=81
    ['Q'] = 
    {0b00111100,  //  ██████
     0b01100110,  // ██    ██
     0b01100110,  // ██    ██
     0b01100110,  // ██    ██
     0b01101110,  // ██  ███
     0b01100110,  // ██    ██
     0b00111110,  //  ██████
     0b00000000}, //

    // R 0x52=82
    ['R'] = 
    {0b01111100,  // ██████
     0b01100110,  // ██    ██
     0b01100110,  // ██    ██
     0b01111100,  // ██████
     0b01101100,  // ██   ██
     0b01100110,  // ██    ██
     0b01100110,  // ██    ██
     0b00000000}, //

    // S 0x53=83
    ['S'] = 
    {0b00111100,  //  ██████
     0b01100110,  // ██    ██
     0b01100000,  // ██
     0b00111100,  //  ██████
     0b00000110,  //      ██
     0b01100110,  // ██    ██
     0b00111100,  //  ██████
     0b00000000}, //

    // T 0x54=84
    ['T'] = 
    {0b01111110,  // ████████
     0b00011000,  //    ██
     0b00011000,  //    ██
     0b00011000,  //    ██
     0b00011000,  //    ██
     0b00011000,  //    ██
     0b00011000,  //    ██
     0b00000000}, //
     
// U 0x55=85
    ['U'] = 
    {0b01100110,  // ██    ██
     0b01100110,  // ██    ██
     0b01100110,  // ██    ██
     0b01100110,  // ██    ██
     0b01100110,  // ██    ██
     0b01100110,  // ██    ██
     0b00111100,  //  ██████
     0b00000000}, //

    // V 0x56=86
    ['V'] = 
    {0b01100110,  // ██    ██
     0b01100110,  // ██    ██
     0b01100110,  // ██    ██
     0b01100110,  // ██    ██
     0b01100110,  // ██    ██
     0b00111100,  //  ██████
     0b00011000,  //    ██
     0b00000000}, //

// W 0x57 = 87
['W'] =
{
    0b01000010,  // █    █
    0b01000010,  // █    █
    0b01000010,  // █    █
    0b01100110,  // ██  ██
    0b01111110,  // ████████
    0b01100110,  // ██  ██
    0b01000010,  // █    █
    0b00000000,
},

    // X 0x58=88
    ['X'] = 
    {0b01100110,  // ██    ██
     0b01100110,  // ██    ██
     0b00111100,  //  ██████
     0b00011000,  //    ██
     0b00111100,  //  ██████
     0b01100110,  // ██    ██
     0b01100110,  // ██    ██
     0b00000000}, //

    // Y 0x59=89
    ['Y'] = 
    {0b01100110,  // ██    ██
     0b01100110,  // ██    ██
     0b01100110,  // ██    ██
     0b00111100,  //  ██████
     0b00011000,  //    ██
     0b00011000,  //    ██
     0b00011000,  //    ██
     0b00000000}, //

    // Z 0x5A=90
    ['Z'] = 
    {0b01111110,  // ████████
     0b00000110,  //      ██
     0b00001100,  //     ██
     0b00011000,  //    ██
     0b00110000,  //   ██
     0b01100000,  //  ██
     0b01111110,  // ████████
     0b00000000}, //

};
```

</details>

