#!/bin/bash
set -e

RELEASE_FILE="release.txt"

## patch openwrt
cp -f patches/*.patch openwrt/feeds/telephony/libs/dahdi-linux/patches/

echo "" > "${RELEASE_FILE}"

# set timezone
sed -i "s|timezone='UTC'|timezone='Asia/Shanghai'|" openwrt/package/base-files/files/bin/config_generate
sed -i "s|log_size='128'|log_size='64'|" openwrt/package/base-files/files/bin/config_generate

echo "- 设置时区为Asia/Shanghai \`timezone=Asia/Shanghai\`" >> "${RELEASE_FILE}"
echo "- 设置日志大小64 \`log_size='64'\`" >> "${RELEASE_FILE}"
echo "- 设置 opkg 源为 阿里云 \`https://mirrors.aliyun.com/openwrt\`" >> "${RELEASE_FILE}"
echo "- 内置简体中文语言包 \`luci-i18n-base-zh-cn\`" >> "${RELEASE_FILE}"

## create new device model
# phicomm_k2p-32m
cp -f openwrt/target/linux/ramips/dts/mt7621_phicomm_k2p.dts openwrt/target/linux/ramips/dts/mt7621_phicomm_k2p-32m.dts
sed -i 's|compatible = "phicomm,k2p"|compatible = "phicomm,k2p-32m", "phicomm,k2p"|' openwrt/target/linux/ramips/dts/mt7621_phicomm_k2p-32m.dts
sed -i 's|model = "Phicomm K2P"|model = "Phicomm K2P (32M)"|' openwrt/target/linux/ramips/dts/mt7621_phicomm_k2p-32m.dts
sed -i 's|reg = <0xa0000 0xf60000>|reg = <0xa0000 0x1f60000>|' openwrt/target/linux/ramips/dts/mt7621_phicomm_k2p-32m.dts
#cat openwrt/target/linux/ramips/dts/mt7621_phicomm_k2p-32m.dts

sed -i 's|TARGET_DEVICES += phicomm_k2p|TARGET_DEVICES += phicomm_k2p\n\ndefine Device/phicomm_k2p-32m\n  $(Device/phicomm_k2p)\n  IMAGE_SIZE := 32128k\n  DEVICE_VARIANT := 32M\n  SUPPORTED_DEVICES += k2p-32m\nendef\nTARGET_DEVICES += phicomm_k2p-32m|' openwrt/target/linux/ramips/image/mt7621.mk
#cat openwrt/target/linux/ramips/image/mt7621.mk

echo "- 添加设备 \`ramips/mt7621/phicomm_k2p-32m\`" >> "${RELEASE_FILE}"

# phicomm_k2-v22.5-16m
cp -f openwrt/target/linux/ramips/dts/mt7620a_phicomm_k2-v22.5.dts openwrt/target/linux/ramips/dts/mt7620a_phicomm_k2-v22.5-16m.dts
sed -i 's|compatible = "phicomm,k2-v22.5"|compatible = "phicomm,k2-v22.5-16m"|' openwrt/target/linux/ramips/dts/mt7620a_phicomm_k2-v22.5-16m.dts
sed -i 's|model = "Phicomm K2 v22.5 or newer"|model = "Phicomm K2 v22.5 or newer (16M)"|' openwrt/target/linux/ramips/dts/mt7620a_phicomm_k2-v22.5-16m.dts
sed -i 's|reg = <0xa0000 0x760000>|reg = <0xa0000 0xf60000>|g' openwrt/target/linux/ramips/dts/mt7620a_phicomm_k2-v22.5-16m.dts
#cat openwrt/target/linux/ramips/dts/mt7620a_phicomm_k2-v22.5-16m.dts

sed -i 's|TARGET_DEVICES += phicomm_k2-v22.5|TARGET_DEVICES += phicomm_k2-v22.5\n\ndefine Device/phicomm_k2-v22.5-16m\n  $(Device/phicomm_k2-v22.5)\n  IMAGE_SIZE := 15744k\n  DEVICE_VARIANT += 16M\n  SUPPORTED_DEVICES += k2-v22.5-16m\nendef\nTARGET_DEVICES += phicomm_k2-v22.5-16m|' openwrt/target/linux/ramips/image/mt7620.mk
#cat openwrt/target/linux/ramips/image/mt7620.mk

echo "- 添加设备 \`ramips/mt7620a/phicomm_k2-v22.5-16m\`" >> "${RELEASE_FILE}"

#touch openwrt/target/linux/ramips/Makefile

#copy kernel MD5
#sed -i 's#$(LINUX_DIR)/.vermagic#$(LINUX_DIR)/.vermagic\n	cp $(TOPDIR)/.vermagic $(LINUX_DIR)/.vermagic#' openwrt/include/kernel-defaults.mk
#cat openwrt/include/kernel-defaults.mk

sed -i 's#$(SCRIPT_DIR)/kconfig.pl $(LINUX_DIR)/.config | $(MKHASH) md5#cat $(TOPDIR)/.vermagic#' openwrt/package/kernel/linux/Makefile
#cat openwrt/package/kernel/linux/Makefile
