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

    .section .text

    .extern _vTaskSwitchContext
    .extern _pxCurrentTCB
    .extern _eiint_handler

    .global _vPortContextSave
    .global _vPortContextRestore
    .global _vPortStartFirstTask
    .global _vPortYieldHandler
    .global _eiint_wrapper

/*-----------------------------------------------------------*/

_vPortContextSave:

    pushsp r6 - r30                 /* Save General Purpose Register */
    pushsp r1 - r2

    stsr EIPSW, r28                 /* Save EIPSW */
    stsr EIPC, r29                  /* Save EIPC */
    pushsp r28 - r29

    mov hilo(_pxCurrentTCB), r2     /* pxCurrentTCB->pxTopOfStack = SP */
    ld.w 0[r2], r2
    st.w sp, 0[r2]

    jmp [lp]

/*-----------------------------------------------------------*/

_vPortContextRestore:

    mov hilo(_pxCurrentTCB), r2     /* SP = pxCurrentTCB->pxTopOfStack */
    ld.w 0[r2], r2
    ld.w 0[r2], sp

    popsp r28 - r29
    ldsr r29, EIPC                  /* Restore EIPC */
    ldsr r28, EIPSW                 /* Restore EIPSW */

    popsp r1 - r2                   /* Restore General Purpose Register */
    popsp r6 - r30

    jmp [lp]

/*-----------------------------------------------------------*/

_vPortStartFirstTask:

    jarl _vPortContextRestore, lp

    dispose 0, {lp}

    eiret

/*-----------------------------------------------------------*/

_vPortYieldHandler:

    prepare {lp}, 0

    jarl _vPortContextSave, lp
    jarl _vTaskSwitchContext, lp
    jarl _vPortContextRestore, lp

    dispose 0, {lp}

    eiret

/*-----------------------------------------------------------*/

_eiint_wrapper:

    prepare {lp}, 0

    jarl _vPortContextSave, lp

    stsr EIIC, r6
    jarl _eiint_handler, lp

    jarl _vPortContextRestore, lp

    dispose 0, {lp}

    eiret

/*-----------------------------------------------------------*/
