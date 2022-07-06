/*
 * According to the manual, the F1L series has up to 287 EI level interrupts
 */
#define EIINT_COUNT (287)

extern void INTTAUJ0I0(void);
extern void INTTAUJ0I1(void);
extern void INTOSTM0(void);

#if defined(__GNUC__)
__attribute__((section(".inttbl")))
#elif defined(__ICCRH850__)
#pragma location = ".inttbl"
#elif defined(__CCRH__)
#pragma section const ".inttbl"
#endif
void *const IntTable[EIINT_COUNT] = {
    [0x48] = (void *)INTTAUJ0I0,
    [0x49] = (void *)INTTAUJ0I1,
    [0x4c] = (void *)INTOSTM0,
};
