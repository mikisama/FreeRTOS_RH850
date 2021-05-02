    .section "RESET", text
    .align	16
__reset:    ; 0x0000
    jr __cstart

    .align  16
__syserr:   ; 0x0010
    jr __syserr

    .align  16
__hvtrap:   ; 0x0020
    jr __hvtrap

    .align  16
__fetrap:   ; 0x0030
    jr __fetrap

    .align  16
__trap0:    ; 0x0040
    jr _vPortYieldHandler

    .align  16
__trap1:    ; 0x0050
    jr __trap1

    .align  16
__rie:      ; 0x0060
    jr __rie

    .align  16
__fpp:      ; 0x0070
    jr __fpp

    .align  16
__ucpop:    ; 0x0080
    jr __ucpop

    .align  16
__mip:      ; 0x0090
    jr __mip

    .align  16
__pie:      ; 0x00a0
    jr __pie

    .align  16
__debug:    ; 0x00b0
    jr __debug

    .align  16
__mae:      ; 0x00c0
    jr __mae

    .align  16
__rfu:      ; 0x00d0
    jr __rfu

    .align  16
__fenmi:    ; 0x00e0
    jr __fenmi

    .align  16
__feint:    ; 0x00f0
    jr __feint

    .align  16
__eiint0:   ; 0x0100
    jr _vISRWrapper

    .align  16
__eiint1:   ; 0x0100
    jr __eiint1

    .align  16
__eiint2:   ; 0x0100
    jr __eiint2

    .align  16
__eiint3:   ; 0x0100
    jr __eiint3

    .align  16
__eiint4:   ; 0x0100
    jr __eiint4

    .align  16
__eiint5:   ; 0x0100
    jr __eiint5

    .align  16
__eiint6:   ; 0x0100
    jr __eiint6

    .align  16
__eiint7:   ; 0x0100
    jr __eiint7

    .align  16
__eiint8:   ; 0x0100
    jr __eiint8

    .align  16
__eiint9:   ; 0x0100
    jr __eiint9

    .align  16
__eiint10:  ; 0x0100
    jr __eiint10

    .align  16
__eiint11:  ; 0x0100
    jr __eiint11

    .align  16
__eiint12:  ; 0x0100
    jr __eiint12

    .align  16
__eiint13:  ; 0x0100
    jr __eiint13

    .align  16
__eiint14:  ; 0x0100
    jr __eiint14

    .align  16
__eiint15:  ; 0x0100
    jr __eiint15
