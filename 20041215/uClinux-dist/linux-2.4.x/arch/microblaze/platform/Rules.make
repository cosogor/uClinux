#
# arch/microblaze/platform/Rules.make
#
# This file is included by the global makefile so that you can add your own
# platform-specific flags and dependencies.
# This is the generic platform Rules.make
#
# This file is subject to the terms and conditions of the GNU General Public
# License.  See the file "COPYING" in the main directory of this archive
# for more details.
#
# Copyright (C) 2004       Atmark Techno <yashi@atmark-techno.com>
# Copyright (C) 2004       John Williams <jwilliams@itee.uq.edu.au>
# Copyright (C) 1999,2001  Greg Ungerer (gerg@snapgear.com)
# Copyright (C) 1998,1999  D. Jeff Dionne <jeff@uClinux.org>
# Copyright (C) 1998       Kenneth Albanowski <kjahds@kjahds.com>
# Copyright (C) 1994 by Hamish Macdonald
# Copyright (C) 2000  Lineo Inc. (www.lineo.com)

INCGCC = .

ARCH_DIR = arch/$(ARCH)


CFLAGS += -O2
CFLAGS += -fno-builtin
CFLAGS += -DNO_MM -DNO_FPU -D__ELF__
CFLAGS += $(UTS_SYSNAME) -D__linux__

ifeq ($(CONFIG_XILINX_MICROBLAZE0_USE_BARREL),1)
   CFLAGS += -mxl-barrel-shift
endif

ifeq ($(CONFIG_XILINX_MICROBLAZE0_USE_DIV),1)
    CFLAGS += -mno-xl-soft-div
endif

# Is the HW multiply instruction available?
# check if C_FAMILY contains spartan3, virtex2 or virtex4
ifneq (,$(findstring virtex2,$(CONFIG_XILINX_MICROBLAZE0_FAMILY)))
    CFLAGS += -mno-xl-soft-mul
endif
ifneq (,$(findstring virtex4,$(CONFIG_XILINX_MICROBLAZE0_FAMILY)))
    CFLAGS += -mno-xl-soft-mul
endif
ifneq (,$(findstring spartan3,$(CONFIG_XILINX_MICROBLAZE0_FAMILY)))
    CFLAGS += -mno-xl-soft-mul
endif

LD_SCRIPT := linux.ld
LINKFLAGS = -T $(LD_SCRIPT) --defsym _STACK_SIZE=0x00

#kernel linker script is preprocessed first
$(LINUX) : $(LD_SCRIPT)
$(LD_SCRIPT): $(ARCH_DIR)/platform/$(PLATFORM)/$(MODEL).ld.in
	$(CPP) -P -x assembler-with-cpp $(AFLAGS) $< > $@

HEAD := $(ARCH_DIR)/platform/$(PLATFORM)/head_$(MODEL).o

SUBDIRS := $(ARCH_DIR)/kernel $(ARCH_DIR)/mm $(ARCH_DIR)/lib \
	   $(ARCH_DIR)/xilinx_ocp \
           $(ARCH_DIR)/platform/$(PLATFORM) $(SUBDIRS)

CORE_FILES := $(ARCH_DIR)/kernel/kernel.o $(ARCH_DIR)/mm/mm.o \
	    $(ARCH_DIR)/xilinx_ocp/xilinx_ocp.o \
            $(ARCH_DIR)/platform/$(PLATFORM)/platform.o $(CORE_FILES)

LIBS += $(ARCH_DIR)/lib/lib.a $(LIBGCC)

MAKEBOOT = $(MAKE) -C $(ARCH_DIR)/boot

archclean:
	@$(MAKEBOOT) clean
	rm -f $(LD_SCRIPT)
	rm -f $(ARCH_DIR)/platform/$(PLATFORM)/microblaze_defs.h

