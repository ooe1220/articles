
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
    
    rect(100,60,120,80,7);
    
    asm volatile("cli"); 
    asm volatile("hlt"); 
}
```
