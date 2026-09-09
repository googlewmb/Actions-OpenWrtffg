#!/bin/bash
#
# Modify default IP
#sed -i 's/192.168.1.1/192.168.50.5/g' package/base-files/files/bin/config_generate
# ==========================================
# H68K + MT7921
# 默认开启所有 Wi-Fi
#
# 作用：
# 1. 首次刷机启动时自动开启 Wi-Fi
# 2. 恢复出厂后再次初始化时自动开启 Wi-Fi
# 3. 不干扰用户后续在 LuCI 中手动关闭
# ==========================================

mkdir -p files/etc/uci-defaults

cat > files/etc/uci-defaults/zz-enable-wifi <<'EOF'
#!/bin/sh

. /lib/functions.sh

# 开启所有 Wi-Fi Radio
enable_wifi_device() {
    local cfg="$1"
    uci -q set "wireless.${cfg}.disabled=0"
}

# 开启所有 Wi-Fi Interface
enable_wifi_iface() {
    local cfg="$1"
    uci -q set "wireless.${cfg}.disabled=0"
}

# 读取无线配置
config_load wireless

# 自动遍历所有 Wi-Fi Radio
config_foreach enable_wifi_device wifi-device

# 自动遍历所有 Wi-Fi Interface
config_foreach enable_wifi_iface wifi-iface

# 保存无线配置
uci -q commit wireless

exit 0
EOF
