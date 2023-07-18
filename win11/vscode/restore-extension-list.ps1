# Usage:
#   powershell.exe -ExecutionPolicy Bypass -File restore-extension-list.ps1
# Note:
#   You may need to TEMPORARILY set the following line in your settings.json,
#   if you're behind a corporate firewall that performs deep packet inspection.
#     "http.proxyStrictSSL": false

foreach($ext in Get-Content extensions.txt) {
  Write-Host("Installing extension: $ext")
  code --install-extension "$ext"
}
