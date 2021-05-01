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

/* Demo includes. */
#include "IntQueueTimer.h"
#include "IntQueue.h"

/* Hardware includes. */
#include "derivative.h"

void vInitialiseTimerForIntQueueTest(void)
{
    ICTAUJ0I0 = (0 << 12) | /* clear interrupt flag */
                (0 << 7) |  /* unmask interrupt */
                (0 << 6) |  /* direct method */
                (0 << 0);   /* interrupt priority first highest */

    ICTAUJ0I1 = (0 << 12) | /* clear interrupt flag */
                (0 << 7) |  /* unmask interrupt */
                (0 << 6) |  /* direct method */
                (1 << 0);   /* interrupt priority second highest */

    TAUJ0.TPS = 0;

    /* TAUJ use HS IntOSC 8MHz */
    /* 8000000 / 1000 - 1 ---> 1ms */
    /* 8000000 / 2000 - 1 ---> 0.5ms */
#if 1
    TAUJ0.CDR0 = 8000000 / 2000; /* ~0.5001ms */
    TAUJ0.CDR1 = 8000000 / 2001; /* ~0.4998ms */
#else
    TAUJ0.CDR0 = 8000000 / 1000; /* ~1.0001ms */
    TAUJ0.CDR1 = 8000000 / 1001; /* ~0.9991ms */
#endif

    TAUJ0.CMOR0 = 0;
    TAUJ0.CMOR1 = 0;

    TAUJ0.TOM = 0;
    TAUJ0.TOC = 0;
    TAUJ0.TOL = 0;
    TAUJ0.TOE = 0;

    TAUJ0.RDE = 0;
    TAUJ0.RDM = 0;

    TAUJ0.TS = 3; /* start TAUJ0I0 and TAUJ0I1*/
}
/*-----------------------------------------------------------*/

void INTTAUJ0I0_IRQHandler(void)
{
    RFTAUJ0I0 = 0;
    portEND_SWITCHING_ISR(xFirstTimerHandler());
}
/*-----------------------------------------------------------*/

void INTTAUJ0I1_IRQHandler(void)
{
    RFTAUJ0I1 = 0;
    portEND_SWITCHING_ISR(xSecondTimerHandler());
}
/*-----------------------------------------------------------*/
