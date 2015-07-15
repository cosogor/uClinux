/*
 * arch/arm/mach-ixp425/arch.c 
 *
 * Copyright (C) 2002 Intel Corporation.
 *
 * Maintainer: Deepak Saxena <dsaxena@mvista.com>
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License version 2 as
 * published by the Free Software Foundation.
 *
 */

#include <asm/types.h>
#include <asm/setup.h>
#include <asm/memory.h>
#include <asm/hardware.h>
#include <asm/mach-types.h>
#include <asm/mach/arch.h>

extern void ixp425_map_io(void);
extern void ixp425_init_irq(void);

#ifdef CONFIG_ARCH_IXDP425
MACHINE_START(IXDP425, "Intel IXDP425 Development Platform")
	MAINTAINER("MontaVista Software, Inc.")
	BOOT_MEM(PHYS_OFFSET, IXP425_PERIPHERAL_BASE_PHYS,
		IXP425_PERIPHERAL_BASE_VIRT)
	MAPIO(ixp425_map_io)
	INITIRQ(ixp425_init_irq)
	BOOT_PARAMS(0x0100)
MACHINE_END
#endif

#ifdef CONFIG_ARCH_IXCDP1100
MACHINE_START(IXCDP1100, "Intel IXCDP1100 Development Platform")
	MAINTAINER("MontaVista Software, Inc.")
	BOOT_MEM(PHYS_OFFSET, IXP425_PERIPHERAL_BASE_PHYS,
		IXP425_PERIPHERAL_BASE_VIRT)
	MAPIO(ixp425_map_io)
	INITIRQ(ixp425_init_irq)
	BOOT_PARAMS(0x0100)
MACHINE_END
#endif

#ifdef CONFIG_ARCH_PRPMC1100
MACHINE_START(PRPMC1100, "Motorola PrPMC 1100")
	MAINTAINER("MontaVista Software, Inc.")
	BOOT_MEM(PHYS_OFFSET, IXP425_PERIPHERAL_BASE_PHYS,
		IXP425_PERIPHERAL_BASE_VIRT)
	MAPIO(ixp425_map_io)
	INITIRQ(ixp425_init_irq)
	BOOT_PARAMS(0x0100)
MACHINE_END
#endif

#ifdef CONFIG_ARCH_ADI_COYOTE
MACHINE_START(ADI_COYOTE, "ADI Coyote Residential Gateway")
	MAINTAINER("MontaVista Software, Inc.")
	BOOT_MEM(PHYS_OFFSET, IXP425_PERIPHERAL_BASE_PHYS,
		IXP425_PERIPHERAL_BASE_VIRT)
	MAPIO(ixp425_map_io)
	INITIRQ(ixp425_init_irq)
	BOOT_PARAMS(0x0100)
MACHINE_END
#endif

#ifdef CONFIG_ARCH_SE4000
MACHINE_START(SE4000, "SnapGear SE4000")
	MAINTAINER("SnapGear - A CyberGuard Company")
	BOOT_MEM(PHYS_OFFSET, IXP425_PERIPHERAL_BASE_PHYS,
		IXP425_PERIPHERAL_BASE_VIRT)
	MAPIO(ixp425_map_io)
	INITIRQ(ixp425_init_irq)
	BOOT_PARAMS(0x0100)
MACHINE_END
#endif

#ifdef CONFIG_MACH_SG560
MACHINE_START(SG560, "CyberGuard/SG560")
	MAINTAINER("CyberGuard Inc")
	BOOT_MEM(PHYS_OFFSET, IXP425_PERIPHERAL_BASE_PHYS,
		IXP425_PERIPHERAL_BASE_VIRT)
	MAPIO(ixp425_map_io)
	INITIRQ(ixp425_init_irq)
	BOOT_PARAMS(0x0100)
MACHINE_END
#endif

#ifdef CONFIG_MACH_SG565
MACHINE_START(SG565, "CyberGuard/SG565")
	MAINTAINER("CyberGuard Inc")
	BOOT_MEM(PHYS_OFFSET, IXP425_PERIPHERAL_BASE_PHYS,
		IXP425_PERIPHERAL_BASE_VIRT)
	MAPIO(ixp425_map_io)
	INITIRQ(ixp425_init_irq)
	BOOT_PARAMS(0x0100)
MACHINE_END
#endif

#ifdef CONFIG_MACH_SG580
MACHINE_START(SG580, "CyberGuard/SG580")
	MAINTAINER("CyberGuard Inc")
	BOOT_MEM(PHYS_OFFSET, IXP425_PERIPHERAL_BASE_PHYS,
		IXP425_PERIPHERAL_BASE_VIRT)
	MAPIO(ixp425_map_io)
	INITIRQ(ixp425_init_irq)
	BOOT_PARAMS(0x0100)
MACHINE_END
#endif

#ifdef CONFIG_MACH_IVPN
MACHINE_START(IVPN, "CyberGuard/iVPN")
	MAINTAINER("CyberGuard Inc")
	BOOT_MEM(PHYS_OFFSET, IXP425_PERIPHERAL_BASE_PHYS,
		IXP425_PERIPHERAL_BASE_VIRT)
	MAPIO(ixp425_map_io)
	INITIRQ(ixp425_init_irq)
	BOOT_PARAMS(0x0100)
MACHINE_END
#endif

#ifdef CONFIG_MACH_ESS710
extern void ess710_memsize(struct machine_desc *mdesc, struct param_struct *tags, char **cmdline, struct meminfo *mi);

MACHINE_START(ESS710, "CyberGuard SG710")
	MAINTAINER("CyberGuard Inc")
	BOOT_MEM(PHYS_OFFSET, IXP425_PERIPHERAL_BASE_PHYS,
		IXP425_PERIPHERAL_BASE_VIRT)
	MAPIO(ixp425_map_io)
	INITIRQ(ixp425_init_irq)
	BOOT_PARAMS(0x0100)
	FIXUP(ess710_memsize)
MACHINE_END
#endif

#ifdef CONFIG_MACH_MONTEJADE
MACHINE_START(MONTEJADE, "Intel IXP425 Monte Jade Demonstration Platform")
	MAINTAINER("CyberGuard Inc")
	BOOT_MEM(PHYS_OFFSET, IXP425_PERIPHERAL_BASE_PHYS,
		IXP425_PERIPHERAL_BASE_VIRT)
	MAPIO(ixp425_map_io)
	INITIRQ(ixp425_init_irq)
	BOOT_PARAMS(0x0100)
MACHINE_END
#endif

#ifdef CONFIG_MACH_SE5100
MACHINE_START(SE5100, "CyberGuard SE5100 VPN/Firewall/Router/VOIP")
	MAINTAINER("CyberGuard Inc")
	BOOT_MEM(PHYS_OFFSET, IXP425_PERIPHERAL_BASE_PHYS,
		IXP425_PERIPHERAL_BASE_VIRT)
	MAPIO(ixp425_map_io)
	INITIRQ(ixp425_init_irq)
	BOOT_PARAMS(0x0100)
MACHINE_END
#endif
