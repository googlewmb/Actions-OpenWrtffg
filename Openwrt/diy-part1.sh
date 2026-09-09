#!/bin/bash
#
# DIY1
#

# 添加 kenzok8 插件源
sed -i '1i src-git kenzo https://github.com/kenzok8/openwrt-packages' feeds.conf.default
sed -i '2i src-git small https://github.com/kenzok8/small' feeds.conf.default

# 删除官方冲突插件
rm -rf feeds/luci/applications/{luci-app-passwall,luci-app-passwall2,luci-app-openclash,luci-app-homeproxy,luci-app-lucky,luci-app-smartdns,luci-app-mosdns}
rm -rf feeds/packages/net/{alist,adguardhome,mosdns,xray*,v2ray*,sing*,smartdns}
rm -rf feeds/packages/utils/v2dat
rm -rf feeds/packages/lang/golang

# 使用新版 golang
git clone https://github.com/kenzok8/golang -b 1.26 feeds/packages/lang/golang

# PassWall依赖
git clone --depth 1 https://github.com/Openwrt-Passwall/openwrt-passwall-packages package/passwall-packages

# 自动添加LuCI中文语言包
for pkg in $(grep '^CONFIG_PACKAGE_luci-app-.*=y' .config | sed 's/^CONFIG_PACKAGE_//;s/=y//'); do
    trans="luci-i18n-${pkg#luci-app-}-zh-cn"
    grep -q "^CONFIG_PACKAGE_${trans}=y" .config || \
    grep -q "config package.*${trans}" feeds/luci/*/Makefile feeds/*/*/Makefile 2>/dev/null && \
    echo "CONFIG_PACKAGE_${trans}=y" >> .config
done

make defconfig
