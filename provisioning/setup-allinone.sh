#!/usr/bin/env bash

# Script Arguments:
# $1 -  Interface for Vlan type networks
# $2 -  Physical network for Vlan type networks interface in allinone and compute1 "rack"
# Interface equivalences:
# eth1 -> enp0s8 
# eth2 -> enp0s9
VLAN_INTERFACE=$1
PHYSICAL_NETWORK=$2

# Get the IP address
ipaddress=$(ip route get 8.8.8.8 | head -1 | cut -d' ' -f8)

# Adjust local.conf
cat << DEVSTACKEOF >> /opt/stack/devstack/local.conf
[[local|localrc]]
# Set this host's IP
HOST_IP=$ipaddress

# Enable Neutron as the networking service
ADMIN_PASSWORD=password
DATABASE_PASSWORD=password
RABBIT_PASSWORD=password
SERVICE_PASSWORD=password
SERVICE_TOKEN=password

DEVSTACKEOF

cd /opt/stack/devstack
./stack.sh
