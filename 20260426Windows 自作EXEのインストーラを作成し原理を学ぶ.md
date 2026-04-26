# 先ずは動作の確認

## 自作インストーラを起動する。
```bash
C:\Users\test\kaihatsu>install
Installed

C:\Users\test\kaihatsu>
```

## フォルダが生成されていることを確認
<img width="1898" height="444" alt="image" src="https://github.com/user-attachments/assets/5ff33051-e368-4b43-ad30-78f77c64d0b6" />

## レジストリに登録されていることを確認
<img width="1332" height="232" alt="image" src="https://github.com/user-attachments/assets/3ffdc4ad-6189-466d-b766-16520d74340f" />

## `プログラムと機能`に登録されていることを確認し、アンインストールをする
<img width="1758" height="580" alt="image" src="https://github.com/user-attachments/assets/01c51096-472d-4d0e-b07d-6f0f28639d21" />

## 再起動してインストール先の及びレジストリを確認
跡形も無く消えている
<img width="1332" height="258" alt="image" src="https://github.com/user-attachments/assets/ef8ec635-c585-479f-bd29-e1653760cb50" />
<img width="1471" height="749" alt="image" src="https://github.com/user-attachments/assets/f79144f3-eb44-4284-997f-9cd07e336902" />

# ソースコード及びコンパイル手順

```bash
gcc test.c -o test.exe -mwindows
gcc uninstall.c -o uninstall.exe
windres resource.rc resource.o
gcc install.c resource.o -o install.exe
gcc install.c -o install.exe
```

```resource.rc
#define IDR_TEST_EXE 1001
#define IDR_UNINSTALL_EXE 1002

IDR_TEST_EXE       RCDATA "test.exe"
IDR_UNINSTALL_EXE  RCDATA "uninstall.exe"
```

<details>
<summary>test.c</summary>

```test.c
#include <windows.h>

int main() {
    MessageBoxA(
        NULL,
        "Hello from TestApp1220!",
        "TestApp1220",
        MB_OK | MB_ICONINFORMATION
    );
    return 0;
}
```

</details>

<details>
<summary>uninstall.c</summary>

```uninstall.c
#include <windows.h>
#include <stdio.h>

BOOL IsElevated() {
    BOOL isAdmin = FALSE;
    HANDLE token;
    TOKEN_ELEVATION elevation;
    DWORD size;

    if (OpenProcessToken(GetCurrentProcess(), TOKEN_QUERY, &token)) {
        if (GetTokenInformation(token, TokenElevation, &elevation, sizeof(elevation), &size)) {
            isAdmin = elevation.TokenIsElevated;
        }
        CloseHandle(token);
    }
    return isAdmin;
}

int main() {
    char path[MAX_PATH];
    GetModuleFileNameA(NULL, path, MAX_PATH);
	
    if (!IsElevated()) {
        // 管理者として再起動
        ShellExecuteA(
            NULL,
            "runas",
            path,
            NULL,
            NULL,
            SW_SHOW
        );
        return 0; // ← 元のプロセスは終了
    }
	
    // ファイル削除
    DeleteFileA("C:\\TestApp1220\\test.exe");

    // レジストリ削除
    RegDeleteKeyA(
        HKEY_CURRENT_USER,
        "Software\\Microsoft\\Windows\\CurrentVersion\\Uninstall\\TestApp1220"
    );
	
    // 自分自身削除
    MoveFileExA(
        path,
        NULL,
        MOVEFILE_DELAY_UNTIL_REBOOT
    );
	
	// フォルダ削除
    MoveFileExA(
        "C:\\TestApp1220",
        NULL,
        MOVEFILE_DELAY_UNTIL_REBOOT
    );
	
	printf("Uninstalled\n");

    return 0;
}
```

</details>

<details>
<summary>install.c</summary>

```install.c
#include <windows.h>
#include <stdio.h>
#include <string.h>

#define IDR_TEST_EXE 1001
#define IDR_UNINSTALL_EXE 1002

int ExtractResourceToFile(int resourceId, const char* outputPath) {
    HRSRC hRes = FindResource(NULL, MAKEINTRESOURCE(resourceId), RT_RCDATA);
    if (!hRes) return 0;

    HGLOBAL hData = LoadResource(NULL, hRes);
    if (!hData) return 0;

    void* pData = LockResource(hData);
    DWORD size = SizeofResource(NULL, hRes);

    FILE* f = fopen(outputPath, "wb");
    if (!f) return 0;

    fwrite(pData, 1, size, f);
    fclose(f);

    return 1;
}

int main() {
    const char *dir = "C:\\TestApp1220";
	
    const char *src = "test.exe";
    const char *dst = "C:\\TestApp1220\\test.exe";
	
    const char *uninstall_src = "uninstall.exe";
    const char *uninstall_dst = "C:\\TestApp1220\\uninstall.exe";

    // フォルダ作成
    CreateDirectoryA(dir, NULL);

    // ファイル複製
    if (!ExtractResourceToFile(IDR_TEST_EXE, dst)) {
        printf("Extract test.exe failed\n");
        return 1;
    }

    if (!ExtractResourceToFile(IDR_UNINSTALL_EXE, uninstall_dst)) {
        printf("Extract uninstall.exe failed\n");
        return 1;
    }

    // レジストリ登録（Uninstall）
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
            NULL) == ERROR_SUCCESS) {

        const char *name = "TestApp1220";

        // 一覧に表示する名称
        RegSetValueExA(hKey, "DisplayName", 0, REG_SZ,(const BYTE*)name, strlen(name)+1);

        // 削除に使用するEXEのパス
        RegSetValueExA(hKey, "UninstallString", 0, REG_SZ,(const BYTE*)uninstall_dst, strlen(uninstall_dst)+1);

        RegCloseKey(hKey);
    }

    printf("Installed\n");
    return 0;
}
```

</details>


# 原理

1. `test.exe`,`uninstall.exe`を一つのファイル`resource.o`に纏める。
2. `install.exe`の中に`resource.o`を内包した形でコンパイルする。
3. `install.exe`により`test.exe`,`uninstall.exe`を`C:\\TestApp1220\\`下に複製する。
4. `install.exe`により、レジストリ`Software\\Microsoft\\Windows\\CurrentVersion\\Uninstall\\`下に自作ソフトの情報を登録する。ここに登録することで `プログラムと機能`上に表示される。
5.  `プログラムと機能`からアンインストールをすると、レジストリに登録した`C:\\TestApp1220\\uninstall.exe`が実行される。
6.  `uninstall.exe`により、`test.exe`及び登録したレジストリを全て削除する。
7.  `uninstall.exe`は実行中の為、自分自身を削除することは出来ない。そこで`uninstall.exe`の削除をOS側に予約しておくと、再起動時に削除される。

# 検証環境

プロセッサ	Intel(R) Core(TM) i5-7200U CPU @ 2.50GHz   2.71 GHz
実装 RAM	8.00 GB
ストレージ	119 GB SSD GT480 128GB
グラフィックス カード	Intel(R) HD Graphics 620 (128 MB)

エディション	Windows 10 Pro
バージョン	22H2
OS ビルド	19045.6466

