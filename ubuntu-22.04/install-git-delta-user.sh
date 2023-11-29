#!/bin/bash

function error { echo "ERROR: $*" >&2; exit 1; }
function cleanup { rm -rf "$tmp"; }
trap cleanup EXIT INT TERM

for cmd in curl jq tar find
do 
  if ! builtin command -v "$cmd" &>/dev/null; then 
    error "command missing ($cmd)"
  fi
done

url_latest="https://api.github.com/repos/dandavison/delta/releases/latest"
tag=$(curl -sSL "$url_latest" | jq -r .tag_name)
file="delta-${tag}-x86_64-unknown-linux-musl.tar.gz"
url_release="https://github.com/dandavison/delta/releases/download/$tag/$file"

tmp=$(mktemp -d)
curl -sSL "$url_release" -o "$tmp/$file"
tar -C "$tmp" -xvzf "$tmp/$file"
install -m 0755 -d "$HOME/bin"
find "$tmp" -type f -iname 'delta' -exec install -m 0755 {} "$HOME/bin" \;
ls -la "$HOME/bin/delta"
