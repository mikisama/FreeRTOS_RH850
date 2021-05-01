cmake_minimum_required(VERSION 3.18.0)

set(CMAKE_SYSTEM_NAME Generic)
set(CMAKE_TRY_COMPILE_TARGET_TYPE STATIC_LIBRARY)

set(V850_GCC_DIR "D:/gcc-v850-elf-windows/bin")

set(CMAKE_C_COMPILER ${V850_GCC_DIR}/v850-elf-gcc.exe)
set(CMAKE_OBJCOPY ${V850_GCC_DIR}/v850-elf-objcopy.exe)
set(CMAKE_SIZE ${V850_GCC_DIR}/v850-elf-size.exe)

project(firmware
    LANGUAGES C ASM
)

# -mspace: this is a V850 specified option for code size optimization.
# However, when the CMAKE_BUILD_TYPE is not Debug, it will cause some build error.
#
# -mlong-calls: this is a V850 specified option, it will prohibit PC relative function calls.
# When the CMAKE_BUILD_TYPE is not Debug and we place the function to SRAM (.ramfunc section),
# there will be some build error.
#
# see `v850-elf-gcc --target-help` for details.

set(CMAKE_C_FLAGS "-mv850e3v5 -msoft-float -fdata-sections -ffunction-sections -gdwarf-2 -mlong-calls")
set(CMAKE_ASM_FLAGS "-mv850e3v5 -msoft-float -fdata-sections -ffunction-sections -gdwarf-2 -mlong-calls")

set(LD_SCRIPT ${CMAKE_CURRENT_SOURCE_DIR}/sample/ldscript/r7f701013.ld)

set(CMAKE_EXE_LINKER_FLAGS "-nostartfiles -Wl,-T${LD_SCRIPT},-Map,${PROJECT_NAME}.map,--gc-sections")

add_executable(${PROJECT_NAME})

add_subdirectory(${CMAKE_CURRENT_LIST_DIR}/freertos)
add_subdirectory(${CMAKE_CURRENT_LIST_DIR}/sample)

set_target_properties(${PROJECT_NAME}
    PROPERTIES SUFFIX ".elf"
)

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
    ## Show the sizes of sections inside ELF
    COMMAND
    ${CMAKE_SIZE}
    ${PROJECT_NAME}.elf
)
