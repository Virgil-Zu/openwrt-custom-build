#!/bin/bash
set -e

RELEASE_FILE="release.txt"

echo "" > "${RELEASE_FILE}"

####################
#*** set timezone
sed -i "s|timezone='UTC'|timezone='Asia/Shanghai'|" openwrt/package/base-files/files/bin/config_generate
sed -i "s|log_size='128'|log_size='64'|" openwrt/package/base-files/files/bin/config_generate

echo "- 设置时区为Asia/Shanghai \`timezone=Asia/Shanghai\`" >> "${RELEASE_FILE}"
echo "- 设置日志大小64 \`log_size='64'\`" >> "${RELEASE_FILE}"
echo "- 设置 opkg 源为 阿里云 \`https://mirrors.aliyun.com/openwrt\`" >> "${RELEASE_FILE}"
echo "- 内置简体中文语言包 \`luci-i18n-base-zh-cn\`" >> "${RELEASE_FILE}"

#*** copy kernel MD5
#sed -i 's#$(LINUX_DIR)/.vermagic#$(LINUX_DIR)/.vermagic\n	cp $(TOPDIR)/.vermagic $(LINUX_DIR)/.vermagic#' openwrt/include/kernel-defaults.mk
#cat openwrt/include/kernel-defaults.mk
sed -i 's#$(SCRIPT_DIR)/kconfig.pl $(LINUX_DIR)/.config | $(MKHASH) md5#cat $(TOPDIR)/.vermagic#' openwrt/package/kernel/linux/Makefile
#cat openwrt/package/kernel/linux/Makefile

####################
#*** create new device model
target_dts='openwrt/target/linux/ath79/dts/ar9331_tplink_tl-wr703n-16m.dts'
cp -f openwrt/target/linux/ath79/dts/ar9331_tplink_tl-wr703n.dts "${target_dts}"
sed -i 's|compatible = "tplink,tl-wr703n"|compatible = "tplink,tl-wr703n-16m", "tplink,tl-wr703n"|' "${target_dts}"
sed -i 's|model = "TP-Link TL-WR703N"|model = "TP-Link TL-WR703N (16M)"|' "${target_dts}"
cat <<EOF >> "${target_dts}"
&spi {
	flash@0 {
        partitions {
			partition@20000 {
				label = "firmware";
				reg = <0x20000 0xfd0000>;
			};
			partition@ff0000 {
				label = "art";
				reg = <0xff0000 0x100000>;
				read-only;
			};
		};
	};
};
EOF
#cat "${target_dts}"
#https://github.com/openwrt/openwrt/blob/v17.01.7/target/linux/ar71xx/image/tp-link.mk
cat <<EOF >> openwrt/target/linux/ath79/image/generic.mk
define Device/tplink_tl-wr703n-16m
  \$(Device/tplink-4mlzma)
  IMAGE_SIZE := 16256k
  DEVICE_VENDOR := TP-Link
  DEVICE_MODEL := TL-WR703N
  DEVICE_VARIANT := v1.6 16M
  DEVICE_PACKAGES += kmod-usb-core kmod-usb2 kmod-usb-ohci kmod-ath9k wpad-basic-mbedtls
  TPLINK_HWID := 0x07030101
  DEVICE_DTS := ar9331_tplink_tl-wr703n-16m
  CONSOLE := ttyATH0,115200
endef
TARGET_DEVICES += tplink_tl-wr703n-16m
EOF
cat openwrt/target/linux/ath79/image/generic.mk
echo "- 添加设备 \`ath79/generic/ar9331_tplink_tl-wr703n-16m\`" >> "${RELEASE_FILE}"


target_dts='openwrt/target/linux/ramips/dts/mt7621_phicomm_k2p-32m.dts'
cp -f openwrt/target/linux/ramips/dts/mt7621_phicomm_k2p.dts "${target_dts}"
sed -i 's|compatible = "phicomm,k2p"|compatible = "phicomm,k2p-32m", "phicomm,k2p"|' "${target_dts}"
sed -i 's|model = "Phicomm K2P"|model = "Phicomm K2P (32M)"|' "${target_dts}"
sed -i 's|reg = <0xa0000 0xf60000>|reg = <0xa0000 0x1f60000>|' "${target_dts}"
#cat "${target_dts}"
#sed -i 's|TARGET_DEVICES += phicomm_k2p|TARGET_DEVICES += phicomm_k2p\n\ndefine Device/phicomm_k2p-32m\n  $(Device/phicomm_k2p)\n  IMAGE_SIZE := 32128k\n  DEVICE_VARIANT := 32M\n  SUPPORTED_DEVICES += k2p-32m\nendef\nTARGET_DEVICES += phicomm_k2p-32m|' openwrt/target/linux/ramips/image/mt7621.mk
cat <<EOF >> openwrt/target/linux/ramips/image/mt7621.mk
define Device/phicomm_k2p-32m
  \$(Device/phicomm_k2p)
  IMAGE_SIZE := 32128k
  DEVICE_VARIANT := A1 32M
  SUPPORTED_DEVICES += k2p-32m
endef
TARGET_DEVICES += phicomm_k2p-32m
EOF
cat openwrt/target/linux/ramips/image/mt7621.mk
echo "- 添加设备 \`ramips/mt7621/phicomm_k2p-32m\`" >> "${RELEASE_FILE}"


target_dts='openwrt/target/linux/ramips/dts/mt7620a_phicomm_k2-v22.5-16m.dts'
cp -f openwrt/target/linux/ramips/dts/mt7620a_phicomm_k2-v22.5.dts "${target_dts}"
sed -i 's|compatible = "phicomm,k2-v22.5"|compatible = "phicomm,k2-v22.5-16m", "phicomm,k2-v22.5"|' "${target_dts}"
sed -i 's|model = "Phicomm K2 v22.5 or newer"|model = "Phicomm K2 v22.5 or newer (16M)"|' "${target_dts}"
sed -i 's|reg = <0xa0000 0x760000>|reg = <0xa0000 0xf60000>|' "${target_dts}"
#cat "${target_dts}"
#sed -i 's|TARGET_DEVICES += phicomm_k2-v22.5|TARGET_DEVICES += phicomm_k2-v22.5\n\ndefine Device/phicomm_k2-v22.5-16m\n  $(Device/phicomm_k2-v22.5)\n  IMAGE_SIZE := 15744k\n  DEVICE_VARIANT += 16M\n  SUPPORTED_DEVICES += k2-v22.5-16m\nendef\nTARGET_DEVICES += phicomm_k2-v22.5-16m|' openwrt/target/linux/ramips/image/mt7620.mk
cat <<EOF >> openwrt/target/linux/ramips/image/mt7620.mk
define Device/phicomm_k2-v22.5-16m
  \$(Device/phicomm_k2-v22.5)
  IMAGE_SIZE := 15744k
  DEVICE_VARIANT := A2 16M
  SUPPORTED_DEVICES += k2-v22.5-16m
endef
TARGET_DEVICES += phicomm_k2-v22.5-16m
EOF
cat openwrt/target/linux/ramips/image/mt7620.mk
echo "- 添加设备 \`ramips/mt7620a/phicomm_k2-v22.5-16m\`" >> "${RELEASE_FILE}"

#touch openwrt/target/linux/ramips/Makefile

####################
#*** patch openwrt v24.10.4
cp -f patches/*.patch openwrt/feeds/telephony/libs/dahdi-linux/patches/


