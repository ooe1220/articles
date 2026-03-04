

```kernel.c
typedef unsigned int uint32_t;
typedef unsigned short uint16_t;
typedef unsigned char uint8_t;

// ここに登録するもの
// Baseアドレス32bit (セグメントは殆ど使わないので基本0を設定)
// Limit 20bit (0xFFFFF)
// 制限
// 設定
struct gdt_entry {
    uint16_t limit_low;        // 
    uint16_t base_low;         // 
    uint8_t  base_middle;      // 
    uint8_t  access;           // 
    uint8_t  limit_high_flags; // 
    uint8_t  base_high;        // 
} __attribute__((packed));

struct gdt_ptr {
    uint16_t limit; // GDT全体の大きさ-1
    uint32_t base;  // GDTの先頭アドレス
} __attribute__((packed));


struct gdt_entry gdt[5];
struct gdt_ptr gdtp;

void gdt_set_entry(int index, uint32_t base, uint32_t limit, uint8_t access, uint8_t flags);
void gdt_init();
void load_gdt();

int kernel_main() {
    
    gdt_init();
    load_gdt();

    uint16_t cs_val;
    asm volatile("mov %%cs, %0" : "=r"(cs_val));
    
    while(1){}
}

void gdt_set_entry(int index, uint32_t base, uint32_t limit, uint8_t access, uint8_t flags) {
    gdt[index].base_low = base & 0xFFFF;
    gdt[index].base_middle = (base >> 16) & 0xFF;
    gdt[index].base_high = (base >> 24) & 0xFF;
    
    gdt[index].limit_low = limit & 0xFFFF;
    gdt[index].limit_high_flags = ((limit >> 16) & 0x0F) | (flags & 0xF0);
    
    gdt[index].access = access;
}

void gdt_init() {

    gdt_set_entry(0, 0, 0, 0, 0);

    // カーネル コード
    // 0x9A=1001 1010
    // 1001 : 1(メモリ上に存在) 00(ring0) 1(コード/データ)
    // 0101 : 1(コード) 0(?) 1(読み込み可能) 0(CPU参照で自動1)
    gdt_set_entry(1, 0, 0xFFFFF, 0x9A, 0xC0);

    // カーネル　データ
    // 0x92=1001 0010
    // 1001 : 上参照
    // 0010 : 0(データ) 0(?) 1(書き込み可能) 0(CPU参照で自動1)
    gdt_set_entry(2, 0, 0xFFFFF, 0x92, 0xC0);

    // ユーザ　コード
    // 0xFA=1111 1010
    // 1111 : 1(メモリ上に存在) 11(ring3) 1(コード/データ)
    // 1010 : 1(コード) 0(?)  1(読み込み可能) 0(CPU参照で自動1)
    gdt_set_entry(3, 0, 0xFFFFF, 0xFA, 0xC0);

    // ユーザ　データ
    // 0xF2=1111 0010
    // 1111 : 上参照
    // 0010 : 0(データ) 0(?)  1(読み込み可能) 0(CPU参照で自動1)
    gdt_set_entry(4, 0, 0xFFFFF, 0xF2, 0xC0);
    
    gdtp.limit = sizeof(gdt) - 1;
    gdtp.base = (uint32_t)&gdt;
    
}

// DS=0x08(GDT1番目　カーネルコード) CS=0x10(GDT2番目　カーネルデータ)
void load_gdt() {
    asm volatile(
        "lgdt (%0)\n\t"
        "mov $0x10, %%ax\n\t"
        "mov %%ax, %%ds\n\t"
        "mov %%ax, %%es\n\t"
        "mov %%ax, %%fs\n\t"
        "mov %%ax, %%gs\n\t"
        "mov %%ax, %%ss\n\t"
        "ljmp $0x08, $flush\n\t"
        "flush:\n\t"
        :
        : "r"(&gdtp)
    );
}
```

セグメントレジスタの値

```
0x08 = 0000 0000 0000 1000
15:3 1 = GDT1番目
2 GDTかLDTか→0
1:0 PRL カーネル権限00

ユーザコード 0x18+3=0x1B
ユーザデータ 0x20+3=0x23

0x10 = 2番目カーネル　データセグ面戸

0x08=0000 0000 0000 1000 (001 0 00) 01=GDT1番目 0=GDT 00=ring0
0x10=0000 0000 0001 0000 (010 0 00)
0x1B=0000 0000 0001 1011 (011 0 11) 11=ring3
0x23=0000 0000 0010 0011 (100 0 11)

```







