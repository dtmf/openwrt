define Build/imx8-compile-dtb
	$(call Image/BuildDTB,$(DEVICE_DTS_DIR)/$(1).dts,$(KDIR)/tmp/$(1).dtb,-I$(DTS_DIR)/freescale)
endef

# This is defined in $TOPDIR/include/image.mk, but redefined here to remove the '-nopad' option
define Image/mkfs/squashfs-common
	$(STAGING_DIR_HOST)/bin/mksquashfs4 $(call mkfs_target_dir,$(1)) $@ \
		-noappend -root-owned \
		-comp $(SQUASHFSCOMP) $(SQUASHFSOPT)
endef

define Build/sysupgrade-tar
	sh $(TOPDIR)/scripts/sysupgrade-tar.sh \
		--board $(DEVICE_NAME) \
		--kernel $(BIN_DIR)/$(DEVICE_IMG_PREFIX)-squashfs-kernel+fdt.itb \
		--rootfs $(call param_get_default,rootfs,$(1),$(IMAGE_ROOTFS)) \
		$@
endef

define Build/milesight-fit-kernel+fdt
	./mkits-milesight-kernel+fdt.sh $@ > $@.its
	PATH=$(LINUX_DIR)/scripts/dtc:$(PATH) mkimage -f $@.its $@.new
	@mv -f $@.new $@
endef

define Build/milesight-fit-uImage
	./mkits-milesight-uImage.sh $(KDIR) > $@.its
	PATH=$(LINUX_DIR)/scripts/dtc:$(PATH) mkimage -f $@.its $@.new
	@mv -f $@.new $@
endef

define Device/milesight_ug6x
	DEVICE_VENDOR := Milesight
	DEVICE_MODEL := UG65/UG67 family
	SUPPORTED_DEVICES := \
		milesight,ug65 \
		milesight,ug67 \
		milesight,ug65-661 \
		milesight,ug67-661
	KERNEL_LOADADDR := 0x40480000
	FILESYSTEMS := squashfs
	IMAGE/sysupgrade.bin := sysupgrade-tar | append-metadata
	KERNEL = kernel-bin
	DEVICE_PACKAGES += \
		wireless-regdb \
		firmware-imx
	DEVICE_DESCRIPTION = \
		Build images for Milesight UG65 and UG67. This generates a single image \
		capable of booting on any of the boards in this family.
	DEVICE_DTS_DIR := ../dts
	IMAGES = kernel+fdt.itb uImage.itb sysupgrade.bin
	IMAGE/kernel+fdt.itb := \
		imx8-compile-dtb milesight-ug65 | \
		imx8-compile-dtb milesight-ug67 | \
		imx8-compile-dtb milesight-ug65-661 | \
		imx8-compile-dtb milesight-ug67-661 | \
		kernel-bin | \
		gzip | \
		milesight-fit-kernel+fdt
	IMAGE/uImage.itb = milesight-fit-uImage
endef
TARGET_DEVICES += milesight_ug6x
