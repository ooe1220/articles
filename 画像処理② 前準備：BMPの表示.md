# 初めに

前回BMPの仕組みを調べました。
[画像処理① 前準備：BMPの仕組みを理解](https://qiita.com/earthen94/items/7978f18a7e075c4b95ce)

今回はWindowsAPIを用いてBMP画像を表示します。

# 表示処理

```main.c
//gcc main.c -o main.exe -lgdi32
#include <windows.h>
#include <stdio.h>
#include <stdlib.h>

typedef struct {
    unsigned char *data;//ピクセルの生データの先頭アドレス
    int width;  // 横(ピクセル)
    int height; // 縦(ピクセル)
    int rowSize;//1行当たりのピクセル数。4の倍数に揃える。
} BMP;

BMP *g_bmp = NULL;

BMP* load_bmp(const char *filename)
{
    FILE *fp = fopen(filename, "rb");
    if (!fp) {
        MessageBox(NULL, "ファイル開けない", "error", MB_OK);
        exit(1);
    }

    BITMAPFILEHEADER fh; // 14バイト ファイル全体の情報を格納
    BITMAPINFOHEADER ih; // 40バイト 画像データに関する情報を格納

    fread(&fh, sizeof(fh), 1, fp);
    fread(&ih, sizeof(ih), 1, fp);

    if (fh.bfType != 0x4D42) { // BMPは必ずこの値
        MessageBox(NULL, "BMP形式でない", "error", MB_OK);
        exit(1);
    }

    if (ih.biBitCount != 24) { // 1ピクセルあたりのビット数
        MessageBox(NULL, "24bit BMP形式でない", "error", MB_OK);
        exit(1);
    }

    BMP *bmp = (BMP*)malloc(sizeof(BMP));

    bmp->width = ih.biWidth;
    bmp->height = ih.biHeight;
    bmp->rowSize = ((bmp->width * 3 + 3) / 4) * 4;//4バイト境界に揃える

    bmp->data = (unsigned char*)malloc(bmp->rowSize * bmp->height);

    fseek(fp, fh.bfOffBits, SEEK_SET); // bfOffBits = ファイル先頭からピクセルデータの開始位置までのオフセット (バイト)
    fread(bmp->data, 1, bmp->rowSize * bmp->height, fp);

    fclose(fp);
	
    return bmp;
}

//BMPの生データを1ピクセルずつ画面に描く関数
void draw_bmp(HDC hdc, BMP *bmp)
{
    for (int y = 0; y < bmp->height; y++) {
        for (int x = 0; x < bmp->width; x++) {

            int row = bmp->height - 1 - y;//下の行から上へ走査

            unsigned char *p = bmp->data + row * bmp->rowSize + x * 3; //row * bmp->rowSize:行 x * 3：列 
            unsigned char b = p[0];
            unsigned char g = p[1];
            unsigned char r = p[2];

            COLORREF color = (r) | (g << 8) | (b << 16);
            SetPixel(hdc, x, y, color);
        }
    }
}

LRESULT CALLBACK WndProc(HWND hwnd, UINT msg, WPARAM wp, LPARAM lp)
{
    switch (msg) {
        case WM_CREATE: // Window生成時実行
            g_bmp = load_bmp("test.bmp");
            break;

        case WM_PAINT: { // 描画時実行
            PAINTSTRUCT ps;
            HDC hdc = BeginPaint(hwnd, &ps);

            if (g_bmp) {
                draw_bmp(hdc, g_bmp);
            }

            EndPaint(hwnd, &ps);
            break;
        }

        case WM_DESTROY: // Window閉じる時
            if (g_bmp) {
                free(g_bmp->data);
                free(g_bmp);
            }
            PostQuitMessage(0);
            break;
        }

        return DefWindowProc(hwnd, msg, wp, lp);
}

int WINAPI WinMain(HINSTANCE hInst, HINSTANCE hPrev, LPSTR lpCmd, int nShow)
{
    WNDCLASS wc = {0};

    wc.lpfnWndProc = WndProc;
    wc.hInstance = hInst;
    wc.lpszClassName = "bmp_viewer";

    RegisterClass(&wc);

    HWND hwnd = CreateWindow(
        "bmp_viewer",
        "BMP Viewer",
        WS_OVERLAPPEDWINDOW,
        CW_USEDEFAULT, CW_USEDEFAULT,
        800, 600,
        NULL, NULL, hInst, NULL
    );

    ShowWindow(hwnd, nShow);

    MSG msg;
    while (GetMessage(&msg, NULL, 0, 0)) {
        TranslateMessage(&msg);
        DispatchMessage(&msg);
    }

    return 0;
}
```

<img width="1328" height="455" alt="image" src="https://github.com/user-attachments/assets/890d6faf-78a2-4ffd-a685-79401bfd2ad9" />
<img width="1178" height="889" alt="image" src="https://github.com/user-attachments/assets/12ef01e1-67e4-493b-a404-116120c6307d" />

# 検証環境
エディション	Windows 10 Pro<br>
バージョン	22H2<br>
OS ビルド	19045.6466<br>
プロセッサ	Intel(R) Core(TM) i5-7200U CPU @ 2.50GHz   2.71 GHz<br>
実装 RAM	8.00 GB<br>
ストレージ	119 GB SSD GT480 128GB<br>
グラフィックス カード	Intel(R) HD Graphics 620 (128 MB)<br>
gcc version 15.2.0 (MinGW-W64 x86_64-ucrt-posix-seh, built by Brecht Sanders, r4)<br>
