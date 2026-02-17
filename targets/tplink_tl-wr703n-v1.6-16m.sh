#!/bin/bash
set -e

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