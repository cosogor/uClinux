/****************************************************************************/

/*
 *      snaparm.c -- mappings for SnapGear ARM based boards
 *
 *      (C) Copyright 2000-2004, Greg Ungerer (gerg@snapgear.com)
 *      (C) Copyright 2001-2004, SnapGear (www.snapgear.com)
 *
 *	I expect most SnapGear ARM based boards will have similar
 *	flash arrangements. So this map driver can handle them all.
 */

/****************************************************************************/

#include <linux/module.h>
#include <linux/init.h>
#include <linux/types.h>
#include <linux/kernel.h>
#include <linux/blk.h>
#include <linux/mtd/mtd.h>
#include <linux/mtd/map.h>
#include <linux/mtd/partitions.h>
#include <linux/mtd/cfi.h>
#include <linux/reboot.h>
#include <linux/ioport.h>
#include <asm/io.h>

/****************************************************************************/

static struct mtd_info *sg_mtd;
static struct resource *sg_res;

/****************************************************************************/

/*
 *	Define physical addresss flash is mapped at. Will be different on
 *	different boards.
 */
#if defined(CONFIG_ARCH_SE4000) || defined(CONFIG_MACH_IVPN) || \
    defined(CONFIG_MACH_SG560) || defined(CONFIG_MACH_SG580)
#define	FLASH_ADDR	0x50000000		/* Physical flash address */
#define	FLASH_SIZE	0x01000000		/* Maximum flash size */
#define	FLASH_WIDTH	2			/* Flash bus width */
#endif

#if defined(CONFIG_MACH_SG565)
#define	FLASH_ADDR	0x50000000		/* Physical flash address */
#define	FLASH_SIZE	0x01000000		/* Maximum flash size */
#define	FLASH_WIDTH	1			/* Flash bus width */
#endif

#if CONFIG_ARCH_KS8695
#define	FLASH_ADDR	0x02000000		/* Physical flash address */
#define	FLASH_SIZE	0x00800000		/* Maximum flash size */
#define	FLASH_WIDTH	1			/* Flash bus width */
#endif

#if defined(CONFIG_MACH_EP9312)
#define	FLASH_ADDR	0x60000000		/* Physical flash address */
#define	FLASH_SIZE	0x00800000		/* Maximum flash size */
#define	FLASH_WIDTH	2			/* Flash bus width */
#endif

#if defined(CONFIG_MACH_IPD)
#define	FLASH_ADDR	0x00000000		/* Physical flash address */
#define	FLASH_SIZE	0x01000000		/* Maximum flash size */
#define	FLASH_WIDTH	2			/* Flash bus width */
#endif

/****************************************************************************/

//#define SNAPARM_DEBUG 1
#if SNAPARM_DEBUG
#define DPRINTK printk
#else
#define DPRINTK(...)
#endif

/****************************************************************************/

#if CONFIG_ARCH_KS8695
/*
 *	The bus read and write buffers can potenitially coalesce read and
 *	write bus cycles to the same address, thus dropping real cycles
 *	when talking to IO type devices. We need to flush those	buffers 
 *	when doing flash reading/writing.
 */
#define	BUFREG	((volatile unsigned int *) (IO_ADDRESS(KS8695_IO_BASE) + KS8695_SDRAM_BUFFER))

#if 0

/*
 * This old version which flushes the buffers caused SDRAM errors.
 * In fact just accessing this register (RO) while operating can cause errors!
 */

#define	READFLUSH(x)	(*BUFREG |= 0x00200000)
#define	WRITEFLUSH(x)	(*BUFREG |= 0x00200000)

#else

/*
 * This version *seems* to work.
 * Walk through a small section of memory avoiding the cache
 * so that we can keep the flash running smoothly
 */

static void
invalidate_buffer(void)
{
	static int z = 0;
	*((volatile unsigned int *) (0xc0010000 + (z++ & 0xffff)));
}

#define	READFLUSH(x)	invalidate_buffer()
#define	WRITEFLUSH(x)	invalidate_buffer()

#endif
#endif

#ifndef READFLUSH
#define	READFLUSH(x)
#endif
#ifndef WRITEFLUSH
#define	WRITEFLUSH(x)
#endif

/****************************************************************************/

static __u8 sg_read8(struct map_info *map, unsigned long ofs)
{
	__u8 res;
	READFLUSH(map->map_priv_1 + ofs);
#if	defined(CONFIG_MACH_IVPN)
	udelay(1);
#endif
	res = readb(map->map_priv_1 + ofs);
#if	defined(CONFIG_MACH_IVPN)
	udelay(1);
#endif
	DPRINTK("%s(..., 0x%x) = 0x%x\n", __FUNCTION__, (__u32)ofs, (__u32)res);
	return(res);
}

static __u16 sg_read16(struct map_info *map, unsigned long ofs)
{
	__u16 res;
	READFLUSH(map->map_priv_1 + ofs);
#if	defined(CONFIG_MACH_IVPN)
	udelay(1);
#endif
	res = readw(map->map_priv_1 + ofs);
#if	defined(CONFIG_MACH_IVPN)
	udelay(1);
#endif
	DPRINTK("%s(..., 0x%x) = 0x%x\n", __FUNCTION__, (__u32)ofs, (__u32)res);
	return(res);
}

static __u32 sg_read32(struct map_info *map, unsigned long ofs)
{
	unsigned long flags;
	__u32 res;
	READFLUSH(map->map_priv_1 + ofs);
#if	defined(CONFIG_MACH_IVPN)
	save_flags(flags); cli();
	udelay(1);
#endif
	res = readl(map->map_priv_1 + ofs);
#if	defined(CONFIG_MACH_IVPN)
	udelay(1);
	restore_flags(flags);
#endif
	DPRINTK("%s(..., 0x%x) = 0x%x\n", __FUNCTION__, (__u32)ofs, (__u32)res);
	return(res);
}

static void sg_copy_from(struct map_info *map, void *to, unsigned long from, ssize_t len)
{
	unsigned long flags;
	unsigned short *dst;
	unsigned int i;

	DPRINTK("%s(..., to=0x%x, from=0x%x, len=%d)\n", __FUNCTION__,
			(__u32)to, (__u32)from, (__u32)len);
#if	defined(CONFIG_MACH_IVPN)
	save_flags(flags); cli();
	for (dst = to, i = 0; (i < len); i += 2) {
		udelay(1);
		*dst++ = readw(map->map_priv_1 + from + i);
	}
	udelay(1);
	restore_flags(flags);
#else
	memcpy_fromio(to, map->map_priv_1 + from, len);
#endif
}

static void sg_write8(struct map_info *map, __u8 d, unsigned long adr)
{
	WRITEFLUSH(map->map_priv_1 + adr);
	DPRINTK("%s(..., d=0x%x, adr=0x%x)\n", __FUNCTION__, (__u32)d, (__u32)adr);
#if	defined(CONFIG_MACH_IVPN)
	udelay(1);
#endif
	writeb(d, map->map_priv_1 + adr);
#if	defined(CONFIG_MACH_IVPN)
	udelay(1);
#endif
}

static void sg_write16(struct map_info *map, __u16 d, unsigned long adr)
{
	WRITEFLUSH(map->map_priv_1 + adr);
	DPRINTK("%s(..., d=0x%x, adr=0x%x)\n", __FUNCTION__, (__u32)d, (__u32)adr);
#if	defined(CONFIG_MACH_IVPN)
	udelay(1);
#endif
	writew(d, map->map_priv_1 + adr);
#if	defined(CONFIG_MACH_IVPN)
	udelay(1);
#endif
}

static void sg_write32(struct map_info *map, __u32 d, unsigned long adr)
{
	unsigned long flags;
	WRITEFLUSH(map->map_priv_1 + adr);
	DPRINTK("%s(..., d=0x%x, adr=0x%x)\n", __FUNCTION__, (__u32)d, (__u32)adr);
#if	defined(CONFIG_MACH_IVPN)
	save_flags(flags); cli();
	udelay(1);
#endif
	writel(d, map->map_priv_1 + adr);
#if	defined(CONFIG_MACH_IVPN)
	udelay(1);
	restore_flags(flags);
#endif
}

static void sg_copy_to(struct map_info *map, unsigned long to, const void *from, ssize_t len)
{
	unsigned long flags;
	unsigned short *src;
	unsigned int i;

	DPRINTK("%s(..., to=0x%x, from=0x%x, len=%d)\n", __FUNCTION__,
			(__u32)to, (__u32)from, (__u32)len);
#if	defined(CONFIG_MACH_IVPN)
	save_flags(flags); cli();
	for (src = from, i = 0; (i < len); i += 2) {
		udelay(1);
		writew(*src++, map->map_priv_1 + from + i);
	}
	udelay(1);
	restore_flags(flags);
#else
	memcpy_toio(map->map_priv_1 + to, from, len);
#endif
}

/****************************************************************************/

/*
 *	Intel FLASH setup. This is the only flash device, it is the entire
 *	non-volatile storage (no IDE CF or hard drive or anything else).
 */

static struct map_info sg_map = {
	name: "SnapGear Intel/StrataFlash",
	size: 0x800000,
	buswidth: FLASH_WIDTH,
	read8: sg_read8,
	read16: sg_read16,
	read32: sg_read32,
	copy_from: sg_copy_from,
	write8: sg_write8,
	write16: sg_write16,
	write32: sg_write32,
	copy_to: sg_copy_to
};

static struct mtd_partition sg_partitions[] = {
	{
		name: "SnapGear Boot Loader",
		offset: 0,
		size: 0x00020000
	},
#if defined(CONFIG_MACH_IPD)
	{
		name: "SnapGear System Data",
		offset: 0x00020000,
		size: 0x00020000
	},
	{
		name: "SnapGear non-volatile configuration",
		offset: 0x00040000,
		size: 0x00020000
	},
	{
		name: "SnapGear image",
		offset: 0x00060000,
	},
#else
	{
		name: "SnapGear non-volatile configuration",
		offset: 0x00020000,
		size: 0x00020000
	},
	{
		name: "SnapGear image",
		offset: 0x40000,
	},
#endif
	{
		name: "SnapGear Intel/StrataFlash",
		offset: 0
	},
};

/****************************************************************************/

#define NUM_PARTITIONS	(sizeof(sg_partitions)/sizeof(sg_partitions[0]))

/****************************************************************************/

/*
 *	Set the Intel flash back to read mode. Sometimes MTD leaves the
 *	flash in status mode, and if you reboot there is no code to
 *	execute (the flash devices do not get a RESET) :-(
 */
static int sg_reboot_notifier(struct notifier_block *nb, unsigned long val, void *v)
{
	struct cfi_private *cfi = sg_map.fldrv_priv;
	int i;

	/* Make sure all FLASH chips are put back into read mode */
	for (i = 0; cfi && i < cfi->numchips; i++) {
		cfi_send_gen_cmd(0xff, 0x55, cfi->chips[i].start, &sg_map,
			cfi, cfi->device_type, NULL);
	}
	return NOTIFY_OK;
}

static struct notifier_block sg_notifier_block = {
	sg_reboot_notifier, NULL, 0
};

/****************************************************************************/

/*
 *	Find the MTD device with the given name.
 */

static int sg_getmtdindex(char *name)
{
	struct mtd_info *mtd;
	int i, index;

	index = -1;
	for (i = 0; (i < MAX_MTD_DEVICES); i++) {
		mtd = get_mtd_device(NULL, i);
		if (mtd) {
			if (strcmp(mtd->name, name) == 0)
				index = mtd->index;
			put_mtd_device(mtd);
			if (index >= 0)
				break;
		}
	}
	return index;
}

/****************************************************************************/

int __init sg_init(void)
{
	int index, rc;

	printk("SNAPGEAR: MTD flash setup\n");

#if defined(CONFIG_ARCH_IXP425)
	/* Enable flash writes */
	*IXP425_EXP_CS0 |= IXP425_FLASH_WRITABLE;
#endif

	sg_res = request_mem_region(FLASH_ADDR, FLASH_SIZE, "SnapGear FLASH");
	if (sg_res == NULL) {
		printk("SNAPGEAR: failed memory resource request?\n");
		return -EIO;
	}

	/*
	 *	Map flash into our virtual address space.
	 */
	sg_map.map_priv_1 = (unsigned long) ioremap(FLASH_ADDR, FLASH_SIZE);
	if (!sg_map.map_priv_1) {
		release_mem_region(FLASH_ADDR, FLASH_SIZE);
		sg_res = NULL;
		printk("SNAPGEAR: failed to ioremap() flash\n");
		return -EIO;
	}

	if ((sg_mtd = do_map_probe("cfi_probe", &sg_map)) == NULL) {
		iounmap((void *)sg_map.map_priv_1);
		release_mem_region(FLASH_ADDR, FLASH_SIZE);
		sg_res = NULL;
		sg_map.map_priv_1 = 0;
		printk("probe failed\n");
		return -ENXIO;
	}

	printk(KERN_NOTICE "SNAPGEAR: %s device size = %dK\n",
		sg_mtd->name, sg_mtd->size>>10);

	sg_mtd->module = THIS_MODULE;
	register_reboot_notifier(&sg_notifier_block);
	rc = add_mtd_partitions(sg_mtd, sg_partitions, NUM_PARTITIONS);

#ifdef CONFIG_BLK_DEV_INITRD
	if (initrd_start == 0)
#endif
	{
		/* Mark mtd partition as root device */
		index = sg_getmtdindex("SnapGear image");
		if (index >= 0)
			ROOT_DEV = MKDEV(MTD_BLOCK_MAJOR, index);
	}

	return rc;
}

/****************************************************************************/

void __exit sg_cleanup(void)
{
	unregister_reboot_notifier(&sg_notifier_block);
	if (sg_mtd) {
		del_mtd_partitions(sg_mtd);
		map_destroy(sg_mtd);
	}
	if (sg_map.map_priv_1) {
		iounmap((void *)sg_map.map_priv_1);
		sg_map.map_priv_1 = 0;
	}
	if (sg_res) {
		release_mem_region(FLASH_ADDR, FLASH_SIZE);
		sg_res = NULL;
	}
}

/****************************************************************************/

module_init(sg_init);
module_exit(sg_cleanup);

MODULE_LICENSE("GPL");
MODULE_AUTHOR("Greg Ungerer <gerg@snapgear.com>");
MODULE_DESCRIPTION("SnapGear/ARM flash support");

/****************************************************************************/
