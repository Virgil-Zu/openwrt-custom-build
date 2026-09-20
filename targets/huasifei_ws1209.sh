#!/bin/bash
set -e

cat <<'EOF' > openwrt/target/linux/ramips/dts/mt7621_huasifei_ws1209.dts
// SPDX-License-Identifier: GPL-2.0-or-later OR MIT

#include "mt7621.dtsi"

#include <dt-bindings/gpio/gpio.h>
#include <dt-bindings/input/input.h>

/ {
	compatible = "huasifei,ws1209", "mediatek,mt7621-soc";
	model = "Huasifei WS1209";

	aliases {
		led-boot = &led_internet;
		led-failsafe = &led_internet;
		led-running = &led_internet;
		led-upgrade = &led_internet;
	};

	chosen {
		bootargs = "console=ttyS0,115200";
	};

	keys {
		compatible = "gpio-keys";

		reset {
			label = "reset";
			gpios = <&gpio 18 GPIO_ACTIVE_LOW>;
			linux,code = <KEY_RESTART>;
		};
	};

	leds {
		compatible = "gpio-leds";

		led_internet: internet {
			label = "green:wan";
			gpios = <&gpio 12 GPIO_ACTIVE_LOW>;
		};

		cellular {
			label = "green:cellular";
			gpios = <&gpio 10 GPIO_ACTIVE_LOW>;
		};

		wlan2g {
			label = "green:wlan2g";
			gpios = <&gpio 5 GPIO_ACTIVE_LOW>;
			linux,default-trigger = "phy0tpt";
		};

		wlan5g {
			label = "green:wlan5g";
			gpios = <&gpio 14 GPIO_ACTIVE_LOW>;
			linux,default-trigger = "phy1tpt";
		};

		usb {
			label = "green:usb";
			gpios = <&gpio 11 GPIO_ACTIVE_HIGH>;
			linux,default-trigger = "usbport";
			trigger-sources = <&xhci_ehci_port1>;
		};
	};
};

&sdhci {
	status = "okay";
};

&spi0 {
	status = "okay";

	flash@0 {
		compatible = "jedec,spi-nor";
		reg = <0>;
		spi-max-frequency = <50000000>;

		partitions {
			compatible = "fixed-partitions";
			#address-cells = <1>;
			#size-cells = <1>;

			partition@0 {
				label = "u-boot";
				reg = <0x0 0x30000>;
			};

			partition@30000 {
				label = "u-boot-env";
				reg = <0x30000 0x10000>;
			};

			factory: partition@40000 {
				label = "factory";
				reg = <0x40000 0x10000>;
			};

			partition@50000 {
				compatible = "denx,uimage";
				label = "firmware";
				reg = <0x50000 0xfb0000>;
			};
		};
	};
};

&pcie {
	status = "okay";
};

&pcie0 {
	wifi@0,0 {
		compatible = "pci14c3,7603";
		reg = <0x0000 0 0 0 0>;
		mediatek,mtd-eeprom = <&factory 0x0000>;
	};
};

&pcie1 {
	wifi@0,0 {
		compatible = "pci14c3,7662";
		reg = <0x0000 0 0 0 0>;
		mediatek,mtd-eeprom = <&factory 0x8000>;
		ieee80211-freq-limit = <5000000 6000000>;

		nvmem-cells = <&macaddr_factory_4>;
		nvmem-cell-names = "mac-address";
		mac-address-increment = <1>;

		led {
			led-sources = <2>;
		};
	};
};

&gmac0 {
	nvmem-cells = <&macaddr_factory_4>;
	nvmem-cell-names = "mac-address";
	mac-address-increment = <2>;
};

&switch0 {
	ports {
		port@0 {
			status = "okay";
			label = "lan1";
		};

		port@1 {
			status = "okay";
			label = "lan2";
		};

		port@2 {
			status = "okay";
			label = "lan3";
		};

		port@3 {
			status = "okay";
			label = "lan4";
		};

		port@4 {
			status = "okay";
			label = "wan";
			nvmem-cells = <&macaddr_factory_4>;
			nvmem-cell-names = "mac-address";
			mac-address-increment = <3>;
		};
	};
};

&factory {
	compatible = "nvmem-cells";
	#address-cells = <1>;
	#size-cells = <1>;

	macaddr_factory_4: macaddr@4 {
		reg = <0x4 0x6>;
	};
};

EOF
cat <<'EOF' >> openwrt/target/linux/ramips/image/mt7621.mk
define Device/huasifei_ws1209
  $(Device/dsa-migration)
  $(Device/uimage-lzma-loader)
  IMAGE_SIZE := 16064k
  DEVICE_VENDOR := Huasifei
  DEVICE_MODEL := WS1209
  DEVICE_PACKAGES := kmod-ata-ahci kmod-mt7603 kmod-mt76x2 kmod-mmc-mtk \
	kmod-usb3 kmod-usb-net-cdc-mbim kmod-usb-net-qmi-wwan \
	kmod-usb-serial-option -uboot-envtools
endef
TARGET_DEVICES += huasifei_ws1209
EOF