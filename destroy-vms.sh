#!/bin/bash
set -ex

if multipass info vm1 ; then
  if [ "$(multipass info vm1 | awk '/State:/ { print $2 }')" != "Deleted" ]; then
    multipass stop vm1
  fi

  multipass delete vm1
fi

if multipass info vm2 ; then
  if [ "$(multipass info vm2 | awk '/State:/ { print $2 }')" != "Deleted" ]; then
    multipass stop vm2
  fi

  multipass delete vm2
fi

multipass purge
