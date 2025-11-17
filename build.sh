#!/bin/bash

echo "build target start ..."

RELEASE_FILE="release.txt"
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

    IFS='/' read -r arch soc device <<< "${line}"

    if [ -n "${arch}" ] && [ -n "${soc}" ] && [ -n "${device}" ]; then
        
        cd openwrt

        echo "" > .config
        wget https://downloads.openwrt.org/releases/${VERSION#v}/targets/${arch}/${soc}/config.buildinfo -O .config

        sed -i "/^[[:space:]]*CONFIG_TARGET_MULTI_PROFILE=/d" .config
        sed -i "/^[[:space:]]*CONFIG_TARGET_DEVICE_/d" .config
        sed -i "/^[[:space:]]*CONFIG_DEVEL=/d" .config
        sed -i "/^[[:space:]]*CONFIG_TARGET_PER_DEVICE_ROOTFS=/d" .config
        sed -i "/^[[:space:]]*CONFIG_AUTOREMOVE=/d" .config
        sed -i "/^[[:space:]]*CONFIG_IB=/d" .config
        sed -i "/^[[:space:]]*CONFIG_MAKE_TOOLCHAIN=/d" .config
        sed -i "/^[[:space:]]*CONFIG_SDK=/d" .config
        sed -i "/^[[:space:]]*CONFIG_SDK_LLVM_BPF=/d" .config
        sed -i "/^[[:space:]]*CONFIG_TARGET_ALL_PROFILES=/d" .config

        sed -i "s|downloads.openwrt.org|mirrors.aliyun.com/openwrt|g" .config
        echo "- 设置 opkg 源为 阿里云 `https://mirrors.aliyun.com/openwrt`" >> "${RELEASE_FILE}"

        echo "CONFIG_TARGET_${arch}_${soc}_DEVICE_${device}=y" >> .config
        echo "CONFIG_LUCI_LANG_zh_Hans=y" >> .config
        echo "CONFIG_PACKAGE_luci-i18n-base-zh-cn=y" >> .config
        echo "CONFIG_PACKAGE_luci-i18n-firewall-zh-cn=y" >> .config
        echo "CONFIG_PACKAGE_luci-i18n-package-manager-zh-cn=y" >> .config

        echo "- 内置简体中文语言包 `luci-i18n-base-zh-cn`" >> "${RELEASE_FILE}"

        cat .config

        #make defconfig

        #echo "download depend..."
        #make download -j$(nproc) V=s
        
        #echo "make..."
        #make -j$(nproc) V=s

		cp -f openwrt/bin/targets/${arch}/${soc}/*-squashfs-sysupgrade.bin bin
		cd ..

    else
        echo "WARN: line '${line}' is invalid, skip"
    fi

done < "${INPUT_FILE}"

echo "build targets done."
tree -L 3 openwrt/bin/targets
ls -l bin