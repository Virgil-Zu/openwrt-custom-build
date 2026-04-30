#!/bin/bash
set -e

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