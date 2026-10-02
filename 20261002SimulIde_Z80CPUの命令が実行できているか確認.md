
# 目的

`SimulIde`でz80の実験をしていきます。
メモリに書き込んだ機械語が本当に動いているのか不安なので、レジスタに数値を書き込み値が変わるかを確認します。

以下の記事でも検証しましたが、A0ピンに電気が流れていたのは偶然だったのではないかと不安になったのでもう一度確かめます。
[z80のA0ピンでLEDを光らせる](https://qiita.com/earthen94/items/64896f20e40b78a21348)

# 機械語


```bash
z80asm -o simz80.bin simz80.asm
```

```simz80.asm
ld a, 1
ld b, 2
ld c, 3
ld d, 4
halt
```

# 動作確認

A,B,C,Dそれぞれの汎用レジスタに意図した値が格納されています。

<img width="1908" height="966" alt="截图 2026-10-02 14-25-41" src="https://github.com/user-attachments/assets/72d5f4fe-157c-4696-9f14-3a5151046c2e" />
