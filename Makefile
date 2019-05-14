HW  ?= i686
APP ?= hello

BUILDROOT_VER = 2019.05-rc1
BUILDROOT = buildroot-$(BUILDROOT_VER)

CWD   = $(CURDIR)
GZ    = $(CWD)/gz
TMP   = $(CWD)/tmp
SRC   = $(TMP)/src
BR    = $(CWD)/$(BUILDROOT)
CROSS = $(CWD)/cross

default: buildroot
#dirs gz 

dirs:
	mkdir -p $(GZ) $(TMP) $(SRC) $(BR) $(CROSS)

WGET = wget -c -P $(GZ)
	
gz: $(GZ)/$(BUILDROOT_VER).tar.gz

buildroot: $(BR)/README $(TMP)/.config
	cd $(BR) ; make menuconfig O=$(TMP)
#	make defconfig BUSYBOX_CONFIG_FILE=qemu.defconfig  &&\
#	
#	list-defconfigs
#	menuconfig
$(BR)/README: $(GZ)/$(BUILDROOT_VER).tar.gz
	tar zx < $< && touch $@ 
$(GZ)/$(BUILDROOT_VER).tar.gz:
	$(WGET) https://github.com/buildroot/buildroot/archive/$(BUILDROOT_VER).tar.gz

$(TMP)/.config: qemu.defconfig
	cat $^ > $@
	echo BR2_DL_DIR=\"$(GZ)\" >> $@
	echo BR2_HOST_DIR=\"$(CROSS)\" >> $@
	echo BR2_CCACHE_DIR=\"$(TMP)/ccache\" >> $@
	echo BR2_UCLIBC_CONFIG_FRAGMENT_FILES=\"$(CWD)/ulibc.config\" >> $@
	echo BR2_TARGET_GENERIC_HOSTNAME=\"$(APP)_$(HW)\" >> $@
	echo BR2_TARGET_GENERIC_ISSUE=\"kvx build: $(shell date +%d%m%y)\" >> $@
	