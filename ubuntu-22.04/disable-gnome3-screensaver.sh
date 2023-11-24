#!/bin/bash

# PURPOSE:  For VMs in a homelab, it usually doesn't make sense to have a
#   screensaver or the screen locking (annoying), so disable them.  This change
#   effects all users after they log out/in.  To modify this per user:
#
#     # IMPORTANT:  must be logged in as the user from GUI (so you have context)
#     gsettings set org.gnome.desktop.session idle-delay 0
#     gsettings set org.gnome.desktop.screensaver lock-enabled false
#     gsettings set org.gnome.desktop.screensaver lock-delay 0

if [[ "$UID" != "0" ]]; then echo "must be run as root" >&2; exit 1; fi

install -m 0755 -d /etc/dconf/profile
cat <<- 'EOF' >    /etc/dconf/profile/user
	user-db:user
	system-db:local
	EOF

install -m 0755 -d /etc/dconf/db/local.d/
cat <<- 'EOF' >    /etc/dconf/db/local.d/00-screensaver
	[org/gnome/desktop/session]
	idle-delay=uint32 0
	[org/gnome/desktop/screensaver]
    lock-enabled=false
	lock-delay=uint32 0
	EOF
dconf update
