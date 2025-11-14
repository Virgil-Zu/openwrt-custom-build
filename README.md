# Goals

- Compile custom versions of **OpenWrt** for `Phicomm K2P A1` and `Phicomm K2 psg1208` devices
- Minimize changes as much as possible, keep compilation options consistent with the official version (even if the bugs in the official version are retained)，based on the official release of `config.buildinfo`
- Use GitHub Actions to build OpenWrt
- Follow https://openwrt.org/docs/guide-developer/adding_new_device



# Frequency

- Follow **OpenWrt** version updates

- Keep the last successful  **3** versions

# Customizations

November 2025

1. Customize target `Phicomm K2P A1` to adapt to 32MB Flash version image `mt7621_phicomm_k2p-32m.dts`
2. Customize target `Phicomm K2 psg1208` to adapt to 16MB Flash version image `mt7620a_phicomm_psg1208-16m.dts`
3. buildin Chinese language package `luci-i18n-base-zh-cn`
4. Set log size to 64: `log_size='64'`
5. Set timezone to Asia/Shanghai: `timezone=Asia/Shanghai`



# Outputs

- For target device `Phicomm K2P A1`, create a new device type **Phicomm K2P (32M)**

	PS:

	```shell
	openwrt-24.10.4-ramips-mt7621-phicomm_k2p-32m-squashfs-sysupgrade.bin
	```

	

- For target device `Phicomm K2 psg1208`, create a new device type **Phicomm psg1208 (16M)**

	PS:

	```shell
	openwrt-24.10.4-ramips-mt7621-phicomm_psg1208-16m-squashfs-sysupgrade.bin
	```

	

# Structure

Since different patches may be required for each version of OpenWrt, each version is organized as a folder

```shell
├─24.10.4 (OpenWrt version)
│  ├─patches (applied to the corresponding directory of the OpenWrt code)
│  ├─.config (predefined compilation configuration)
│  ├─customize.sh (applied to the corresponding directory of the OpenWrt code)
```



# Versions

## 24.10.4

1. The `asterisk/dahdi-linux` project is referenced, using an old version from 2024; subsequent new versions have fixed this issue.

	A local macro is defined on line 1519 of `base.c`: `#define MAX 10 /* attempts */`, which is used to indicate the maximum number of attempts.

	The Linux header file `include/linux/minmax.h` has already defined the `MAX(a, b)` macro (used to compare the maximum of two values).

	It is necessary to change `MAX` in `base.c` to `MAX_ATTEMPTS`.

	 <font color="red">I don't know how the official image compiles successfully; this is unreasonable.</font>