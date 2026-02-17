**这个Repo为中国大陆地区的用户添加了时区和仓库源等配置**



# 目标

针对以下设备编译定制版本的 OpenWrt，满足硬件修改Flash大小后的固件



- 目标设备 `tl-wr703n v1.6`，创建新的设备类型  **tl-wr703n v1.6 (16M)**，公版 0x50000 布局

  ```shell
  openwrt-xx.xx.x-ath79-generic-tplink_tl-wr703n-v1.6-16M-squashfs-sysupgrade.bin
  ```

- 目标设备 `Phicomm K2 A2 v22.4` ，创建新的设备类型  **Phicomm K2 A2 v22.4 (16M)**，公版 0x50000 布局，v22.4 指刷过官方固件v22.4和或更低的版本

  ```shell
  openwrt-xx.xx.x-ramips-mt7620-phicomm_k2-A2-v22.4-16m-squashfs-sysupgrade.bin
  ```

- 目标设备 `Phicomm K2 A2` v22.5 ，创建新的设备类型  **Phicomm K2 A2 v22.5 (16M)**，斐讯 0xA0000 布局，v22.5 指刷过官方固件v22.5和或更高的版本

  ```shell
  openwrt-xx.xx.x-ramips-mt7620-phicomm_k2-A2-v22.5-16m-squashfs-sysupgrade.bin
  ```

- 目标设备 `Phicomm K2P A1`，创建新的设备类型  **Phicomm K2P A1 (32M)**，斐讯 0xA0000 布局

  ```shell
  openwrt-xx.xx.x-ramips-mt7621-phicomm_k2p-A1-32m-squashfs-sysupgrade.bin
  ```



# 原则

- 尽可能减少改动，编译选项和官方版本保持一致（即使官方版本的缺陷也保留），编译配置基于官方发布的不同设备的  `config.buildinfo`

- 使用GitHub Action自定义编译 OpenWrt，确保过程和产出物干净

- 添加设备步骤遵循 

  https://openwrt.org/docs/techref/targets/ath79

  https://openwrt.org/docs/guide-developer/porting-to-ath79

  https://openwrt.org/docs/guide-developer/build-system/device-trees

- 编译步骤遵循 

  https://openwrt.org/docs/guide-developer/toolchain/use-buildsystem



# 频次

- 跟随 **OpenWrt** 版本更新




# 定制

2025/11

1. 内置简体中文语言包 `luci-i18n-base-zh-cn`
2. 设置日志大小64  `log_size='64'`
3. 设置时区为Asia/Shanghai  `timezone=Asia/Shanghai`
4. 设置 opkg 源为 阿里云 `https://mirrors.aliyun.com/openwrt`



# 版本

## 24.10.4

1. `asterisk/dahdi-linux`项目被引用，用的是2024年的旧版本，之后的新版本已经修复

	`base.c` 的第 1519 行定义了一个局部宏：#define MAX 10 /* attempts */，用于表示最大尝试次数

	linux头文件`include/linux/minmax.h` 中已经定义了 MAX(a, b) 宏（用于比较两个值的最大值）

	这里需要将`base.c` 中的`MAX`改为`MAX_ATTEMPTS`
	
	:rage:**不知道官方镜像是如何编译成功的，这很不合理**
