#
# Automatically generated make config: don't edit
# Linux kernel version: 2.6.9-uc0
# Mon Dec 13 14:44:51 2004
#
CONFIG_M68KNOMMU=y
# CONFIG_MMU is not set
# CONFIG_FPU is not set
CONFIG_UID16=y
CONFIG_RWSEM_GENERIC_SPINLOCK=y
# CONFIG_RWSEM_XCHGADD_ALGORITHM is not set

#
# Code maturity level options
#
CONFIG_EXPERIMENTAL=y
CONFIG_CLEAN_COMPILE=y
CONFIG_BROKEN_ON_SMP=y

#
# General setup
#
CONFIG_LOCALVERSION=""
# CONFIG_BSD_PROCESS_ACCT is not set
# CONFIG_SYSCTL is not set
# CONFIG_AUDIT is not set
CONFIG_LOG_BUF_SHIFT=14
# CONFIG_HOTPLUG is not set
# CONFIG_IKCONFIG is not set
CONFIG_EMBEDDED=y
# CONFIG_KALLSYMS is not set
# CONFIG_FUTEX is not set
# CONFIG_EPOLL is not set
CONFIG_IOSCHED_NOOP=y
# CONFIG_IOSCHED_AS is not set
# CONFIG_IOSCHED_DEADLINE is not set
CONFIG_IOSCHED_CFQ=y
# CONFIG_CC_OPTIMIZE_FOR_SIZE is not set

#
# Loadable module support
#
# CONFIG_MODULES is not set

#
# Processor type and features
#
CONFIG_M68328=y
# CONFIG_M68EZ328 is not set
# CONFIG_M68VZ328 is not set
# CONFIG_M68360 is not set
# CONFIG_M5206 is not set
# CONFIG_M5206e is not set
# CONFIG_M5249 is not set
# CONFIG_M527x is not set
# CONFIG_M5272 is not set
# CONFIG_M528x is not set
# CONFIG_M5307 is not set
# CONFIG_M5407 is not set
CONFIG_CLOCK_AUTO=y
# CONFIG_CLOCK_11MHz is not set
# CONFIG_CLOCK_16MHz is not set
# CONFIG_CLOCK_20MHz is not set
# CONFIG_CLOCK_24MHz is not set
# CONFIG_CLOCK_25MHz is not set
# CONFIG_CLOCK_33MHz is not set
# CONFIG_CLOCK_40MHz is not set
# CONFIG_CLOCK_45MHz is not set
# CONFIG_CLOCK_48MHz is not set
# CONFIG_CLOCK_50MHz is not set
# CONFIG_CLOCK_54MHz is not set
# CONFIG_CLOCK_60MHz is not set
# CONFIG_CLOCK_64MHz is not set
# CONFIG_CLOCK_66MHz is not set
# CONFIG_CLOCK_70MHz is not set
# CONFIG_CLOCK_100MHz is not set
# CONFIG_CLOCK_140MHz is not set
# CONFIG_CLOCK_150MHz is not set
# CONFIG_CLOCK_166MHz is not set

#
# Platform
#
CONFIG_PILOT3=y
CONFIG_XCOPILOT_BUGS=y
CONFIG_PILOT=y
# CONFIG_LARGE_ALLOCS is not set
CONFIG_RAMAUTO=y
# CONFIG_RAM4MB is not set
# CONFIG_RAM8MB is not set
# CONFIG_RAM16MB is not set
# CONFIG_RAM32MB is not set
CONFIG_RAMAUTOBIT=y
# CONFIG_RAM8BIT is not set
# CONFIG_RAM16BIT is not set
# CONFIG_RAM32BIT is not set
# CONFIG_RAMKERNEL is not set
CONFIG_ROMKERNEL=y

#
# Bus options (PCI, PCMCIA, EISA, MCA, ISA)
#
# CONFIG_PCI is not set

#
# Executable file formats
#
CONFIG_BINFMT_FLAT=y
# CONFIG_BINFMT_ZFLAT is not set
# CONFIG_BINFMT_SHARED_FLAT is not set
# CONFIG_BINFMT_MISC is not set

#
# Power management options
#
# CONFIG_PM is not set

#
# Device Drivers
#

#
# Generic Driver Options
#
CONFIG_STANDALONE=y
CONFIG_PREVENT_FIRMWARE_BUILD=y

#
# Memory Technology Devices (MTD)
#
CONFIG_MTD=y
# CONFIG_MTD_DEBUG is not set
CONFIG_MTD_PARTITIONS=y
# CONFIG_MTD_CONCAT is not set
# CONFIG_MTD_REDBOOT_PARTS is not set
# CONFIG_MTD_CMDLINE_PARTS is not set

#
# User Modules And Translation Layers
#
CONFIG_MTD_CHAR=y
CONFIG_MTD_BLOCK=y
# CONFIG_FTL is not set
# CONFIG_NFTL is not set
# CONFIG_INFTL is not set

#
# RAM/ROM/Flash chip drivers
#
# CONFIG_MTD_CFI is not set
# CONFIG_MTD_JEDECPROBE is not set
CONFIG_MTD_MAP_BANK_WIDTH_1=y
CONFIG_MTD_MAP_BANK_WIDTH_2=y
CONFIG_MTD_MAP_BANK_WIDTH_4=y
# CONFIG_MTD_MAP_BANK_WIDTH_8 is not set
# CONFIG_MTD_MAP_BANK_WIDTH_16 is not set
# CONFIG_MTD_MAP_BANK_WIDTH_32 is not set
CONFIG_MTD_CFI_I1=y
CONFIG_MTD_CFI_I2=y
# CONFIG_MTD_CFI_I4 is not set
# CONFIG_MTD_CFI_I8 is not set
CONFIG_MTD_RAM=y
# CONFIG_MTD_ROM is not set
# CONFIG_MTD_ABSENT is not set

#
# Mapping drivers for chip access
#
# CONFIG_MTD_COMPLEX_MAPPINGS is not set
CONFIG_MTD_UCLINUX=y
# CONFIG_MTD_SNAPGEARuC is not set

#
# Self-contained MTD device drivers
#
# CONFIG_MTD_SLRAM is not set
# CONFIG_MTD_PHRAM is not set
# CONFIG_MTD_MTDRAM is not set
# CONFIG_MTD_BLKMTD is not set

#
# Disk-On-Chip Device Drivers
#
# CONFIG_MTD_DOC2000 is not set
# CONFIG_MTD_DOC2001 is not set
# CONFIG_MTD_DOC2001PLUS is not set

#
# NAND Flash Device Drivers
#
# CONFIG_MTD_NAND is not set

#
# Parallel port support
#
# CONFIG_PARPORT is not set

#
# Plug and Play support
#

#
# Block devices
#
# CONFIG_BLK_DEV_FD is not set
# CONFIG_BLK_DEV_LOOP is not set
CONFIG_BLK_DEV_RAM=y
CONFIG_BLK_DEV_RAM_SIZE=4096
# CONFIG_BLK_DEV_INITRD is not set

#
# ATA/ATAPI/MFM/RLL support
#
# CONFIG_IDE is not set

#
# SCSI device support
#
# CONFIG_SCSI is not set

#
# Multi-device support (RAID and LVM)
#
# CONFIG_MD is not set

#
# Fusion MPT device support
#

#
# IEEE 1394 (FireWire) support
#
# CONFIG_IEEE1394 is not set

#
# I2O device support
#

#
# Networking support
#
# CONFIG_NET is not set
# CONFIG_NETPOLL is not set
# CONFIG_NET_POLL_CONTROLLER is not set

#
# ISDN subsystem
#

#
# Telephony Support
#
# CONFIG_PHONE is not set

#
# Input device support
#
CONFIG_INPUT=y

#
# Userland interfaces
#
# CONFIG_INPUT_MOUSEDEV is not set
# CONFIG_INPUT_JOYDEV is not set
# CONFIG_INPUT_TSDEV is not set
# CONFIG_INPUT_EVDEV is not set
# CONFIG_INPUT_EVBUG is not set

#
# Input I/O drivers
#
# CONFIG_GAMEPORT is not set
CONFIG_SOUND_GAMEPORT=y
CONFIG_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=y
# CONFIG_SERIO_CT82C710 is not set
# CONFIG_SERIO_RAW is not set

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
CONFIG_KEYBOARD_ATKBD=y
# CONFIG_KEYBOARD_SUNKBD is not set
# CONFIG_KEYBOARD_LKKBD is not set
# CONFIG_KEYBOARD_XTKBD is not set
# CONFIG_KEYBOARD_NEWTON is not set
CONFIG_INPUT_MOUSE=y
CONFIG_MOUSE_PS2=y
# CONFIG_MOUSE_SERIAL is not set
# CONFIG_MOUSE_VSXXXAA is not set
# CONFIG_INPUT_JOYSTICK is not set
# CONFIG_INPUT_TOUCHSCREEN is not set
# CONFIG_INPUT_MISC is not set

#
# Character devices
#
# CONFIG_VT is not set
# CONFIG_SERIAL_NONSTANDARD is not set
# CONFIG_LEDMAN is not set
# CONFIG_RESETSWITCH is not set

#
# Serial drivers
#
# CONFIG_SERIAL_8250 is not set

#
# Non-8250 serial port support
#
CONFIG_SERIAL_68328=y
# CONFIG_SERIAL_68328_RTS_CTS is not set
# CONFIG_UNIX98_PTYS is not set
CONFIG_LEGACY_PTYS=y
CONFIG_LEGACY_PTY_COUNT=256

#
# IPMI
#
# CONFIG_IPMI_HANDLER is not set

#
# Watchdog Cards
#
# CONFIG_WATCHDOG is not set
# CONFIG_RTC is not set
# CONFIG_GEN_RTC is not set
# CONFIG_DTLK is not set
# CONFIG_R3964 is not set

#
# Ftape, the floppy tape device driver
#
# CONFIG_AGP is not set
# CONFIG_DRM is not set
# CONFIG_RAW_DRIVER is not set

#
# I2C support
#
# CONFIG_I2C is not set

#
# Dallas's 1-wire bus
#
# CONFIG_W1 is not set

#
# Misc devices
#

#
# Multimedia devices
#
# CONFIG_VIDEO_DEV is not set

#
# Digital Video Broadcasting Devices
#

#
# Graphics support
#
# CONFIG_FB is not set
# CONFIG_FB_68328 is not set

#
# Sound
#
# CONFIG_SOUND is not set

#
# USB support
#

#
# USB Gadget Support
#
# CONFIG_USB_GADGET is not set

#
# File systems
#
CONFIG_EXT2_FS=y
# CONFIG_EXT2_FS_XATTR is not set
# CONFIG_EXT3_FS is not set
# CONFIG_JBD is not set
# CONFIG_REISERFS_FS is not set
# CONFIG_JFS_FS is not set
# CONFIG_XFS_FS is not set
# CONFIG_MINIX_FS is not set
CONFIG_ROMFS_FS=y
CONFIG_MAGIC_ROM_PTR=y
# CONFIG_QUOTA is not set
# CONFIG_AUTOFS_FS is not set
# CONFIG_AUTOFS4_FS is not set

#
# CD-ROM/DVD Filesystems
#
# CONFIG_ISO9660_FS is not set
# CONFIG_UDF_FS is not set

#
# DOS/FAT/NT Filesystems
#
# CONFIG_MSDOS_FS is not set
# CONFIG_VFAT_FS is not set
# CONFIG_NTFS_FS is not set

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
CONFIG_PROC_KCORE=y
CONFIG_SYSFS=y
# CONFIG_DEVFS_FS is not set
# CONFIG_TMPFS is not set
# CONFIG_HUGETLB_PAGE is not set
CONFIG_RAMFS=y

#
# Miscellaneous filesystems
#
# CONFIG_ADFS_FS is not set
# CONFIG_AFFS_FS is not set
# CONFIG_HFS_FS is not set
# CONFIG_HFSPLUS_FS is not set
# CONFIG_BEFS_FS is not set
# CONFIG_BFS_FS is not set
# CONFIG_EFS_FS is not set
# CONFIG_JFFS_FS is not set
# CONFIG_JFFS2_FS is not set
# CONFIG_CRAMFS is not set
# CONFIG_VXFS_FS is not set
# CONFIG_HPFS_FS is not set
# CONFIG_QNX4FS_FS is not set
# CONFIG_SYSV_FS is not set
# CONFIG_UFS_FS is not set

#
# Partition Types
#
# CONFIG_PARTITION_ADVANCED is not set
CONFIG_MSDOS_PARTITION=y

#
# Native Language Support
#
# CONFIG_NLS is not set

#
# Kernel hacking
#
# CONFIG_DEBUG_KERNEL is not set
# CONFIG_FRAME_POINTER is not set
CONFIG_FULLDEBUG=y
# CONFIG_BOOTPARAM is not set
CONFIG_NO_KERNEL_MSG=y

#
# Security options
#
# CONFIG_SECURITY is not set

#
# Cryptographic options
#
# CONFIG_CRYPTO is not set

#
# Library routines
#
# CONFIG_CRC_CCITT is not set
# CONFIG_CRC32 is not set
# CONFIG_LIBCRC32C is not set
