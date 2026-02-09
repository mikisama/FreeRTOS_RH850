The CCRH compiler cannot preprocess assembly files. To work around this, we inlined the assembly function into `port.c`, allowing CCRH to handle the `__FPU` macro.
