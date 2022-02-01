-rom=.data=.data.R

-start= .vector,        &
        .text,          &
        .const,         &
        .data           /00000000

-start= .data.R,        &
        .bss,           &
        .stack.bss      /FEDF8000
