/*
 *  linux/arch/armnommu/mach-p2001/time.c
 *
 *  Copyright (C) 2004 Tobias Lorenz
 *
 *  Timer handling code
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License version 2 as
 * published by the Free Software Foundation.
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
#include <linux/timex.h>
#include <linux/init.h>
#include <linux/interrupt.h>
#include <linux/sched.h>

#include <asm/hardware.h>
#include <asm/irq.h>
#include <asm/leds.h>
#include <asm/io.h>

#include <asm/mach/time.h>

//#define CLOCKS_PER_USEC	(CONFIG_SYSCLK/1000000)
#define CLOCKS_PER_USEC		((12288000/1000000)/10)
#define P2001_TIMER1_PRESCALER	(10*CONFIG_SYSCLK/12288000)

/* Return number of microseconds since last interrupt */
static unsigned long p2001_gettimeoffset(void)
{
	return ((0xffff - P2001_TIMER->Timer1) & 0xffff) / CLOCKS_PER_USEC;
}

static irqreturn_t
p2001_timer_interrupt(int irq, void *dev_id, struct pt_regs *regs)
{
	/* clear interrupt pending bit */
	P2001_TIMER->TIMER_INT = 0x80000010;
	timer_tick(regs);
	return IRQ_HANDLED;
}

static struct irqaction p2001_timer_irq = {
	.name		= "P2001 Timer Tick",
	.flags		= SA_INTERRUPT,
	.handler	= p2001_timer_interrupt
};

/*
 * Set up timer interrupt, and return the current time in seconds.
 */
void __init p2001_init_time(void)
{
	unsigned int period;

	/*
	 * disable and clear timer 0, set to
	 * internal clock and interval mode
	 */
	P2001_TIMER->Timer12_PreDiv = 0x70bb0000;
	P2001_TIMER->Timer1 = 0;
	P2001_TIMER->Timer2 = 0;

	/* initialize the timer period and prescaler */
	period = (CONFIG_SYSCLK/P2001_TIMER1_PRESCALER)/HZ;
	P2001_TIMER->TIMER_PRELOAD = (0xffff << 16) | (period);
	P2001_TIMER->Timer12_PreDiv |= P2001_TIMER1_PRESCALER - 1;

	/*
	 * @todo do those really need to be function pointers ?
	 */
	gettimeoffset = p2001_gettimeoffset;

	/* set up the interrupt vector for timer 1 match */
	setup_irq(IRQ_TIMER1, &p2001_timer_irq);
	
	/* enable the timer IRQ */
	P2001_TIMER->TIMER_INT = 0x80000010;

	/* let timer 1 run... */
	P2001_TIMER->Timer12_PreDiv &= ~(1<<28);
}
