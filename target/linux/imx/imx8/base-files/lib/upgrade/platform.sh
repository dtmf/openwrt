#
REQUIRE_IMAGE_METADATA=1

platform_copy_config() {
	emmc_copy_config
}

platform_check_image() {
	return 0
}

platform_do_upgrade() {
	CI_KERNPART="0:HLOS"
	CI_ROOTPART="rootfs"
	CI_DATAPART="rootfs_data"
	emmc_do_upgrade "$1"
}
