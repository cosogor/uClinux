/*
 * arch/microblaze/kernel/intv.S -- Interrupt vectors
 *
 *  Copyright (C) 2003	     John Williams <jwilliams@itee.uq.edu.au>
 *  Copyright (C) 2001,2002  NEC Corporation
 *  Copyright (C) 2001,2002  Miles Bader <miles@gnu.org>
 *
 * This file is subject to the terms and conditions of the GNU General
 * Public License.  See the file COPYING in the main directory of this
 * archive for more details.
 *
 * Written by John Williams <jwilliams@itee.uq.edu.au>
 */

#include <asm/clinkage.h>
#include <asm/irq.h>
#include <asm/machdep.h>
#include <asm/entry.h>

	/* These are compiled and loaded into high memory, then
	   copied into place in mach_early_setup */
	.section	.intv.common, "ax"
	.org	0x0
	brai	C_SYMBOL_NAME(start);	// Kernel entry point

	.org	0x08
	brai	C_SYMBOL_NAME(trap);	// syscall handler

	.org	0x10
	brai	C_SYMBOL_NAME(irq);	// Interrupt handler

	.org	0x18
	brai	C_SYMBOL_NAME(nmi);	// nmi trap handler

	.org	0x20
	//brai	C_SYMBOL_NAME(hw_ex);	// HW exception handler

	.org	0x28
	//brai	C_SYMBOL_NAME(mmu_ex);	// MMU exception

	.org	0x30
	brai	C_SYMBOL_NAME(dbtrap);	// debug trap handler

