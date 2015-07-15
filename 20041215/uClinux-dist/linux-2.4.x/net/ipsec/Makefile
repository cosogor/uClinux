ifeq ($(CONFIG_IPSEC),)
fastdep:
else
.EXPORT_ALL_VARIABLES:

ifdef CONFIG_IXP4XX_CRYPTO	
EXTRA_CFLAGS += -I$(ROOTDIR)/freeswan/klips/net/ipsec_xscale
endif
EXTRA_CFLAGS += -I$(ROOTDIR)/freeswan -I$(ROOTDIR)/freeswan/lib \
			-I$(ROOTDIR)/freeswan/klips/net/ipsec \
			-I$(ROOTDIR)/freeswan/libdes

ifdef CONFIG_IXP4XX_CRYPTO
vpath %.h $(ROOTDIR)/freeswan/klips/net/ipsec_xscale:$(ROOTDIR)/freeswan/klips/net/ipsec
else
vpath %.h $(ROOTDIR)/freeswan/klips/net/ipsec
endif

ifdef CONFIG_IXP4XX_CRYPTO
%.c: $(ROOTDIR)/freeswan/klips/net/ipsec_xscale/%.c
	ln -fs $< $@
endif

# special hack required because of exported object files
%.c: $(ROOTDIR)/freeswan/klips/net/ipsec/%.c
	ln -fs $< $@

include $(ROOTDIR)/freeswan/klips/net/ipsec/Makefile
endif
