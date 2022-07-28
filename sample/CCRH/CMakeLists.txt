target_sources(${PROJECT_NAME}
    PRIVATE
    # {{BEGIN_TARGET_SOURCES}}
    ${CMAKE_CURRENT_LIST_DIR}/startup.s
    ${CMAKE_CURRENT_LIST_DIR}/vector.s
    # {{END_TARGET_SOURCES}}
)

# How to get CC-RH to delete dead code?
# CC-RH's link-time optimization is applied when compiling with `-goptimize` and linking with `-optimize` and `-entry`.
#
# The start execution address specified by `-entry=_start` should be as far ahead as possible,
# otherwise CC-RH's link-time optimization won't work at all.
target_compile_options(${PROJECT_NAME}
    PUBLIC
    -Xcpu=g3k
    -goptimize
    $<$<COMPILE_LANGUAGE:C>:-lang=c99>
)

set(LD_SCRIPT ${CMAKE_CURRENT_LIST_DIR}/rh850_ccrh.ld)

target_link_options(${PROJECT_NAME}
    PUBLIC
    -library=${CCRH_LIB_DIR}/libc
    -sub=${LD_SCRIPT}
    -list=${PROJECT_NAME}.map
    -show=all
    -optimize
    -entry=_start
)
