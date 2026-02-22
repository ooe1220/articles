# 問題1
int型変数 a = 10 を用意し、
aの値
aのアドレス
ポインタ経由の値を表示せよ。

条件
int a = 10;
int *p = &a;

目的
& と * の理解

```mondai1.c
#include<stdio.h>

void main(){
 int a=10;
 int *ptr=&a;
 printf("a=%d ",a);
 printf("&a=%x ",&a);
 printf("*ptr=%d ",*ptr);
}
```
<img width="1920" height="1080" alt="截图 2026-02-22 22-41-37" src="https://github.com/user-attachments/assets/b5ad4d24-c577-4efa-a9d2-ec4563edd581" />



# 問題2（重要）
ポインタを使って値を書き換えよ。
int a = 5;
ポインタ経由で 20に変更 して表示。
目的
「ポインタ＝メモリ書き込み」

```mondai2.c
#include<stdio.h>

void main(){
 int a=5;
 int *ptr=&a;
 *ptr=20;

 printf("a=%d ",a);
}
```
<img width="1920" height="1080" alt="截图 2026-02-22 22-41-56" src="https://github.com/user-attachments/assets/94c918bc-c31b-40d9-a12f-a8d94804329b" />


# 問題3
次の関数を作れ
void set100(int *p);
mainから呼び出し、変数を100に変更させる。
目的
値渡しと参照渡しの違い

```mondai3.c
#include<stdio.h>

void set100(int *p){
 *p=100;
}

void main(){
 int a=5;
 set100(&a);
 printf("a=%d ",a);
}
```
<img width="1920" height="1080" alt="截图 2026-02-22 22-42-16" src="https://github.com/user-attachments/assets/96197dbe-3fa5-455d-8ad4-0022fd1bacbe" />


# 問題4
2つの変数を入れ替える関数を作れ
void swap(int *a, int *b);
例：
x = 10, y = 20
→ swap後
x = 20, y = 10

```mondai4.c
#include<stdio.h>

void swap(int *a,int *b){
 int tmp=*a;
 *a=*b;
 *b=tmp;
}

void main(){
 int x=5;
 int y=100;
 swap(&x,&y);

 printf("x=%d y=%d",x,y);
}
```
<img width="1920" height="1080" alt="截图 2026-02-22 22-42-30" src="https://github.com/user-attachments/assets/0abac785-e7ac-499e-a41c-5ee87085214b" />


# 問題5
配列をポインタで走査せよ
int arr[5] = {1,2,3,4,5};
次の形式で表示
値:1 アドレス:xxxx
値:2 アドレス:xxxx
...
条件
arr[i]は禁止
*(p+i) または p++ を使う

```mondai5.c
#include<stdio.h>

void main(){
 int arr[5] = {1,2,3,4,5};
 int i;

 int *p=&arr;

 for(i=0;i<5;i++)
  printf("抣%d 傾僪儗僗:%x \n",*(p+i),p+i);
}
```
<img width="1920" height="1080" alt="截图 2026-02-22 22-42-46" src="https://github.com/user-attachments/assets/a6215c2a-b6a8-46c5-b4be-4c28dcf0eed3" />


# 問題6
配列の合計を求める関数を作れ
int sum(int *p, int size);


```mondai6.c
#include<stdio.h>

int sum(int *p,int size){
 int ret=0;
 int i;
 for(i=0;i<size;i++){
  ret+=*p++;
 }
 return ret;
}

void main(){
 int arr[5] = {1,2,3,4,5};
 int s=sum(&arr,5); 
 printf("s=%d",s);
}
```
<img width="1920" height="1080" alt="截图 2026-02-22 22-43-01" src="https://github.com/user-attachments/assets/52293072-fd1c-47d3-b942-d9d0808a271d" />


# 問題7 欠番

# 問題8（文字列）

ポインタだけで文字列の長さを求める関数
int my_strlen(char *s);
※ strlen禁止
ヒント：
while(*s) {
    count++;
    s++;
}

```mondai8.c
#include<stdio.h>

int mystrlen(char *s){
 int count=0;
 while(*s++){
  count++;
 }
 return count;
}

void main(){
 char str[]="abcde";
 int cnt=mystrlen(&str);
 printf("cnt=%d",cnt);
}
```
<img width="1920" height="1080" alt="截图 2026-02-22 22-43-21" src="https://github.com/user-attachments/assets/9081ccb7-b60b-4152-9fcc-9c37b3c00ccb" />


# 問題9（重要）
配列の中の最大値を返す関数
int max(int *p, int size);

```mondai9.c
#include<stdio.h>

int max(int *p,int size){
 int max=0;
 int i;
 for(i=0;i<size;i++){
  if(*(p+i) > max)max=*(p+i);
 }

 return max;
}

void main(){
 int array[]={1,5,6,3,5,199,9};
 int maxnum=max(&array,7);
 printf("maxnum=%d",maxnum);
}
```
<img width="1920" height="1080" alt="截图 2026-02-22 22-43-36" src="https://github.com/user-attachments/assets/af7052ef-cad9-4891-acdb-d891659faefa" />


# 問題10
次を実装
void mem_copy(char *dst, char *src, int size);
※ memcpy禁止

```mondai10.c
#include<stdio.h>

void memcopy(char *dst,char *src,int size){
 while(size!=0){
  *dst++=*src++;
  size--;
 }
}

void main(){
 char arr1[]={0x01,0x02,0x03,0x04,0x05};
 char arr2[5];
 int i;

 memcopy(&arr2,&arr1,5);
 for(i=0;i<5;i++)
  printf("arr2[%i] = %x \n",i,*(arr2+i));
}
```
<img width="1920" height="1080" alt="截图 2026-02-22 22-43-53" src="https://github.com/user-attachments/assets/ebb7503e-c7e9-4e1f-a3d6-033c382cb728" />


# 問題11
メモリを0クリア
void mem_zero(char *p, int size);
これはC版の memset(p,0,size)

```mondai11.c
#include<stdio.h>

void memzero(char *p,int size){
 while(size!=0){
  *p++=0;
  size--;
 }
}

void main(){
 char arr[]={0x01,0x02,0x03,0x04,0x05};
 int i;

 memzero(arr,5);
 for(i=0;i<5;i++)
  printf("arr[%i] = %x \n",i,*(arr+i));
}
```
<img width="1920" height="1080" alt="截图 2026-02-22 22-44-08" src="https://github.com/user-attachments/assets/08415bbc-2a23-4a50-a410-7c7246054479" />
