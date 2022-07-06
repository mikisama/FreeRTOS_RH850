    .section .text

    .global _start
    .global __exit

    .extern _main
    .extern _etext
    .extern _sdata
    .extern _edata
    .extern _sbss
    .extern _ebss
    .extern _stack

/* global Start routine */
_start:
    mov hilo(_stack), sp

    mov hilo(_sdata), r6
    mov hilo(_edata), r7
    mov hilo(_etext), r8
copy_data_start:
    cmp r7, r6
    bge copy_data_done              /* if R6 >= R7, goto copy_data_done */
    ld.w 0[r8], r9
    st.w r9, 0[r6]
    add 4, r6
    add 4, r8
    jr copy_data_start
copy_data_done:

    mov hilo(_sbss), r6
    mov hilo(_ebss), r7
bss_clear_start:
    cmp r7, r6
    bge bss_clear_done              /* if R6 >= R7, goto bss_clear_done */
    st.w r0, 0[r6]
    add 4, r6
    jr bss_clear_start
bss_clear_done:

    jarl _main, lp

__exit:
    jr __exit
