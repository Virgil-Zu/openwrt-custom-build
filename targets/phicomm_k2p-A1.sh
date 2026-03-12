#!/bin/bash
set -e

####################
#*** patch mt76 max-tx-power
mkdir -p openwrt/package/kernel/mt76/patches/
cp -f patches/301-mt76-mt7615-max-tx-power-k2p.patch openwrt/package/kernel/mt76/patches/

target_dts='openwrt/target/linux/ramips/dts/mt7621_phicomm_k2p-A1.dts'
cp -f openwrt/target/linux/ramips/dts/mt7621_phicomm_k2p.dts "${target_dts}"
cat <<EOF >> openwrt/target/linux/ramips/image/mt7621.mk
define Device/phicomm_k2p-A1
  \$(Device/phicomm_k2p)
  SUPPORTED_DEVICES += k2p-A1
endef
TARGET_DEVICES += phicomm_k2p-A1
EOF