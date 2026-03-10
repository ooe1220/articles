
```kernel.c
typedef unsigned char uint8_t;

volatile uint8_t* vram = (uint8_t*)0xA0000;

void rect(int x,int y,int w,int h,int c)
{
    for(int j=0;j<h;j++)
        for(int i=0;i<w;i++)
            vram[(y+j)*320 + (x+i)] = c;
}

    
void kernel_main()
{
    for(int y=0;y<200;y++)
        for(int x=0;x<320;x++)
            vram[y*320+x] = 2;
    
    rect(50,40,200,120,15); // window 白
    rect(50,40,200,10,9);   // title bar 青
    rect(0,180,320,20,7);   // タスクバー 灰色
    
    asm volatile("cli"); 
    asm volatile("hlt"); 
}
```
