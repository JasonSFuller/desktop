#!/bin/bash

if [[ "$UID" != "0" ]]; then echo "ERROR: must be run as root" >&2; exit 1; fi

if ! getent passwd jfuller &>/dev/null; then
  useradd --user-group jfuller
  #passwd -l jfuller # lock password (ssh keys only, no console or gui access)
  #echo -n 'homelab' | passwd --stdin jfuller # for Fedora, CentOS, RHEL, etc
  echo 'jfuller:homelab' | chpasswd # for Debian, Ubuntu, etc
fi

if [[ -d /etc/sudoers.d ]]; then
  if [[ ! -f /etc/sudoers.d/jfuller ]]; then
    install -o root -g root -m 0440 \
      <(echo 'jfuller ALL=(ALL) NOPASSWD: ALL') \
      /etc/sudoers.d/jfuller
  fi
else
  echo "WARNING: sudoers.d not found" >&2
fi

if [[ -d ~jfuller && ! -f ~jfuller/.ssh/authorized_keys ]]; then
  install -m 0755 -d ~jfuller/.ssh
  install -m 0640 \
    <(curl -fsL https://github.com/jasonsfuller.keys) \
    ~jfuller/.ssh/authorized_keys  
fi
