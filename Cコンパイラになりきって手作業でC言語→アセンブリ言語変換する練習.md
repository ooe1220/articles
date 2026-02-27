# 目的

C言語で書いたプログラムをアセンブリ言語に変換してどのようにCPU上で実行されるかを確認する機会が多々あります。
コンパイラの変換規則を理解する為に、自分でもコンパイラになりきって、手作業でC言語→アセンブリへ変換する練習をします。
練習問題はGPTで自動生成します。

アセンブラ及びデバッグの命令
```
nasm -f elf32 test.asm
ld -m elf_i386 -o test test.o
gdb ./test
run
info registers eax
```

本物のコンパイラが生成したアセンブリと比較する
```
gcc -m32 -S -O0 -masm=intel testc.c
gcc -m32 -S -O2 -masm=intel testc.c
```

# 問題1：足し算（最初の基本）
Cコード
```
int add(int a, int b)
{
    int c = a + b;
    return c;
}

int main()
{
    int r;
    r = add(2, 3);
    return r;
}
```
条件
add
プロローグ／エピローグあり
ローカル変数 c をスタックに置く
main
ローカル変数 r
呼び出しは cdec

## そのまま変換

```test.asm
BITS 32

section .text
global _start

add:
    push ebp
    mov ebp,esp
    sub esp,4
    
    mov eax,dword [ebp+8]
    add eax,dword [ebp+12]
    mov dword [ebp-4],eax
    mov eax,dword [ebp-4] ; return c
    
    mov esp,ebp
    pop ebp
    ret

_start:
    push ebp
    mov ebp,esp
    sub esp,4
    
    push 3
    push 2
    call add
    add esp,8
    mov dword [ebp-4],eax
    
    mov eax, dword [ebp-4] ; return r
    
    mov esp,ebp
    pop ebp
    
    int 3 ; //ここで止め、GDBからEAXの値を確認
    
    ; exit(0)
    mov eax, 1      ; sys_exit
    mov ebx, 0 
    int 0x80
```

```
(gdb) info registers eax
eax            0x5                 5
```

## C言語を意識せずに書く

```test.asm
BITS 32

section .text
global _start

add:
    add eax,ebx
    ret

_start:
 
    mov eax,2
    mov ebx,3
    call add
    
    int 3
    
    ; exit(0)
    mov eax, 1      ; sys_exit
    mov ebx, 0
    int 0x80
```
```
eax            0x5                 5
```
