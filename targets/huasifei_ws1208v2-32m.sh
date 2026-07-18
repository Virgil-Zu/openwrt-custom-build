#!/bin/bash
set -e

target_dts='openwrt/target/linux/ramips/dts//mt7621_huasifei_ws1208v2-32m.dts'
cp -f openwrt/target/linux/ramips/dts//mt7621_huasifei_ws1208v2.dts "${target_dts}"
sed -i 's|compatible = "huasifei,ws1208v2"|compatible = "huasifei,ws1208v2", "huasifei,ws1208v2-32m"|' "${target_dts}"
sed -i 's|model = "Huasifei WS1208V2"|model = "Huasifei WS1208V2 (32M)"|' "${target_dts}"
sed -i 's|reg = <0x50000 0xfb0000>|reg = <0x50000 0x1f60000>|' "${target_dts}"
cat <<EOF >> openwrt/target/linux/ramips/image/mt7621.mk
define Device/huasifei_ws1208v2-32m
  \$(Device/huasifei_ws1208v2)
  IMAGE_SIZE := 32128k
  DEVICE_VARIANT :=  (32M)
  SUPPORTED_DEVICES += ws1208v2-32m
endef
TARGET_DEVICES += huasifei_ws1208v2-32m
EOF