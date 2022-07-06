# post build
# used to post-process a binary after linking

set(CMAKE_EXECUTABLE_SUFFIX ".elf")

if(${FREERTOS_TOOLCHAIN} STREQUAL "GCC")

    add_custom_command(TARGET
        ${PROJECT_NAME}
        POST_BUILD
        ## Convert ELF to Motorola S-records
        COMMAND
        ${CMAKE_OBJCOPY}
        -O
        srec
        ${PROJECT_NAME}.elf
        ${PROJECT_NAME}.srec
        ## Convert ELF to Raw Binary
        COMMAND
        ${CMAKE_OBJCOPY}
        -O
        binary
        ${PROJECT_NAME}.elf
        ${PROJECT_NAME}.bin
    )

elseif(${FREERTOS_TOOLCHAIN} STREQUAL "IAR")

    add_custom_command(TARGET
        ${PROJECT_NAME}
        POST_BUILD
        ## Convert ELF to Motorola S-records
        COMMAND
        ${CMAKE_IAR_ELFTOOL}
        --silent
        ${PROJECT_NAME}.elf
        --srec
        ${PROJECT_NAME}.srec
        ## Convert ELF to Raw Binary
        COMMAND
        ${CMAKE_IAR_ELFTOOL}
        --silent
        ${PROJECT_NAME}.elf
        --bin
        ${PROJECT_NAME}.bin
    )

elseif(${FREERTOS_TOOLCHAIN} STREQUAL "CCRH")

    add_custom_command(TARGET
        ${PROJECT_NAME}
        POST_BUILD
        ## Convert ELF to Motorola S-records
        COMMAND
        ${CMAKE_CCRH_LINKER}
        ${PROJECT_NAME}.elf
        -form=stype
        -output=${PROJECT_NAME}.srec
        ## Convert ELF to Raw Binary
        COMMAND
        ${CMAKE_CCRH_LINKER}
        ${PROJECT_NAME}.elf
        -form=binary
        -output=${PROJECT_NAME}.bin
    )

endif()
