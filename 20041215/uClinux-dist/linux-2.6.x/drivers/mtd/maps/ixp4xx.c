/*
 * $Id: ixp4xx.c,v 1.4 2004/10/19 06:41:34 gerg Exp $
 *
 * drivers/mtd/maps/ixp425.c
 *
 * MTD Map file for IXP4XX based systems. Please do not make per-board
 * map driver as the code will be 90% identical. For now just add
 * if(machine_is_XXX()) checks to the code. I'll clean this stuff to
 * use platform_data in the the future so we can get rid of that too.
 *
 * Original Author: Intel Corporation
 * Maintainer: Deepak Saxena <dsaxena@mvista.com>
 *
 * Copyright (C) 2002 Intel Corporation
 * Copyright (C) 2003 MontaVista Software, Inc.
 *
 */

#include <linux/module.h>
#include <linux/types.h>
#include <linux/init.h>
#include <linux/kernel.h>
#include <linux/string.h>
#include <linux/mtd/mtd.h>
#include <linux/mtd/map.h>
#include <linux/mtd/partitions.h>
#include <linux/ioport.h>
#include <linux/device.h>
#include <asm/io.h>
#include <asm/mach-types.h>
#include <asm/mach/flash.h>

#include <linux/reboot.h>

#ifndef __ARMEB__
#define	BYTE0(h)	((h) & 0xFF)
#define	BYTE1(h)	(((h) >> 8) & 0xFF)
#else
#define	BYTE0(h)	(((h) >> 8) & 0xFF)
#define	BYTE1(h)	((h) & 0xFF)
#endif

static map_word ixp4xx_read16(struct map_info *map, unsigned long ofs)
{
	map_word val;
	val.x[0] = *(__u16 *) (map->map_priv_1 + ofs);
	return val;
}

/*
 * The IXP4XX expansion bus only allows 16-bit wide acceses
 * when attached to a 16-bit wide device (such as the 28F128J3A),
 * so we can't just memcpy_fromio().
 */
static void ixp4xx_copy_from(struct map_info *map, void *to,
			     unsigned long from, ssize_t len)
{
	int i;
	u8 *dest = (u8 *) to;
	u16 *src = (u16 *) (map->map_priv_1 + from);
	u16 data;

	for (i = 0; i < (len / 2); i++) {
#ifdef __ARMEB__
		data = src[i];
#else
		data = src[i ^ 1];
#endif
		dest[i * 2] = BYTE0(data);
		dest[i * 2 + 1] = BYTE1(data);
	}

	if (len & 1)
#ifdef __ARMEB__
		dest[len - 1] = BYTE0(src[i]);
#else
		dest[len - 1] = BYTE0(src[i ^ 1]);
#endif
}

/*
 * Unaligned writes are ignored, causing the 8-bit
 * probe to fail and proceed to the 16-bit probe (which succeeds).
 */
static void ixp4xx_probe_write16(struct map_info *map, map_word d, unsigned long adr)
{
	if (!(adr & 1))
	       *(__u16 *) (map->map_priv_1 + adr) = d.x[0];
}

/*
 * Fast write16 function without the probing check above
 */
static void ixp4xx_write16(struct map_info *map, map_word d, unsigned long adr)
{
       *(__u16 *) (map->map_priv_1 + adr) = d.x[0];
}

struct ixp425_flash_info {
	struct mtd_info *mtd;
	struct map_info map;
	struct mtd_partition *partitions;
	struct resource *res;
};

static const char *probes[] = { "RedBoot", "cmdlinepart", NULL };

static int ixp4xx_flash_remove(struct device *_dev)
{
	struct platform_device *dev = to_platform_device(_dev);
	struct flash_platform_data *plat = dev->dev.platform_data;
	struct ixp4xx_flash_info *info = dev_get_drvdata(&dev->dev);
	map_word d;

	dev_set_drvdata(&dev->dev, NULL);

	/*
	 * Reboot hack...
	 */
	d.x[0] = 0xff;
	ixp4xx_write16(&info->map, d, 0x55 * 0x2);

	if (info->mtd) {
		del_mtd_partitions(info->mtd);
		map_destroy(info->mtd);
	}
	if (info->map.map_priv_1)
		iounmap((void *) info->map.map_priv_1);

	if (info->partitions)
		kfree(info->partitions);

	if (info->res) {
		release_resource(info->res);
		kfree(info->res);
	}

	/* Disable flash write */
	*IXP4XX_EXP_CS0 &= ~IXP4XX_FLASH_WRITABLE;

	return 0;
}

static int ixp425_flash_probe(struct device *_dev)
{
	struct platform_device *dev = to_platform_device(_dev);
	struct flash_platform_data *plat = dev->dev.platform_data;
	struct ixp425_flash_info *info;
	int err = -1;

	info = kmalloc(sizeof(struct ixp425_flash_info), GFP_KERNEL);
	if(!info) {
		err = -ENOMEM;
		goto Error;
	}	
	memzero(info, sizeof(struct ixp425_flash_info));

	dev_set_drvdata(&dev->dev, info);

	/* Enable flash write */
	*IXP4XX_EXP_CS0 |= IXP4XX_FLASH_WRITABLE;

	/*
	 * We only support 16-bit accesses for now. If and when
	 * any board use 8-bit access, we'll fixup the driver to
	 * handle that.
	 */
	info->map.bankwidth = 2;
	info->map.name = dev->dev.bus_id;
	info->map.read = ixp4xx_read16,
	info->map.write = ixp4xx_probe_write16,
	info->map.copy_from = ixp4xx_copy_from,

	info->res = request_mem_region(dev->resource->start, 
			dev->resource->end - dev->resource->start + 1, 
			"IXP4XXFlash");
	if (!info->res) {
		printk(KERN_ERR "IXP4XXFlash: Could not reserve memory region\n");
		err = -ENOMEM;
		goto Error;
	}

	info->map.map_priv_1 =
	    (void __iomem *) ioremap(dev->resource->start,
				    dev->resource->end - dev->resource->start + 1);
	if (!info->map.map_priv_1) {
		printk(KERN_ERR "IXP4XXFlash: Failed to ioremap region\n");
		err = -EIO;
		goto Error;
	}

	info->mtd = do_map_probe(plat->map_name, &info->map);
	if (!info->mtd) {
		printk(KERN_ERR "IXP4XXFlash: map_probe failed\n");
		err = -ENXIO;
		goto Error;
	}
	info->mtd->owner = THIS_MODULE;

	/* Use the fast version */
	info->map.write = ixp4xx_write16,

	err = parse_mtd_partitions(info->mtd, probes, &info->partitions, 0);
	if (err > 0) {
		err = add_mtd_partitions(info->mtd, info->partitions, err);
		if(err)
			printk(KERN_ERR "Could not parse partitions\n");
	}

	if (err)
		goto Error;

	return 0;

Error:
	ixp425_flash_remove(_dev);
	return err;
}

static struct device_driver ixp425_flash_driver = {
	.name		= "IXP4XX-Flash",
	.bus		= &platform_bus_type,
	.probe		= ixp425_flash_probe,
	.remove		= ixp425_flash_remove,
};

static int __init ixp425_flash_init(void)
{
	return driver_register(&ixp425_flash_driver);
}

static void __exit ixp425_flash_exit(void)
{
	driver_unregister(&ixp425_flash_driver);
}


module_init(ixp425_flash_init);
module_exit(ixp425_flash_exit);

MODULE_LICENSE("GPL");
MODULE_DESCRIPTION("MTD map driver for ixp425 evaluation board");
MODULE_AUTHOR("Deepak Saxena");

