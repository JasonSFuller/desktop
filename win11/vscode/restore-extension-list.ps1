# Usage:
#   powershell.exe -ExecutionPolicy Bypass -File restore-extension-list.ps1

foreach($ext in Get-Content extensions.txt) {
  Write-Host("Installing extension: $ext")
  code --install-extension "$ext"
}
