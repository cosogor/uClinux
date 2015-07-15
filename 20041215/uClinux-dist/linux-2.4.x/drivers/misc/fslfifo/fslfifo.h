/*
 * fslfifo.h -- FSL FIFO driver for Microblaze
 *
 * Copyright (C) 2004 John Williams <jwilliams@itee.uq.edu.au>
 *
 *	This program is free software; you can redistribute it and/or
 *	modify it under the terms of the GNU General Public License
 *	as published by the Free Software Foundation; either version
 *	2 of the License, or (at your option) any later version.
 *       
 */

#ifndef _FSLFIFO_H
#define _FSLFIFO_H

#include <linux/miscdevice.h>
#include <linux/major.h>

/* Maximum number of FSL FIFOs */
#define MAX_FSL_FIFO_COUNT 8

/* FSL fifo data channels are misc devices (major-10)
   minor channel is base+fsl_num (eg 192--199) */
#define FSL_FIFO_MINOR_BASE 192

#define FSL_FIFO_MINOR(id) (FSL_FIFO_MINOR_BASE | ((id)&0x7))

/* Return a dev->device code for a given fsl channel*/
#define FSL_FIFO(id) MKDEV(MISC_MAJOR, FSL_FIFO_MINOR(id))

/* Compute an fsl fifo ID from a device number */
#define FSL_FIFO_ID(dev) (MINOR(dev) & ~FSL_FIFO_MINOR_BASE)

#define FSL_FIFO_BUF_SIZE 2048

struct fsl_fifo_t {
	int id;				/* Which FSL port */
	int exists;			/* Is there something on the end? */
	int width;			/* Data width in bytes (1,2,4) */
	char tx_buf[FSL_FIFO_BUF_SIZE]; /* TX buffer */
	int tx_head, tx_tail;		/* TX buffer accounting */
	int tx_cnt;

	char rx_buf[FSL_FIFO_BUF_SIZE];	/* RX buffer */
	int rx_head, rx_tail;		/* RX buffer accounting */
	int rx_cnt;
};

#endif

