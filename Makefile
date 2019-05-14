CWD = $(CURDIR)
GZ  = $(CWD)/gz

default: gz

dirs:
	mkdir -p $(GZ)
	
BUILDROOT_VER = 2019.05-rc1

WGET = wget -c -P $(GZ)
	
gz: $(GZ)/$(BUILDROOT_VER).tar.gz

$(GZ)/$(BUILDROOT_VER).tar.gz:
	$(WGET) https://github.com/buildroot/buildroot/archive/$(BUILDROOT_VER).tar.gz
