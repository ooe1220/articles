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
