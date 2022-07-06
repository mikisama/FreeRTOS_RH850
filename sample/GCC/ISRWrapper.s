    .section .text

    .extern _vPortSaveContext
    .extern _vPortRestoreContext
    .extern _INTTAUJ0I0_IRQHandler
    .extern _INTTAUJ0I1_IRQHandler
    .extern _xPortSysTickHandler

    .global _INTTAUJ0I0
    .global _INTTAUJ0I1
    .global _INTOSTM0

/*-----------------------------------------------------------*/

_INTTAUJ0I0:

    prepare {lp}, 0
    jarl _vPortSaveContext, lp
    jarl _INTTAUJ0I0_IRQHandler, lp
    jr _vPortRestoreContext

/*-----------------------------------------------------------*/

_INTTAUJ0I1:

    prepare {lp}, 0
    jarl _vPortSaveContext, lp
    jarl _INTTAUJ0I1_IRQHandler, lp
    jr _vPortRestoreContext

/*-----------------------------------------------------------*/

_INTOSTM0:

    prepare {lp}, 0
    jarl _vPortSaveContext, lp
    jarl _xPortSysTickHandler, lp
    jr _vPortRestoreContext

/*-----------------------------------------------------------*/
