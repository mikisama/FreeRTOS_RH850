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
	-dwarf2
    -delete
)

set(LD_SCRIPT ${CMAKE_CURRENT_SOURCE_DIR}/dr7f701013.ld)

target_link_options(${PROJECT_NAME}
    PUBLIC
    -T ${LD_SCRIPT}
	-cpu=rh850g3k
	-sda=all
    -no_callt
	-single_tda
	-dwarf2
    -delete
)
