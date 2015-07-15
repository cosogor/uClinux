/*
 *  linux/arch/armnommu/mach-p2001/entry-macro.S
 *
 *  Copyright (C) 2004 Tobias Lorenz
 *
 *  defines machine dependent entry macros.
 *  included in the arch/armnommu/kernel/entry.S
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

#define Adr_INT_CTRL_BASE		0x00130000
#define REL_Adr_Main_NFIQ_Int_Ctrl	0x00
#define REL_Adr_Main_NIRQ_Int_Ctrl	0x04
#define REL_Adr_Status_NFIQ		0x08
#define REL_Adr_Status_NIRQ		0x0c

#define NR_IRQS				27	/* 27 Interrupts: INT 0..26 */

#if defined(CONFIG_ARCH_P2001)

		/* disable FIQ */
                .macro  disable_fiq
                .endm


		/*
		 * get the irq number(at least), and others.
		 * irqnr  :  The number of the IRQ that you want to raise.
		 * irqstat: ???
		 * base   :  The comments suggest this is a prioritization mechanism, but it doesn't appear
		 *           to be actually used anywhere.  That's why many of the irq_prio_table macros are empty.
		 * flags  :  This is non-obvious, but you'll notice that every get_irqnr_and_base macro
		 *           does a test at the end of the macro.  If you don't have a flag (I think it's the Z) set,
		 *           then you'll never call do_IRQ.  It's basically a check to avoid calling do_IRQ if you had
		 *           a spurious interrupt (or one that was masked).
		 */
		/* irqnr=r0 irqstat=r6 base=r5 tmp=lr */
                .macro  get_irqnr_and_base, irqnr, irqstat, base, tmp
		mov	\irqstat, #Adr_INT_CTRL_BASE
		ldr	\irqstat, [\irqstat, #REL_Adr_Status_NIRQ]

                mov	\irqnr, #0
1001:
                tst     \irqstat, #1
                bne	1002f
                add	\irqnr, \irqnr, #1
                mov	\irqstat, \irqstat, lsr #1
                cmp	\irqnr, #NR_IRQS
                bcc	1001b
1002:           /* EQ will be set if we reach 32 */
                .endm


		/* irq priority table */
                .macro  irq_prio_table
                .endm

#endif
