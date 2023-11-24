#!/bin/bash

# PURPOSE:  For VMs in a homelab, it usually doesn't make sense to have a
#   screensaver or screen locking enabled (it's annoying), so disable them.
#   This change effects only the currently logged in user (w/ a Gnome session)
#   and will take effect after they've logged out/in:
#
# IMPORTANT:  User MUST be logged from GUI (so you have context).

if ! grep -q ^GNOME <(env); then echo "ERROR: GNOME session not found" >&2; exit 1; fi

gsettings set org.gnome.desktop.session idle-delay 0
gsettings set org.gnome.desktop.screensaver lock-enabled false
gsettings set org.gnome.desktop.screensaver lock-delay 0
