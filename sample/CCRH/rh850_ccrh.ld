-rom=.data=.data.R

-start= RESET,                                  &
        .const,                                 &
        .INIT_DSEC.const,                       &
        .INIT_BSEC.const,                       &
        .text,                                  &
        .data                           /00000000

-start= .bss,                                   &
        .data.R,                                &
        .stack.bss                      /FEDF8000
