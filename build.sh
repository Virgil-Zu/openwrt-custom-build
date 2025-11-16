#!/bin/bash

echo "build target start ..."

if [ ! -d "config" ]; then
    echo "error：dir [config] not exist"
    exit 1
fi

echo "mkdir [bin]"
mkdir -p bin
ls -l

echo "loop config target ..."

for file in ./config/*; do
    if [ -f "$file" ]; then
        cp -f "$file" "openwrt/.config"
		IFS="#" read -r part1 part2 part3 <<< $(basename "$file")
		echo "build target [$part1/$part2/$part3]"
		cd openwrt
		make -j$(nproc) V=s
		cd ..
		ls -l openwrt/bin/targets
		ls -l openwrt/bin/targets/$part1
		ls -l openwrt/bin/targets/$part1/$part2
		cp -f openwrt/bin/targets/$part1/$part2/*-squashfs-sysupgrade.bin bin
		ls -l bin
    fi
done