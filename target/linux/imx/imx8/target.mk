ARCH:=aarch64
BOARDNAME:=NXP i.MX8 boards
KERNELNAME:=Image
SUBTARGET:=imx8
FEATURES:=gpio rtc usb squashfs dt emmc nand boot-part rootfs-part testing-kernel
CONFIG_TARGET=subtarget

KERNEL_PATCHVER:=5.15
KERNEL_TESTING_PATCHVER:=6.1

define Target/Description
	Build firmware images for NXP i.MX8 boards.
endef

DEFAULT_PACKAGES += kmod-leds-gpio kmod-gpio-button-hotplug
