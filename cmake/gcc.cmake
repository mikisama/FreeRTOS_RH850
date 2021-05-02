set(CMAKE_SYSTEM_NAME Generic)
set(CMAKE_TRY_COMPILE_TARGET_TYPE STATIC_LIBRARY)

set(V850_GCC_DIR "D:/gcc-v850-elf-windows/bin")

set(CMAKE_C_COMPILER ${V850_GCC_DIR}/v850-elf-gcc.exe)
set(CMAKE_OBJCOPY ${V850_GCC_DIR}/v850-elf-objcopy.exe)
set(CMAKE_SIZE ${V850_GCC_DIR}/v850-elf-size.exe)

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

set(LD_SCRIPT ${CMAKE_CURRENT_SOURCE_DIR}/sample/GCC/r7f701013.ld)

set(CMAKE_EXE_LINKER_FLAGS "-nostartfiles -Wl,-T${LD_SCRIPT},-Map,${PROJECT_NAME}.map,--gc-sections")

set(FREERTOS_TOOLCHAIN "GCC")
