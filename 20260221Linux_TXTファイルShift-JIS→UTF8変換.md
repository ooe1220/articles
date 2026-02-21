# 目的
WindowsXPで編集したTXTファイルをLinuxで開くと文字化けしてしまうので、Shift-JIS→UTF8へ一発で変換する方法を記録しておきます。

<img width="1920" height="1080" alt="截图 2026-02-21 21-42-46" src="https://github.com/user-attachments/assets/fde948fc-ce3a-4b3f-88b9-e90ad82d2c5c" />
<img width="955" height="394" alt="截图 2026-02-21 21-45-26" src="https://github.com/user-attachments/assets/0c1f3b2e-6e98-4a46-bae7-48364ef3b80d" />

# コマンド

```bash
test@test-fujitsu:~$ iconv -f SHIFT_JIS -t UTF-8 a.txt -o output.txt
test@test-fujitsu:~$ 
```

# 変換後







