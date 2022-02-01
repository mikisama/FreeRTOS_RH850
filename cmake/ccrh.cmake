set(CMAKE_SYSTEM_NAME Generic)
set(CMAKE_TRY_COMPILE_TARGET_TYPE STATIC_LIBRARY)
set(CMAKE_C_COMPILER_WORKS TRUE) # make CMake happy with ccrh

set(CCRH_DIR "C:/Program Files (x86)/Renesas Electronics/CS+/CC/CC-RH/V2.03.00")

set(CMAKE_C_COMPILER    ${CCRH_DIR}/bin/ccrh.exe)
set(CMAKE_ASM_COMPILER  ${CCRH_DIR}/bin/asrh.exe)
set(CMAKE_CCRH_LINKER   ${CCRH_DIR}/bin/rlink.exe)

set(CMAKE_C_COMPILE_OBJECT      "<CMAKE_C_COMPILER> -c <SOURCE> <DEFINES> <INCLUDES> <FLAGS> -o<OBJECT>")
set(CMAKE_ASM_COMPILE_OBJECT    "<CMAKE_ASM_COMPILER> <SOURCE> <DEFINES> <INCLUDES> <FLAGS> -o<OBJECT>")
set(CMAKE_C_LINK_EXECUTABLE     "\"${CMAKE_CCRH_LINKER}\" <OBJECTS> <LINK_FLAGS> <LINK_LIBRARIES> -output=<TARGET>")

# How to get CCRH to delete unused variables and functions?
# When compiling with `-goptimize` and linking with `-optimize`, only some unused variables and functions are removed.
set(CMAKE_C_FLAGS "-Xcpu=g3k -lang=c99 -Osize -goptimize -g -g_line")
set(CMAKE_ASM_FLAGS "-Xcpu=g3k -goptimize -g")

set(LD_SCRIPT ${CMAKE_CURRENT_SOURCE_DIR}/sample/CCRH/rh850_ccrh.ld)

set(CMAKE_EXE_LINKER_FLAGS "-library=\"${CCRH_DIR}/lib/v850e3v5/libc\" \
                            -sub=${LD_SCRIPT} \
                            -list=${PROJECT_NAME}.map \
                            -show=all \
                            -optimize \
                            -entry=_start")

set(FREERTOS_TOOLCHAIN "CCRH")
