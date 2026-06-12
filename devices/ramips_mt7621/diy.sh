#!/bin/bash

shopt -s extglob

SHELL_FOLDER=$(dirname $(readlink -f "$0"))


sed -i "s/DEVICE_MODEL := HC5962$/DEVICE_MODEL := HC5962 \/ B70/" target/linux/ramips/image/mt7621.mk


sed -i '/# start dockerd/,/# end dockerd/d' .config

sed -i "s/--max-leb-cnt=96/--max-leb-cnt=128/g" target/linux/ramips/image/mt7621.mk

# 固定 sing-box 版本为 1.12.23
for singbox_mk in feeds/kiddin9/sing-box/Makefile package/feeds/kiddin9/sing-box/Makefile; do
	[ -f "$singbox_mk" ] || continue
	sed -i 's/^PKG_VERSION:=.*/PKG_VERSION:=1.12.23/' "$singbox_mk"
	sed -i 's/^PKG_HASH:=.*/PKG_HASH:=skip/' "$singbox_mk"
done
