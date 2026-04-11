# BMP24ビット形式の画像を用意

Windows標準のペイントを使って生成します。
<img width="1066" height="400" alt="image" src="https://github.com/user-attachments/assets/00237ad4-8e76-4913-9949-79ee8bd38d72" />
<img width="940" height="531" alt="image" src="https://github.com/user-attachments/assets/1f5f2fe9-daf1-4354-96c4-c6ff02ba7f76" />

# ヘッダ情報を読み込む

以下の記事を参考にさせて頂きました。
https://qiita.com/ImagingSolAkira/items/30fd3727afa3076b8050

C言語を使用し、先ほど保存した画像のヘッダ情報を読み込みます。<br>
一応全ての要素を表示しますが、今回の主題に関係無い要素は無視します。<br>
以下は4×2の画像ヘッダを表示した結果です。<br>

`bfType        : 0x4D42` この値でないとBMPと認識されない。(後から自作予定のBMP表示プログラムでもファイルの先頭がこの値かを以て選択されたファイルがBMP形式かどうかを判定する)<br>

`biWidth       : 0x00000004` 幅<br>
`biHeight      : 0x00000002` 高さ<br>
`biSizeImage   : 0x00000018` 4×2(解像度)×3(1ピクセルの大きさ)=24=0x18　※幅は後述する0埋めを考慮する必要あり<br>

```bash
C:\Users\test\kaihatsu>gcc header.c -o header.exe

C:\Users\test\kaihatsu>header
=== BITMAPFILEHEADER ===
bfType        : 0x4D42
bfSize        : 0x0000004E
bfReserved1   : 0x0000
bfReserved2   : 0x0000
bfOffBits     : 0x00000036

=== BITMAPINFOHEADER ===
biSize        : 0x00000028
biWidth       : 0x00000004
biHeight      : 0x00000002
biPlanes      : 0x0001
biBitCount    : 0x0018
biCompression : 0x00000000
biSizeImage   : 0x00000018
biXPelsPerMeter:0x00000000
biYPelsPerMeter:0x00000000
biClrUsed     : 0x00000000
biClrImportant: 0x00000000

C:\Users\test\kaihatsu>
```

<details>
<summary>header.c</summary>

```header.c
//gcc header.c -o header.exe
#include <stdio.h>
#include <stdint.h>

#pragma pack(push, 1)

// 14バイト
typedef struct {
    uint16_t bfType;
    uint32_t bfSize;
    uint16_t bfReserved1;
    uint16_t bfReserved2;
    uint32_t bfOffBits;
} BITMAPFILEHEADER;

// 40バイト
typedef struct {
    uint32_t biSize;
    int32_t  biWidth;
    int32_t  biHeight;
    uint16_t biPlanes;
    uint16_t biBitCount;
    uint32_t biCompression;
    uint32_t biSizeImage;
    int32_t  biXPelsPerMeter;
    int32_t  biYPelsPerMeter;
    uint32_t biClrUsed;
    uint32_t biClrImportant;
} BITMAPINFOHEADER;

#pragma pack(pop)

int main() {
    FILE *fp = fopen("test.bmp", "rb");
    if (!fp) {
        printf("file open error\n");
        return 1;
    }

    BITMAPFILEHEADER fh;
    BITMAPINFOHEADER ih;

    fread(&fh, sizeof(fh), 1, fp);
    fread(&ih, sizeof(ih), 1, fp);

    printf("=== BITMAPFILEHEADER ===\n");
    printf("bfType        : 0x%04X\n", fh.bfType);
    printf("bfSize        : 0x%08X\n", fh.bfSize);
    printf("bfReserved1   : 0x%04X\n", fh.bfReserved1);
    printf("bfReserved2   : 0x%04X\n", fh.bfReserved2);
    printf("bfOffBits     : 0x%08X\n", fh.bfOffBits);

    printf("\n=== BITMAPINFOHEADER ===\n");
    printf("biSize        : 0x%08X\n", ih.biSize);
    printf("biWidth       : 0x%08X\n", ih.biWidth);
    printf("biHeight      : 0x%08X\n", ih.biHeight);
    printf("biPlanes      : 0x%04X\n", ih.biPlanes);
    printf("biBitCount    : 0x%04X\n", ih.biBitCount);
    printf("biCompression : 0x%08X\n", ih.biCompression);
    printf("biSizeImage   : 0x%08X\n", ih.biSizeImage);
    printf("biXPelsPerMeter:0x%08X\n", ih.biXPelsPerMeter);
    printf("biYPelsPerMeter:0x%08X\n", ih.biYPelsPerMeter);
    printf("biClrUsed     : 0x%08X\n", ih.biClrUsed);
    printf("biClrImportant: 0x%08X\n", ih.biClrImportant);

    fclose(fp);
    return 0;
}
```

</details>

# ピクセルの4バイト境界
BITMAPの仕様では、1行のバイト数を4の倍数に合わせます。<br>
例えば幅が4の場合は`4×3バイト=12`となる為、そのまま12バイトになりますが、
幅が5の場合は`5×3=15バイト`となり、16バイトに合わせる為に0埋めが発生します。

4×2の画像<br>
<img width="262" height="140" alt="image" src="https://github.com/user-attachments/assets/7fa7c37e-a921-4601-97fd-eebd17bcdc51" />

```
=== RAW PIXEL ROW DUMP ===
width=4 height=2 rowSize=12
Row 0: FF FF FF FF FF FF FF FF FF 00 00 00
Row 1: 24 1C ED E8 A2 00 FF FF FF FF FF FF
```

5×2の画像<br>
<img width="339" height="140" alt="image" src="https://github.com/user-attachments/assets/2fe7d8dc-cefe-4409-a032-3d56f6cb0ca6" />

```
=== RAW PIXEL ROW DUMP ===
width=5 height=2 rowSize=16
Row 0: FF FF FF FF FF FF FF FF FF FF FF FF E8 A2 00 | 00
Row 1: 24 1C ED 4C B1 22 A4 49 A3 FF FF FF FF FF FF | 00
```
※ Row 0 は画像の最下段を表す(後述)

<details>
<summary>pixel.c</summary>

```pixel.c
// gcc pixel.c -o pixel.exe
#include <stdio.h>
#include <stdint.h>

#pragma pack(push, 1)

typedef struct {
    uint16_t bfType;
    uint32_t bfSize;
    uint16_t bfReserved1;
    uint16_t bfReserved2;
    uint32_t bfOffBits;
} BITMAPFILEHEADER;

typedef struct {
    uint32_t biSize;
    int32_t  biWidth;
    int32_t  biHeight;
    uint16_t biPlanes;
    uint16_t biBitCount;
    uint32_t biCompression;
    uint32_t biSizeImage;
    int32_t  biXPelsPerMeter;
    int32_t  biYPelsPerMeter;
    uint32_t biClrUsed;
    uint32_t biClrImportant;
} BITMAPINFOHEADER;

#pragma pack(pop)

int main() {
    FILE *fp = fopen("test.bmp", "rb");
    if (!fp) {
        printf("file open error\n");
        return 1;
    }

    BITMAPFILEHEADER fh;
    BITMAPINFOHEADER ih;

    fread(&fh, sizeof(fh), 1, fp);
    fread(&ih, sizeof(ih), 1, fp);

    // ピクセル開始位置へ
    fseek(fp, fh.bfOffBits, SEEK_SET);//SEEK_SETで「ファイル先頭」からの距離

    int rowSize = ((ih.biWidth * 3 + 3) / 4) * 4;

    printf("=== RAW PIXEL ROW DUMP ===\n");
    printf("width=%d height=%d rowSize=%d\n", ih.biWidth, ih.biHeight, rowSize);

    for (int y = 0; y < ih.biHeight; y++) {
        printf("Row %d: ", y);

        for (int i = 0; i < rowSize; i++) {

            // 境界に印を付ける
            if (i == ih.biWidth * 3) {
                printf("| ");
            }

            unsigned char v = fgetc(fp);
            printf("%02X ", v);
        }

        printf("\n");
    }

    fclose(fp);
    return 0;
}
```

</details>

# BITMAPの行は下から上へ読む
BITMAPの仕様で`biHeight`が正の場合は下の行から上に格納されます(説明が下手なので仕様は他のサイトで確認して下さい)。
この章では本当に下から格納されているかを確認します。

4×3の画像を用意し、前章のpixel.cにてピクセルの生データを確認します。<br>
観測の為に幅を4ピクセルにして0埋めが発生しないようにしています。<br>
<img width="271" height="206" alt="image" src="https://github.com/user-attachments/assets/008838b2-d67c-473e-a561-364d707c3d8c" />

```
=== RAW PIXEL ROW DUMP ===
width=4 height=3 rowSize=12
Row 0: 00 F2 FF FF FF FF FF FF FF FF FF FF
Row 1: FF FF FF CC 48 3F FF FF FF CC 48 3F
Row 2: 24 1C ED FF FF FF 24 1C ED FF FF FF
```

筆者の作成した画像は、分かり易くする為に最終行左のピクセルのみ着色し、その後は全て白(`FF FF FF`)としています<br>
バイナリを見てみると仕様通り最終行が一番上に保存されています。

即ち以下の様な画像があった場合に<br>
```
赤青紫藍
白黄橙茶
桃黒緑灰
```
バイナリ上は以下の様な配列となる。<br>
```
桃黒緑灰
白黄橙茶
赤青紫藍
```

# 検証環境
エディション	Windows 10 Pro<br>
バージョン	22H2<br>
OS ビルド	19045.6466<br>
プロセッサ	Intel(R) Core(TM) i5-7200U CPU @ 2.50GHz   2.71 GHz<br>
実装 RAM	8.00 GB<br>
ストレージ	119 GB SSD GT480 128GB<br>
グラフィックス カード	Intel(R) HD Graphics 620 (128 MB)<br>
gcc version 15.2.0 (MinGW-W64 x86_64-ucrt-posix-seh, built by Brecht Sanders, r4)<br>
