#!/bin/bash
#
# DIY1
# H68K + ImmortalWrt/OpenWrt
# kenzok8 + small + small-package
#


# ============================================================
# 添加第三方插件源
# ============================================================

# kenzok8 主插件源
sed -i '1i src-git kenzo https://github.com/kenzok8/openwrt-packages' feeds.conf.default

# kenzok8 small
sed -i '2i src-git small https://github.com/kenzok8/small' feeds.conf.default

# kenzok8 small-package
sed -i '3i src-git smpackage https://github.com/kenzok8/small-package' feeds.conf.default



# ============================================================
# 删除官方冲突插件
# 防止多个feed提供同名软件包
# ============================================================

rm -rf feeds/luci/applications/{
luci-app-passwall,
luci-app-passwall2,
luci-app-openclash,
luci-app-homeproxy,
luci-app-lucky,
luci-app-smartdns,
luci-app-mosdns
}


rm -rf feeds/packages/net/{
alist,
adguardhome,
mosdns,
xray-core,
xray-geodata,
v2ray-geodata,
sing-box,
smartdns,
chinadns-ng,
dns2socks,
hysteria,
naiveproxy
}


rm -rf feeds/packages/utils/v2dat



# ============================================================
# Golang
# 部分插件依赖Go编译
# ============================================================

rm -rf feeds/packages/lang/golang


git clone --depth 1 \
-b 1.26 \
https://github.com/kenzok8/golang \
feeds/packages/lang/golang



# ============================================================
# PassWall依赖包
# ============================================================

git clone --depth 1 \
https://github.com/Openwrt-Passwall/openwrt-passwall-packages \
package/passwall-packages



# ============================================================
# 更新feeds
# ============================================================

./scripts/feeds update -a

./scripts/feeds install -a



# ============================================================
# 自动添加LuCI中文语言包
# ============================================================

for pkg in $(grep '^CONFIG_PACKAGE_luci-app-.*=y' .config \
| sed 's/^CONFIG_PACKAGE_//;s/=y//')
do

    trans="luci-i18n-${pkg#luci-app-}-zh-cn"


    if grep -q "^CONFIG_PACKAGE_${trans}=y" .config
    then
        continue
    fi


    if grep -q "config package.*${trans}" \
    feeds/luci/*/Makefile \
    feeds/*/*/Makefile 2>/dev/null
    then

        echo "添加中文语言包: ${trans}"

        echo "CONFIG_PACKAGE_${trans}=y" >> .config

    fi

done



# ============================================================
# 修复依赖
# ============================================================

make defconfig
