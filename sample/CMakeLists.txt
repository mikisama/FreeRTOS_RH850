target_sources(${PROJECT_NAME}
    PRIVATE
    # {{BEGIN_TARGET_SOURCES}}
    ${CMAKE_CURRENT_LIST_DIR}/start.s
    ${CMAKE_CURRENT_LIST_DIR}/vector.s
    ${CMAKE_CURRENT_LIST_DIR}/eiint_wrapper.s
    ${CMAKE_CURRENT_LIST_DIR}/eiint_handler.c
    ${CMAKE_CURRENT_LIST_DIR}/RegTest.s
    ${CMAKE_CURRENT_LIST_DIR}/main.c
    ${CMAKE_CURRENT_LIST_DIR}/IntQueue.c
    ${CMAKE_CURRENT_LIST_DIR}/IntQueueTimer.c
    ${CMAKE_CURRENT_LIST_DIR}/blocktim.c
    ${CMAKE_CURRENT_LIST_DIR}/countsem.c
    ${CMAKE_CURRENT_LIST_DIR}/recmutex.c
    # {{END_TARGET_SOURCES}}
)

target_include_directories(${PROJECT_NAME}
    PUBLIC
    ${CMAKE_CURRENT_LIST_DIR}/include
)
