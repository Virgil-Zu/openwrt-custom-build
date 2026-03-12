**Read this in other languages: [English](README.md), [中文](README_zh.md).**



**This repository adds configurations such as time zone and package repository sources for users in mainland China.**

# Objectives

Compile customized versions of OpenWrt for the following devices to meet the firmware requirements after modifying the Flash size of the hardware:

- Target device `tl-wr703n v1.6`: Create a new device type **tl-wr703n v1.6 (16M)** with the official 0x50000 partition layout.

  ```shell
  openwrt-xx.xx.x-ath79-generic-tplink_tl-wr703n-v1.6-16m-squashfs-sysupgrade.bin
  ```


- Target device `Phicomm K2 A2 v22.4`: Create a new device type **Phicomm K2 A2 v22.4 (16M)** with the official 0x50000 partition layout. "v22.4" refers to devices that have been flashed with the official firmware v22.4 or lower versions.

  ```shell
  openwrt-xx.xx.x-ramips-mt7620-phicomm_k2-A2-v22.4-16m-squashfs-sysupgrade.bin
  ```

- Target device `Phicomm K2 A2 v22.5`: Create a new device type **Phicomm K2 A2 v22.5 (16M)** with the Phicomm 0xA0000 partition layout. "v22.5" refers to devices that have been flashed with the official firmware v22.5 or higher versions.

  ```shell
  openwrt-xx.xx.x-ramips-mt7620-phicomm_k2-A2-v22.5-16m-squashfs-sysupgrade.bin
  ```

- Target device `Phicomm K2P A1`: Create a new device type **Phicomm K2P A1 (32M)** with the Phicomm 0xA0000 partition layout.

  Fixed the bug in the WIFI transmit power settings.
  
  > OpenWrt uses the open-source driver for the MT7621 chip from the mt76 project at https://github.com/openwrt/mt76. The Phicomm K2P has an external power amplifier (PA) on its PCB, but Phicomm did not follow the standard EEPROM layout: instead of programming the transmit power values into `MT_EE_EXT_PA_2G_TARGET_POWER` and `MT_EE_EXT_PA_5G_TARGET_POWER`, it stored them in `MT_EE_TX0_2G_TARGET_POWER` and `MT_EE_TX0_5G_G0_TARGET_POWER`. As a result, the mt76 driver reads 0 for the maximum supported transmit power and defaults to a safe maximum of 7 dBm. We have applied a fix for this issue when building K2P firmware, and we will provide two firmware builds: filenames without "32m" use the official flash size, and all builds are based on version `v24.10.x`.
  >
  > ```shell
  > lsmod | grep mt76
  > cfg80211              323584  4 mt7615_common,mt76_connac_lib,mt76,mac80211
  > compat                 12288  3 mt76,mac80211,cfg80211
  > hwmon                  16384  1 mt7615_common
  > mac80211              647168  4 mt7615e,mt7615_common,mt76_connac_lib,mt76
  > mt76                   69632  3 mt7615e,mt7615_common,mt76_connac_lib
  > mt76_connac_lib        49152  2 mt7615e,mt7615_common
  > mt7615_common          73728  1 mt7615e
  > mt7615e                20480  0
  > ```
  >
  > so, modify `https://github.com/openwrt/mt76/blob/master/mt7615/eeprom.c`
  
  ```shell
  openwrt-xx.xx.x-ramips-mt7621-phicomm_k2p-A1-32m-squashfs-sysupgrade.bin
  openwrt-xx.xx.x-ramips-mt7621-phicomm_k2p-A1-squashfs-sysupgrade.bin
  ```
  
  

# Principles

- Minimize modifications as much as possible; keep compilation options consistent with the official version (retain even the defects of the official version). The compilation configuration is based on the `config.buildinfo` files of different devices released by the official.

- Use GitHub Actions to compile OpenWrt customly to ensure the process and output artifacts are clean.

- Follow the steps below to add devices:

  https://openwrt.org/docs/guide-developer/build-system/device-trees

- Follow the steps below for compilation:

  https://openwrt.org/docs/guide-developer/toolchain/use-buildsystem

  

# Update Frequency

- Align with **OpenWrt** version updates.

  

# Customizations

2025/11

1. Prebuilt with Simplified Chinese language package `luci-i18n-base-zh-cn`.
2. Set the log size to 64: `log_size='64'`.
3. Set the time zone to Asia/Shanghai: `zonename=Asia/Shanghai`.
4. Set the opkg repository to Alibaba Cloud: `https://mirrors.aliyun.com/openwrt`.

# Version Notes

## 24.10.4

1. The `asterisk/dahdi-linux` project is referenced with an old version from 2024, and subsequent new versions have fixed the issue.

   Line 1519 of `base.c` defines a local macro: #define MAX 10 /* attempts */, which is used to indicate the maximum number of attempts.

   The Linux header file `include/linux/minmax.h` already defines the MAX(a, b) macro (used to compare the maximum value of two values).

   Here, `MAX` in `base.c` needs to be changed to `MAX_ATTEMPTS`.

   :rage:**It's unreasonable that the official mirror can be compiled successfully; this makes no sense at all.**

