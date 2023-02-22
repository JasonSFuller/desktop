# Purpose:
#   The default colors in PuTTY suck.  Blue is particularly difficult to see on
#   a dark background, so directories (when you use `ls --color`) and comments
#   (in `vim`) are almost unreadable.  The Gnome terminal's Tango theme is
#   pretty nice (and solves this readability problem), so this script applies
#   that theme to existing PuTTY profiles, so you don't have to tediously type
#   them all.  Also, adjust a few other defaults to my preferences.
# Usage:
#   powershell.exe -ExecutionPolicy Bypass -File putty-update-default-settings.ps1
# Source:
#   https://winterdom.com/2009/05/03/configuring-putty-with-tango

$sessionKey = "HKCU:\Software\SimonTatham\PuTTY\Sessions\Default%20Settings"

if ( !(test-path $sessionKey) ) {
  new-item -path $sessionKey -force
}

$values = @{

  # color settings (gnome's tango theme)
  "Xterm256Colour" = 0x00000001
  "BoldAsColour" = 0x00000001
  "Colour0" = "187,187,187"
  "Colour1" = "255,255,255"
  "Colour2" = "8,8,8"
  "Colour3" = "85,85,85"
  "Colour4" = "0,0,0"
  "Colour5" = "0,255,0"
  "Colour6" = "46,52,54"
  "Colour7" = "85,87,83"
  "Colour8" = "204,0,0"
  "Colour9" = "239,41,41"
  "Colour10" = "78,154,6"
  "Colour11" = "138,226,52"
  "Colour12" = "196,160,0"
  "Colour13" = "252,233,79"
  "Colour14" = "52,101,164"
  "Colour15" = "114,159,207"
  "Colour16" = "117,80,123"
  "Colour17" = "173,127,168"
  "Colour18" = "6,152,154"
  "Colour19" = "52,226,226"
  "Colour20" = "211,215,207"
  "Colour21" = "238,238,236"

  # appearance
  "Font" = "Source Code Pro"
  "FontHeight" = 0x0000000c
  "TermWidth" = 0x00000078
  "TermHeight" = 0x00000018

  # max compatibility + show me all the colors
  "TerminalType" = "xterm-256color"

  # don't warn me on close
  "WarnOnClose" = 0x00000000

  # keep my conections alive (ping once every 30 sec)
  "PingIntervalSecs" = 0x0000001e
  "TCPKeepalives" = 0x00000001

  # no @#$%ing beeping
  "Beep" = 0x00000000

  # use UTF-8 for compatibility
  "LineCodePage" = "UTF-8"

  # set scrollback to 2,000,000 lines
  "ScrollbackLines" = 0x001e8480

  # no scrollbar (use mouse wheel and shift+pgup/pgdn)
  "ScrollBar" = 0x00000000

  # only scroll to bottom on key press
  "ScrollOnKey" = 0x00000001
  "ScrollOnDisp" = 0x00000000

}

$values.Keys | %{
  set-itemproperty $sessionKey $_ $values[$_]
}





