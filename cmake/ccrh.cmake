set(CMAKE_SYSTEM_NAME Generic)
set(CMAKE_TRY_COMPILE_TARGET_TYPE STATIC_LIBRARY)
set(CMAKE_C_COMPILER_WORKS TRUE) # make CMake happy with ccrh

# This file assumes that path to the Renesas CC-RH toolchain is added
# to the environment(PATH) variable, so that CMake can find

find_program(CMAKE_C_COMPILER ccrh)
find_program(CMAKE_ASM_COMPILER asrh)
find_program(CMAKE_CCRH_LINKER rlink)

STRING(REGEX REPLACE "/bin.+$" "/lib/v850e3v5" CCRH_LIB_DIR ${CMAKE_C_COMPILER})

set(CMAKE_C_COMPILE_OBJECT      "<CMAKE_C_COMPILER> -c <SOURCE> <DEFINES> <INCLUDES> <FLAGS> -o<OBJECT>")
set(CMAKE_ASM_COMPILE_OBJECT    "<CMAKE_ASM_COMPILER> <SOURCE> <DEFINES> <INCLUDES> <FLAGS> -o<OBJECT>")
set(CMAKE_C_LINK_EXECUTABLE     "\"${CMAKE_CCRH_LINKER}\" <OBJECTS> <LINK_FLAGS> <LINK_LIBRARIES> -output=<TARGET>")

set(CMAKE_C_FLAGS_INIT " ")
set(CMAKE_C_FLAGS_DEBUG_INIT " -g -g_line -Onothing")
set(CMAKE_C_FLAGS_MINSIZEREL_INIT " -Odefault")
set(CMAKE_C_FLAGS_RELEASE_INIT " -Ospeed")
set(CMAKE_C_FLAGS_RELWITHDEBINFO_INIT " -g -g_line -Ospeed")

set(CMAKE_ASM_FLAGS_INIT " ")
set(CMAKE_ASM_FLAGS_DEBUG_INIT " -g")
set(CMAKE_ASM_FLAGS_MINSIZEREL_INIT " ")
set(CMAKE_ASM_FLAGS_RELEASE_INIT " ")
set(CMAKE_ASM_FLAGS_RELWITHDEBINFO_INIT " ")

# How to get CC-RH to delete dead code?
# CC-RH's link-time optimization is applied when compiling with `-goptimize` and linking with `-optimize` and `-entry`.
#
# The start execution address specified by `-entry=_start` should be as far ahead as possible,
# otherwise CC-RH's link-time optimization won't work at all.
set(CMAKE_C_FLAGS "-Xcpu=g3k -lang=c99 -goptimize")
set(CMAKE_ASM_FLAGS "-Xcpu=g3k -goptimize")

set(LD_SCRIPT ${CMAKE_CURRENT_SOURCE_DIR}/sample/CCRH/rh850_ccrh.ld)

set(CMAKE_EXE_LINKER_FLAGS "-library=\"${CCRH_LIB_DIR}/libc\" \
                            -sub=${LD_SCRIPT} \
                            -list=${PROJECT_NAME}.map \
                            -show=all \
                            -optimize \
                            -entry=_start")

set(FREERTOS_TOOLCHAIN "CCRH")
