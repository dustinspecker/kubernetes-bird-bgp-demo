#!/bin/bash
set -ex

if ! multipass info vm1 ; then
  multipass launch \
    --cloud-init cloud-init/vm1.yaml \
    --name vm1 \
    --mem 2048M \
    20.04
fi

if ! multipass info vm2 ; then
  multipass launch \
    --cloud-init cloud-init/vm2.yaml \
    --name vm2 \
    --mem 2048M \
    20.04
fi

if ! multipass info vm1 | grep "=> /kubernetes-bird-bgp-demo" ; then
  multipass mount $PWD vm1:/kubernetes-bird-bgp-demo
fi
if ! multipass info vm2 | grep "=> /kubernetes-bird-bgp-demo" ; then
  multipass mount $PWD vm2:/kubernetes-bird-bgp-demo
fi

multipass exec vm1 -- /kubernetes-bird-bgp-demo/create-network-interfaces.sh "1"
multipass exec vm2 -- /kubernetes-bird-bgp-demo/create-network-interfaces.sh "2"

multipass exec vm1 -- /kubernetes-bird-bgp-demo/setup-bird.sh "1"
multipass exec vm2 -- /kubernetes-bird-bgp-demo/setup-bird.sh "2"
