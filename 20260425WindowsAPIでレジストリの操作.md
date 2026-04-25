
# レジストリの登録

[RegCreateKeyExA 使い方](https://learn.microsoft.com/ja-jp/windows/win32/api/winreg/nf-winreg-regcreatekeyexa)
[RegSetValueExA 使い方](https://learn.microsoft.com/ja-jp/windows/win32/api/winreg/nf-winreg-regsetvalueexa)

```bash
C:\Users\test\kaihatsu>gcc main.c -o main.exe

C:\Users\test\kaihatsu>main
```

<img width="1332" height="691" alt="image" src="https://github.com/user-attachments/assets/f2bcf5c6-f5c1-486c-ad7f-5ddf748a3e34" />

```main.c
#include <windows.h>

int main() {
    HKEY hKey;
    RegCreateKeyExA(
        HKEY_CURRENT_USER,
        "Software\\TestApp1220",
        0,
        NULL,
        0,
        KEY_WRITE,
        NULL,
        &hKey,
        NULL
    );

    const char *value = "1234.5678";
    RegSetValueExA(
        hKey,
        "Version",
        0,
        REG_SZ,
        (const BYTE*)value,
        strlen(value) + 1
    );

    RegCloseKey(hKey);
    return 0;
}
```

# レジストリの削除

```bash
C:\Users\test\kaihatsu>gcc main.c -o main.exe

C:\Users\test\kaihatsu>main
```




```main.c
#include <windows.h>
#include <stdio.h>

int main() {
    LONG result;

    result = RegDeleteKeyA(
        HKEY_CURRENT_USER,
        "Software\\TestApp1220"
    );

    return 0;
}
```
