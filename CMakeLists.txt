cmake_minimum_required(VERSION 3.18.0)

project(firmware
    LANGUAGES C ASM
)

add_executable(${PROJECT_NAME})

add_subdirectory(${CMAKE_CURRENT_LIST_DIR}/freertos)
add_subdirectory(${CMAKE_CURRENT_LIST_DIR}/sample)

include(${CMAKE_CURRENT_LIST_DIR}/cmake/post.cmake)
include(${CMAKE_CURRENT_LIST_DIR}/cmake/rfp.cmake)
