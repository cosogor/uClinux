#
# Makefile -- Build instructions for generic Microblaze platform
#

include $(LINUX_CONFIG)
include $(CONFIG_CONFIG)
include $(ARCH_CONFIG)

LINUX	 = $(ROOTDIR)/$(LINUXDIR)/linux 
LINUXBIN = $(IMAGEDIR)/linux.bin
ROMFSIMG = $(IMAGEDIR)/romfs.img
JFFS2IMG = $(IMAGEDIR)/jffs2.img
IMAGE    = $(IMAGEDIR)/image.bin
IMAGEZ	 = $(IMAGEDIR)/imagez.bin
ELFIMAGE = $(IMAGEDIR)/image.elf
CKSUM	 = $(ROOTDIR)/tools/cksum

DIRS = 

ROMFS_DIRS = bin dev dev/flash etc home lib mnt proc usr var

FSIMG = $(ROMFSIMG)

ifdef CONFIG_USER_FLATFSD_FLATFSD
ETCDIR = /etc/default
else
ETCDIR = /etc
endif

DEVICES =								      \
	tty,c,5,0      console,c,5,1   mem,c,1,1     kmem,c,1,2    null,c,1,3 \
									      \
	ttyS0,c,4,64							      \
									      \
	zero,c,1,5     random,c,1,8    urandom,c,1,9			      \
									      \
        fb0,c,29,0                                                            \
                                                                              \
	ptyp0,c,2,0    ptyp1,c,2,1     ptyp2,c,2,2   ptyp3,c,2,3	      \
	ptyp4,c,2,4    ptyp5,c,2,5     ptyp6,c,2,6   ptyp7,c,2,7	      \
	ptyp8,c,2,8    ptyp9,c,2,9     ptypa,c,2,10  ptypb,c,2,11	      \
	ptypc,c,2,12   ptypd,c,2,13    ptype,c,2,14  ptypf,c,2,15	      \
									      \
	ttyp0,c,3,0    ttyp1,c,3,1     ttyp2,c,3,2   ttyp3,c,3,3	      \
	ttyp4,c,3,4    ttyp5,c,3,5     ttyp6,c,3,6   ttyp7,c,3,7	      \
	ttyp8,c,3,8    ttyp9,c,3,9     ttypa,c,3,10  ttypb,c,3,11	      \
	ttypc,c,3,12   ttypd,c,3,13    ttype,c,3,14  ttypf,c,3,15	   

DEVICES +=   \
	mtd0,c,90,0	mtdr0,c,90,1	mtdblock0,b,31,0	\
	mtd1,c,90,2	mtdr1,c,90,3	mtdblock1,b,31,1	\
	mtd2,c,90,4	mtdr2,c,90,5	mtdblock2,b,31,2	\
	mtd3,c,90,6	mtdr3,c,90,7	mtdblock3,b,31,3	\
	mtd4,c,90,8 	mtdr4,c,90,9	mtdblock4,b,31,4	\
	mtd5,c,90,10 	mtdr5,c,90,11	mtdblock5,b,31,5	\
	mtd6,c,90,12 	mtdr6,c,90,13	mtdblock6,b,31,6	\
	mtd7,c,90,14 	mtdr7,c,90,15	mtdblock7,b,31,7


FLASH_DEVICES = \
	boot,c,90,0     \
	bootarg,c,90,2  \
	ethmac,c,90,4   \
	config,c,90,6   \
	spare,c,90,8    \
	image,c,90,10   \
	jffs2,c,90,12   \
	all,c,90,14

PICO_DEVICES =

ifdef CONFIG_MICROBLAZE_PICO0
	PICO_DEVICES += pico0,c,10,192
endif
ifdef CONFIG_MICROBLAZE_PICO1
	PICO_DEVICES += pico1,c,10,193
endif
ifdef CONFIG_MICROBLAZE_PICO2
	PICO_DEVICES += pico2,c,10,194
endif
ifdef CONFIG_MICROBLAZE_PICO3
	PICO_DEVICES += pico3,c,10,195
endif
ifdef CONFIG_MICROBLAZE_PICO4
	PICO_DEVICES += pico4,c,10,196
endif
ifdef CONFIG_MICROBLAZE_PICO5
	PICO_DEVICES += pico5,c,10,197
endif
ifdef CONFIG_MICROBLAZE_PICO6
	PICO_DEVICES += pico6,c,10,198
endif
ifdef CONFIG_MICROBLAZE_PICO7
	PICO_DEVICES += pico7,c,10,199
endif

ROOT_PASSWD := $(shell crypt.pl root)

all:
	dirs=$(DIRS) ; \
	for i in $$dirs ; do  $(MAKE) -C $$i || exit $? ; done

clean:
	-dirs=$(DIRS) ; \
	for i in $$dirs; do [ ! -d $$i ] || $(MAKE) -C $$i clean; done

romfs:
	[ -d $(ROMFSDIR)/$$i ] || mkdir -p $(ROMFSDIR)
	for i in $(ROMFS_DIRS); do \
		[ -d $(ROMFSDIR)/$$i ] || mkdir -p $(ROMFSDIR)/$$i; \
	done
	for i in $(DIRS); do $(MAKE) -C $$i romfs || exit $? ; done

	mkdir -p $(ROMFSDIR)/etc/init.d
	mkdir -p $(ROMFSDIR)/etc/rc.d

	$(ROMFSINST) -s /bin /sbin

	for i in $(DEVICES); do \
		touch $(ROMFSDIR)/dev/@$$i; \
	done
	# these permissions are needed for openpty and family to work
	# on non-ptmx ptys
	chmod 620 $(ROMFSDIR)/dev/@[pt]ty[pqrsPQRS][0-9a-f],*
	for i in $(FLASH_DEVICES); do \
		touch $(ROMFSDIR)/dev/flash/@$$i; \
	done
	$(ROMFSINST) -s /var/tmp /tmp

ifdef CONFIG_MICROBLAZE_PICOBLAZE
	for i in $(PICO_DEVICES); do \
		touch $(ROMFSDIR)/dev/@$$i; \
	done
endif

ifdef CONFIG_USER_FLATFSD_FLATFSD
	mkdir -p $(ROMFSDIR)/etc/config
	mkdir -p $(ROMFSDIR)$(ETCDIR)
	$(ROMFSINST) etc/rc/flatfsd /etc/init.d/flatfsd
	$(ROMFSINST) -s /etc/init.d/flatfsd /etc/rc.d/S02flatfsd
endif

	$(ROMFSINST) -a "root:${ROOT_PASSWD}:0:0::/:/bin/sh" $(ETCDIR)/passwd

ifdef CONFIG_USER_INIT_INIT
	$(ROMFSINST) -e CONFIG_USER_AGETTY_AGETTY \
			-a "ttyS0:vt100:/bin/agetty ttyS0 115200" /etc/inittab
	$(ROMFSINST) -e CONFIG_USER_FLATFSD_FLATFSD \
			-a "flt:unknown:/bin/flatfsd" /etc/inittab
	$(ROMFSINST) -e CONFIG_USER_INETD_INETD \
			-a "inet:unknown:/bin/inetd" /etc/inittab
	$(ROMFSINST) -e CONFIG_USER_FLATFSD_FLATFSD \
			etc/rc/start $(ETCDIR)/start
	$(ROMFSINST) -e CONFIG_USER_FLATFSD_FLATFSD \
			etc/inittab.config $(ETCDIR)/inittab
	$(ROMFSINST) etc/rc/sysinit /etc/rc
endif

ifdef CONFIG_USER_BUSYBOX_INIT
	$(ROMFSINST) etc/rc/sysinit /etc/rc.sysinit
	$(ROMFSINST) etc/rc/reboot /etc/rc.reboot
ifdef CONFIG_USER_AGETTY_AGETTY 
	$(ROMFSINST) etc/inittab.agetty /etc/inittab
else
	$(ROMFSINST) etc/inittab.sh /etc/inittab
endif
endif

	$(ROMFSINST) -e CONFIG_USER_NET_TOOLS_HOSTNAME \
			etc/rc/hostname /etc/init.d/hostname
	$(ROMFSINST) -e CONFIG_USER_SYSUTILS_HOSTNAME  \
			etc/rc/hostname /etc/init.d/hostname
	$(ROMFSINST) -e CONFIG_USER_NET_TOOLS_HOSTNAME \
			etc/rc/hostname /etc/init.d/hostname

	[ -e $(ROMFSDIR)/etc/init.d/hostname ] && \
		$(ROMFSINST) -a "/bin/hostname $(CONFIG_PRODUCT)" /etc/init.d/hostname
	[ -e $(ROMFSDIR)/etc/init.d/hostname ] && \
		$(ROMFSINST) -s /etc/init.d/hostname /etc/rc.d/S30hostname


############################################

ifdef CONFIG_NET

# setup /etc/init.d/network and/or /etc/resolv.conf
ifdef CONFIG_USER_DHCPCD_NEW_DHCPCD
	$(ROMFSINST) etc/rc/dhcpcd-new /etc/init.d/network
else
	[ -f etc/resolv.conf ] && $(ROMFSINST) etc/resolv.conf $(ETCDIR)/resolv.conf
endif

# this is the special case, overwrite /etc/init.d/network
ifdef CONFIG_USER_DHCPCD_NEW_DHCPCD
ifndef CONFIG_USER_FLATFSD_FLATFSD
	$(ROMFSINST)  etc/rc/dhcpcd-new.no-resolv.conf /etc/init.d/network
endif
else
	$(ROMFSINST) -755 etc/rc/ifconfig /etc/init.d/network
endif

	$(ROMFSINST) -s /etc/init.d/network /etc/rc.d/S40network

	$(ROMFSINST) -e CONFIG_USER_INETD_INETD \
			etc/rc/inetd /etc/init.d/inetd
	$(ROMFSINST) -e CONFIG_USER_INETD_INETD \
			-s /etc/init.d/inetd /etc/rc.d/S50inetd

ifdef CONFIG_USER_THTTPD_THTTPD
	$(ROMFSINST) etc/rc/thttpd /etc/init.d/thttpd
	$(ROMFSINST) -s /etc/init.d/thttpd /etc/rc.d/S90thttpd
	$(ROMFSINST) /home/httpd
endif

	$(ROMFSINST) ../../Generic/romfs/etc/services /etc/services
endif

$(LINUXBIN): $(LINUX)
	[ -d $(IMAGEDIR) ] || mkdir -p $(IMAGEDIR)
	$(CROSS)objcopy -O binary $(LINUX) $@

$(ROMFSIMG): 
ifdef CONFIG_BINFMT_ZFLAT
	for i in $(ROMFSDIR)/bin/* ; do \
		$(CROSS)flthdr -z $$i; \
	done
endif
	genromfs -v -V "ROMdisk" -x *~ -f $(ROMFSIMG) -d $(ROMFSDIR)

$(JFFS2IMG):
# current mkfs.jffs2 in uclinux dist doesn't work.
# assume we have good working mkfs.jffs2 installed on host system
	mkfs.jffs2 --big-endian --pad=1966080 --squash --eraseblock=65536 \
                   --devtable jffs2_devtable.txt --root=$(ROMFSDIR) --output=$(JFFS2IMG)
	cp $(LINUXBIN) $(IMAGE)
	dd if=$(JFFS2IMG) of=$(IMAGE) bs=1024 seek=1472


.PHONY: image $(FSIMG)
image: $(ELFIMAGE) $(LINUXBIN) $(IMAGEZ)
	$(CROSS)objcopy -O binary --remove-section=.stab \
		--remove-section=.stabstr $(ELFIMAGE) $(IMAGE)

ifdef CONFIG_USER_NETFLASH_VERSION
	echo -ne "\000" >> $(IMAGE)
	echo -n $(VERSIONPKG) >> $(IMAGE)
	echo -ne "\000" >> $(IMAGE)
	echo -n $(CONFIG_VENDOR) >> $(IMAGE)
	echo -ne "\000" >> $(IMAGE)
	echo -n $(CONFIG_PRODUCT) >> $(IMAGE)
endif
ifdef CONFIG_USER_NETFLASH_HMACMD5
	$(ROOTDIR)/user/netflash/hmacmd5 $(CONFIG_USER_NETFLASH_HMACMD5_KEY) < $(IMAGE) >> $(IMAGE)
else
	$(CKSUM) -b -o 2 $(IMAGE) >> $(IMAGE)
endif
	# Copy image files into /tftpboot, if requested
	[ -n "$(NO_BUILD_INTO_TFTPBOOT)" ] || cp $(IMAGE) /tftpboot
	[ -n "$(NO_BUILD_INTO_TFTPBOOT)" ] || cp $(IMAGEZ) /tftpboot

$(IMAGEZ): 
	gzip -9 < $(LINUXBIN) | dd conv=sync ibs=4 > $(IMAGEDIR)/linuxz.bin
	cat $(IMAGEDIR)/linuxz.bin $(ROMFSIMG) | gzip -9 > $(IMAGEZ)

$(ELFIMAGE): $(ROMFSIMG) $(LINUX)
	BSS=`$(CROSS)objdump --headers $(LINUX) | \
		grep "\.bss"` ; \
	ADDR=`set -- $${BSS} ; echo 0x$${4}` ; \
	$(CROSS)objcopy --add-section=.romfs=$(ROMFSIMG) \
		--adjust-section-vma=.romfs=$${ADDR} --no-adjust-warnings \
		--set-section-flags=.romfs=alloc,load,data   \
		$(LINUX) $(ELFIMAGE)

