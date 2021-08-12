STACK_SIZE = 0x200;

MEMORY
{
  ROM_0 (RX) : ORIGIN = 0x00000000, LENGTH = 512K
  ROM_1 (RX) : ORIGIN = 0x01000000, LENGTH = 32K
  RAM_0 (RW) : ORIGIN = 0xFEDF8000, LENGTH = 32K
  RAM_1 (RW) : ORIGIN = 0xFEE00000, LENGTH = 32K
}

ENTRY(_start)

SECTIONS
{
    .text : ALIGN(4)
    {
        KEEP(*(.vector*))       /* vector table */
        . = ALIGN(4);
        *(.text*)               /* program code */
        . = ALIGN(4);
        *(.rodata*)             /* read-only data */
    } > ROM_0

    . = ALIGN(4);
    __etext = . ;               /* define a global symbol at end of code */

    .noinit (NOLOAD) : ALIGN(4)
    {
        *(.noinit*)             /* ram, but not cleared on reset */
    } > RAM_0

    .data : ALIGN(4)
    {
        . = ALIGN(4);
        __data_start__ = .;     /* define a global symbol at data start */
        *(.ramfunc*)            /* functions to run in ram */
        *(.data*)               /* read-write initialized data */
        . = ALIGN(4);
        __data_end__ = .;       /* define a global symbol at data end */
    } > RAM_0 AT > ROM_0

    .bss : ALIGN(4)
    {
        . = ALIGN(4);
        __bss_start__ = .;      /* define a global symbol at bss start */
        *(.bss*)                /* read-write zero initialized data */
        *(COMMON)
        . = ALIGN(4);
        __bss_end__ = .;        /* define a global symbol at bss end */
    } > RAM_0

    .stack : ALIGN(4)
    {
        . = ALIGN(4);
        __stack_start__ = .;    /* define a global symbol at stack start */
        . += STACK_SIZE;
        . = ALIGN(4);
        __stack_end__ = .;      /* define a global symbol at stack end */
        __stack = .;
    } > RAM_0
}
