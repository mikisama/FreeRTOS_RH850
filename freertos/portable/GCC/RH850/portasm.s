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
    .extern _vISRHandler
    .extern _xPortSwitchRequired
    .extern _xInterruptNesting
    .extern _stack

    .global _vPortStartFirstTask
    .global _vPortYieldHandler
    .global _vISRWrapper

/*-----------------------------------------------------------*/

_vPortStartFirstTask:

    mov hilo(_pxCurrentTCB), r8         # SP = pxCurrentTCB->pxTopOfStack
    ld.w 0[r8], r9
    ld.w 0[r9], sp

    popsp r20 - r30                     # Restore General Purpose Register (callee save register)

#if !defined(__NO_FPU__)
    popsp r6 - r8                       # FPU used
    ldsr r8, FPSR                       # Restore FPSR
#else
    popsp r6 - r7                       # FPU not used
#endif
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
#if !defined(__NO_FPU__)
    stsr FPSR, r8                       # FPU used
    pushsp r6 - r8                      # Save FPSR
#else
    pushsp r6 - r7                      # FPU not used
#endif

    pushsp r20 - r30                    # Save General Purpose Register (callee save register)

    mov hilo(_pxCurrentTCB), r8         # pxCurrentTCB->pxTopOfStack = SP
    ld.w 0[r8], r9
    st.w sp, 0[r9]

    jarl _vTaskSwitchContext, lp

    mov hilo(_pxCurrentTCB), r8         # SP = pxCurrentTCB->pxTopOfStack
    ld.w 0[r8], r9
    ld.w 0[r9], sp

    popsp r20 - r30                     # Restore General Purpose Register (callee save register)

#if !defined(__NO_FPU__)
    popsp r6 - r8                       # FPU used
    ldsr r8, FPSR                       # Restore FPSR
#else
    popsp r6 - r7                       # FPU not used
#endif
    ldsr r7, EIPC                       # Restore EIPC
    ldsr r6, EIPSW                      # Restore EIPSW

    popsp r1 - r2                       # Restore General Purpose Register (caller save register)
    popsp r6 - r19

    dispose 0, {lp}

    eiret

/*-----------------------------------------------------------*/

_vISRWrapper:

    prepare {lp}, 0

    pushsp r6 - r19                     # Save General Purpose Register (caller save register)
    pushsp r1 - r2

    stsr EIPSW, r6                      # Save EIPSW
    stsr EIPC, r7                       # Save EIPC
#if !defined(__NO_FPU__)
    stsr FPSR, r8                       # FPU used
    pushsp r6 - r8                      # Save FPSR
#else
    pushsp r6 - r7                      # FPU not used
#endif

    mov hilo(_xInterruptNesting), r6
    ld.w 0[r6], r7
    cmp 0, r7                           # if ( xInterruptNesting == 0 )
    bne no_switch_sp                    # {

    mov hilo(_pxCurrentTCB), r8         #     pxCurrentTCB->pxTopOfStack = SP
    ld.w 0[r8], r9
    st.w sp, 0[r9]

    mov hilo(_stack), sp                #     SP = MainStackTop (switch to the interrupt stack)
no_switch_sp:                           # }
    add 1, r7                           # xInterruptNesting++
    st.w r7, 0[r6]

    stsr EIIC, r6                       # Save EI level Interrupt Cause

    ei                                  # Enable interrupt (enable interrupt nesting)
    jarl _vISRHandler, lp               # Call the ISR Handler
    di                                  # Disable interrupt (disable interrupt nesting)

    mov hilo(_xInterruptNesting), r6    # xInterruptNesting--
    ld.w 0[r6], r7
    add -1, r7
    st.w r7, 0[r6]

    cmp 0, r7                           # if ( xInterruptNesting == 0 )
    bne no_switch_ctx                   # {

    mov hilo(_pxCurrentTCB), r8         #     SP = pxCurrentTCB->pxTopOfStack
    ld.w 0[r8], r9
    ld.w 0[r9], sp

    mov hilo(_xPortSwitchRequired), r6
    ld.w 0[r6], r7
    cmp 0, r7                           #     if ( xPortSwitchRequired )
    be no_switch_ctx                    #     {

    st.w r0, 0[r6]                      #         xPortSwitchRequired = pdFALSE
    pushsp r20 - r30                    #         Save General Purpose Register (callee save register)
    st.w sp, 0[r9]                      #         pxCurrentTCB->pxTopOfStack = SP

    jarl _vTaskSwitchContext, lp        #         vTaskSwitchContext()

    mov hilo(_pxCurrentTCB), r8         #         SP = pxCurrentTCB->pxTopOfStack
    ld.w 0[r8], r9
    ld.w 0[r9], sp

    popsp r20 - r30                     #         Restore General Purpose Register (callee save register)
                                        #     }
                                        # }
no_switch_ctx:
#if !defined(__NO_FPU__)
    popsp r6 - r8                       # FPU used
    ldsr r8, FPSR                       # Restore FPSR
#else
    popsp r6 - r7                       # FPU not used
#endif
    ldsr r7, EIPC                       # Restore EIPC
    ldsr r6, EIPSW                      # Restore EIPSW

    popsp r1 - r2                       # Restore General Purpose Register (caller save register)
    popsp r6 - r19

    dispose 0, {lp}

    eiret

/*-----------------------------------------------------------*/
