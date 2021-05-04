STACK_SIZE = 0x200;

MEMORY
{
  ROM_0     (RX) : ORIGIN = 0x00000000, LENGTH = 512K
  ROM_1     (RX) : ORIGIN = 0x01000000, LENGTH = 32K
  RAM_0     (RW) : ORIGIN = 0xFEDF8000, LENGTH = 32K
  RAM_1     (RW) : ORIGIN = 0xFEE00000, LENGTH = 32K
}

ENTRY(_start)

SECTIONS
{
    .text :
    {
        KEEP(*(.vector*))
        *(.text*)
        *(.rodata*)
    } > ROM_0

    __etext = ALIGN(4);

    .data : AT (__etext)
    {
        . = ALIGN(4);
        __data_start__ = .;
        *(.ramfunc*)
        *(.data*)
        . = ALIGN(4);
        __data_end__ = .;
    } > RAM_0

    .bss :
    {
        . = ALIGN(4);
        __bss_start__ = .;
        *(.bss*)
        *(COMMON)
        . = ALIGN(4);
        __bss_end__ = .;
    } > RAM_0

    .stack :
    {
        . = ALIGN(4);
        __stack_start__ = .;
        . += STACK_SIZE;
        . = ALIGN(4);
        __stack_end__ = .;
        __stack = .;
    } > RAM_0
}
