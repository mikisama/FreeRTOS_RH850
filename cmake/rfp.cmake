# Renesas Flash Programmer

set(RFP_DIR "C:/Program Files (x86)/Renesas Electronics/Programming Tools/Renesas Flash Programmer V3.08")
set(RFP_CLI ${RFP_DIR}/rfp-cli.exe)

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
