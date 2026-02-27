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
gcc -m32 -S -O0 -masm=intel \
-fno-asynchronous-unwind-tables \
-fno-unwind-tables \
-fno-stack-protector \
-fno-pic \
-fno-pie \
testc.c

gcc -m32 -S -O2 -masm=intel \
-fno-asynchronous-unwind-tables \
-fno-unwind-tables \
-fno-stack-protector \
-fno-pic \
-fno-pie \
testc.c
```

# 問題1：足し算（最初の基本）
Cコード
```c
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

## 手作業
### そのまま変換

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
    
main:
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
    ret

_start:

    call main
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

### C言語を意識せずに書く

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
(gdb) info registers eax
eax            0x5                 5
```

## コンパイラ版

###　最適化無し -O0
```testc.s
	.file	"testc.c"
	.intel_syntax noprefix
	.text
	.globl	add
	.type	add, @function
add:
	push	ebp
	mov	ebp, esp
	sub	esp, 16
	mov	edx, DWORD PTR [ebp+8]
	mov	eax, DWORD PTR [ebp+12]
	add	eax, edx
	mov	DWORD PTR [ebp-4], eax
	mov	eax, DWORD PTR [ebp-4]
	leave
	ret
	.size	add, .-add
	.globl	main
	.type	main, @function
main:
	push	ebp
	mov	ebp, esp
	sub	esp, 16
	push	3
	push	2
	call	add
	add	esp, 8
	mov	DWORD PTR [ebp-4], eax
	mov	eax, DWORD PTR [ebp-4]
	leave
	ret
	.size	main, .-main
	.ident	"GCC: (Ubuntu 11.4.0-1ubuntu1~22.04.2) 11.4.0"
	.section	.note.GNU-stack,"",@progbits
```

###　最適化あり -O2
```testc.s
	.file	"testc.c"
	.intel_syntax noprefix
	.text
	.p2align 4
	.globl	add
	.type	add, @function
add:
	mov	eax, DWORD PTR [esp+8]
	add	eax, DWORD PTR [esp+4]
	ret
	.size	add, .-add
	.section	.text.startup,"ax",@progbits
	.p2align 4
	.globl	main
	.type	main, @function
main:
	mov	eax, 5
	ret
	.size	main, .-main
	.ident	"GCC: (Ubuntu 11.4.0-1ubuntu1~22.04.2) 11.4.0"
	.section	.note.GNU-stack,"",@progbits
```
## 考察

`int c = a + b;`の部分に関して筆者は
```
    mov eax,dword [ebp+8]
    add eax,dword [ebp+12]
    mov dword [ebp-4],eax
```
のようになると予想していましたが、コンパイラは各変数をレジスタに入れてから、レジスタ同士を加算するコードを生成しました。
```
	mov	edx, DWORD PTR [ebp+8]
	mov	eax, DWORD PTR [ebp+12]
	add	eax, edx
```


# 問題2：条件分岐
Cコード
```c
int max(int a, int b)
{
    if (a > b)
        return a;
    else
        return b;
}

int main()
{
    int r;
    r = max(10, 4);
    return r;
}
```
条件
cmp
条件ジャンプ（jg / jle など）
mainは問題1と同じ形式

## 手作業

```test.asm
BITS 32

section .text
global _start

max:
    push ebp
    mov ebp,esp
    sub esp,16
    
    mov ebx,dword [ebp+8]  ; b
    mov eax,dword [ebp+12] ; a
    cmp eax,ebx
    jg la;  a>b
    mov eax,dword [ebp+8] ; return b;
    jmp end
la:
    mov eax,dword [ebp+12] ; return a;
end:
    
    mov esp,ebp
    pop ebp
    ret
    
main:
    push ebp
    mov ebp,esp
    sub esp,16
    
    push 4
    push 10
    call max
    add esp,8
    
    mov dword [ebp-4],eax
    mov eax, dword [ebp-4] 
    
    mov esp,ebp
    pop ebp
    ret


_start:

    call main
    int 3; //ここで止め、GDBからEAXの値を確認

    ; exit(0)
    mov eax, 1      ; sys_exit
    mov ebx, 0
    int 0x80
```
```
(gdb) info registers eax
eax            0xa                 10
```

## コンパイラ版

###　最適化無し -O0

```testc.s
	.file	"testc.c"
	.intel_syntax noprefix
	.text
	.globl	max
	.type	max, @function
max:
	push	ebp
	mov	ebp, esp
	mov	eax, DWORD PTR [ebp+8]
	cmp	eax, DWORD PTR [ebp+12]
	jle	.L2
	mov	eax, DWORD PTR [ebp+8]
	jmp	.L3
.L2:
	mov	eax, DWORD PTR [ebp+12]
.L3:
	pop	ebp
	ret
	.size	max, .-max
	.globl	main
	.type	main, @function
main:
	push	ebp
	mov	ebp, esp
	sub	esp, 16
	push	4
	push	10
	call	max
	add	esp, 8
	mov	DWORD PTR [ebp-4], eax
	mov	eax, DWORD PTR [ebp-4]
	leave
	ret
	.size	main, .-main
	.ident	"GCC: (Ubuntu 11.4.0-1ubuntu1~22.04.2) 11.4.0"
	.section	.note.GNU-stack,"",@progbits
```

###　最適化あり -O2

```testc.s
	.file	"testc.c"
	.intel_syntax noprefix
	.text
	.p2align 4
	.globl	max
	.type	max, @function
max:
	mov	eax, DWORD PTR [esp+4]
	mov	edx, DWORD PTR [esp+8]
	cmp	eax, edx
	cmovl	eax, edx
	ret
	.size	max, .-max
	.section	.text.startup,"ax",@progbits
	.p2align 4
	.globl	main
	.type	main, @function
main:
	mov	eax, 10
	ret
	.size	main, .-main
	.ident	"GCC: (Ubuntu 11.4.0-1ubuntu1~22.04.2) 11.4.0"
	.section	.note.GNU-stack,"",@progbits
```
