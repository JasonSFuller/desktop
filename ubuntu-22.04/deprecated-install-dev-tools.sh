#!/bin/bash

# Writing smaller scripts to break this up.
#
# Still TODO:
# - Vagrant (and other hashi tools)
# - Virtualbox
# - Docker
# - Tailscale

# shellcheck disable=SC2317
echo "DEPRECATED, aborting" >&2
exit 1

################################################################################

function info  { echo "[${color[blu_b]}INFO${color[reset]}]:  ${color[blu]}$*${color[reset]}"; }
function warn  { echo "[${color[yel_b]}WARN${color[reset]}]:  ${color[yel]}$*${color[reset]}" >&2; }
function error { echo "[${color[red_b]}ERROR${color[reset]}]: ${color[red]}$*${color[reset]}" >&2; exit 1; }

function pre_flight_checks {
  set -e
  declare -A color=(
    [red]="$(tput setaf 1)"
    [blu]="$(tput setaf 4)"
    [yel]="$(tput setaf 3)"
    [red_b]="$(tput setaf 9)"
    [blu_b]="$(tput setaf 12)"
    [yel_b]="$(tput setaf 11)"
    [reset]="$(tput sgr0)"
  )
  if [[ "$UID" != "0" ]]; then error "must be run as root"; fi
  export DEBIAN_FRONTEND="noninteractive"
}

function install_deb_from_url {
  local url="$1"
  local base="$2"
  if [[ -z "$base" ]]; then base=$(basename "$url"); fi
  local file="/tmp/$base"
  curl -sSL "$url" -o "$file"
  apt-get install -y "$file"
  rm -f "$file"
}

# https://developer.hashicorp.com/vagrant/downloads
function install_hashicorp_repo {
  wget -O- https://apt.releases.hashicorp.com/gpg \
    | gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
  echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" \
    > /etc/apt/sources.list.d/hashicorp.list
}

# https://docs.docker.com/engine/install/ubuntu/
function install_docker_repo {
  # remove old packages
  for pkg in docker.io docker-doc docker-compose podman-docker containerd runc
  do apt-get remove -y "$pkg"
  done
  # pre-requisites
  apt-get install -y ca-certificates curl gnupg
  # install gpg key
  install -m 0755 -d /etc/apt/keyrings
  curl -sSL https://download.docker.com/linux/ubuntu/gpg \
    | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
  chmod 0644 /etc/apt/keyrings/docker.gpg
  (
    # shellcheck source=/dev/null
    source /etc/os-release
    local arch; arch=$(dpkg --print-architecture)
    echo "deb [arch=$arch signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $VERSION_CODENAME stable" \
      > /etc/apt/sources.list.d/docker.list
  )
}

# https://tailscale.com/download/linux/ubuntu-2204
function install_tailscale_repo {
  curl -sSL https://pkgs.tailscale.com/stable/ubuntu/jammy.noarmor.gpg \
    > /usr/share/keyrings/tailscale-archive-keyring.gpg
  curl -sSL https://pkgs.tailscale.com/stable/ubuntu/jammy.tailscale-keyring.list \
    > /etc/apt/sources.list.d/tailscale.list
}


##### main #####################################################################

pre_flight_checks

# for vagrant and packer (installed later via apt)
install_hashicorp_repo

# for docker (installed later via apt)
install_docker_repo

# for tailscale (installed later via apt)
install_tailscale_repo


# update repos
apt-get update

# install my preferred dev tools
apt-get install -y \
  virtualbox \
  vagrant \
  packer \
  libssl-dev \
  libffi-dev \
  docker-ce \
  docker-ce-cli \
  containerd.io \
  docker-buildx-plugin \
  docker-compose-plugin \
  tailscale
