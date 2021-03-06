/*
 * linux/arch/arm/mm/arm6.S: MMU functions for ARM6
 *
 * (C) 1997 Russell King
 *
 * These are the low level assembler for performing cache and TLB
 * functions on the ARM6 & ARM7.
 */

#include <asm/assembler.h>
#include "../lib/constants.h"
#define current current_set

/*
 * Function: arm6_7_flush_cache_all (void)
 *	   : arm6_7_flush_cache_page (unsigned long address, int size, int flags)
 *
 * Params  : address	Area start address
 *	   : size	size of area
 *	   : flags	b0 = I cache as well
 *
 * Purpose : Flush all cache lines
 */
arm6_7_flush_cache:
		mov	r0, #0
#ifndef NO_MM
		mcr	p15, 0, r0, c7, c0, 0		@ flush cache
#endif
arm6_7_null:
		mov	pc, lr

/*
 * Function: arm6_7_flush_tlb_all (void)
 *
 * Purpose : flush all TLB entries in all caches
 */
arm6_7_flush_tlb_all:
		mov	r0, #0
#ifndef NO_MM
		mcr	p15, 0, r0, c5, c0, 0		@ flush TLB
#endif
		mov	pc, lr

/*
 * Function: arm6_7_flush_tlb_page (unsigned long address, int end, int flags)
 *
 * Params  : address	Area start address
 *	   : end	Area end address
 *	   : flags	b0 = I cache as well
 *
 * Purpose : flush a TLB entry
*/
arm6_7_flush_tlb_area:
#ifndef NO_MM
1:		mcr	p15, 0, r0, c6, c0, 0		@ flush TLB
		add	r0, r0, #4096
		cmp	r0, r1
		blt	1b
#endif
		mov	pc, lr

LC0:		.word	current


/*
 * Function: arm6_7_switch_to (struct task_struct *prev, struct task_struct *next)
 *
 * Params  : prev	Old task structure
 *	   : next	New task structure for process to run
 *
 * Purpose : Perform a task switch, saving the old processes state, and restoring
 *	     the new.
 *
 * Notes   : We don't fiddle with the FP registers here - we postpone this until
 *	     the new task actually uses FP.  This way, we don't swap FP for tasks
 *	     that do not require it.
 */
arm6_7_switch_to:
		stmfd	sp!, {r4 - r10, fp, lr}		@ Store most regs on stack
		mrs	ip, cpsr
		stmfd	sp!, {ip}			@ Save cpsr_SVC
		str	sp, [r0, #TSS_SAVE]		@ Save sp_SVC
		ldr	r2, LC0
		str	r1, [r2]
		ldr	sp, [r1, #TSS_SAVE]		@ Get saved sp_SVC
#ifndef NO_MM 
		ldr	r0, [r1, #TSS_MEMMAP]		@ Page table pointer
		mov	r1, #0
		mcr	p15, 0, r1, c7, c0, 0		@ flush cache
		mcr	p15, 0, r0, c2, c0, 0		@ update page table ptr
		mcr	p15, 0, r1, c5, c0, 0		@ flush TLBs
#endif
		ldmfd	sp!, {ip}
		msr	spsr, ip			@ Save tasks CPSR into SPSR for this return
		ldmfd	sp!, {r4 - r10, fp, pc}^		@ Load all regs saved previously

/*
 * Function: arm6_7_data_abort ()
 *
 * Params  : r0 = address of aborted instruction
 *
 * Purpose : obtain information about current aborted instruction
 *
 * Returns : r0 = address of abort
 *	   : r1 = FSR
 *	   : r2 != 0 if writing
 *	   : sp = pointer to registers
 *
 * Notes   : data abort *** NEEDS WORK ***
 */

Lukabttxt:	.ascii	"Unknown data abort code %d [pc=%p, *pc=%p] LR=%p\0"
		.align

msg:		.ascii	"DA*%p=%p\n\0"
		.align

arm6_data_abort:
		ldr	r4, [r0]			@ read instruction causing problem
		mov	r2, r4, lsr #19			@ r2 b1 = L
		and	r1, r4, #15 << 24
		add	pc, pc, r1, lsr #22		@ Now branch to the relevent processing routine
		movs	pc, lr
		b	Ldata_unknown
		b	Ldata_unknown
		b	Ldata_unknown
		b	Ldata_unknown
		b	Ldata_earlyldrpost		@ ldr	rd, [rn], #m
		b	Ldata_simple			@ ldr	rd, [rn, #m]	@ RegVal
		b	Ldata_earlyldrpost		@ ldr	rd, [rn], rm
		b	Ldata_simple			@ ldr	rd, [rn, rm]
		b	Ldata_ldmstm			@ ldm*a	rn, <rlist>
		b	Ldata_ldmstm			@ ldm*b	rn, <rlist>
		b	Ldata_unknown
		b	Ldata_unknown
		b	Ldata_simple			@ ldc	rd, [rn], #m	@ Same as ldr	rd, [rn], #m
		b	Ldata_simple			@ ldc	rd, [rn, #m]
		b	Ldata_unknown
Ldata_unknown:	@ Part of jumptable
		ldr	r3, [sp, #15 * 4]		@ Get PC
		str	r3, [sp, #-4]!
		mov	r1, r1, lsr #2
		mov	r3, r4
		mov	r2, r0
		adr	r0, Lukabttxt
		bl	panic
Lstop:		b	Lstop

arm7_data_abort:
		ldr	r4, [r0]			@ read instruction causing problem
		mov	r2, r4, lsr #19			@ r2 b1 = L
		and	r1, r4, #15 << 24
		add	pc, pc, r1, lsr #22		@ Now branch to the relevent processing routine
		movs	pc, lr
		b	Ldata_unknown
		b	Ldata_unknown
		b	Ldata_unknown
		b	Ldata_unknown
		b	Ldata_lateldrpostconst		@ ldr	rd, [rn], #m
		b	Ldata_lateldrpreconst		@ ldr	rd, [rn, #m]	@ RegVal
		b	Ldata_lateldrpostreg		@ ldr	rd, [rn], rm
		b	Ldata_lateldrprereg		@ ldr	rd, [rn, rm]
		b	Ldata_ldmstm			@ ldm*a	rn, <rlist>
		b	Ldata_ldmstm			@ ldm*b	rn, <rlist>
		b	Ldata_unknown
		b	Ldata_unknown
		b	Ldata_simple			@ ldc	rd, [rn], #m	@ Same as ldr	rd, [rn], #m
		b	Ldata_simple			@ ldc	rd, [rn, #m]
		b	Ldata_unknown
		b	Ldata_unknown

Ldata_ldmstm:	tst	r4, #1 << 21			@ check writeback bit
		beq	Ldata_simple

		mov	r7, #0x11
		orr	r7, r7, r7, lsl #8
		and	r0, r4, r7
		and	r1, r4, r7, lsl #1
		add	r0, r0, r1, lsr #1
		and	r1, r4, r7, lsl #2
		add	r0, r0, r1, lsr #2
		and	r1, r4, r7, lsl #3
		add	r0, r0, r1, lsr #3
		add	r0, r0, r0, lsr #8
		add	r0, r0, r0, lsr #4
		and	r7, r0, #15			@ r7 = no. of registers to transfer.
		and	r5, r4, #15 << 16		@ Get Rn
		ldr	r0, [sp, r5, lsr #14]		@ Get register
		eor	r6, r4, r4, lsl #2
		tst	r6, #1 << 23			@ Check inc/dec ^ writeback
		rsbeq	r7, r7, #0
		add	r7, r0, r7, lsl #2		@ Do correction (signed)
		str	r7, [sp, r5, lsr #14]		@ Put register

Ldata_simple:	and	r2, r2, #2			@ check read/write bit
#ifndef NO_MM
		mrc	p15, 0, r0, c6, c0, 0		@ get FAR
		mrc	p15, 0, r1, c5, c0, 0		@ get FSR
#endif
		and	r1, r1, #15
		mov	pc, lr

Ldata_earlyldrpost:
		tst	r2, #4
		and	r2, r2, #2			@ check read/write bit
		orrne	r2, r2, #1			@ T bit
#ifndef NO_MM
		mrc	p15, 0, r0, c6, c0, 0		@ get FAR
		mrc	p15, 0, r1, c5, c0, 0		@ get FSR
#endif
		and	r1, r1, #15
		mov	pc, lr

Ldata_lateldrpostconst:
		movs	r1, r4, lsl #20			@ Get offset
		beq	Ldata_earlyldrpost		@ if offset is zero, no effect
		and	r5, r4, #15 << 16		@ Get Rn
		ldr	r0, [sp, r5, lsr #14]
		tst	r4, #1 << 23			@ U bit
		subne	r0, r0, r1, lsr #20
		addeq	r0, r0, r1, lsr #20
		str	r0, [sp, r5, lsr #14]		@ Put register
		b	Ldata_earlyldrpost

Ldata_lateldrpreconst:
		tst	r4, #1 << 21			@ check writeback bit
		movnes	r1, r4, lsl #20			@ Get offset
		beq	Ldata_simple
		and	r5, r4, #15 << 16		@ Get Rn
		ldr	r0, [sp, r5, lsr #14]
		tst	r4, #1 << 23			@ U bit
		subne	r0, r0, r1, lsr #20
		addeq	r0, r0, r1, lsr #20
		str	r0, [sp, r5, lsr #14]		@ Put register
		b	Ldata_simple

Ldata_lateldrpostreg:
		and	r5, r4, #15
		ldr	r1, [sp, r5, lsl #2]		@ Get Rm
		mov	r3, r4, lsr #7
		ands	r3, r3, #31
		and	r6, r4, #0x70
		orreq	r6, r6, #8
		add	pc, pc, r6
		mov	r0, r0

		mov	r1, r1, lsl r3			@ 0: LSL #!0
		b	1f
		b	1f				@ 1: LSL #0
		mov	r0, r0
		b	1f				@ 2: MUL?
		mov	r0, r0
		b	1f				@ 3: MUL?
		mov	r0, r0
		mov	r1, r1, lsr r3			@ 4: LSR #!0
		b	1f
		mov	r1, r1, lsr #32			@ 5: LSR #32
		b	1f
		b	1f				@ 6: MUL?
		mov	r0, r0
		b	1f				@ 7: MUL?
		mov	r0, r0
		mov	r1, r1, asr r3			@ 8: ASR #!0
		b	1f
		mov	r1, r1, asr #32			@ 9: ASR #32
		b	1f
		b	1f				@ A: MUL?
		mov	r0, r0
		b	1f				@ B: MUL?
		mov	r0, r0
		mov	r1, r1, ror r3			@ C: ROR #!0
		b	1f
		mov	r1, r1, rrx			@ D: RRX
		b	1f
		mov	r0, r0				@ E: MUL?
		mov	r0, r0
		mov	r0, r0				@ F: MUL?


1:		and	r5, r4, #15 << 16		@ Get Rn
		ldr	r0, [sp, r5, lsr #14]
		tst	r4, #1 << 23			@ U bit
		subne	r0, r0, r1
		addeq	r0, r0, r1
		str	r0, [sp, r5, lsr #14]		@ Put register
		b	Ldata_earlyldrpost

Ldata_lateldrprereg:
		tst	r4, #1 << 21			@ check writeback bit
		beq	Ldata_simple
		and	r5, r4, #15
		ldr	r1, [sp, r5, lsl #2]		@ Get Rm
		mov	r3, r4, lsr #7
		ands	r3, r3, #31
		and	r6, r4, #0x70
		orreq	r6, r6, #8
		add	pc, pc, r6
		mov	r0, r0

		mov	r1, r1, lsl r3			@ 0: LSL #!0
		b	1f
		b	1f				@ 1: LSL #0
		mov	r0, r0
		b	1f				@ 2: MUL?
		mov	r0, r0
		b	1f				@ 3: MUL?
		mov	r0, r0
		mov	r1, r1, lsr r3			@ 4: LSR #!0
		b	1f
		mov	r1, r1, lsr #32			@ 5: LSR #32
		b	1f
		b	1f				@ 6: MUL?
		mov	r0, r0
		b	1f				@ 7: MUL?
		mov	r0, r0
		mov	r1, r1, asr r3			@ 8: ASR #!0
		b	1f
		mov	r1, r1, asr #32			@ 9: ASR #32
		b	1f
		b	1f				@ A: MUL?
		mov	r0, r0
		b	1f				@ B: MUL?
		mov	r0, r0
		mov	r1, r1, ror r3			@ C: ROR #!0
		b	1f
		mov	r1, r1, rrx			@ D: RRX
		b	1f
		mov	r0, r0				@ E: MUL?
		mov	r0, r0
		mov	r0, r0				@ F: MUL?


1:		and	r5, r4, #15 << 16		@ Get Rn
		ldr	r0, [sp, r5, lsr #14]
		tst	r4, #1 << 23			@ U bit
		subne	r0, r0, r1
		addeq	r0, r0, r1
		str	r0, [sp, r5, lsr #14]		@ Put register
		b	Ldata_simple

/*
 * Function: arm6_7_check_bugs (void)
 *	   : arm6_7_proc_init (void)
 *	   : arm6_7_proc_fin (void)
 *
 * Notes   : This processor does not require these
 */
arm6_7_check_bugs:
		mrs	ip, cpsr
		bic	ip, ip, #F_BIT
		msr	cpsr, ip
arm6_7_proc_init:
arm6_7_proc_fin:
		mov	pc, lr

/*
 * Function: arm6_set_pmd ()
 *
 * Params  : r0 = Address to set
 *	   : r1 = value to set
 *
 * Purpose : Set a PMD and flush it out of any WB cache
 */
arm6_set_pmd:	and	r2, r1, #3
		teq	r2, #2
		andeq	r2, r1, #8
		orreq	r1, r1, r2, lsl #1		@ Updatable = Cachable
		teq	r2, #1
		orreq	r1, r1, #16			@ Updatable = 1 if Page table
		str	r1, [r0]
		mov	pc, lr

/*
 * Function: arm7_set_pmd ()
 *
 * Params  : r0 = Address to set
 *	   : r1 = value to set
 *
 * Purpose : Set a PMD and flush it out of any WB cache
 */
arm7_set_pmd:
#ifndef NO_MM
	orr	r1, r1, #16			@ Updatable bit is always set on ARM7
		str	r1, [r0]
#endif
		mov	pc, lr

/*
 * Function: arm6_7_reset
 *
 * Notes   : This sets up everything for a reset
 */
arm6_7_reset:	mrs	r1, cpsr
		orr	r1, r1, #F_BIT|I_BIT
		msr	cpsr, r1
		mov	r0, #0
#ifndef NO_MM
		mcr	p15, 0, r0, c7, c0, 0		@ flush cache
		mcr	p15, 0, r0, c5, c0, 0		@ flush TLB
#endif
		mov	r1, #F_BIT | I_BIT | 3
		mov	pc, lr

/*
 * Purpose : Function pointers used to access above functions - all calls
 *	     come through these
 */
arm6_name:	.ascii	"arm6\0"
		.align

		.globl	arm6_processor_functions
arm6_processor_functions:
		.word	arm6_name			@  0
		.word	arm6_7_switch_to		@  4
		.word	arm6_data_abort		@  8
		.word	arm6_7_check_bugs		@ 12
		.word	arm6_7_proc_init		@ 16
		.word	arm6_7_proc_fin		@ 20

		.word	arm6_7_flush_cache		@ 24
		.word	arm6_7_flush_cache		@ 28
		.word	arm6_7_flush_cache		@ 32
		.word	arm6_7_null			@ 36
		.word	arm6_7_flush_cache		@ 40
		.word	arm6_7_flush_tlb_all		@ 44
		.word	arm6_7_flush_tlb_area		@ 48
		.word	arm6_set_pmd			@ 52
		.word	arm6_7_reset			@ 54

/*
 * Purpose : Function pointers used to access above functions - all calls
 *	     come through these
 */
arm7_name:	.ascii	"arm7\0"
		.align

		.globl	arm7_processor_functions
arm7_processor_functions:
		.word	arm7_name			@  0
		.word	arm6_7_switch_to		@  4
		.word	arm7_data_abort		@  8
		.word	arm6_7_check_bugs		@ 12
		.word	arm6_7_proc_init		@ 16
		.word	arm6_7_proc_fin		@ 20
		.word	arm6_7_flush_cache		@ 24
		.word	arm6_7_flush_cache		@ 28
		.word	arm6_7_flush_cache		@ 32
		.word	arm6_7_null			@ 36
		.word	arm6_7_flush_cache		@ 40
		.word	arm6_7_flush_tlb_all		@ 44
		.word	arm6_7_flush_tlb_area		@ 48
		.word	arm7_set_pmd			@ 52
		.word	arm6_7_reset			@ 54
