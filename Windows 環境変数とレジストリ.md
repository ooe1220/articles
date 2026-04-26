# 環境変数の保存先

環境変数の保存先は以下の2つ

```
コンピューター\HKEY_CURRENT_USER\Environment
コンピューター\HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Environment
```

環境変数画面
上段 → ユーザー（HKCU）
下段 → システム（HKLM）

<img width="441" height="484" alt="path" src="https://github.com/user-attachments/assets/9421298a-6756-4e4a-a9bf-4e8c97e8452c" />

# レジストリ経由で環境変数を設定

登録するEXEを生成しておく
```bash
gcc test_user.c -o test_user.exe -mwindows
gcc test_system.c -o test_system.exe -mwindows
```

## ユーザ側
<img width="1375" height="540" alt="image" src="https://github.com/user-attachments/assets/65ac773a-8134-4cce-88c1-d91176e05b93" />

## システム側
<img width="1375" height="540" alt="image" src="https://github.com/user-attachments/assets/f84d9cb6-7b19-444f-9296-12b73211a357" />


