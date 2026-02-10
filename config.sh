#!/bin/bash
set -e

RELEASE_FILE="release.txt"

echo "" > "${RELEASE_FILE}"

####################
#*** set timezone
sed -i "s|timezone='UTC'|zonename='Asia/Shanghai'|" openwrt/package/base-files/files/bin/config_generate
sed -i "s|zonename='UTC'|zonename='Asia/Shanghai'|" openwrt/package/base-files/files/bin/config_generate
sed -i "s|timezone='GMT0'|timezone='CST-8'|" openwrt/package/base-files/files/bin/config_generate
sed -i "s|log_size='128'|log_size='64'|" openwrt/package/base-files/files/bin/config_generate

echo "- 设置时区为Asia/Shanghai \`zonename=Asia/Shanghai\`" >> "${RELEASE_FILE}"
echo "- 设置日志大小64 \`log_size='64'\`" >> "${RELEASE_FILE}"
echo "- 设置 opkg 源为 阿里云 \`https://mirrors.aliyun.com/openwrt\`" >> "${RELEASE_FILE}"
echo "- 内置简体中文语言包 \`luci-i18n-base-zh-cn\`" >> "${RELEASE_FILE}"

#*** copy kernel MD5
sed -i 's#$(LINUX_DIR)/.vermagic#$(LINUX_DIR)/.vermagic\n	cp $(TOPDIR)/.vermagic $(LINUX_DIR)/.vermagic#' openwrt/include/kernel-defaults.mk
sed -i 's#$(SCRIPT_DIR)/kconfig.pl $(LINUX_DIR)/.config | $(MKHASH) md5#cat $(TOPDIR)/.vermagic#' openwrt/package/kernel/linux/Makefile

####################
#*** create new device model

target_dts='openwrt/target/linux/ath79/dts/ar9331_tplink_tl-wr703n-v1.6-16m.dts'
cp -f openwrt/target/linux/ath79/dts/ar9331_tplink_tl-wr703n_tl-mr10u.dtsi openwrt/target/linux/ath79/dts/ar9331_tplink_tl-wr703n-16m.dtsi
sed -i 's|reg = <0x20000 0x3d0000>|reg = <0x20000 0xfd0000>|' openwrt/target/linux/ath79/dts/ar9331_tplink_tl-wr703n-16m.dtsi
sed -i 's|partition@3f0000|partition@ff0000|' openwrt/target/linux/ath79/dts/ar9331_tplink_tl-wr703n-16m.dtsi
sed -i 's|reg = <0x3f0000 0x10000>|reg = <0xff0000 0x10000>|' openwrt/target/linux/ath79/dts/ar9331_tplink_tl-wr703n-16m.dtsi
cp -f openwrt/target/linux/ath79/dts/ar9331_tplink_tl-wr703n.dts "${target_dts}"
sed -i 's|wr703n_tl-mr10u.dtsi|wr703n-16m.dtsi"|' "${target_dts}"
sed -i 's|"tplink,tl-wr703n"|"tplink,tl-wr703n-v1.6-16m", "tplink,tl-wr703n"|' "${target_dts}"
sed -i 's|"TP-Link TL-WR703N"|"TP-Link TL-WR703N (16M)"|' "${target_dts}"
cat <<EOF >> openwrt/target/linux/ath79/image/tiny-tp-link.mk
define Device/tplink_tl-wr703n-v1.6-16m
  \$(Device/tplink-16mlzma)
  SOC := ar9331
  DEVICE_MODEL := TL-WR703N
  DEVICE_VARIANT := v1.6 (16M)
  DEVICE_PACKAGES := kmod-usb-core kmod-usb-ehci-platform kmod-usb-ohci-platform
  TPLINK_HWID := 0x07030101
  SUPPORTED_DEVICES += tl-wr703n-v1.6-16m
endef
TARGET_DEVICES += tplink_tl-wr703n-v1.6-16m
EOF
#cat openwrt/target/linux/ath79/image/tiny-tp-link.mk
echo "- 添加设备 \`ath79/tiny/tplink_tl-wr703n-v1.6-16m\`" >> "${RELEASE_FILE}"


target_dts='openwrt/target/linux/ramips/dts/mt7620a_phicomm_k2-A2-v22.4-16m.dts'
cp -f openwrt/target/linux/ramips/dts/mt7620a_phicomm_k2-v22.4.dts "${target_dts}"
sed -i 's|"phicomm,k2-v22.4"|"phicomm,k2-A2-v22.4-16m", "phicomm,k2-v22.4"|' "${target_dts}"
sed -i 's|"Phicomm K2 v22.4 or older"|"Phicomm K2 v22.4 or older (16M)"|' "${target_dts}"
sed -i 's|reg = <0x50000 0x7b0000>|reg = <0x50000 0xfb0000>|' "${target_dts}"
cat <<EOF >> openwrt/target/linux/ramips/image/mt7620.mk
define Device/phicomm_k2-A2-v22.4-16m
  \$(Device/phicomm_k2-v22.4)
  IMAGE_SIZE := 16064k
  DEVICE_VARIANT := A2 (16M)
  SUPPORTED_DEVICES += k2-A2-v22.4-16m
endef
TARGET_DEVICES += phicomm_k2-A2-v22.4-16m
EOF
echo "- 添加设备 \`ramips/mt7620a/phicomm_k2-A2-v22.4-16m\`" >> "${RELEASE_FILE}"


target_dts='openwrt/target/linux/ramips/dts/mt7620a_phicomm_k2-A2-v22.5-16m.dts'
cp -f openwrt/target/linux/ramips/dts/mt7620a_phicomm_k2-v22.5.dts "${target_dts}"
sed -i 's|"phicomm,k2-v22.5"|"phicomm,k2-A2-v22.5-16m", "phicomm,k2-v22.5"|' "${target_dts}"
sed -i 's|"Phicomm K2 v22.5 or newer"|"Phicomm K2 v22.5 or newer (16M)"|' "${target_dts}"
sed -i 's|reg = <0xa0000 0x760000>|reg = <0xa0000 0xf60000>|' "${target_dts}"
cat <<EOF >> openwrt/target/linux/ramips/image/mt7620.mk
define Device/phicomm_k2-A2-v22.5-16m
  \$(Device/phicomm_k2-v22.5)
  IMAGE_SIZE := 15744k
  DEVICE_VARIANT := A2 (16M)
  SUPPORTED_DEVICES += k2-A2-v22.5-16m
endef
TARGET_DEVICES += phicomm_k2-A2-v22.5-16m
EOF
echo "- 添加设备 \`ramips/mt7620a/phicomm_k2-A2-v22.5-16m\`" >> "${RELEASE_FILE}"


target_dts='openwrt/target/linux/ramips/dts/mt7621_phicomm_k2p-A1-32m.dts'
cp -f openwrt/target/linux/ramips/dts/mt7621_phicomm_k2p.dts "${target_dts}"
sed -i 's|compatible = "phicomm,k2p"|compatible = "phicomm,k2p-A1-32m", "phicomm,k2p"|' "${target_dts}"
sed -i 's|model = "Phicomm K2P"|model = "Phicomm K2P (32M)"|' "${target_dts}"
sed -i 's|reg = <0xa0000 0xf60000>|reg = <0xa0000 0x1f60000>|' "${target_dts}"
cat <<EOF >> openwrt/target/linux/ramips/image/mt7621.mk
define Device/phicomm_k2p-A1-32m
  \$(Device/phicomm_k2p)
  IMAGE_SIZE := 32128k
  DEVICE_VARIANT := A1 (32M)
  SUPPORTED_DEVICES += k2p-A1-32m
endef
TARGET_DEVICES += phicomm_k2p-A1-32m
EOF
echo "- 添加设备 \`ramips/mt7621/phicomm_k2p-32m\`" >> "${RELEASE_FILE}"


####################
#*** patch openwrt v24.10.4
cp -f patches/*.patch openwrt/feeds/telephony/libs/dahdi-linux/patches/


