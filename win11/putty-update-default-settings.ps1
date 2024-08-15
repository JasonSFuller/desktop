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
  "Colour0" = "187,187,187"  # Default Foreground
  "Colour1" = "255,255,255"  # Default Bold Foreground
  "Colour2" = "8,8,8"        # Default Background
  "Colour3" = "85,85,85"     # Default Bold Background
  "Colour4" = "0,0,0"        # Cursor Text
  "Colour5" = "0,255,0"      # Cursor Colour
  "Colour6" = "46,52,54"     # ANSI Black
  "Colour7" = "85,87,83"     # ANSI Black Bold
  "Colour8" = "204,0,0"      # ANSI Red
  "Colour9" = "239,41,41"    # ANSI Red Bold
  "Colour10" = "78,154,6"    # ANSI Green
  "Colour11" = "138,226,52"  # ANSI Green Bold
  "Colour12" = "196,160,0"   # ANSI Yellow
  "Colour13" = "252,233,79"  # ANSI Yellow Bold
  "Colour14" = "52,101,164"  # ANSI Blue
  "Colour15" = "114,159,207" # ANSI Blue Bold
  "Colour16" = "117,80,123"  # ANSI Magenta
  "Colour17" = "173,127,168" # ANSI Magenta Bold
  "Colour18" = "6,152,154"   # ANSI Cyan
  "Colour19" = "52,226,226"  # ANSI Cyan Bold
  "Colour20" = "211,215,207" # ANSI White
  "Colour21" = "238,238,236" # ANSI White Bold

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

