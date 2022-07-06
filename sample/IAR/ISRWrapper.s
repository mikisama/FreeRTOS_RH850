    SECTION .text:CODE

    EXTERN _vPortSaveContext
    EXTERN _vPortRestoreContext
    EXTERN _INTTAUJ0I0_IRQHandler
    EXTERN _INTTAUJ0I1_IRQHandler
    EXTERN _xPortSysTickHandler

    PUBLIC _INTTAUJ0I0
    PUBLIC _INTTAUJ0I1
    PUBLIC _INTOSTM0

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
    END
