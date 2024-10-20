# Renesas Flash Programmer

# This file assumes that path to the rfp-cli is added
# to the environment(PATH) variable, so that CMake can find

find_program(RFP_CLI rfp-cli)

if(NOT RFP_CLI)
    message(WARNING "  No RFP_CLI could be found.\n"
    "  Please add the path to rfp-cli to the environment(PATH) variable.\n")
else()

    add_custom_target(flash
        COMMAND
        ${RFP_CLI}
        -d rh850
        -t e1
        -vo 3.3
        -osc 8
        -a ${PROJECT_NAME}.srec
        DEPENDS all
    )

    add_custom_target(erase
        COMMAND
        ${RFP_CLI}
        -d rh850
        -t e1
        -vo 3.3
        -osc 8
        -e
    )

endif()
