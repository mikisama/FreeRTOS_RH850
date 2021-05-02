set(CMAKE_SYSTEM_NAME Generic)
set(CMAKE_TRY_COMPILE_TARGET_TYPE STATIC_LIBRARY)

set(EW_RH850_DIR "C:/Program Files (x86)/IAR Systems/Embedded Workbench 8.1/rh850/")

set(CMAKE_C_COMPILER ${EW_RH850_DIR}/bin/iccrh850.exe)
set(CMAKE_ASM_COMPILER ${EW_RH850_DIR}/bin/iasmrh850.exe)

include_directories(${EW_RH850_DIR}/lib)

set(CMAKE_C_FLAGS "--core g3k --dlib_config normal --diag_suppress Pa082")

set(LD_SCRIPT ${CMAKE_CURRENT_SOURCE_DIR}/sample/IAR/lnkr7f701013xafp.icf)

set(CMAKE_EXE_LINKER_FLAGS "--config ${LD_SCRIPT} --map ${PROJECT_NAME}.map --config_def CSTACK_SIZE=0x0200 --config_def HEAP_SIZE=0x0000")

set(FREERTOS_TOOLCHAIN "IAR")
