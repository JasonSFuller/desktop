#!/bin/bash

# https://github.com/adobe-fonts/source-code-pro/releases

function error { echo "ERROR: $*" >&2; exit 1; }
function cleanup { rm -rf "$tmp"; }
trap cleanup EXIT INT TERM

install -m 0755 -d "$HOME/.fonts"
tmp=$(mktemp -d)
pushd "$tmp" || error "pushd '$tmp' failed"

for url in \
  'https://github.com/adobe-fonts/source-code-pro/releases/download/2.042R-u%2F1.062R-i%2F1.026R-vf/TTF-source-code-pro-2.042R-u_1.062R-i.zip' \
  'https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.0/SourceCodePro.zip'
do
  ((i++))
  curl -sSL "$url" -o "font-$i.zip"
  unzip "font-$i.zip"
done

popd || error "popd '$tmp' failed"

find . -iname '*.ttf' -exec install -m 0644 {} "$HOME/.fonts" \;
fc-cache -v -f;

sudo apt-get install -y fonts-firacode fonts-inconsolata
