#!/bin/bash

shopt -s extglob

SHELL_FOLDER=$(dirname $(readlink -f "$0"))


sed -i "s/DEVICE_MODEL := HC5962$/DEVICE_MODEL := HC5962 \/ B70/" target/linux/ramips/image/mt7621.mk


sed -i '/# start dockerd/,/# end dockerd/d' .config

sed -i "s/--max-leb-cnt=96/--max-leb-cnt=128/g" target/linux/ramips/image/mt7621.mk

# shortcut-fe 内核补丁与 kernel 6.12.92 不兼容，HC5962 无需此加速
rm -f target/linux/generic/hack-6.12/953-net-patch-linux-kernel-to-support-shortcut-fe.patch
rm -rf feeds/kiddin9/shortcut-fe package/feeds/kiddin9/shortcut-fe 2>/dev/null || true

# 固定 sing-box 版本为 1.12.23
for singbox_mk in feeds/kiddin9/sing-box/Makefile package/feeds/kiddin9/sing-box/Makefile; do
	[ -f "$singbox_mk" ] || continue
	sed -i 's/^PKG_VERSION:=.*/PKG_VERSION:=1.12.23/' "$singbox_mk"
	sed -i 's/^PKG_HASH:=.*/PKG_HASH:=skip/' "$singbox_mk"
done
