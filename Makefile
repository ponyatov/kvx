BUILDROOT_VER = 2019.05-rc1
BUILDROOT = buildroot-$(BUILDROOT_VER)

CWD = $(CURDIR)
GZ  = $(CWD)/gz
TMP = $(CWD)/tmp
SRC = $(TMP)/src
BR  = $(CWD)/$(BUILDROOT)

default: buildroot
#dirs gz 

dirs:
	mkdir -p $(GZ) $(TMP) $(SRC) $(BR)

WGET = wget -c -P $(GZ)
	
gz: $(GZ)/$(BUILDROOT_VER).tar.gz

buildroot: $(BR)/README
	cd $(BR) ; make menuconfig
$(BR)/README: $(GZ)/$(BUILDROOT_VER).tar.gz
	tar zx < $< && touch $@ 
$(GZ)/$(BUILDROOT_VER).tar.gz:
	$(WGET) https://github.com/buildroot/buildroot/archive/$(BUILDROOT_VER).tar.gz
