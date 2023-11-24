#!/bin/bash

# PURPOSE:  For VMs in a homelab, it usually doesn't make sense to have a
#   screensaver or screen locking enabled (it's annoying), so disable them. 
#   This change effects all users after they log out/in.
#
# Adapted from:
#   https://help.gnome.org/admin/system-admin-guide/stable/desktop-lockscreen.html.en

if [[ "$UID" != "0" ]]; then echo "must be run as root" >&2; exit 1; fi

install -m 0755 -d /etc/dconf/profile
install -m 0755 -d /etc/dconf/db/local.d/

cat <<- 'EOF' >    /etc/dconf/profile/user
	user-db:user
	system-db:local
	EOF

cat <<- 'EOF' >    /etc/dconf/db/local.d/00-screensaver
	[org/gnome/desktop/session]
	idle-delay=uint32 0
	[org/gnome/desktop/screensaver]
    lock-enabled=false
	lock-delay=uint32 0
	EOF

dconf update
