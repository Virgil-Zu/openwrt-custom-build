#!/bin/bash
set -e

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