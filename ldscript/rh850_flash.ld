STACK_SIZE = 0x400;

MEMORY
{
  FLASH_1          (RX)  : ORIGIN = 0x00000000, LENGTH = 512K
  FLASH_2          (RX)  : ORIGIN = 0x01000000, LENGTH = 32K
  SRAM             (RW)  : ORIGIN = 0xFEDF8000, LENGTH = 32K
}

ENTRY(_start)

SECTIONS
{
    .text :
    {
        KEEP(*(.vectors))
        *(.text*)

        KEEP(*(.init))
        KEEP(*(.fini))

        /* .ctors */
        *crtbegin.o(.ctors)
        *crtbegin?.o(.ctors)
        *(EXCLUDE_FILE(*crtend?.o *crtend.o) .ctors)
        *(SORT(.ctors.*))
        *(.ctors)

        /* .dtors */
        *crtbegin.o(.dtors)
        *crtbegin?.o(.dtors)
        *(EXCLUDE_FILE(*crtend?.o *crtend.o) .dtors)
        *(SORT(.dtors.*))
        *(.dtors)

        *(.rodata*)

        KEEP(*(.eh_frame*))
    } > FLASH_1

    .call_table_data ALIGN(4) :
    {
        PROVIDE(__ctbp = .);
        *(.call_table_data)
    } > FLASH_1

    .call_table_text :
	{
        *(.call_table_text)
	} > FLASH_1

    __etext = ALIGN(4);

    .data : AT (__etext)
    {
        . = ALIGN(4);
        __data_start__ = .;
        *(.data)
        *(.data.*)

        . = ALIGN(4);
        /* preinit data */
        PROVIDE_HIDDEN (__preinit_array_start = .);
        KEEP(*(.preinit_array))
        PROVIDE_HIDDEN (__preinit_array_end = .);

        . = ALIGN(4);
        /* init data */
        PROVIDE_HIDDEN (__init_array_start = .);
        KEEP(*(SORT(.init_array.*)))
        KEEP(*(.init_array))
        PROVIDE_HIDDEN (__init_array_end = .);

        . = ALIGN(4);
        /* finit data */
        PROVIDE_HIDDEN (__fini_array_start = .);
        KEEP(*(SORT(.fini_array.*)))
        KEEP(*(.fini_array))
        PROVIDE_HIDDEN (__fini_array_end = .);

        KEEP(*(.jcr*))
        . = ALIGN(4);
        /* All data end */
        __data_end__ = .;
    } > SRAM

    .tdata :
    {
        __ep = .;
        *(.tdata)
        *(.tcommon_byte)
        *(.tbss)
        *(.tcommon)
        *(.tbyte)
    } > SRAM

    .sdata :
    {
        *(.sdata)
        __gp = . + 0x8000;
    } > SRAM

    .bss :
    {
        . = ALIGN(4);
        __bss_start__ = .;
        *(.bss)
        *(.bss.*)
        *(COMMON)
        . = ALIGN(4);
        __bss_end__ = .;
    } > SRAM

    .stack (ORIGIN(SRAM) + LENGTH(SRAM) - STACK_SIZE):
    {
        . = ALIGN(4);
        __StackLimit = .;
        . += STACK_SIZE;
        . = ALIGN(4);
        __StackTop = .;
    } > SRAM

    PROVIDE(__stack = __StackTop);

}
