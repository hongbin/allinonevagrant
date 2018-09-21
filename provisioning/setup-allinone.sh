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

PACKAGES="python3-dev git-review"
DEBIAN_FRONTEND=noninteractive sudo apt-get install -qqy $BASE_PACKAGES

ssh-keygen -t rsa -N "" -f ~/.ssh/id_rsa

# open all security groups
source devstack/openrc demo demo
SG=default
openstack security group rule create --protocol tcp --dst-port 1:65535 --remote-ip 0.0.0.0/0 $SG
openstack security group rule create --protocol udp --dst-port 1:65535 --remote-ip 0.0.0.0/0 $SG
openstack security group rule create --protocol icmp --dst-port -1 --remote-ip 0.0.0.0/0 $SG
