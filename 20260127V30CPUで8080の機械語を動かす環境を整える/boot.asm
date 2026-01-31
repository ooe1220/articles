; nasm -f bin boot.asm -o boot.bin
; qemu-system-i386 -hda boot.bin -boot a -no-reboot
; lsblk
; sudo dd if=boot.bin of=/dev/sdb bs=512 count=1 conv=notrunc

[BITS 16]
[ORG 0x7C00]

%define TARGET_VECC 0x80
%define TARGET_ADDR (TARGET_VECC * 4)

buffer_addr equ 0x7000  ; 8080モード用の文字バッファ

start:
    cli
    xor ax, ax
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x7C00

    ; --- IVT 0x80 に 8080コードの開始地点を登録 ---
    ; ここで登録したアドレスが 8080モードの「PC=0」として解釈されます
    mov word [TARGET_ADDR], entry_8080_code ; オフセット
    mov word [TARGET_ADDR + 2], 0           ; セグメント(CS)

    mov si, msg_enter
    call print_string

    ; 8080モードへ突入 (指定したベクタ経由)
    db 0x0F, 0xFF, TARGET_VECC 

    ; --- RETEM実行後、ここに戻ってくる ---
    jmp after_8080

; 8080モード
entry_8080_code:
    
    %include "8080.asm"
    
    db 0xED, 0xFD   ; RETEM (8086へ復帰)

; 8086復帰
after_8080:
    xor ax, ax
    mov ds, ax
    mov ax, 0xB800
    mov es, ax
    
    ; --- バッファからVRAMに複製 ---
    mov si, buffer_addr
    mov di, 0x0000
    mov cx, 8    ; 4文字×2バイト
    rep movsb ; DS:SI → ES:DI
    
    mov si, msg_back
    call print_string
    
hang:
    jmp hang

print_string:
    lodsb
    or al, al
    jz .done
    mov ah, 0x0E
    int 0x10
    jmp print_string
.done:
    ret

msg_enter db "Entering 8080 mode...", 13, 10, 0
msg_back  db "Successfully returned!", 13, 10, 0

times 510-($-$$) db 0
dw 0xAA55
