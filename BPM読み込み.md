# BMP24ビット形式の画像を用意する

構造を理解し易くする為に4×2の大きさで作成
<img width="1066" height="400" alt="image" src="https://github.com/user-attachments/assets/00237ad4-8e76-4913-9949-79ee8bd38d72" />
<img width="940" height="531" alt="image" src="https://github.com/user-attachments/assets/1f5f2fe9-daf1-4354-96c4-c6ff02ba7f76" />

# ヘッダ情報を読み込む

C言語を使用し、先ほど保存した画像のヘッダ情報を読み込みます。<br>
一応全ての要素を表示しますが、今回の主題に関係ない要素は無視します。<br>

`bfType        : 0x4D42` この値でないとBMPと認識されない。(後から自作予定のBMP表示プログラムでもファイルの先頭がこの値かを以て選択されたファイルがBMP形式かどうかを判定する)<br>

`biWidth       : 0x00000004` 幅<br>
`biHeight      : 0x00000002` 高さ<br>
`biSizeImage   : 0x00000018` 4×2(解像度)×3(1ピクセルの大きさ)=24=0x18<br>

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


