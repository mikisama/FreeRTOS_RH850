target_sources(${PROJECT_NAME}
    PRIVATE
    # {{BEGIN_TARGET_SOURCES}}
    ${CMAKE_CURRENT_LIST_DIR}/startup.s
    ${CMAKE_CURRENT_LIST_DIR}/vector.s
    ${CMAKE_CURRENT_LIST_DIR}/ISRWrapper.s
    # {{END_TARGET_SOURCES}}
)
