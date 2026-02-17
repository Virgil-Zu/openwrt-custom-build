#!/bin/bash
set -e

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