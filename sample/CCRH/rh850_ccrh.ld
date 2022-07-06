-rom=.data=.data.R

-start= .vector         /00000000
-start= .inttbl.const   /00000200
-start= .startup,       &
        .text,          &
        .const,         &
        .data           /00000680

-start= .data.R,        &
        .bss,           &
        .stack.bss      /FEDF8000
