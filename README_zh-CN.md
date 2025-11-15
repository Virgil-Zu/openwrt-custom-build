Read this in other languages: **[English](README.md), [中文](README_zh-CN.md).**



# 目标

- 针对` Phicomm K2P A1`和 `Phicomm K2 psg1218` 两种设备编译定制版本的**OpenWrt**
- 尽最大可能减少改动，编译选项和官方版本保持一致（即使官方版本的缺陷也保留），编译配置基于官方发布的  `config.buildinfo`

- 使用GitHub Action自定义编译openwrt

- 编译步骤遵循 https://openwrt.org/docs/guide-developer/adding_new_device



# 频次

- 跟随**OpenWrt**版本更新

- 保留最后成功的 **3** 个版本

# 定制

2025/11

1. 定制目标 ` Phicomm K2P A1` 适配 **32MB** 容量Flash版本镜像  `mt7621_phicomm_k2p-32m.dts`
2. 定制目标 `Phicomm K2 psg1218` 适配 **16MB** 容量Flash版本镜像 `mt7620a_phicomm_k2-v22.5-16m.dts`
3. 内置简体中文语言包 `luci-i18n-base-zh-cn`
4. 设置日志大小64  `log_size='64'`
5. 设置时区为Asia/Shanghai  `timezone=Asia/Shanghai`
6. 设置feeds源为阿里源 `https://mirrors.aliyun.com/openwrt`



# 输出

- 目标设备 `Phicomm K2P A1`，创建新的设备类型  **Phicomm K2P (32M)**

  例如:

  ``````shell
  openwrt-24.10.4-ramips-mt7621-phicomm_k2p-32m-squashfs-sysupgrade.bin
  ``````

  

- 目标设备 `Phicomm K2 psg1218` ，创建新的设备类型  **Phicomm K2 v22.5 or newer (16M)**

	例如:
	
	```shell
	openwrt-24.10.4-ramips-mt7620-phicomm_k2-v22.5-16m-squashfs-sysupgrade.bin
	```
	
	

# 结构

由于OpenWrt每个版本可能需要应用不同的patch，所以每个版本作为一个文件夹

```shell
├─24.10.4 (openwrt 版本)
│  ├─.config  (预定义的编译配置)
│  └─customize.sh (应用在openwrt代码的对应目录)
```



# 版本

## 24.10.4

1. `asterisk/dahdi-linux`项目被引用，用的是2024年的旧版本，之后的新版本已经修复

	`base.c` 的第 1519 行定义了一个局部宏：#define MAX 10 /* attempts */，用于表示最大尝试次数

	linux头文件`include/linux/minmax.h` 中已经定义了 MAX(a, b) 宏（用于比较两个值的最大值）

	这里需要将`base.c` 中的MAX改为MAX_ATTEMPTS
	
	<font color="red">我不知道官方镜像是如何编译成功的，这很不合理</font>
