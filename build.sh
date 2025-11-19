#!/bin/bash
set -e
echo "build target start ..."

INPUT_FILE="targets.txt"
VERSION=$(cat version.txt)

if [ ! -f "${INPUT_FILE}" ]; then
	echo "error: dir [${INPUT_FILE}] not exist"
	exit 1
fi
ls -l
echo "loop build targets ..."

while IFS= read -r line; do
	if [[ "${line}" =~ ^[[:space:]]*# ]]; then
		continue
	fi

	if [ -z "$line" ]; then
		continue
	fi

	echo "build '${line}' ..."

	IFS='/' read -r arch soc device <<< "${line}"

	if [ -n "${arch}" ] && [ -n "${soc}" ] && [ -n "${device}" ]; then
		
		cd openwrt

		echo "" > .config
		wget "https://downloads.openwrt.org/releases/${VERSION#v}/targets/${arch}/${soc}/config.buildinfo" -O .config

		sed -i "/^[[:space:]]*CONFIG_TARGET_DEVICE_/d" .config
		sed -i "s/^[[:space:]]*CONFIG_TARGET_MULTI_PROFILE=y/# CONFIG_TARGET_MULTI_PROFILE is not set/g" .config
		sed -i "s/^[[:space:]]*CONFIG_DEVEL=y/# CONFIG_DEVEL is not set/g" .config
		sed -i "s/^[[:space:]]*CONFIG_TARGET_PER_DEVICE_ROOTFS=y/# CONFIG_TARGET_PER_DEVICE_ROOTFS is not set/g" .config
		sed -i "s/^[[:space:]]*CONFIG_AUTOREMOVE=y/# CONFIG_AUTOREMOVE is not set/g" .config
		sed -i "s/^[[:space:]]*CONFIG_IB=y/# CONFIG_IB is not set/g" .config
		sed -i "s/^[[:space:]]*CONFIG_MAKE_TOOLCHAIN=y/# CONFIG_MAKE_TOOLCHAIN is not set/g" .config
		sed -i "s/^[[:space:]]*CONFIG_SDK=y/# CONFIG_SDK is not set/g" .config
		sed -i "s/^[[:space:]]*CONFIG_SDK_LLVM_BPF=y/# CONFIG_SDK_LLVM_BPF is not set/g" .config
		sed -i "s/^[[:space:]]*CONFIG_TARGET_ALL_PROFILES=y/# CONFIG_TARGET_ALL_PROFILES is not set/g" .config
		sed -i "s/^[[:space:]]*CONFIG_COLLECT_KERNEL_DEBUG=y/# CONFIG_COLLECT_KERNEL_DEBUG is not set/g" .config

		sed -i "s|downloads.openwrt.org|mirrors.aliyun.com/openwrt|g" .config

		echo "# CONFIG_KERNEL_DEBUG_INFO is not set" >> .config
		echo "# CONFIG_KERNEL_DEBUG_INFO_REDUCED is not set" >> .config
		echo "# CONFIG_KERNEL_DEBUG_KERNEL is not set" >> .config
		echo "# CONFIG_KERNEL_DEBUG_FS is not set" >> .config
		echo "# CONFIG_TARGET_ROOTFS_INITRAMFS is not set" >> .config
		echo "CONFIG_TARGET_${arch}_${soc}_DEVICE_${device}=y" >> .config
		echo "CONFIG_LUCI_LANG_zh_Hans=y" >> .config
		echo "CONFIG_PACKAGE_luci-i18n-base-zh-cn=y" >> .config
		echo "CONFIG_PACKAGE_luci-i18n-firewall-zh-cn=y" >> .config
		echo "CONFIG_PACKAGE_luci-i18n-package-manager-zh-cn=y" >> .config

		manifest=$(wget -q -O - "https://downloads.openwrt.org/releases/${VERSION#v}/targets/${arch}/${soc}/openwrt-${VERSION#v}-${arch}-${soc}.manifest")
		if [ -z "$manifest" ]; then
			echo "wget manifest error"
			exit 1
		fi

		kernel=$(echo "$manifest" | grep "^kernel - ")
		if [ -z "$kernel" ]; then
			echo "can not find 'kernel' line"
			exit 1
		fi

		#md5_value=$(echo "$kernel" | sed -n 's/.*~\([0-9a-fA-F]*\)-.*/\1/p')
		md5_value=$(echo "$kernel" | sed -n 's/.*~\(\w*\)-.*/\1/p')
		if [ -z "$md5_value" ]; then
			echo "fetch 'md5' failed"
			exit 1
		fi
		echo "kernel MD5:${md5_value}"
		echo $md5_value > .vermagic

		echo "config..."
		make defconfig
		#cat .config

		echo "download depend..."
		make download -j$(nproc)

		echo "make..."
		make -j$(nproc)

		cd ..

		df -h
		tree -L 3 openwrt/bin/targets
		cp -f openwrt/bin/targets/${arch}/${soc}/*-squashfs-sysupgrade.bin bin

	else
		echo "WARN: line '${line}' is invalid, skip"
	fi

done < "${INPUT_FILE}"

echo "build targets done."
