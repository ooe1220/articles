
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

[RegDeleteKeyA 使い方](https://learn.microsoft.com/ja-jp/windows/win32/api/winreg/nf-winreg-regdeletekeya)

```bash
C:\Users\test\kaihatsu>gcc main.c -o main.exe

C:\Users\test\kaihatsu>main
```

<img width="1332" height="691" alt="image" src="https://github.com/user-attachments/assets/6939c831-12c5-4e4f-9a03-43a2c7cba9f2" />

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

# 使ってみる

## 設定値として使用

レジストリに登録した値を、キー指定で取得する。自作のソフトで必要な設定値を自由に設定可能。

<img width="1332" height="739" alt="image" src="https://github.com/user-attachments/assets/248a1b16-f2f5-44d0-ac63-45486a1f672d" />

```bash
C:\Users\test\kaihatsu>gcc main.c -o main.exe

C:\Users\test\kaihatsu>main
Value: AAAABBBBCCCC

C:\Users\test\kaihatsu>
```

```main.c
#include <windows.h>
#include <stdio.h>

int main() {
    HKEY hKey;
    char buffer[256];
    DWORD bufferSize = sizeof(buffer);
    DWORD type;

    // キーを開く
    if (RegOpenKeyExA(
            HKEY_CURRENT_USER,
            "Software\\TestApp1220",
            0,
            KEY_READ,
            &hKey) != ERROR_SUCCESS) {
        printf("Failed to open key\n");
        return 1;
    }

    // 値を読む
    if (RegQueryValueExA(
            hKey,
            "TESTMSG1220",
            NULL,
            &type,
            (LPBYTE)buffer,
            &bufferSize) == ERROR_SUCCESS) {

        printf("Value: %s\n", buffer);
    } else {
        printf("Failed to read value\n");
    }

    RegCloseKey(hKey);
    return 0;
}
```

## 「プログラムと機能」に登録

`Software\Microsoft\Windows\CurrentVersion\Uninstall\`に登録すると「プログラムと機能」に表示される

<img width="1332" height="691" alt="image" src="https://github.com/user-attachments/assets/1b021e2d-deef-4fe6-b028-db60ec1fef44" />
<img width="1180" height="815" alt="image" src="https://github.com/user-attachments/assets/0ca4c513-3013-45ef-bc02-10b7d6c7d2b8" />

```main.c
#include <windows.h>
#include <stdio.h>

int main() {
    HKEY hKey;
    const char *subkey =
        "Software\\Microsoft\\Windows\\CurrentVersion\\Uninstall\\TestApp1220";

    if (RegCreateKeyExA(
            HKEY_CURRENT_USER,
            subkey,
            0, NULL, 0,
            KEY_WRITE,
            NULL,
            &hKey,
            NULL) != ERROR_SUCCESS) {
        printf("Failed to create key\n");
        return 1;
    }

    const char *name = "TestApp1220";
    const char *version = "1234.5678";
    const char *publisher = "HISSHA";
    const char *uninstall = "C:\\TestApp\\uninstall.exe";

    RegSetValueExA(hKey, "DisplayName", 0, REG_SZ,
        (const BYTE*)name, strlen(name)+1);

    RegSetValueExA(hKey, "DisplayVersion", 0, REG_SZ,
        (const BYTE*)version, strlen(version)+1);

    RegSetValueExA(hKey, "Publisher", 0, REG_SZ,
        (const BYTE*)publisher, strlen(publisher)+1);

    RegSetValueExA(hKey, "UninstallString", 0, REG_SZ,
        (const BYTE*)uninstall, strlen(uninstall)+1);

    RegCloseKey(hKey);

    printf("Registered in Uninstall list.\n");
    return 0;
}
```




