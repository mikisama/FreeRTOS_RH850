    STACKSIZE .set 0x200
    .section ".stack.bss", bss
    .align 4
    .ds (STACKSIZE)
    .align 4
_stacktop:

;-----------------------------------------------------------------------------
;   section initialize table
;-----------------------------------------------------------------------------
    .section ".INIT_DSEC.const", const
    .align 4
    .dw #__s.data, #__e.data, #__s.data.R

    .section ".INIT_BSEC.const", const
    .align 4
    .dw #__s.bss, #__e.bss

;-----------------------------------------------------------------------------
;   startup
;-----------------------------------------------------------------------------
    .section ".text", text
    .public __cstart
    .align 2
__cstart:
    mov #_stacktop, sp      ; set sp register
    mov #__gp_data, gp      ; set gp register
    mov #__ep_data, ep      ; set ep register

    mov #__s.INIT_DSEC.const, r6
    mov #__e.INIT_DSEC.const, r7
    mov #__s.INIT_BSEC.const, r8
    mov #__e.INIT_BSEC.const, r9
    jarl __INITSCT_RH, lp   ; initialize RAM area

    jarl _main, lp

_exit:
    jr _exit
