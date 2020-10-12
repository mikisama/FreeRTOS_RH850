    .section .vectors

	.extern _start
    .extern _eiint_wrapper
	.extern _vPortYieldHandler

	.align 4
__reset:	/* 0x0000 */
	jr _start

	.align 4
__syserr:	/* 0x0010 */
	jr __unused_isr

	.align 4
__hvtrap:	/* 0x0020 */
	jr __unused_isr

	.align 4
__fetrap:	/* 0x0030 */
	jr __unused_isr

	.align 4
__trap0: 	/* 0x0040 */
	jr _vPortYieldHandler

	.align 4
__trap1: 	/* 0x0050 */
	jr __unused_isr

	.align 4
__rie:   	/* 0x0060 */
	jr __unused_isr

	.align 4
__fppfpi:	/* 0x0070 */
	jr __unused_isr

	.align 4
__ucpop: 	/* 0x080 */
	jr __unused_isr

	.align 4
__mip:   	/* 0x0090 */
	jr __unused_isr

	.align 4
__pie:  	/* 0x00a0 */
	jr __unused_isr

	.align 4
__debug: 	/* 0x00b0 */
	jr __unused_isr

	.align 4
__mae:   	/* 0x00c0 */
	jr __unused_isr

	.align 4
__rfu:   	/* 0x00d0 */
	jr __unused_isr

	.align 4
__fenmi:  	/* 0x00e0 */
	jr __unused_isr

	.align 4
__feint:  	/* 0x00f0 */
	jr __unused_isr

	.align 4
__eiint0: 	/* 0x0100 */
	jr _eiint_wrapper

	.align 4
__eiint1: 	/* 0x0110 */
	jr _eiint_wrapper

	.align 4
__eiint2: 	/* 0x0120 */
	jr _eiint_wrapper

	.align 4
__eiint3: 	/* 0x0130 */
	jr _eiint_wrapper

	.align 4
__eiint4: 	/* 0x0140 */
	jr _eiint_wrapper

	.align 4
__eiint5: 	/* 0x0150 */
	jr _eiint_wrapper

	.align 4
__eiint6: 	/* 0x0160 */
	jr _eiint_wrapper

	.align 4
__eiint7: 	/* 0x0170 */
	jr _eiint_wrapper

	.align 4
__eiint8: 	/* 0x0180 */
	jr _eiint_wrapper

	.align 4
__eiint9: 	/* 0x0190 */
	jr _eiint_wrapper

	.align 4
__eiint10:	/* 0x01a0 */
	jr _eiint_wrapper

	.align 4
__eiint11:	/* 0x01b0 */
	jr _eiint_wrapper

	.align 4
__eiint12:	/* 0x01c0 */
	jr _eiint_wrapper

	.align 4
__eiint13:	/* 0x01d0 */
	jr _eiint_wrapper

	.align 4
__eiint14:	/* 0x01e0 */
	jr _eiint_wrapper

	.align 4
__eiint15:	/* 0x01f0 */
	jr _eiint_wrapper

    .section .text
__unused_isr:
    br __unused_isr
