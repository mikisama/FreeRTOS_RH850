#include "FreeRTOS.h"
#include "task.h"

#define CRYSTAL8 8
#define CRYSTAL16 16
#define CRYSTAL24 24

#ifndef CRYSTAL_FREQ
#define CRYSTAL_FREQ CRYSTAL8
#endif

#if CRYSTAL_FREQ == CRYSTAL8
#define GAIN 0x07
#define PllcValue 0x00000227
/* MainOSC stabilization time 8.19ms */
/* 0xffff / 8000000 * 1000 = 8.19 */
#elif CRYSTAL_FREQ == CRYSTAL16
#define GAIN 0x6
#define PllcValue 0x00000A27
/* MainOSC stabilization time 4.09ms */
/* 0xffff / 16000000 * 1000 = 4.09 */
#elif CRYSTAL_FREQ == CRYSTAL24
#define GAIN 0x4
#define PllcValue 0x00001227
/* MainOSC stabilization time 2.73ms */
/* 0xffff / 24000000 * 1000 = 2.73 */
#else
#error no valid crystal freq. valid values are: 8 16 24
#endif

void prvSetupHardware(void)
{
    /* Prepare MainOsc */
    if ((MOSCS & 0x04u) != 0x4u) /* Check if MainOsc needs to be started */
    {
        MOSCC = GAIN;                                    /* Set MainOSC gain */
        MOSCST = 0x0000ffffu;                            /* Set MainOSC stabilization time to max */
        protected_write(PROTCMD0, PROTS0, MOSCE, 0x01u); /* Trigger Enable (protected write) */
        while ((MOSCS & 0x04u) != 0x04u)
        {
            /* Wait for active MainOSC */
            __NOP();
        }
    }

    if ((PLLS & 0x04u) != 0x04u) /* Check if PLL needs to be started */
    {
        /* Prepare PLL */
        PLLC = PllcValue;                               /* 80MHz PLL */
        protected_write(PROTCMD1, PROTS1, PLLE, 0x01u); /* Enable PLL */
        while ((PLLS & 0x04u) != 0x04u)
        {
            /* Wait for active PLL */
            __NOP();
        }
    }

    /* CPU Clock 80MHz */
    protected_write(PROTCMD1, PROTS1, CKSC_CPUCLKS_CTL, 0x03u);
    while (CKSC_CPUCLKS_ACT != 0x03u)
    {
        __NOP();
    }

    /*
     * Setup LED Port
     * LED is on P0_0
     */
    P0 &= ~(1 << 0);
    PM0 &= ~(1 << 0);
    PMC0 &= ~(1 << 0);

    /*
     * set EBASE.RINT
     * all EI level interrupts will jump to 0x0100
     */
#if defined(__GNUC__) || defined(__ICCRH850__)
    asm("ldsr %[ebase], 3, 1" ::[ebase] "r"(0x0001));
#elif defined(__CCRH__)
    __ldsr_rh(3, 1, 0x0001);
#endif
}

extern void main_blinky(void);
extern void main_full(void);

int main(void)
{
    prvSetupHardware();

#if 0
    main_blinky();
#else
    main_full();
#endif

    return 0;
}

void vMainToggleLED(void)
{
    PNOT0 |= (1 << 0);
}
