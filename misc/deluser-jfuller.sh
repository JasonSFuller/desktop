#!/bin/bash

# PURPOSE:  Remove the local 'jfuller' user and all files (home dir, mail spool,
#           etc).  Targeting EL distros.
# USAGE:    ./deluser-jfuller.sh            # as the root user, or...
#           sudo bash ./deluser-jfuller.sh  # as a regular user with sudo access

if ! grep -qiE 'red hat|centos|fedora|enterprise linux' /etc/*release; then
  echo "ERROR: does not appear to be an enterprise linux distro" >&2
  exit 1
fi

if [[ "$(id -u)" -ne 0 ]]; then
  echo "ERROR: must run as root (hint: try 'sudo bash $0')" >&2
  exit 1
fi

if ! id jfuller; then
  echo "ERROR: user 'jfuller' does not exist" >&2
  exit 1
fi

if ! cd ~jfuller/..; then
  echo "ERROR: could not find the 'jfuller' home dir" >&2
  exit 1
fi

now=$(date +%Y%m%d%H%M%S)
backup="jfuller-${now}.tgz"
umask 137
tar -czf "${backup}" ~jfuller/ 2>&1 \
  | grep -vE 'tar: Removing leading ./. from member names'
echo "INFO: created backup (${backup})"

if ! userdel --remove jfuller; then
  echo "ERROR: could not remove user 'jfuller'" >&2
  exit 1
fi

if ! groupdel jfuller; then
  echo "ERROR: could not remote group 'jfuller'" >&2
  exit 1
fi

echo "INFO: removed user 'jfuller'"
