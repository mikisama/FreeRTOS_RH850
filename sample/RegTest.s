    .section .text

    .extern _ulRegTest1LoopCounter
    .extern _ulRegTest2LoopCounter

    .global _vRegTest1Task
    .global _vRegTest2Task

_vRegTest1Task:

    /* Fill the core registers with known values. */
    mov 0x101, r1
    mov 0x102, r2
    mov 0x106, r6
    mov 0x107, r7
    mov 0x108, r8
    mov 0x109, r9
    mov 0x110, r10
    mov 0x111, r11
    mov 0x112, r12
    mov 0x113, r13
    mov 0x114, r14
    mov 0x115, r15
    mov 0x116, r16
    mov 0x117, r17
    mov 0x118, r18
    mov 0x119, r19
    mov 0x120, r20
    mov 0x121, r21
    mov 0x122, r22
    mov 0x123, r23
    mov 0x124, r24
    mov 0x125, r25
    mov 0x126, r26
    mov 0x127, r27
    mov 0x128, r28
    mov 0x129, r29
    mov 0x130, r30
    mov 0x131, r31

reg1_loop:

    mov 0x101, r11
    cmp r11, r1
    bne reg1_error_loop

    mov 0x102, r11
    cmp r11, r2
    bne reg1_error_loop

    mov 0x106, r11
    cmp r11, r6
    bne reg1_error_loop

    mov 0x107, r11
    cmp r11, r7
    bne reg1_error_loop

    mov 0x108, r11
    cmp r11, r8
    bne reg1_error_loop

    mov 0x109, r11
    cmp r11, r9
    bne reg1_error_loop

    mov 0x110, r11
    cmp r11, r10
    bne reg1_error_loop

    mov 0x111, r11
    cmp r11, r11
    bne reg1_error_loop

    mov 0x112, r11
    cmp r11, r12
    bne reg1_error_loop

    mov 0x113, r11
    cmp r11, r13
    bne reg1_error_loop

    mov 0x114, r11
    cmp r11, r14
    bne reg1_error_loop

    mov 0x115, r11
    cmp r11, r15
    bne reg1_error_loop

    mov 0x116, r11
    cmp r11, r16
    bne reg1_error_loop

    mov 0x117, r11
    cmp r11, r17
    bne reg1_error_loop

    mov 0x118, r11
    cmp r11, r18
    bne reg1_error_loop

    mov 0x119, r11
    cmp r11, r19
    bne reg1_error_loop

    mov 0x120, r11
    cmp r11, r20
    bne reg1_error_loop

    mov 0x121, r11
    cmp r11, r21
    bne reg1_error_loop

    mov 0x122, r11
    cmp r11, r22
    bne reg1_error_loop

    mov 0x123, r11
    cmp r11, r23
    bne reg1_error_loop

    mov 0x124, r11
    cmp r11, r24
    bne reg1_error_loop

    mov 0x125, r11
    cmp r11, r25
    bne reg1_error_loop

    mov 0x126, r11
    cmp r11, r26
    bne reg1_error_loop

    mov 0x127, r11
    cmp r11, r27
    bne reg1_error_loop

    mov 0x128, r11
    cmp r11, r28
    bne reg1_error_loop

    mov 0x129, r11
    cmp r11, r29
    bne reg1_error_loop

    mov 0x130, r11
    cmp r11, r30
    bne reg1_error_loop

    mov 0x131, r11
    cmp r11, r31
    bne reg1_error_loop

    /* Everything passed, increment the loop counter. */
    mov hilo(_ulRegTest1LoopCounter), r11
    ld.w 0[r11], r12
    add 1, r12
    st.w r12, 0[r11]

    /* Start again. */
    mov 0x111, r11
    mov 0x112, r12
    jr reg1_loop

reg1_error_loop:

    jr reg1_error_loop

/*-----------------------------------------------------------*/

_vRegTest2Task:

    /* Fill the core registers with known values. */
    mov 0x201, r1
    mov 0x202, r2
    mov 0x206, r6
    mov 0x207, r7
    mov 0x208, r8
    mov 0x209, r9
    mov 0x210, r10
    mov 0x211, r11
    mov 0x212, r12
    mov 0x213, r13
    mov 0x214, r14
    mov 0x215, r15
    mov 0x216, r16
    mov 0x217, r17
    mov 0x218, r18
    mov 0x219, r19
    mov 0x220, r20
    mov 0x221, r21
    mov 0x222, r22
    mov 0x223, r23
    mov 0x224, r24
    mov 0x225, r25
    mov 0x226, r26
    mov 0x227, r27
    mov 0x228, r28
    mov 0x229, r29
    mov 0x230, r30
    mov 0x231, r31

reg2_loop:

    mov 0x201, r11
    cmp r11, r1
    bne reg2_error_loop

    mov 0x202, r11
    cmp r11, r2
    bne reg2_error_loop

    mov 0x206, r11
    cmp r11, r6
    bne reg2_error_loop

    mov 0x207, r11
    cmp r11, r7
    bne reg2_error_loop

    mov 0x208, r11
    cmp r11, r8
    bne reg2_error_loop

    mov 0x209, r11
    cmp r11, r9
    bne reg2_error_loop

    mov 0x210, r11
    cmp r11, r10
    bne reg2_error_loop

    mov 0x211, r11
    cmp r11, r11
    bne reg2_error_loop

    mov 0x212, r11
    cmp r11, r12
    bne reg2_error_loop

    mov 0x213, r11
    cmp r11, r13
    bne reg2_error_loop

    mov 0x214, r11
    cmp r11, r14
    bne reg2_error_loop

    mov 0x215, r11
    cmp r11, r15
    bne reg2_error_loop

    mov 0x216, r11
    cmp r11, r16
    bne reg2_error_loop

    mov 0x217, r11
    cmp r11, r17
    bne reg2_error_loop

    mov 0x218, r11
    cmp r11, r18
    bne reg2_error_loop

    mov 0x219, r11
    cmp r11, r19
    bne reg2_error_loop

    mov 0x220, r11
    cmp r11, r20
    bne reg2_error_loop

    mov 0x221, r11
    cmp r11, r21
    bne reg2_error_loop

    mov 0x222, r11
    cmp r11, r22
    bne reg2_error_loop

    mov 0x223, r11
    cmp r11, r23
    bne reg2_error_loop

    mov 0x224, r11
    cmp r11, r24
    bne reg2_error_loop

    mov 0x225, r11
    cmp r11, r25
    bne reg2_error_loop

    mov 0x226, r11
    cmp r11, r26
    bne reg2_error_loop

    mov 0x227, r11
    cmp r11, r27
    bne reg2_error_loop

    mov 0x228, r11
    cmp r11, r28
    bne reg2_error_loop

    mov 0x229, r11
    cmp r11, r29
    bne reg2_error_loop

    mov 0x230, r11
    cmp r11, r30
    bne reg2_error_loop

    mov 0x231, r11
    cmp r11, r31
    bne reg2_error_loop

    /* Everything passed, increment the loop counter. */
    mov hilo(_ulRegTest2LoopCounter), r11
    ld.w 0[r11], r12
    add 1, r12
    st.w r12, 0[r11]

    /* Start again. */
    mov 0x211, r11
    mov 0x212, r12
    jr reg2_loop

reg2_error_loop:

    jr reg2_error_loop

/*-----------------------------------------------------------*/
