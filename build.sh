#!/bin/bash

if [ ! -d "config" ]; then
    echo "error：dir [config] not exist"
    exit 1
fi

mkdir -p bin

for file in "config/*"; do
    if [ -f "$file" ]; then
		echo "build target [$file]"
        cp -f "$file" "openwrt/.config"
		make -j4
		IFS="-" read -r part1 part2 part3 <<< "$file"
		cp -f openwrt/bin/targets/$part1/$part2/*.-squashfs-sysupgrade.bin bin
    fi
done