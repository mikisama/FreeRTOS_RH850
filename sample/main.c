#include "FreeRTOS.h"
#include "task.h"
#include "timers.h"

#include "IntQueue.h"

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

void CLKC_Init(void)
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
            asm("nop");
        }
    }

    if ((PLLS & 0x04u) != 0x04u) /* Check if PLL needs to be started */
    {
        /* Prepare PLL*/
        PLLC = PllcValue;                               /* 80MHz PLL */
        protected_write(PROTCMD1, PROTS1, PLLE, 0x01u); /* Enable PLL */
        while ((PLLS & 0x04u) != 0x04u)
        {
            /* Wait for active PLL */
            asm("nop");
        }
    }

    /* PLL0 -> CPU Clock */
    protected_write(PROTCMD1, PROTS1, CKSC_CPUCLKS_CTL, 0x03u);
    while (CKSC_CPUCLKS_ACT != 0x03u)
    {
        asm("nop");
    }

    /* CPU Clock divider = PLL0/1 */
    protected_write(PROTCMD1, PROTS1, CKSC_CPUCLKD_CTL, 0x01u);
    while (CKSC_CPUCLKD_ACT != 0x01u)
    {
        asm("nop");
    }

    /* Set Peripheral CLK2 to 40 MHZ (PPLL2) */
    protected_write(PROTCMD1, PROTS1, CKSC_IPERI2S_CTL, 0x02u);
    while (CKSC_IPERI2S_ACT != 0x02u)
    {
        asm("nop");
    }
}

#define GPIO_P(P, N) P##N
#define GPIO_PM(P, N) P##M##N
#define GPIO_PMC(P, N) P##MC##N
#define GPIO_PNOT(P, N) P##NOT##N

#define GPIO_SET_OUT_LOW(P, N, PIN)    \
    do                                 \
    {                                  \
        GPIO_P(P, N) &= ~(1 << PIN);   \
        GPIO_PM(P, N) &= ~(1 << PIN);  \
        GPIO_PMC(P, N) &= ~(1 << PIN); \
    } while (0)

#define GPIO_SET_OUT_HIGH(P, N, PIN)   \
    do                                 \
    {                                  \
        GPIO_P(P, N) |= (1 << PIN);    \
        GPIO_PM(P, N) &= ~(1 << PIN);  \
        GPIO_PMC(P, N) &= ~(1 << PIN); \
    } while (0)

#define GPIO_TOOGLE(P, N, PIN)         \
    do                                 \
    {                                  \
        GPIO_PNOT(P, N) |= (1 << PIN); \
    } while (0)

void LED_TASK(void *pvParameters)
{
    for (;;)
    {
        /* toggle P0 pin 0 output every 500ms */
        GPIO_TOOGLE(P, 0, 0);
        vTaskDelay(500);
    }
}

uint32_t ulRegTest1LoopCounter = 0;
uint32_t ulRegTest2LoopCounter = 0;

extern void vRegTest1Task(void *pvParameters);
extern void vRegTest2Task(void *pvParameters);

void prvCheckTimerCallback(TimerHandle_t xTimer);

int main(void)
{
    CLKC_Init();

    /* set P0 pin 0 output low */
    GPIO_SET_OUT_LOW(P, 0, 0);

    vStartInterruptQueueTasks();

    xTaskCreate(vRegTest1Task,            /* Function that implements the task. */
                "vRegTest1Task",          /* Text name of the task. */
                configMINIMAL_STACK_SIZE, /* Stack allocated to the task. */
                NULL,                     /* The task parameter is not used. */
                0,                        /* The priority to assign to the task. */
                NULL);                    /* Don't receive a handle back, it is not needed. */

    xTaskCreate(vRegTest2Task,            /* Function that implements the task. */
                "vRegTest2Task",          /* Text name of the task. */
                configMINIMAL_STACK_SIZE, /* Stack allocated to the task. */
                NULL,                     /* The task parameter is not used. */
                0,                        /* The priority to assign to the task. */
                NULL);                    /* Don't receive a handle back, it is not needed. */

    TimerHandle_t xTimer = xTimerCreate("CheckTimer",           /* A text name, purely to help debugging. */
                                        3000,                   /* The timer period, in this case 3000ms (3s). */
                                        pdTRUE,                 /* This is an auto-reload timer, so xAutoReload is set to pdTRUE. */
                                        NULL,                   /* The ID is not used, so can be set to anything. */
                                        prvCheckTimerCallback); /* The callback function that inspects the status of all the other tasks. */
    configASSERT(xTimer);
    xTimerStart(xTimer, 0);

    vTaskStartScheduler();
}

void prvCheckTimerCallback(TimerHandle_t xTimer)
{
    static uint32_t ulLastRegTest1Value = 0, ulLastRegTest2Value = 0;
    static BaseType_t lChangedTimerPeriodAlready = pdFALSE;
    BaseType_t ulErrorFound = pdFALSE;

    if (xAreIntQueueTasksStillRunning() != pdPASS)
    {
        ulErrorFound |= (1 << 0);
    }

    /* Check that the register test 1 task is still running. */
    if (ulLastRegTest1Value == ulRegTest1LoopCounter)
    {
        ulErrorFound |= (1 << 4);
    }
    ulLastRegTest1Value = ulRegTest1LoopCounter;

    /* Check that the register test 2 task is still running. */
    if (ulLastRegTest2Value == ulRegTest2LoopCounter)
    {
        ulErrorFound |= (1 << 5);
    }
    ulLastRegTest2Value = ulRegTest2LoopCounter;

    GPIO_TOOGLE(P, 0, 0);

    if (ulErrorFound != pdFALSE)
    {
        if (lChangedTimerPeriodAlready == pdFALSE)
        {
            lChangedTimerPeriodAlready = pdTRUE;
            xTimerChangePeriod(xTimer, 200, 0);
        }
    }
}
