/*
 *  linux/arch/armnommu/kernel/debug.S
 *
 *  Copyright (C) 2004 Tobias Lorenz
 *
 *  32-bit debugging code
 *  based on linux/arch/arm/kernel/debug-armv.S
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License version 2 as
 * published by the Free Software Foundation.
 */
#include <linux/config.h>
#include <linux/linkage.h>
#include <asm/hardware.h>

		.text

/*
 * Some debugging routines (useful if you've got MM problems and
 * printk isn't working).  For DEBUGGING ONLY!!!  Do not leave
 * references to these in a production kernel!
 */
#if defined(CONFIG_ARCH_ATMEL)
#warning Not yet implemented

#elif defined(CONFIG_ARCH_S3C3410)
#warning Not yet implemented

#elif defined(CONFIG_ARCH_S5C7375)
#warning Not yet implemented

#elif defined(CONFIG_ARCH_P2001)
		/* UART base address */
		.macro	addruart,rx
		mov	\rx, #0x00140000
		.endm

		/* send char */
		.macro	senduart,rd,rx
		strb	\rd, [\rx]
		.endm

		/* wait for end of transmission */
		.macro	busyuart,rd,rx
		.endm

		/* wait for fifo space */
		/* quickest way here: test for >0x20 chars in fifo */
		.macro	waituart,rd,rx
1001:		ldrb	\rd, [\rx, #0x24]
		tst	\rd, #0x20
		bne	1001b
		.endm
#else
#error Unknown architecture
#endif

/*
 * Useful debugging routines
 */
ENTRY(printhex8)
		mov	r1, #8
		b	printhex

ENTRY(printhex4)
		mov	r1, #4
		b	printhex

ENTRY(printhex2)
		mov	r1, #2
printhex:	adr	r2, hexbuf
		add	r3, r2, r1
		mov	r1, #0
		strb	r1, [r3]
1:		and	r1, r0, #15
		mov	r0, r0, lsr #4
		cmp	r1, #10
		addlt	r1, r1, #'0'
		addge	r1, r1, #'a' - 10
		strb	r1, [r3, #-1]!
		teq	r3, r2
		bne	1b
		mov	r0, r2
		b	printascii

		.ltorg

ENTRY(printascii)
		addruart r3
		b	2f
1:		waituart r2, r3
		senduart r1, r3
		busyuart r2, r3
		teq	r1, #'\n'
		moveq	r1, #'\r'
		beq	1b
2:		teq	r0, #0
		ldrneb	r1, [r0], #1
		teqne	r1, #0
		bne	1b
		mov	pc, lr

ENTRY(printch)
		addruart r3
		mov	r1, r0
		mov	r0, #0
		b	1b

hexbuf:		.space 16
