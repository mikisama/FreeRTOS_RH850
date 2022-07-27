set(CMAKE_SYSTEM_NAME Generic)
set(CMAKE_TRY_COMPILE_TARGET_TYPE STATIC_LIBRARY)

# This file assumes that path to the IAR toolchain is added
# to the environment(PATH) variable, so that CMake can find

find_program(CMAKE_C_COMPILER iccrh850)
find_program(CMAKE_ASM_COMPILER iasmrh850)

STRING(REGEX REPLACE "/bin.+$" "/lib" IAR_LIB_DIR ${CMAKE_C_COMPILER})

include_directories(${IAR_LIB_DIR})

set(CMAKE_C_FLAGS "--core g3k --dlib_config normal --diag_suppress Pa082")

set(LD_SCRIPT ${CMAKE_CURRENT_SOURCE_DIR}/sample/IAR/lnkr7f701013xafp.icf)

set(CMAKE_EXE_LINKER_FLAGS "--config ${LD_SCRIPT} --map ${PROJECT_NAME}.map --config_def CSTACK_SIZE=0x0200 --config_def HEAP_SIZE=0x0000")

set(FREERTOS_TOOLCHAIN "IAR")

set(CMAKE_EXPORT_COMPILE_COMMANDS FALSE)
