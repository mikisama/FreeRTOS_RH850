#if !defined(DERIVATIVE_H)
#define DERIVATIVE_H

#include "iodefine.h"

#define protected_write(preg, pstatus, reg, value) \
    do                                             \
    {                                              \
        (preg) = 0xa5u;                            \
        (reg) = (value);                           \
        (reg) = ~(value);                          \
        (reg) = (value);                           \
    } while ((pstatus) == 1u)

#define software_reset()                              \
    do                                                \
    {                                                 \
        protected_write(PROTCMD0, PROTS0, SWRESA, 1); \
        for (;;)                                      \
        {                                             \
            asm("nop");                               \
        }                                             \
    } while (0)

#endif // DERIVATIVE_H
