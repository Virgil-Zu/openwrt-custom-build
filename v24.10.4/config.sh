#!/bin/bash

#pwd => ${{env.TARGET_VERSION}}

#patch openwrt 24.10.4
cp -f patches/*.patch openwrt/feeds/telephony/libs/dahdi-linux/patches/

#create new device model
# phicomm_k2p-32m
cp -f openwrt/target/linux/ramips/dts/mt7621_phicomm_k2p.dts openwrt/target/linux/ramips/dts/mt7621_phicomm_k2p-32m.dts
sed -i 's|compatible = "phicomm,k2p"|compatible = "phicomm,k2p-32m", "phicomm,k2p"|g' openwrt/target/linux/ramips/dts/mt7621_phicomm_k2p-32m.dts
sed -i 's|model = "Phicomm K2P"|model = "Phicomm K2P (32M)"|g' openwrt/target/linux/ramips/dts/mt7621_phicomm_k2p-32m.dts
sed -i 's|reg = <0xa0000 0xf60000>|reg = <0xa0000 0x1fb0000>|g' openwrt/target/linux/ramips/dts/mt7621_phicomm_k2p-32m.dts
cat openwrt/target/linux/ramips/dts/mt7621_phicomm_k2p-32m.dts

sed -i 's|TARGET_DEVICES += phicomm_k2p|TARGET_DEVICES += phicomm_k2p\n\ndefine Device/phicomm_k2p-32m  $(Device/phicomm_k2p)\n  IMAGE_SIZE := 32128k\n  DEVICE_VARIANT := 32M\n  SUPPORTED_DEVICES += k2p-32m\nendef\nTARGET_DEVICES += phicomm_k2p-32m|g' openwrt/target/linux/ramips/image/mt7621.mk
cat openwrt/target/linux/ramips/image/mt7621.mk


# phicomm_k2p-32m
cp -f openwrt/target/linux/ramips/dts/mt7620a_phicomm_k2-v22.5.dts openwrt/target/linux/ramips/dts/mt7620a_phicomm_k2-v22.5-16m.dts
sed -i 's|compatible = "phicomm,k2-v22.5"|compatible = "phicomm,k2-v22.5-16m"|g' openwrt/target/linux/ramips/dts/mt7620a_phicomm_k2-v22.5-16m.dts
sed -i 's|model = "Phicomm K2 v22.5 or newer"|model = "Phicomm K2 v22.5 or newer (16M)"|g' openwrt/target/linux/ramips/dts/mt7620a_phicomm_k2-v22.5-16m.dts
sed -i 's|reg = <0xa0000 0x760000>|reg = <0xa0000 0x760000>|g' openwrt/target/linux/ramips/dts/mt7620a_phicomm_k2-v22.5-16m.dts
cat openwrt/target/linux/ramips/dts/mt7620a_phicomm_k2-v22.5-16m.dts

sed -i 's|TARGET_DEVICES += phicomm_k2-v22.5|TARGET_DEVICES += phicomm_k2-v22.5\n\ndefine Device/phicomm_k2-v22.5-16m  $(Device/phicomm_k2-v22.5)\n  IMAGE_SIZE := 15744k\n  DEVICE_VARIANT := 16M\n  SUPPORTED_DEVICES += k2-v22.5-16m\nendef\nTARGET_DEVICES += phicomm_k2-v22.5-16m|g' openwrt/target/linux/ramips/image/mt7620.mk
cat openwrt/target/linux/ramips/image/mt7620.mk








