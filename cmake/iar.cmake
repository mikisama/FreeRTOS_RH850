set(CMAKE_SYSTEM_NAME Generic)
set(CMAKE_TRY_COMPILE_TARGET_TYPE STATIC_LIBRARY)

# This file assumes that path to the IAR toolchain is added
# to the environment(PATH) variable, so that CMake can find

find_program(CMAKE_C_COMPILER iccrh850)
find_program(CMAKE_ASM_COMPILER iasmrh850)

STRING(REGEX REPLACE "/bin.+$" "/lib" IAR_LIB_DIR ${CMAKE_C_COMPILER})

include_directories(${IAR_LIB_DIR})

set(FREERTOS_TOOLCHAIN "IAR")

set(CMAKE_EXPORT_COMPILE_COMMANDS FALSE)
