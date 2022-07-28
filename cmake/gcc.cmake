set(CMAKE_SYSTEM_NAME Generic)
set(CMAKE_TRY_COMPILE_TARGET_TYPE STATIC_LIBRARY)

# This file assumes that path to the GCC toolchain is added
# to the environment(PATH) variable, so that CMake can find

set(CMAKE_C_COMPILER v850-elf-gcc)

set(FREERTOS_TOOLCHAIN "GCC")

set(CMAKE_EXPORT_COMPILE_COMMANDS TRUE)
