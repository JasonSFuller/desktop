#!/bin/bash

function error { echo "ERROR: $*" >&2; exit 1; }
function cleanup { rm -rf "$tmp"; }
trap cleanup EXIT INT TERM

# utilities and packaged fonts
sudo DEBIAN_FRONTEND="noninteractive" apt-get install -y \
  curl \
  unzip \
  fonts-firacode \
  fonts-inconsolata

# other fonts
tmp=$(mktemp -d)
for url in \
  'https://github.com/adobe-fonts/source-code-pro/releases/download/2.042R-u%2F1.062R-i%2F1.026R-vf/TTF-source-code-pro-2.042R-u_1.062R-i.zip' \
  'https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.0/SourceCodePro.zip'
do
  ((i++))
  curl -sSL "$url" -o "$tmp/font-$i.zip"
  install -m 0755 -d "$tmp/font-$i"
  unzip "$tmp/font-$i.zip" -d "$tmp/font-$i/"
done

install -m 0755 -d "$HOME/.fonts"
find "$tmp" -iname '*.ttf' -exec install -m 0644 {} "$HOME/.fonts" \;
fc-cache -f
ls "$HOME/.fonts"
