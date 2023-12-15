#!/bin/bash

config="./terminator.config"

sudo DEBIAN_FRONTEND=noninteractive apt-get install -y terminator

if [[ ! -f "$config" ]]; then
  echo "ERROR: missing config ($config)" >&2
  exit 1
fi

install -d ~/.config/terminator
install "$config" ~/.config/terminator/config
