/***********************************************************************
 * arch/arm/mach-dm270/dma.c
 *
 *   Derived from arch/armnommu/mach-c5471/dma.c
 *
 *   Copyright (C) 2004 InnoMedia Pte Ltd. All rights reserved.
 *   cheetim_loh@innomedia.com.sg  <www.innomedia.com>
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
 *
 ***********************************************************************/

#include <linux/sched.h>
#include <linux/slab.h>
#include <linux/mman.h>
#include <linux/init.h>

#include <asm/page.h>
#include <asm/pgtable.h>
#include <asm/dma.h>
#include <asm/io.h>
#include <asm/hardware.h>

#include <asm/mach/dma.h>

void __init arch_dma_init(dma_t *dma)
{
  /* No special initial setup is required for the dm270.
   */
}