#if !defined(DERIVATIVE_H)
#define DERIVATIVE_H

#include "iodefine.h"

#if defined(__GNUC__)
#define __NOP() asm("nop")
#define __DI() asm("di")
#define __EI() asm("ei")
#define __STSR(regID, selID) ({ long _val_; asm("stsr " #regID ", %[_val_], " #selID : [_val_]"=r"(_val_)); _val_; })
#define __LDSR(regID, selID, val) asm("ldsr %[_val_]," #regID "," #selID ::[_val_] "r"(val))
#elif defined(__ICCRH850__)
#include <intrinsics.h>
#elif defined(__CCRH__)
#include <builtin.h>
#define __NOP() __nop()
#define __STSR(regID, selID) __stsr_rh(regID, selID)
#define __LDSR(regID, selID, val) __ldsr_rh(regID, selID, val)
#elif defined(__ghs__)
#include <v800_ghs.h>
#endif

#define protected_write(preg, pstatus, reg, value) \
    do                                             \
    {                                              \
        (preg) = 0xa5u;                            \
        (reg) = (value);                           \
        (reg) = ~(value);                          \
        (reg) = (value);                           \
    } while ((pstatus) == 1u)

#define software_reset() protected_write(PROTCMD0, PROTS0, SWRESA, 1)

#endif // DERIVATIVE_H
