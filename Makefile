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
ROOT  = $(CWD)/root

default: dirs gz buildroot

dirs:
	mkdir -p $(GZ) $(TMP) $(SRC) $(BR) $(CROSS)

WGET = wget -c -P $(GZ)
	
gz: $(GZ)/$(BUILDROOT_VER).tar.gz

buildroot: $(BR)/README $(TMP)/.config $(ROOT)/etc/about
	cd $(BR) ; make menuconfig O=$(TMP)
	cd $(TMP) ; make
$(BR)/README: $(GZ)/$(BUILDROOT_VER).tar.gz
	tar zx < $< && touch $@ 
$(GZ)/$(BUILDROOT_VER).tar.gz:
	$(WGET) https://github.com/buildroot/buildroot/archive/$(BUILDROOT_VER).tar.gz
	
$(ROOT)/etc/about: README.md
	cp $< $@

$(TMP)/.config: qemu.defconfig
	cat $^ > $@
	echo BR2_DL_DIR=\"$(GZ)\" >> $@
	echo BR2_HOST_DIR=\"$(CROSS)\" >> $@
	echo BR2_CCACHE_DIR=\"$(TMP)/ccache\" >> $@
	echo BR2_UCLIBC_CONFIG_FRAGMENT_FILES=\"$(CWD)/ulibc.config\" >> $@
	echo BR2_TARGET_GENERIC_HOSTNAME=\"$(APP)_$(HW)\" >> $@
	echo BR2_TARGET_GENERIC_ISSUE=\"kvx build: $(shell date +%d%m%y)\" >> $@
	echo BR2_ROOTFS_OVERLAY=\"$(ROOT)\" >> $@
	echo BR2_LINUX_KERNEL_CUSTOM_CONFIG_FILE=\"$(CWD)/kernel.config\" >> $@
	

