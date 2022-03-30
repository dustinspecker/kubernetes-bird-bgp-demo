#!/bin/bash
set -ex

VM="$1"

sudo apt update

sudo apt install bird2 --yes

sudo cp /kubernetes-bird-bgp-demo/bird/bird-vm"$VM".conf /etc/bird/bird.conf

sudo systemctl restart bird
