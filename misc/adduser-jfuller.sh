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
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCxbTmm99Me75PYOx23IFYH38i5BIR4vzRSCPSZx/QhUyPYyDZY9NsgoVdQcuhvyjfFZ3DKYWE0Sh9jraF0G3ySgU0lkvCk44JRitGs+knhWQoVEPksTg4dRBHaQgA96ztMDyK9O08oeEgDTLt19tGOeA0STUe9ls1YVfbKxmEI4jyV3uhNBPAeE6DXVrUa7xTzYWjAQXVPatOwnMO0qqD+yc1LUTx1H8I6pnRoFgIL4Q0HFxwRqLweXWdMWOU7St52+whOiIQ5oys9Lw6SJfHEZpRu2uOgVdQhaykFfpHchVpKZX9nVke6r+pNIOIS3rHtVlGTmOMvSAE4C0VMZsEPLjSipH5rsoTwqQWtwOvuBgHc6o0HKX71rLD88J2+TTZny5F7GDvX6iRr2HNKms1OCJEndzslrogv6PqagdXCg2xI8XIr1EvazGLJo4PLT/VO5hxMzUjS9oZ0p6ykWJsMCtmgq4VYMdSnItnCHxQ2zRjMfeclCbhVfCD9vFnOFyjs4iXsJv+z3c5gtuOVPAjdBywTwEsvICemUbQ1yr4OqRcqWYWhgw/4AJUuCLEM/mVAq4oHmfR1+Ubw8Jutp7eivpuMVX7FwyiLcqUaLNr0sD+TLrdkaUKL0ZsyZwbieqbhBOKAinJNbctVSmZfBuSWl1IqGL4f6ZwzujAQfMZBBQ==
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDL4z+O9D01QkS30DZU+CgfPYS1SgMtRmSXRPW1c0rT6lBpr3rQOnjV4PmbMcg3jyuXQwCEm3kSR3ILC0Mdn/J+t2Z0WzbJ4dGJtNl0uYC84PXr4U3GwR3LG7N0CiKk9dJ6xZDUHChnDjqzh4DIzP4a2NK6mQvIFACQ0+AYbQvtMixkMBS5ZCkl7pNUSbvru95VIBpoNNpgZhNOChYz4Vdp7nm2aX1mABDGqQPXNeEqfkrhLaVlTBTCCbgZA6BMZUxC9rZgzy2F1Fby41FKHHDO6MdhpwGSRKzEov1WXjUM9cmggpe8bhqxP17bIEOiRUtsaaYwpq7d71yQwrXBbL/DPLkoJSJiTF/9SYp7agFtb3CR78iVaF2rw9ClJz8M8F0Ehy0c9aO2pVh8D64br2bWmg6GO9dvXFnkJVE5u4GEHssDRTUTMCaCXucOgmDDn1E6aBIoVda7LpJ5ZlDmL/DwV/GpnZCWKPUUMW/V7pkw1uCTw9cn4dt5tvVBZKDWpY0=
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCeOce/s3zIJgFcwuI5kfwQo1DIvEDl39/NgO4ruRO/PrFWwZ8wX3naWikCTHA+OxJ8MFoV5sunzwcTBJNz6qJ1rU3HH0oYwlBI2OeWUMWnxJ8TExdor0ctDo232MwXKmnQskuRoCeojQh8dRNfHVD/yxGtA02iVyDEOOylCvUNvfvqR4rkvTN+urZNk2fUXqBHb6SOLT97mfNsMqd+D+0uNEDLku0GsJrUx4hbAtF8JQCw59xuqRfo0zcpBmZw5mw9Csg5h1IN8L/4lVQN/gkFkdobv/cvlDkcuRigAJhKMX5zJAfWTzzZ4tfS8T6yArJXhhKyqkOSCDg3ekcgTq0j
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
