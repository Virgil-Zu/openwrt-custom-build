#!/bin/bash
set -e

####################
#*** patch mt76 max-tx-power
cp -f patches/701-mt76-mt7615-max-tx-power.patch openwrt/package/kernel/mt76/patches/

cat <<EOF >> openwrt/target/linux/ramips/image/mt7621.mk
define Device/phicomm_k2p-A1
  \$(Device/phicomm_k2p)
  SUPPORTED_DEVICES += k2p-A1
endef
TARGET_DEVICES += phicomm_k2p-A1
EOF