extern void xPortSysTickHandler(void);
extern void INTTAUJ0I0_IRQHandler(void);
extern void INTTAUJ0I1_IRQHandler(void);

void vISRHandler(unsigned long eiic)
{
    switch (eiic)
    {
    case 0x1048:
        INTTAUJ0I0_IRQHandler();
        break;
    case 0x1049:
        INTTAUJ0I1_IRQHandler();
        break;
    case 0x104c:
        xPortSysTickHandler();
        break;
    }
}
