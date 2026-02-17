# 目的
自分でアセンブリを書く練習をします。
出題にはAIを使いますが、回答時は検索のみに留めます。



# 問題1：レジスタ転送
次の値をレジスタ操作だけで作れ。
AX = 1234h
BX = AX の値
CX = BX + 10h
DX = CX - 4h

条件：
即値使用OK
メモリ使用禁止
最後 int 20h で終了
![c12854881bb4c8](https://github.com/user-attachments/assets/8414881f-269d-462a-8d89-b9eb25392efd)

# 問題2：メモリ書き込み
.data に1バイト変数を作る。
変数に 55h を格納せよ
条件：
MOVのみ使用
レジスタ経由でもOK
![aae838df3d292](https://github.com/user-attachments/assets/b0b3d1c5-6228-406f-8a7f-6232c78d6d3b)


# 問題3：カウンタループ
CXを使って
10回ループするだけのプログラム
条件：
LOOP命令を必ず使う
ループ中はNOPだけでよい
![8e0dacfe37a728](https://github.com/user-attachments/assets/2fcb5219-83bf-40d6-9997-becee146d5ed)


# 問題4：合計値計算
1〜10までの合計をAXに求めよ。
条件：
ループ使用
変数使用禁止
AXに最終結果を残す
![5384024900c96](https://github.com/user-attachments/assets/281e2e32-da7a-41bc-8bfb-ee0f325ce6ae)



# 問題5：1文字表示（BIOS）
BIOSを使って
'A'
を画面表示せよ。
条件：
テキストモード前提
BIOS割り込み使用
DOS割り込み禁止
![44527f1f0dcc58](https://github.com/user-attachments/assets/3cf0260f-f754-41af-9636-5a6f37f23a44)


# 問題6：文字を10回表示
*を10個横に並べて表示せよ。
条件：
BIOS表示
ループ必須
![c54f3026625f38](https://github.com/user-attachments/assets/ab8f9662-d830-4071-93cf-9a1aec965a66)


# 問題7：キー入力待ち
BIOSで
キーを1回押すまで待つだけのプログラムを作れ。
条件：
入力値は保存不要
![d873d5a28f4e38](https://github.com/user-attachments/assets/2f737ac2-d64d-450f-a158-d2f4948536a7)


問題8：入力文字をそのまま表示
BIOSで1文字入力 → 同じ文字を表示
条件：
DOS表示禁止
BIOSのみ
![40ca41de8dd97](https://github.com/user-attachments/assets/2beab415-635d-41e5-ab6d-6c957a72299c)


# 問題9：文字列表示
DOS機能を使ってHELLOを表示せよ。
条件：
$ 終端文字列を使用
改行は自由
![3c4860f3e18708](https://github.com/user-attachments/assets/14005c44-0fff-477f-a58c-cc273dbabef0)

# 問題10：キーボード入力（DOS）
1文字入力して入力した文字を表示
条件：
DOSのみ使用
BIOS禁止

https://blog.csdn.net/mid_Faker/article/details/112271486
![cb3d0cf9bae89](https://github.com/user-attachments/assets/ca0ef377-a261-4465-ace7-a421082b2ca2)

# 問題11：PCスピーカON/OFF
ポート操作を使ってスピーカを一瞬鳴らす
条件：
IN / OUT 使用
BIOS禁止
DOS禁止

？？？？？

# 問題12：ポート値の取得
任意のポートから値を読み取りALに保存するだけ
条件：
IN命令必須

https://www.toolify.ai/zh/hardwarecn/%E5%AD%A6%E4%B9%A08086%E5%BE%AE%E5%A4%84%E7%90%86%E5%99%A8%E7%9A%84in%E5%92%8Cout%E6%8C%87%E4%BB%A4-2979882
![fb0ada341f37a8](https://github.com/user-attachments/assets/c5bed13d-7e42-41a4-8095-ad816769fce6)


