set(CMAKE_SYSTEM_NAME Generic)
set(CMAKE_TRY_COMPILE_TARGET_TYPE STATIC_LIBRARY)
set(CMAKE_C_COMPILER_WORKS TRUE) # make CMake happy with GHS

# This file assumes that path to the GHS toolchain is added
# to the environment(PATH) variable, so that CMake can find

find_program(CMAKE_C_COMPILER ccrh850)
find_program(CMAKE_ASM_COMPILER ccrh850)
find_program(CMAKE_GSREC gsrec)
find_program(CMAKE_GMEMFILE gmemfile)

set(FREERTOS_TOOLCHAIN "GHS")

set(CMAKE_EXPORT_COMPILE_COMMANDS FALSE)
