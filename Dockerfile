FROM ghcr.io/netbootxyz/netbootxyz

# Install dnsmasq to play DHCP server
RUN apk add --update dnsmasq

# Copy config files for dnsmasq, and running as a service
COPY etc /etc/
COPY dnsmasq-dhcp-wrapper.sh /usr/local/bin/dnsmasq-dhcp-wrapper.sh
RUN chmod +x /usr/local/bin/dnsmasq-dhcp-wrapper.sh
RUN echo "[include]" >> /etc/supervisor.conf && \
    echo "files = /etc/supervisor/conf.d/*.conf" >> /etc/supervisor.conf
# Set the start of the IP range to reply to PXE DHCP requests on
ENV DHCP_RANGE_START=192.168.0.1

# dnsmasq will be started as a system service by the s6 supervisor
