extern void xPortSysTickHandler(void);

void eiint_handler(unsigned long eiic)
{
    switch (eiic)
    {
    case 0x104c:
        xPortSysTickHandler();
        break;
    }
}
