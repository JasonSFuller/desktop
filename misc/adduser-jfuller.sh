#!/bin/bash

# PURPOSE:  Add local user 'jfuller' to a host.  Targeting EL distros.
# USAGE:    bash ./adduser-jfuller.sh       # as the root user, or...
#           sudo bash ./adduser-jfuller.sh  # as a regular user with sudo access

if ! grep -qiE 'red hat|centos|fedora|enterprise linux' /etc/*release; then
  echo "ERROR: does not appear to be an enterprise linux distro" >&2
  exit 1
fi

if [[ "$(id -u)" -ne 0 ]]; then
  echo "ERROR: must run as root (hint: try 'sudo bash $0')" >&2
  exit 1
fi

if ! useradd --user-group jfuller; then
  echo "ERROR: failed to create user 'jfuller'" >&2
  exit 1
fi
echo "INFO: created user 'jfuller'"

install -o jfuller -g jfuller -m 0755 -d ~jfuller/.ssh
install -o jfuller -g jfuller -m 0644 /dev/null ~jfuller/.ssh/authorized_keys
install -o root -g root -m 0440 \
  <(echo 'jfuller ALL=(ALL:ALL) NOPASSWD: ALL') \
  /etc/sudoers.d/jfuller

cat << 'EOF' > ~jfuller/.ssh/authorized_keys
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDFbyUWr2IP65wC0rcXSUEHaFDcuZ46bYJZKBgvZsHm4QOJjxLE5db/dPWkT9EwgsqPX2ZuUfV6PQnZMnQdrkKN+svde00/BJ0DDZHUBd/UD8/R4xr3FjKPG63STSjjZwWc8GWEAEUY1brntbjmO1b3YM7+80ha6ruBFGh9fykgB6lhiDXM9VPMo4r94bZjcOHaSl1numQYqitDphWAgDk8Of1kgnr/wTQXoCqavClyy5Ub6tkt6qupmuZLgEOF6tFU+qf8x6Ns7RS3l12HFAOBpACndg4bdZOCM+AZ9czEs+2KW+jwo6CLgUOsxEHRnYeh8k2b0yjP/cqj38Ig+NGN jason.fuller@cdw.com-rsa-key-20230221
EOF

if builtin command -v md5sum &>/dev/null; then
  if md5sum ~jfuller/.ssh/authorized_keys | grep -qF 496bcb41fbc271258867b424f1fdee55; then
    echo "INFO: authorized_keys md5 checksum ok"
  else
	echo "ERROR: authorized_keys md5 checksum failed"
	exit 1
  fi
fi

if builtin command -v restorecon &>/dev/null; then
  restorecon -R ~jfuller/.ssh/
fi
