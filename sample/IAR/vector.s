    SECTION .reset:CODE

    PUBLIC _exception_vector_table

    EXTERN __iar_program_start
    EXTERN _vPortYieldHandler
    EXTERN _vISRWrapper

    ALIGN 4
__reset:    /* 0x0000 */
_exception_vector_table:
    jr  F:__iar_program_start

    ALIGN 4
__syserr:   /* 0x0010 */
    jr __syserr

    ALIGN 4
__hvtrap:   /* 0x0020 */
    jr __hvtrap

    ALIGN 4
__fetrap:   /* 0x0030 */
    jr __fetrap

    ALIGN 4
__trap0:    /* 0x0040 */
    jr _vPortYieldHandler

    ALIGN 4
__trap1:    /* 0x0050 */
    jr __trap1

    ALIGN 4
__rie:      /* 0x0060 */
    jr __rie

    ALIGN 4
__fpp:      /* 0x0070 */
    jr __fpp

    ALIGN 4
__ucpop:    /* 0x0080 */
    jr __ucpop

    ALIGN 4
__mip:      /* 0x0090 */
    jr __mip

    ALIGN 4
__pie:      /* 0x00a0 */
    jr __pie

    ALIGN 4
__debug:    /* 0x00b0 */
    jr __debug

    ALIGN 4
__mae:      /* 0x00c0 */
    jr __mae

    ALIGN 4
__rfu:      /* 0x00d0 */
    jr __rfu

    ALIGN 4
__fenmi:    /* 0x00e0 */
    jr __fenmi

    ALIGN 4
__feint:    /* 0x00f0 */
    jr __feint

    ALIGN 4
__eiint0:   /* 0x0100 */
    jr _vISRWrapper

    ALIGN 4
__eiint1:   /* 0x0110 */
    jr __eiint1

    ALIGN 4
__eiint2:   /* 0x0120 */
    jr __eiint2

    ALIGN 4
__eiint3:   /* 0x0130 */
    jr __eiint3

    ALIGN 4
__eiint4:   /* 0x0140 */
    jr __eiint4

    ALIGN 4
__eiint5:   /* 0x0150 */
    jr __eiint5

    ALIGN 4
__eiint6:   /* 0x0160 */
    jr __eiint6

    ALIGN 4
__eiint7:   /* 0x0170 */
    jr __eiint7

    ALIGN 4
__eiint8:   /* 0x0180 */
    jr __eiint8

    ALIGN 4
__eiint9:   /* 0x0190 */
    jr __eiint9

    ALIGN 4
__eiint10:  /* 0x01a0 */
    jr __eiint10

    ALIGN 4
__eiint11:  /* 0x01b0 */
    jr __eiint11

    ALIGN 4
__eiint12:  /* 0x01c0 */
    jr __eiint12

    ALIGN 4
__eiint13:  /* 0x01d0 */
    jr __eiint13

    ALIGN 4
__eiint14:  /* 0x01e0 */
    jr __eiint14

    ALIGN 4
__eiint15:  /* 0x01f0 */
    jr __eiint15

/*-----------------------------------------------------------*/
    END
