    .section .text

    .extern _eiint_handler

    .global _eiint_wrapper

_eiint_wrapper:

    prepare {lp}, 0

    jarl _vPortContextSave, lp

    stsr EIIC, r6
    jarl _eiint_handler, lp

    jarl _vPortContextRestore, lp

    dispose 0, {lp}

    eiret
