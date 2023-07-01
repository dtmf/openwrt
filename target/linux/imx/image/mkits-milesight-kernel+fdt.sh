#!/bin/sh

KERNEL=$1

MODELS="65 67 65-661 67-661"

cat <<EOF1
/dts-v1/;

/ {
	description = "U-Boot fitImage";
	#address-cells = <1>;

	images {
		kernel@0 {
			description = "Linux Kernel";
			data = /incbin/("$KERNEL");
			type = "kernel";
			arch = "arm64";
			os = "linux";
			compression = "gzip";
			load = <0x40480000>;
			entry = <0x40480000>;
			hash@1 {
				algo = "sha1";
			};
		};
EOF1

NUM=0
for MODEL in $MODELS
do
	cat <<EOF2
		fdt@$NUM {
			description = "Flattened Device Tree blob Milesight_UG$MODEL";
			data = /incbin/("milesight-ug$MODEL.dtb");
			type = "flat_dt";
			arch = "arm64";
			compression = "none";
			hash@1 {
				algo = "crc32";
			};
			hash@2 {
				algo = "sha1";
			};
		};
EOF2
	NUM=`expr $NUM + 1`
done

cat <<EOF3
	};
	configurations {
EOF3

NUM=0
for MODEL in $MODELS
do
	cat <<EOF4
		config@imx8mn-ug$MODEL {
			description = "Boot Linux kernel with FDT blob";
			kernel = "kernel@0";
			fdt = "fdt@$NUM";
			hash@1 {
				algo = "sha1";
			};
		};
EOF4
	NUM=`expr $NUM + 1`
done
	
cat <<EOF5
	};
};
EOF5
