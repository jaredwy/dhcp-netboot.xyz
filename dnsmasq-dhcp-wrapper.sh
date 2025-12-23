#!/bin/bash

if [ -z ${CONTAINER_IP} ]; then
    # If an IP wasn't given, assume the default route is the one to go for and get IP from that
    CONTAINER_IP=$(ip route get to 1.1.1.1 | awk '/1.1.1.1/ { print $7}')
fi

/usr/sbin/dnsmasq -C /etc/dnsmasq-dhcp.conf --no-daemon --dhcp-range=${DHCP_RANGE_START},proxy \
    --dhcp-userclass=set:ipxe-ok,iPXE \
    --dhcp-match=set:bios,option:client-arch,0 \
    --dhcp-match=set:efi-x86,option:client-arch,7 \
    --dhcp-match=set:efi-x86,option:client-arch,9 \
    --dhcp-match=set:efi-arm64,option:client-arch,11 \
    --dhcp-boot=tag:!ipxe-ok,tag:bios,netboot.xyz.kpxe,,${CONTAINER_IP} \
    --dhcp-boot=tag:!ipxe-ok,tag:efi-x86,netboot.xyz.efi,,${CONTAINER_IP} \
    --dhcp-boot=tag:!ipxe-ok,tag:efi-arm64,netboot.xyz-arm64.efi,,${CONTAINER_IP} \

    ${DNSMASQ_ARGS}
