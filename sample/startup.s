        .section .text

        .global _start

        .extern _main
        .extern __etext
        .extern __data_start__
        .extern __data_end__
        .extern __bss_start__
        .extern __bss_end__
        .extern __stack

/* global Start routine */
_start:
        mov     hilo(__stack),          sp
        mov     hilo(__ep),             ep
        mov     hilo(__gp),             gp

        mov     hilo(__data_start__),   r6
        mov     hilo(__data_end__),     r7
        mov     hilo(__etext),          r8
copy_data_start:
        cmp     r7,                     r6
        bge     copy_data_end /* if R6 >= R7, goto copy_data_end */
        ld.w    0[r8],                  r9
        st.w    r9,                     0[r6]
        add     4,                      r6
        add     4,                      r8
        br      copy_data_start
copy_data_end:

        mov     hilo(__bss_start__),    r6
        mov     hilo(__bss_end__),      r7
bss_clear_start:
        cmp     r7,                     r6
        bge     bss_clear_end /* if R6 >= R7, goto bss_clear_end */
        st.w    r0,                     0[r6]
        add     4,                      r6
        br      bss_clear_start
bss_clear_end:

        jarl    _main,                  lp
        add     -16,                    sp
        mov     0,                      r6
        mov     0,                      r7
        mov     0,                      r8
        mov     r10,                    r6
        jr      _exit

/* call to exit */
_exit:
        br      _exit
