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


# 原理




