# wineの導入

```bash
sudo dpkg --add-architecture i386
sudo apt update
sudo apt install wine wine64 wine32
sudo apt install winetricks
```

# Linux上でWindowsm向けにコンパイル

```bash
sudo apt install gcc-mingw-w64-i686
i686-w64-mingw32-gcc dialog.c -o dialog.exe
```

```bash
wine dialog.exe
```

```dialog.c
#include <windows.h>

int WINAPI WinMain(HINSTANCE hInstance, HINSTANCE hPrevInstance,
                   LPSTR lpCmdLine, int nCmdShow)
{
    MessageBox(
        NULL,
        "Windows Dialog",
        "Wine",
        MB_OK | MB_ICONINFORMATION
    );

    return 0;
}
```
