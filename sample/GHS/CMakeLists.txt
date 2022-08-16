target_sources(${PROJECT_NAME}
    PRIVATE
    # {{BEGIN_TARGET_SOURCES}}
    ${CMAKE_CURRENT_LIST_DIR}/vector.s
    # {{END_TARGET_SOURCES}}
)

# `-single_tda` make GHS to use R30(EP) as the callee-save register.

target_compile_options(${PROJECT_NAME}
    PUBLIC
    -cpu=rh850g3k
    -sda=all
    -no_callt
    -single_tda
)

set(LD_SCRIPT ${CMAKE_CURRENT_SOURCE_DIR}/dr7f701013.ld)

target_link_options(${PROJECT_NAME}
    PUBLIC
    -T ${LD_SCRIPT}
    -dwarf2
    -delete
)

# generate `ghs.predef` for better intellisense (code completions).
if(NOT EXISTS ${CMAKE_BINARY_DIR}/dummy.d)
    file(TOUCH ${CMAKE_BINARY_DIR}/dummy.d)
endif()

add_custom_target(predef
    COMMAND
    ${CMAKE_C_COMPILER}
    -cpu=rh850g3k
    -sda=all
    -no_callt
    -single_tda
    ${CMAKE_BINARY_DIR}/dummy.d
    -dM -E
    -o ${CMAKE_BINARY_DIR}/ghs.predef
)

add_dependencies(${PROJECT_NAME} predef)
