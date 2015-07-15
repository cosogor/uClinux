/*
 * arch/arm/mach-ixp4xx/sg.c
 *
 * SG5XX/SE4000 board-setup 
 *
 * Copyright (C) 2003-2004 MontaVista Software, Inc.
 * Copyright (C) 2004      Greg Ungerer <gerg@snapgear.com>
 *
 * Author: Deepak Saxena <dsaxena@mvista.com>
 */

#include <linux/init.h>
#include <linux/device.h>
#include <asm/types.h>
#include <asm/setup.h>
#include <asm/memory.h>
#include <asm/hardware.h>
#include <asm/mach-types.h>
#include <asm/mach/arch.h>
#include <asm/mach/flash.h>

#ifdef	__ARMEB__
#define	REG_OFFSET	3
#else
#define	REG_OFFSET	0
#endif

extern void ixp4xx_map_io(void);
extern void ixp4xx_init_irq(void);

/*
 *	Console serial port on CyberGuard/SnapGear boards.
 */
static struct uart_port sg_serial_port[] = {
	{
		.membase	= (char*)(IXP4XX_UART1_BASE_VIRT + REG_OFFSET),
		.mapbase	= (IXP4XX_UART1_BASE_PHYS),
		.irq		= IRQ_IXP4XX_UART1,
		.flags		= UPF_SKIP_TEST,
		.iotype		= UPIO_MEM,	
		.regshift	= 2,
		.uartclk	= IXP4XX_UART_XTAL,
		.line		= 0,
		.type		= PORT_XSCALE,
		.fifosize	= 32
	}
};

void __init sg_map_io(void) 
{
	early_serial_setup(&sg_serial_port[0]);
	ixp4xx_map_io();
}

static struct flash_platform_data sg_flash_data = {
	.map_name	= "cfi_probe",
	.width		= 2,
};

static struct resource sg_flash_resource = {
	.start		= IXP425_EXP_BUS_CS0_BASE_PHYS,
	.end		= IXP425_EXP_BUS_CS0_BASE_PHYS + 
				IXP425_EXP_BUS_CSX_REGION_SIZE,
	.flags		= IORESOURCE_MEM,
};

static struct platform_device sg_flash_device = {
	.name		= "IXP425Flash",
	.id		= 0,
	.dev		= {
		.platform_data = &sg_flash_data,
	},
	.num_resources	= 1,
	.resource	= &sg_flash_resource,
};

static int __init sg_init(void)
{
	if (!machine_is_se4000() && !machine_is_sg560())
		return -ENODEV;

	platform_add_device(&sg_flash_device);
	return 0;
}

arch_initcall(sg_init);

#ifdef CONFIG_ARCH_SE4000
MACHINE_START(SE4000, "SnapGear SE4000")
	MAINTAINER("SnapGear Inc.")
	BOOT_MEM(PHYS_OFFSET, IXP425_PERIPHERAL_BASE_PHYS,
		IXP425_PERIPHERAL_BASE_VIRT)
	MAPIO(sg_map_io)
	INITIRQ(ixp4xx_init_irq)
	BOOT_PARAMS(0x100)
MACHINE_END
#endif

#ifdef CONFIG_MACH_SG560
MACHINE_START(SG560, "CyberGuard SG560")
	MAINTAINER("CyberGuard Inc.")
	BOOT_MEM(PHYS_OFFSET, IXP425_PERIPHERAL_BASE_PHYS,
		IXP425_PERIPHERAL_BASE_VIRT)
	MAPIO(sg_map_io)
	INITIRQ(ixp4xx_init_irq)
	BOOT_PARAMS(0x100)
MACHINE_END
#endif

