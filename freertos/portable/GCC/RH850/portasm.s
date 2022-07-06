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
    .extern _xPortSwitchRequired
    .extern _xInterruptNesting
    .extern _stack

    .global _vPortStartFirstTask
    .global _vPortYieldHandler
    .global _vPortSaveContext
    .global _vPortRestoreContext

/*-----------------------------------------------------------*/

_vPortStartFirstTask:

    mov hilo(_pxCurrentTCB), r2         # SP = pxCurrentTCB->pxTopOfStack
    ld.w 0[r2], r2
    ld.w 0[r2], sp

    popsp r20 - r30                     # Restore General Purpose Register (callee save register)

    popsp r6 - r7
    ldsr r7, EIPC                       # Restore EIPC
    ldsr r6, EIPSW                      # Restore EIPSW

    popsp r1 - r2                       # Restore General Purpose Register (caller save register)
    popsp r6 - r19

    dispose 0, {lp}

    eiret

/*-----------------------------------------------------------*/

_vPortYieldHandler:

    prepare {lp}, 0

    pushsp r6 - r19                     # Save General Purpose Register (caller save register)
    pushsp r1 - r2

    stsr EIPSW, r6                      # Save EIPSW
    stsr EIPC, r7                       # Save EIPC
    pushsp r6 - r7

    pushsp r20 - r30                    # Save General Purpose Register (callee save register)

    mov hilo(_pxCurrentTCB), r2         # pxCurrentTCB->pxTopOfStack = SP
    ld.w 0[r2], r2
    st.w sp, 0[r2]

    jarl _vTaskSwitchContext, lp

    mov hilo(_pxCurrentTCB), r2         # SP = pxCurrentTCB->pxTopOfStack
    ld.w 0[r2], r2
    ld.w 0[r2], sp

    popsp r20 - r30                     # Restore General Purpose Register (callee save register)

    popsp r6 - r7
    ldsr r7, EIPC                       # Restore EIPC
    ldsr r6, EIPSW                      # Restore EIPSW

    popsp r1 - r2                       # Restore General Purpose Register (caller save register)
    popsp r6 - r19

    dispose 0, {lp}

    eiret

/*-----------------------------------------------------------*/

_vPortSaveContext:

    pushsp r6 - r19                     # Save General Purpose Register (caller save register)
    pushsp r1 - r2

    stsr EIPSW, r6                      # Save EIPSW
    stsr EIPC, r7                       # Save EIPC
    pushsp r6 - r7

    mov hilo(_xInterruptNesting), r6
    ld.w 0[r6], r7
    cmp 0x0, r7                         # if ( xInterruptNesting == 0 )
    bne aa                              # {
    mov hilo(_pxCurrentTCB), r2         #     pxCurrentTCB->pxTopOfStack = SP
    ld.w 0[r2], r2                      #     SP = MainStackTop
    st.w sp, 0[r2]                      # }
    mov hilo(_stack), sp
aa:
    add 0x1, r7                         # xInterruptNesting++
    st.w r7, 0[r6]

    ei                                  # Enable interrupt (enable interrupt nesting)

    jmp [lp]

/*-----------------------------------------------------------*/

_vPortRestoreContext:

    di                                  # Disable interrupt (disable interrupt nesting)

    mov hilo(_xInterruptNesting), r6
    ld.w 0[r6], r7
    cmp 0x0, r7                         # if ( xInterruptNesting > 0 )
    be bb                               # {
    add -1, r7                          #     xInterruptNesting--
    st.w r7, 0[r6]                      # }
bb:
    cmp 0x0, r7
    bne dd                              # if ( xInterruptNesting == 0 )
    mov hilo(_xPortSwitchRequired), r6  # {
    ld.w 0[r6], r7                      #     if ( xPortSwitchRequired )
    cmp 0x0, r7                         #     {
    be cc
    st.w r0, 0[r6]                      #         xPortSwitchRequired = pdFALSE

    mov hilo(_pxCurrentTCB), r2         #         SP = pxCurrentTCB->pxTopOfStack
    ld.w 0[r2], r2
    ld.w 0[r2], sp

    pushsp r20 - r30                    #         Save General Purpose Register (callee save register)
    st.w sp, 0[r2]                      #         pxCurrentTCB->pxTopOfStack = SP

    jarl _vTaskSwitchContext, lp        #         vTaskSwitchContext()

    mov hilo(_pxCurrentTCB), r2         #         SP = pxCurrentTCB->pxTopOfStack
    ld.w 0[r2], r2
    ld.w 0[r2], sp

    popsp r20 - r30                     #         Restore General Purpose Register (callee save register)

    jr dd                               #     }
cc:                                     #     else
    mov hilo(_pxCurrentTCB), r2         #     {
    ld.w 0[r2], r2                      #         SP = pxCurrentTCB->pxTopOfStack
    ld.w 0[r2], sp                      #     }
dd:                                     # }
    popsp r6 - r7
    ldsr r7, EIPC                       # Restore EIPC
    ldsr r6, EIPSW                      # Restore EIPSW

    popsp r1 - r2                       # Restore General Purpose Register (caller save register)
    popsp r6 - r19

    dispose 0, {lp}

    eiret

/*-----------------------------------------------------------*/
