target_sources(${PROJECT_NAME}
    PRIVATE
    # {{BEGIN_TARGET_SOURCES}}
    # ${CMAKE_CURRENT_LIST_DIR}/startup.s
    ${CMAKE_CURRENT_LIST_DIR}/vector.s
    # {{END_TARGET_SOURCES}}
)

target_compile_options(${PROJECT_NAME}
    PUBLIC
    --core g3k
    --diag_suppress Pa082
    $<$<COMPILE_LANGUAGE:C>:--dlib_config normal>
)

set(LD_SCRIPT ${CMAKE_CURRENT_SOURCE_DIR}/lnkr7f701013xafp.icf)

target_link_options(${PROJECT_NAME}
    PUBLIC
    --config ${LD_SCRIPT}
    --map ${PROJECT_NAME}.map
    # The `SHELL:` prefix prevents option de-duplication
    "SHELL:--config_def CSTACK_SIZE=0x0200 --config_def HEAP_SIZE=0x0000"
)

# generate `iar.predef` for better intellisense (code completions).
if(NOT EXISTS ${CMAKE_BINARY_DIR}/dummy.d)
    file(TOUCH ${CMAKE_BINARY_DIR}/dummy.d)
endif()

add_custom_target(predef
    COMMAND
    ${CMAKE_C_COMPILER}
    --core g3k
    ${CMAKE_BINARY_DIR}/dummy.d
    --silent
    --predef_macros
    ${CMAKE_BINARY_DIR}/iar.predef
)

add_dependencies(${PROJECT_NAME} predef)
