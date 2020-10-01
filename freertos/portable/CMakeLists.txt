target_sources(${PROJECT_NAME}
    PRIVATE
    # {{BEGIN_TARGET_SOURCES}}
    ${CMAKE_CURRENT_LIST_DIR}/MemMang/heap_1.c
    ${CMAKE_CURRENT_LIST_DIR}/GCC/RH850/port.c
    ${CMAKE_CURRENT_LIST_DIR}/GCC/RH850/portasm.s
    # {{END_TARGET_SOURCES}}
)

target_include_directories(${PROJECT_NAME}
    PUBLIC
    ${CMAKE_CURRENT_LIST_DIR}/GCC/RH850
)
