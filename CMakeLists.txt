cmake_minimum_required(VERSION 3.18.0)

project(firmware
    LANGUAGES C ASM
)

add_executable(${PROJECT_NAME})

add_subdirectory(${CMAKE_CURRENT_LIST_DIR}/freertos)
add_subdirectory(${CMAKE_CURRENT_LIST_DIR}/sample)

set(CMAKE_EXECUTABLE_SUFFIX ".elf")

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
