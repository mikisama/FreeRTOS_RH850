STACK_SIZE = 0x200;

ENTRY(_start)

MEMORY
{
  ROM (RX) : ORIGIN = 0x00000000, LENGTH = 512K
  EXT (RX) : ORIGIN = 0x01000000, LENGTH = 32K
  RAM (RW) : ORIGIN = 0xFEDF8000, LENGTH = 32K
  RET (RW) : ORIGIN = 0xFEE00000, LENGTH = 32K
}

SECTIONS
{
    .text : ALIGN(4)
    {
        KEEP(*(.vector*))       /* vector table */
        *(.text*)               /* program code */
    } > ROM

    .rodata : ALIGN(4)
    {
        *(.rodata*)             /* read-only data */
    } > ROM

    . = ALIGN(4);
    _etext = . ;                /* define a global symbol at end of code */

    .noinit (NOLOAD) : ALIGN(4)
    {
        *(.noinit*)             /* ram, but not cleared on reset */
    } > RAM

    .data : ALIGN(4)
    {
        . = ALIGN(4);
        _sdata = .;             /* define a global symbol at data start */
        *(.ramfunc*)            /* functions to run in ram */
        *(.data*)               /* read-write initialized data */
        . = ALIGN(4);
        _edata = .;             /* define a global symbol at data end */
    } > RAM AT > ROM

    .bss : ALIGN(4)
    {
        . = ALIGN(4);
        _sbss = .;              /* define a global symbol at bss start */
        *(.bss*)                /* read-write zero initialized data */
        *(COMMON)
        . = ALIGN(4);
        _ebss = .;              /* define a global symbol at bss end */
    } > RAM

    . = ALIGN(4);
    _end = .;
}

PROVIDE(_stack = ORIGIN(RAM) + LENGTH(RAM));
