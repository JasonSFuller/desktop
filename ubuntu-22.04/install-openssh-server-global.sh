#!/bin/bash

sudo DEBIAN_FRONTEND="noninteractive" \
  apt-get install -y openssh-server

sudo systemctl enable --now ssh
