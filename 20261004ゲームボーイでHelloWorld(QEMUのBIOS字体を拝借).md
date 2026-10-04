# 目次
https://qiita.com/earthen94/items/3a3601b9e82ab40a4805

# 目的

前回QEMUのソースコードを拝借してASCIIの字体を生成し、ゲームボーイで表示する検証を行いました。
[ゲームボーイで文字を表示する(QEMUのBIOSから字体を抽出)](https://qiita.com/earthen94/items/3a1cb50aba91d8dd7181)

今回は文字列が表示できるようにします。

# 実装

<img width="340" height="338" alt="截图 2026-10-04 13-12-00" src="https://github.com/user-attachments/assets/fc49b937-8051-4ad1-b78f-db7473d31a83" />

```main.asm
SECTION "Entry", ROM0[$0100]
    jp start

SECTION "Main", ROM0[$0150]

start:
    di ; 割り込み禁止
    ld sp, $FFFE ; スタック設定
    
    call display_off ; 画面描画停止
    call bj_clear ; 画面上のタイルを全て真っ白の255へ設定
    
    ld hl, font_8x8    ; 元データ（1文字8バイト）
    ld de, $8000          ; VRAM 開始
    ld b, 255              ; 256文字分
    call copy_font_to_vram
    
    ld hl, msg        ; hl = 文字列のアドレス先頭
    ld de, $9800      ; de = VRAM のタイルマップ開始位置
    call print_str
    
    ; パレット
    ld a, %11100100 ; 4色(11 10 01 00)を設定
    ld [$FF47], a
    
    ; 画面描画再開: BG有効
    call display_on ; 画面描画再開

hang:
    jr hang

; HL = 表示する文字列の先頭アドレス
; DE = VRAM 宛先
print_str:
    ld a, [hl]        ; ← hl が指してる文字を a に読む
    or a              ; 終端判定 (A or AでA=0の時のみ0となる)
    jr z, done        ; 0 なら終了
    ld [de], a        ; VRAM にタイル番号として書く
    inc hl            ; ← 次の文字へ
    inc de            ; ← 次のVRAM位置へ
    jr print_str      ; ループ
done:
    ret

; HL = フォントデータ元（1文字8バイト、1行1バイト）
; DE = VRAM 宛先
; B  = 文字数
copy_font_to_vram:
    push bc
    ld b, 8          ; 1文字あたり8行

.row_loop:
    ld a, [hl]       ; 1行分読み込み
    inc hl
    ld [de], a       
    inc de
    ld [de], a       
    inc de
    dec b
    jr nz, .row_loop

    pop bc
    dec b
    jr nz, copy_font_to_vram
    ret
    
    ; 画面全体にタイル255(真っ白)を登録する
    ; メモリは初めから0で初期化されているのでタイル255を故意に書き換え無ければ全て0
bj_clear:
    ld bc, 32*32
    ld hl, $9800
loop1:
    ld [hl],255
    inc hl
    dec bc
    ld a, b
    or c
    jr nz, loop1
    ret
    
    ; 画面描画停止
display_off:
    xor a
    ldh[$FF40], a
    ret

    ; 画面描画再開: BG有効
display_on:
    ld a, %10010011
    ldh [$FF40], a
    ret
    
msg: db "Hello, World!", 0

font_8x8:
INCBIN "font_8x8.bin"
```
