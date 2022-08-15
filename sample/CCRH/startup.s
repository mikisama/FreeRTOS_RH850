    STACKSIZE .set 0x200
    .section ".stack.bss", bss
    .align 4
    .ds (STACKSIZE)
    .align 4

;-----------------------------------------------------------------------------
;   startup
;-----------------------------------------------------------------------------
    .section ".startup", text
    .public _start
_start:
    mov #__E_stack_bss, sp  ; set sp register
    mov #__gp_data, gp      ; set gp register
    mov #__ep_data, ep      ; set ep register

    mov #__S_data_R, r6
    mov #__E_data_R, r7
    mov #__S_data, r8
copy_data_loop:
    cmp r7, r6
    bge copy_data_done      ; if R6 >= R7, goto copy_data_done
    ld.w 0[r8], r9
    st.w r9, 0[r6]
    add 4, r6
    add 4, r8
    br copy_data_loop
copy_data_done:

    mov #__S_bss, r6
    mov #__E_bss, r7
bss_clear_loop:
    cmp r7, r6
    bge bss_clear_done      ; if R6 >= R7, goto bss_clear_done
    st.w r0, 0[r6]
    add 4, r6
    br bss_clear_loop
bss_clear_done:

    jarl _main, lp

_exit:
    br _exit

;-----------------------------------------------------------------------------
;   dummy section
;-----------------------------------------------------------------------------
    .section ".data", data
.dummy.data:
    .section ".bss", bss
.dummy.bss:
    .section ".const", const
.dummy.const:
    .section ".text", text
.dummy.text:
;-------------------- end of start up module -------------------;
