# deluge and OpenVPN
#
# Version 1.8

FROM ubuntu:18.04
LABEL maintainer="JanVanBraeckel"

VOLUME /downloads
VOLUME /config

ARG DEBIAN_FRONTEND="noninteractive"

RUN usermod -u 99 nobody

# Update packages and install software
RUN apt-get update \
    && apt-get install -y --no-install-recommends apt-utils openssl \
    && apt-get install -y software-properties-common \
    && apt-key adv --keyserver keyserver.ubuntu.com --recv-keys C5E6A5ED249AD24C \
    && echo "deb http://ppa.launchpad.net/deluge-team/stable/ubuntu bionic main" >> \
    /etc/apt/sources.list.d/deluge.list \
    && echo "deb-src http://ppa.launchpad.net/deluge-team/stable/ubuntu bionic main" >> \
    /etc/apt/sources.list.d/deluge.list \

    && apt-get update \
    && apt-get install -y deluged deluge-console deluge-web openvpn curl moreutils net-tools dos2unix kmod iptables ipcalc unrar \
    && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Add configuration and scripts
ADD openvpn/ /etc/openvpn/
ADD deluge/ /etc/deluge/

RUN chmod +x /etc/deluge/*.sh /etc/deluge/*.init /etc/openvpn/*.sh

# Expose ports and run
EXPOSE 8112 58846 58946 58946/udp
CMD ["/bin/bash", "/etc/openvpn/start.sh"]
