# Network Change Helper Script
# Run this when you change WiFi/network

Write-Host "╔════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║   ASTERISK NETWORK CONFIGURATION HELPER   ║" -ForegroundColor Cyan
Write-Host "╔════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host ""

# Step 1: Get current IP
Write-Host "📍 STEP 1: Finding Your PC IP Address..." -ForegroundColor Yellow
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Gray

# $ip = (Get-NetIPAddress -AddressFamily IPv4 | Where-Object { ($_.InterfaceAlias -match 'Wi-Fi' -or $_.InterfaceAlias -match 'Ethernet') -and $_.InterfaceAlias -notmatch 'vEthernet' }).IPAddress | Select-Object -First 1
$ip = (Get-NetIPAddress -AddressFamily IPv4 | Where-Object { $_.InterfaceAlias -notmatch 'vEthernet|Loopback|Bluetooth|WSL' -and $_.IPAddress -notlike "169.254.*" -and $_.IPAddress -notlike "172.*" -and $_.IPAddress -notlike "127.*" }).IPAddress | Select-Object -First 1
if ($ip) {
    Write-Host "✅ Your PC IP Address: " -NoNewline -ForegroundColor Green
    Write-Host "$ip" -ForegroundColor White -BackgroundColor DarkGreen
} else {
    Write-Host "❌ Could not find IP address. Are you connected to network?" -ForegroundColor Red
    exit
}

Write-Host ""

# Step 2: Check Docker
Write-Host "🐳 STEP 2: Checking Asterisk Container..." -ForegroundColor Yellow
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Gray

$container = docker ps -a --filter "name=my-asterisk" --format "{{.Status}}"

if ($container -match "Up") {
    Write-Host "✅ Asterisk container is running" -ForegroundColor Green
} elseif ($container) {
    Write-Host "⚠️  Container exists but not running" -ForegroundColor Yellow
    Write-Host "   Starting container..." -ForegroundColor Yellow
    docker start my-asterisk
    Start-Sleep -Seconds 3
    Write-Host "✅ Container started" -ForegroundColor Green
} else {
    Write-Host "❌ Container 'my-asterisk' not found!" -ForegroundColor Red
    Write-Host "   Run the setup script first!" -ForegroundColor Red
    exit
}

Write-Host ""

# Step 3: Show configuration needed
Write-Host "📱 STEP 3: Phone Configuration Needed" -ForegroundColor Yellow
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Gray
Write-Host ""

Write-Host "═══════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host "  PHONE ON SAME PC (MicroSIP - Extension 1001)" -ForegroundColor Cyan
Write-Host "═══════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host "  Server:    " -NoNewline
Write-Host "localhost" -ForegroundColor Green -NoNewline
Write-Host " or " -NoNewline
Write-Host "127.0.0.1" -ForegroundColor Green
Write-Host "  Username:  1001" -ForegroundColor White
Write-Host "  Password:  pass1001" -ForegroundColor White
Write-Host "  Port:      5060" -ForegroundColor White
Write-Host "  Transport: UDP" -ForegroundColor White
Write-Host ""
Write-Host "  ✅ NO CHANGE NEEDED when network changes!" -ForegroundColor Green
Write-Host ""

Write-Host "═══════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host "  PHONE ON OTHER DEVICE (Mobile - Ext 1002)" -ForegroundColor Cyan
Write-Host "═══════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host "  Server:    " -NoNewline
Write-Host "$ip" -ForegroundColor Yellow -BackgroundColor DarkRed
Write-Host "             ⬆️ USE THIS IP! ⬆️" -ForegroundColor Red
Write-Host "  Username:  1002" -ForegroundColor White
Write-Host "  Password:  pass1002" -ForegroundColor White
Write-Host "  Port:      5060" -ForegroundColor White
Write-Host "  Transport: UDP" -ForegroundColor White
Write-Host ""
Write-Host "  ⚠️  UPDATE this when network changes!" -ForegroundColor Yellow
Write-Host ""

# Step 4: Check endpoints
Write-Host "🔍 STEP 4: Checking Registered Phones..." -ForegroundColor Yellow
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Gray

$endpoints = docker exec my-asterisk asterisk -rx "pjsip show endpoints" 2>$null

if ($endpoints -match "1001.*Available") {
    Write-Host "✅ Extension 1001 - " -NoNewline -ForegroundColor Green
    Write-Host "Registered" -ForegroundColor White
} elseif ($endpoints -match "1001") {
    Write-Host "⚠️  Extension 1001 - " -NoNewline -ForegroundColor Yellow
    Write-Host "Not registered" -ForegroundColor White
}

if ($endpoints -match "1002.*Available") {
    Write-Host "✅ Extension 1002 - " -NoNewline -ForegroundColor Green
    Write-Host "Registered" -ForegroundColor White
} elseif ($endpoints -match "1002") {
    Write-Host "⚠️  Extension 1002 - " -NoNewline -ForegroundColor Yellow
    Write-Host "Not registered (update IP to $ip)" -ForegroundColor White
}

Write-Host ""

# Step 5: Network info
Write-Host "🌐 STEP 5: Network Information" -ForegroundColor Yellow
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Gray

$gateway = (Get-NetRoute -DestinationPrefix "0.0.0.0/0" | Select-Object -First 1).NextHop
$subnet = $ip -replace '\.\d+$', '.0/24'

Write-Host "  Your PC IP:     $ip" -ForegroundColor White
Write-Host "  Router IP:      $gateway" -ForegroundColor White
Write-Host "  Network Range:  $subnet" -ForegroundColor White
Write-Host ""
Write-Host "  ℹ️  Your phone must be on same network!" -ForegroundColor Cyan
Write-Host "     Phone IP should start with: " -NoNewline -ForegroundColor Cyan
$networkPrefix = $ip -replace '\d+$', ''
Write-Host "$networkPrefix*" -ForegroundColor Yellow
Write-Host ""

# Step 6: Quick tests
Write-Host "🧪 STEP 6: Quick Tests You Can Run" -ForegroundColor Yellow
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Gray
Write-Host ""
Write-Host "  Test 1: Echo Test" -ForegroundColor White
Write-Host "    • Open your phone app" -ForegroundColor Gray
Write-Host "    • Dial: 999 or 9999" -ForegroundColor Gray
Write-Host "    • You should hear your voice back" -ForegroundColor Gray
Write-Host ""
Write-Host "  Test 2: Call Between Extensions" -ForegroundColor White
Write-Host "    • From 1001, dial 1002" -ForegroundColor Gray
Write-Host "    • From 1002, dial 1001" -ForegroundColor Gray
Write-Host ""

# Summary
Write-Host "╔════════════════════════════════════════════╗" -ForegroundColor Green
Write-Host "║              SUMMARY                       ║" -ForegroundColor Green
Write-Host "╚════════════════════════════════════════════╝" -ForegroundColor Green
Write-Host ""
Write-Host "✅ Asterisk config files: " -NoNewline -ForegroundColor Green
Write-Host "No changes needed!" -ForegroundColor White
Write-Host ""
Write-Host "✅ PC phone (1001): " -NoNewline -ForegroundColor Green
Write-Host "Use 'localhost' - No changes!" -ForegroundColor White
Write-Host ""
Write-Host "⚠️  External phones (1002): " -NoNewline -ForegroundColor Yellow
Write-Host "Update server to: $ip" -ForegroundColor Yellow
Write-Host ""
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Gray
Write-Host ""

# Save to file
$configInfo = @"
═══════════════════════════════════════════════
ASTERISK CONFIGURATION - $(Get-Date -Format "yyyy-MM-dd HH:mm")
═══════════════════════════════════════════════

PC IP Address: $ip
Router IP: $gateway
Network: $subnet

EXTENSION 1001 (Same PC):
  Server: localhost
  Username: 1001
  Password: pass1001

EXTENSION 1002 (External):
  Server: $ip
  Username: 1002
  Password: pass1002

═══════════════════════════════════════════════
"@

$configInfo | Out-File -FilePath ".\current-network-config.txt" -Encoding UTF8

Write-Host "💾 Configuration saved to: " -NoNewline -ForegroundColor Cyan
Write-Host "current-network-config.txt" -ForegroundColor White
Write-Host ""
Write-Host "Press any key to exit..."
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
