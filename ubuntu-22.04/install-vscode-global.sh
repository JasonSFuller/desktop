#!/bin/bash

url='https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64'
file='/tmp/code.deb'

function cleanup { rm -rf "$file"; }
trap cleanup EXIT INT TERM

sudo DEBIAN_FRONTEND=noninteractive apt-get install -y \
  curl \
  vim \
  git \
  shellcheck

curl -sSL "$url" -o "$file"

sudo DEBIAN_FRONTEND=noninteractive apt-get install -y \
  "$file" 

rm -f "$file"
