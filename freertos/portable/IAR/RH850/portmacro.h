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
 * https://www.FreeRTOS.org
 * https://github.com/FreeRTOS
 *
 * 1 tab == 4 spaces!
 */


#ifndef PORTMACRO_H
    #define PORTMACRO_H

    #ifdef __cplusplus
        extern "C" {
    #endif

/*-----------------------------------------------------------
 * Port specific definitions.
 *
 * The settings in this file configure FreeRTOS correctly for the
 * given hardware and compiler.
 *
 * These settings should not be altered.
 *-----------------------------------------------------------
 */

/* Type definitions. */
    #define portCHAR          char
    #define portFLOAT         float
    #define portDOUBLE        double
    #define portLONG          long
    #define portSHORT         short
    #define portSTACK_TYPE    uint32_t
    #define portBASE_TYPE     long

    typedef portSTACK_TYPE   StackType_t;
    typedef long             BaseType_t;
    typedef unsigned long    UBaseType_t;

    #if ( configUSE_16_BIT_TICKS == 1 )
        typedef uint16_t     TickType_t;
        #define portMAX_DELAY              ( TickType_t ) 0xffff
    #else
        typedef uint32_t     TickType_t;
        #define portMAX_DELAY              ( TickType_t ) 0xffffffffUL

/* 32-bit tick type on a 32-bit architecture, so reads of the tick count do
 * not need to be guarded with a critical section. */
        #define portTICK_TYPE_IS_ATOMIC    1
    #endif
/*-----------------------------------------------------------*/

/* Architecture specifics. */
    #define portSTACK_GROWTH      ( -1 )
    #define portTICK_PERIOD_MS    ( ( TickType_t ) 1000 / configTICK_RATE_HZ )

/* It can be a multiple of 4, otherwise it will cause MAE (Misaligned Exception)
 * according to the manual. */
    #define portBYTE_ALIGNMENT    4
/*-----------------------------------------------------------*/


/* Scheduler utilities. */

/* Called at the end of an ISR that can cause a context switch. */
    #define portEND_SWITCHING_ISR( xSwitchRequired )    \
    {                                                   \
        extern volatile BaseType_t xPortSwitchRequired; \
                                                        \
        if( xSwitchRequired != pdFALSE )                \
        {                                               \
            xPortSwitchRequired = pdTRUE;               \
        }                                               \
    }

    #define portYIELD_FROM_ISR( x )                     portEND_SWITCHING_ISR( x )
    #define portYIELD()                                 asm( "trap 0" )
/*-----------------------------------------------------------*/


/* Critical section management. */
    extern void vTaskEnterCritical( void );
    extern void vTaskExitCritical( void );

    #pragma inline = forced
    static inline BaseType_t xSetInterruptMaskFromISR( void )
    {
        BaseType_t xPSW;
        asm( "stsr PSW, %[psw]" : [psw] "=r" ( xPSW ) );
        asm( "di" );
        return xPSW;
    }

    #pragma inline = forced
    static inline void vClearInterruptMaskFromISR( BaseType_t xPSW )
    {
        asm( "ldsr %[psw], PSW" :: [psw] "r" ( xPSW ) );
    }

    #define portSET_INTERRUPT_MASK_FROM_ISR()           xSetInterruptMaskFromISR()
    #define portCLEAR_INTERRUPT_MASK_FROM_ISR( x )      vClearInterruptMaskFromISR( x )

    #define portDISABLE_INTERRUPTS()                    asm( "di" )
    #define portENABLE_INTERRUPTS()                     asm( "ei" )
    #define portCRITICAL_NESTING_IN_TCB                 1
    #define portENTER_CRITICAL()                        vTaskEnterCritical()
    #define portEXIT_CRITICAL()                         vTaskExitCritical()
/*-----------------------------------------------------------*/

/* Task function macros as described on the FreeRTOS.org WEB site. */
    #define portTASK_FUNCTION_PROTO( vFunction, pvParameters )    void vFunction( void * pvParameters )
    #define portTASK_FUNCTION( vFunction, pvParameters )          void vFunction( void * pvParameters )
/*-----------------------------------------------------------*/

/* Architecture specific optimisations. */
    #ifndef configUSE_PORT_OPTIMISED_TASK_SELECTION
        #define configUSE_PORT_OPTIMISED_TASK_SELECTION     1
    #endif

    #if ( configUSE_PORT_OPTIMISED_TASK_SELECTION == 1 )

/* Check the configuration. */
        #if ( configMAX_PRIORITIES > 32 )
            #error configUSE_PORT_OPTIMISED_TASK_SELECTION can only be set to 1 when configMAX_PRIORITIES is less than or equal to 32.  It is very rare that a system requires more than 10 to 15 difference priorities as tasks that share a priority will time slice.
        #endif

/* Store/clear the ready priorities in a bit map. */
        #define portRECORD_READY_PRIORITY( uxPriority, uxReadyPriorities )      ( uxReadyPriorities ) |= ( 1UL << ( uxPriority ) )
        #define portRESET_READY_PRIORITY( uxPriority, uxReadyPriorities )       ( uxReadyPriorities ) &= ~( 1UL << ( uxPriority ) )

        /*
         *           uxReadyPriorities             uxTopPriority
         * -----------------------------------    ---------------
         * b31  b30  b29  ...   b02  b01  b00           --
         *  1    x    x          x    x    x            31
         *  0    1    x          x    x    x            30
         *  0    0    1          x    x    x            29
         *  :    :    :          :    :    :            :
         *  :    :    :          :    :    :            :
         *  0    0    0          1    x    x            02
         *  0    0    0          0    1    x            01
         *  0    0    0          0    0    1            00
         */
        #define portGET_HIGHEST_PRIORITY( uxTopPriority, uxReadyPriorities )    ( uxTopPriority ) = ( 32 - __SCH1L( ( uxReadyPriorities ) ) )

    #endif /* configUSE_PORT_OPTIMISED_TASK_SELECTION */
/*-----------------------------------------------------------*/

    #ifdef __cplusplus
        }
    #endif

#endif /* PORTMACRO_H */
