target_sources(${PROJECT_NAME}
    PRIVATE
    # {{BEGIN_TARGET_SOURCES}}
    ${CMAKE_CURRENT_LIST_DIR}/croutine.c
    ${CMAKE_CURRENT_LIST_DIR}/event_groups.c
    ${CMAKE_CURRENT_LIST_DIR}/list.c
    ${CMAKE_CURRENT_LIST_DIR}/queue.c
    ${CMAKE_CURRENT_LIST_DIR}/stream_buffer.c
    ${CMAKE_CURRENT_LIST_DIR}/tasks.c
    ${CMAKE_CURRENT_LIST_DIR}/timers.c
    # {{END_TARGET_SOURCES}}
)

target_include_directories(${PROJECT_NAME}
    PUBLIC
    ${CMAKE_CURRENT_LIST_DIR}/include
)

add_subdirectory(${CMAKE_CURRENT_LIST_DIR}/portable)
