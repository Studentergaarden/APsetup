#!/bin/bash



architecture="ar71xx"

# These should be fine unless you've changed something
user="root"
ip_address="192.168.1.1"

url="https://downloads.openwrt.org/snapshots/trunk/${architecture}/generic/packages/"
#tmpdir="/tmp/luci-offline"
declare -a packages_base=(libiwinfo-lua kmod-ath10k  kmod-ath ath10k-firmware-qca988x  liblua lua libuci-lua libubus libubus-lua uhttpd rpcd)
declare -a packages_luci=(luci-base luci-lib-ip luci-lib-nixio luci-theme-bootstrap luci-mod-admin-full)

#mkdir "$tmpdir"
#cd "$tmpdir"
i=0
wget -N --quiet "${url}base/Packages"
for pkg in "${packages_base[@]}"; do
    pkgfile="$(egrep -oe " ${pkg}_.+" Packages | tail -c +2)"
    pkgurl="${url}base/${pkgfile}"	
    wget -N --quiet "$pkgurl"
done

wget -N --quiet "${url}luci/Packages"
for pkg in "${packages_luci[@]}"; do
    pkgfile="$(egrep -oe " ${pkg}_.+" Packages | tail -c +2)"
    pkgurl="${url}luci/${pkgfile}"
    wget -N --quiet "$pkgurl"
	
done

ssh "${user}@${ip_address}" mkdir -p /tmp/luci-offline-packages
scp *.ipk "${user}@${ip_address}":/tmp/luci-offline-packages
ssh "${user}@${ip_address}" opkg install /tmp/luci-offline-packages/*.ipk
ssh "${user}@${ip_address}" rm -rf /tmp/luci-offline-packages/
 
ssh "${user}@${ip_address}" /etc/init.d/uhttpd start
ssh "${user}@${ip_address}" /etc/init.d/uhttpd enable
