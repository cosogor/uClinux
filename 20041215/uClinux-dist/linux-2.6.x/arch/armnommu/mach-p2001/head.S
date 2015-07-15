/*
 *  linux/arch/armnommu/mach-p2001/head.S
 *
 *  Copyright (C) 2004 Tobias Lorenz
 *
 *  uClinux kernel startup code for p2001
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
 */
#include <linux/config.h>
#include <linux/linkage.h>
#include <linux/init.h>

#include <asm/assembler.h>
#include <asm/mach-types.h>
#include <asm/procinfo.h>
#include <asm/ptrace.h>
#include <asm/mach/arch.h>

/*
 * Kernel startup entry point.
 */
	__INIT
	.type	stext, #function
ENTRY(stext)
	mov	r0, #PSR_F_BIT | PSR_I_BIT | MODE_SVC	@ make sure svc mode
	msr	cpsr_c, r0				@ and all irqs disabled

        adr	r5, LC0
        ldmia	r5, {r5, r6, r8, r9, sp}		@ Setup stack

        /*  Copy data sections to their new home.  */

        /*  Clear BSS */
        mov	r4, #0
1:      cmp	r5, r8					
        strcc	r4, [r5],#4
        bcc	1b

        /*  Pretend we know what our processor code is (for arm_id)   */
	ldr	r2, P2001_PROCESSOR_TYPE
	str     r2, [r6]
	ldr     r2, P2001_MACH_TYPE
	str     r2, [r9]

        mov	fp, #0
        b	start_kernel
        
LC0:	.long	__bss_start
        .long	processor_id
        .long	_end
	.long   __machine_arch_type
        .long	init_thread_union+8192

/*
 *	arm_id/PROCESSOR_TYPE:
 *	31:24:	Implementer		(ARM Ltd)
 *	23:20:	Variant			(0)
 *	19:16:	Architecture		(4T)
 *	15:4:	Primary Part Number	(0)
 *	3:0	Revision		(0)
 */
P2001_PROCESSOR_TYPE:
	.long	0x41029000
P2001_MACH_TYPE:
	.long	MACH_TYPE_P2001
