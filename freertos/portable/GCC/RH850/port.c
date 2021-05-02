/*
 * FreeRTOS Kernel V10.3.1
 * Copyright (C) 2020 Amazon.com, Inc. or its affiliates.  All Rights Reserved.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy of
 * this software and associated documentation files (the "Software"), to deal in
 * the Software without restriction, including without limitation the rights to
 * use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
 * the Software, and to permit persons to whom the Software is furnished to do so,
 * subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
 * FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
 * COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
 * IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
 * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 *
 * http://www.FreeRTOS.org
 * http://aws.amazon.com/freertos
 *
 * 1 tab == 4 spaces!
 */

/* Scheduler includes. */
#include "FreeRTOS.h"
#include "task.h"

/* Constants required to set up the initial stack. */
#define portINITIAL_PSW     ( 0x00008000 ) /* PSW.EBV bit */

#ifndef configISR_STACK_SIZE
#define configISR_STACK_SIZE ( 512 )
#endif

/* The stack used by interrupt service routines. */
static StackType_t xISRStack[ configISR_STACK_SIZE ] = { 0 };

/* The top of ISR stack. */
const StackType_t * const xISRStackTop = &( xISRStack[ ( configISR_STACK_SIZE & ~portBYTE_ALIGNMENT_MASK ) ] );

/* Counts the interrupt nesting depth. A context switch is only performed
 * if the nesting depth is 0. */
volatile BaseType_t xInterruptNesting = 0;

/* Set to 1 to pend a context switch from an ISR. */
volatile BaseType_t xPortSwitchRequired = pdFALSE;

/*
 * Setup the timer to generate the tick interrupts.  The implementation in this
 * file is weak to allow application writers to change the timer used to
 * generate the tick interrupt.
 */
void vPortSetupTimerInterrupt( void );

/*
 * Exception handlers.
 */
void xPortSysTickHandler( void );

/*
 * Start first task is a separate function so it can be tested in isolation.
 */
extern void vPortStartFirstTask( void );

/*
 * Used to catch tasks that attempt to return from their implementing function.
 */
static void prvTaskExitError( void );

/*-----------------------------------------------------------*/

/*
 * See header file for description.
 */
StackType_t *pxPortInitialiseStack( StackType_t * pxTopOfStack,
                                    TaskFunction_t pxCode,
                                    void * pvParameters )
{
    /* Simulate the stack frame as it would be created by a context switch
     * interrupt. */
    *( pxTopOfStack ) = ( StackType_t ) prvTaskExitError;   /* R31 (LP) */
    *( --pxTopOfStack ) = ( StackType_t ) pvParameters;     /* R6       */
    *( --pxTopOfStack ) = ( StackType_t ) 0x07070707;       /* R7       */
    *( --pxTopOfStack ) = ( StackType_t ) 0x08080808;       /* R8       */
    *( --pxTopOfStack ) = ( StackType_t ) 0x09090909;       /* R9       */
    *( --pxTopOfStack ) = ( StackType_t ) 0x10101010;       /* R10      */
    *( --pxTopOfStack ) = ( StackType_t ) 0x11111111;       /* R11      */
    *( --pxTopOfStack ) = ( StackType_t ) 0x12121212;       /* R12      */
    *( --pxTopOfStack ) = ( StackType_t ) 0x13131313;       /* R13      */
    *( --pxTopOfStack ) = ( StackType_t ) 0x14141414;       /* R14      */
    *( --pxTopOfStack ) = ( StackType_t ) 0x15151515;       /* R15      */
    *( --pxTopOfStack ) = ( StackType_t ) 0x16161616;       /* R16      */
    *( --pxTopOfStack ) = ( StackType_t ) 0x17171717;       /* R17      */
    *( --pxTopOfStack ) = ( StackType_t ) 0x18181818;       /* R18      */
    *( --pxTopOfStack ) = ( StackType_t ) 0x19191919;       /* R19      */
    *( --pxTopOfStack ) = ( StackType_t ) 0x01010101;       /* R1       */
    *( --pxTopOfStack ) = ( StackType_t ) 0x02020202;       /* R2       */
    *( --pxTopOfStack ) = ( StackType_t ) portINITIAL_PSW;  /* EIPSW    */
    *( --pxTopOfStack ) = ( StackType_t ) pxCode;           /* EIPC     */
    *( --pxTopOfStack ) = ( StackType_t ) 0x20202020;       /* R20      */
    *( --pxTopOfStack ) = ( StackType_t ) 0x21212121;       /* R21      */
    *( --pxTopOfStack ) = ( StackType_t ) 0x22222222;       /* R22      */
    *( --pxTopOfStack ) = ( StackType_t ) 0x23232323;       /* R23      */
    *( --pxTopOfStack ) = ( StackType_t ) 0x24242424;       /* R24      */
    *( --pxTopOfStack ) = ( StackType_t ) 0x25252525;       /* R25      */
    *( --pxTopOfStack ) = ( StackType_t ) 0x26262626;       /* R26      */
    *( --pxTopOfStack ) = ( StackType_t ) 0x27272727;       /* R27      */
    *( --pxTopOfStack ) = ( StackType_t ) 0x28282828;       /* R28      */
    *( --pxTopOfStack ) = ( StackType_t ) 0x29292929;       /* R29      */
    *( --pxTopOfStack ) = ( StackType_t ) 0x30303030;       /* R30 (EP) */

    return pxTopOfStack;
}
/*-----------------------------------------------------------*/

static void prvTaskExitError( void )
{
    /* A function that implements a task must not exit or attempt to return to
     * its caller as there is nothing to return to.  If a task wants to exit it
     * should instead call vTaskDelete( NULL ).
     *
     * Artificially force an assert() to be triggered if configASSERT() is
     * defined, then stop here so application writers can catch the error. */
    configASSERT( pdFALSE );
}
/*-----------------------------------------------------------*/

/*
 * See header file for description.
 */
BaseType_t xPortStartScheduler( void )
{
    /* Start the timer that generates the tick ISR.  Interrupts are disabled
     * here already. */
    vPortSetupTimerInterrupt();

    /* Start the first task. */
    vPortStartFirstTask();

    /* Should not get here! */
    return 0;
}
/*-----------------------------------------------------------*/

void vPortEndScheduler( void )
{
    /* Not implemented in ports where there is nothing to return to.
     * Artificially force an assert. */
    configASSERT( pdFALSE );
}
/*-----------------------------------------------------------*/

void xPortSysTickHandler( void )
{
    BaseType_t xSavedInterruptStatus;
	xSavedInterruptStatus = portSET_INTERRUPT_MASK_FROM_ISR();
    {
        /* Increment the RTOS tick. */
        if ( xTaskIncrementTick() != pdFALSE )
        {
            /* Pend a context switch. */
            xPortSwitchRequired = pdTRUE;
        }
    }
    portCLEAR_INTERRUPT_MASK_FROM_ISR(xSavedInterruptStatus);
}
/*-----------------------------------------------------------*/

/*
 * Setup the systick timer to generate the tick interrupts at the required
 * frequency.
 */
void vPortSetupTimerInterrupt( void )
{
    /*
     * Do not modify the interrupt priority bits
     * so that it defaults to the lowest priority.
     */
    ICOSTM0 &= ~( ( 1 << 12 ) |  /* clear interrupt flag */
                  ( 1 << 7 ) |   /* unmask interrupt */
                  ( 1 << 6 ) );  /* direct method */

    OSTM0.EMU = 0;
    OSTM0.CTL = 0;
    OSTM0.CMP = ( configCPU_CLOCK_HZ / configTICK_RATE_HZ / 2 ) - 1;
    OSTM0.TS = 1;
}
