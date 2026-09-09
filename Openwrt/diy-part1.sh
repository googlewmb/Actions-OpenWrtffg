#!/bin/bash
#
# Add a feed source
#1·在feeds.conf.default文件首行添加源码
sed -i '1i src-git moruiris https://github.com/moruiris/openwrt-packages;openwrt' feeds.conf.default
#2·在feeds.conf.default文件末尾添加源码
#echo 'src-git moruiris https://github.com/moruiris/openwrt-packages;openwrt' >>feeds.conf.default
#3·直接在./package添加源码
#git clone -b openwrt https://github.com/moruiris/openwrt-packages ./package/moruiris

# 自动为已选择的 LuCI 插件添加简体中文翻译
for pkg in $(grep '^CONFIG_PACKAGE_luci-app-.*=y' .config | sed 's/^CONFIG_PACKAGE_//;s/=y//'); do
    trans="luci-i18n-${pkg#luci-app-}-zh-cn"

    if grep -q "^CONFIG_PACKAGE_${trans}=y" .config 2>/dev/null; then
        continue
    fi

    if grep -q "config package.*${trans}" feeds/luci/*/Makefile feeds/*/*/Makefile 2>/dev/null; then
        echo "自动启用中文翻译: ${trans}"
        echo "CONFIG_PACKAGE_${trans}=y" >> .config
    fi
done

make defconfig








