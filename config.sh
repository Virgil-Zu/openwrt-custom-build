#!/bin/bash
set -e

IFS=/ read -r target sub_target device <<< "$1"

RELEASE_FILE="${device}-release.txt"

echo "" > "${RELEASE_FILE}"

####################
#*** patch openwrt v24.10.4
#cp -f patches/*.patch openwrt/feeds/telephony/libs/dahdi-linux/patches/


####################
#*** set timezone
sed -i "s|timezone='UTC'|zonename='Asia/Shanghai'|" openwrt/package/base-files/files/bin/config_generate
sed -i "s|zonename='UTC'|zonename='Asia/Shanghai'|" openwrt/package/base-files/files/bin/config_generate
sed -i "s|timezone='GMT0'|timezone='CST-8'|" openwrt/package/base-files/files/bin/config_generate
sed -i "s|log_size='128'|log_size='64'|" openwrt/package/base-files/files/bin/config_generate

echo "- 设置时区为Asia/Shanghai \`zonename=Asia/Shanghai\`" >> "${RELEASE_FILE}"
echo "- 设置日志大小64 \`log_size='64'\`" >> "${RELEASE_FILE}"
echo "- 设置 opkg 源为 阿里云 \`https://mirrors.aliyun.com/openwrt\`" >> "${RELEASE_FILE}"
echo "- 内置简体中文语言包 \`luci-i18n-base-zh-cn\`" >> "${RELEASE_FILE}"

#*** copy kernel MD5
sed -i 's#$(LINUX_DIR)/.vermagic#$(LINUX_DIR)/.vermagic\n	cp $(TOPDIR)/.vermagic $(LINUX_DIR)/.vermagic#' openwrt/include/kernel-defaults.mk
sed -i 's#$(SCRIPT_DIR)/kconfig.pl $(LINUX_DIR)/.config | $(MKHASH) md5#cat $(TOPDIR)/.vermagic#' openwrt/package/kernel/linux/Makefile


####################
#*** create new device model
if [ ! -f "targets/${device}.sh" ]; then
	echo "[targets/${device}.sh] not found!"
	exit 1
fi
. "targets/${device}.sh"


