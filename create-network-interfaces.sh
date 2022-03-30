#!/bin/bash
set -ex

VM="$1"

sudo sysctl --write net.ipv4.ip_forward=1

sudo ip netns add "$VM"_pod_1 || true
sudo ip link add dev veth_"$VM"_1 type veth peer veth_"$VM"_1_pod || true
sudo ip link set dev veth_"$VM"_1 up || true
sudo ip link set dev veth_"$VM"_1_pod netns "$VM"_pod_1 || true
sudo ip netns exec "$VM"_pod_1 ip link set dev lo up || true
sudo ip netns exec "$VM"_pod_1 ip link set dev veth_"$VM"_1_pod up || true
sudo ip netns exec "$VM"_pod_1 ip address add 10.0."$VM".10 dev veth_"$VM"_1_pod || true
sudo ip netns exec "$VM"_pod_1 ip route add default via 10.0."$VM".10 || true

sudo ip route add 10.0."$VM".10/32 dev veth_"$VM"_1 || true

sudo sysctl --write net.ipv4.conf.veth_"$VM"_1.proxy_arp=1

sudo iptables --append FORWARD --in-interface ens3 --out-interface veth_"$VM"_1 --jump ACCEPT
sudo iptables --append FORWARD --in-interface veth_"$VM"_1 --out-interface ens3 --jump ACCEPT
sudo iptables --append POSTROUTING --table nat --out-interface ens3 --jump MASQUERADE
