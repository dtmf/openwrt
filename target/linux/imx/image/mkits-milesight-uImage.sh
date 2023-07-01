#!/bin/sh

KDIR=$1

# GUID partition table. Copied to the MMC when firmware installed from U-Boot.
GPT=milesight-gpt.dat
zcat $GPT.gz > $KDIR/$GPT

cat <<EOF1
/dts-v1/;

/ {
        description = "Milesight uImage";
        #address-cells = <1>;

        images {
		gpt-yeastar {
                        description = "gpt-yeastar";
                        data = /incbin/("$KDIR/milesight-gpt.dat");
                        compression = "none";
                };
                hlos-yeastar {
                        description = "hlos-yeastar";
                        data = /incbin/("$KDIR/tmp/openwrt-imx-imx8-milesight_ug6x-squashfs-kernel+fdt.itb");
                        compression = "none";
                        hash {
                                algo = "sha1";
                        };
                };
                rootfs-yeastar {
                        description = "rootfs-yeastar";
                        data = /incbin/("$KDIR/root.squashfs");
                        compression = "none";
                };
        };

        configurations {
                default = "standard";
                standard {
                        description = "Standard Boot";
			gpt-yeastar = "gpt-yeastar";
                        hlos-yeastar = "hlos-yeastar";
                        rootfs-yeastar = "rootfs-yeastar";
                        hash {
                                algo = "sha1";
                        };
                };
        };

}; 
EOF1
