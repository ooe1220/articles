

```kernel.c
typedef unsigned int uint32_t;
typedef unsigned short uint16_t;
typedef unsigned char uint8_t;

void putc(char c) {
    static int pos = 0;
    volatile unsigned short* vram = (unsigned short*)0xB8000;
    vram[pos++] = 0x0F00 | c; //属性 背景色 = 0x0 = 黒 文字色 = 0xF = 白
}

void puts(const char* s) {
    while (*s) putc(*s++);
}

/*
 IDT 1個分の構造体
*/
struct idt_entry {
    uint16_t offset_low;  // ISR アドレス下位 16bit
    uint16_t selector;     // コードセグメント
    uint8_t  zero;         // 常に 0
    uint8_t  type_attr;
    uint16_t offset_high;  // ISR アドレス上位 16bit
} __attribute__((packed));

/*
 * IDTR に渡す構造体
 * lidt 命令は
 *   limit : IDT 全体の大きさ - 1
 *   base  : IDT 配列の先頭アドレス
 *  が必要
 */
struct idt_ptr {
    uint16_t limit;
    uint32_t base;
} __attribute__((packed));


/*
 * IDT 本体
 * 256 個分（CPU 仕様）
 *
 * 0〜31   : CPU 例外
 * 32〜47  : IRQ (PIC)
 * 48〜255 : 
 */
static struct idt_entry idt[256];

/*
 * IDTに1個分処理を設定する関数
 *
 * n       : IDT 番号（例外番号 / IRQ 番号）
 * handler : ISR のアドレス
 */
void idt_set_gate(int n, uint32_t handler) {
    idt[n].offset_low  = handler & 0xFFFF;
    idt[n].selector    = 0x08; // CS(カーネル)の選択子
    idt[n].zero        = 0;
    idt[n].type_attr   = 0x8E;
    idt[n].offset_high = handler >> 16;
}

/*
 * IDTの空表をCPUへ登録
 */
void idt_init(void) {
    struct idt_ptr idtp; // lidt は「値」を読むだけ。ローカル変数で問題無し
    idtp.limit = sizeof(idt) - 1;
    idtp.base  = (uint32_t)&idt;

    asm volatile("lidt (%0)" :: "r"(&idtp));
    //asm volatile("lidt %0" : : "m"(idtp));
}

void isr0_handler()
{
    puts("DIVIDE ERROR");
    while(1);
}

void isr6_handler()
{
    puts("INVALID OPCODE");
    while(1);
}

void isr13_handler(uint32_t error)
{
    puts("GENERAL PROTECTION");
    while(1);
}

void isr14_handler(uint32_t error)
{
    puts("PAGE FAULT");
    while(1);
}

int kernel_main() {
    asm volatile("cli"); 
    idt_set_gate(0, (uint32_t)isr0_handler);
    idt_set_gate(6, (uint32_t)isr6_handler);
    idt_set_gate(13, (uint32_t)isr13_handler);
    idt_set_gate(14, (uint32_t)isr14_handler);
    idt_init();
    asm volatile("sti"); 
    
    int a=1;
    int b=0;
    int c=a/b;

    //asm volatile ("ud2");
    
    while(1);
}
```


