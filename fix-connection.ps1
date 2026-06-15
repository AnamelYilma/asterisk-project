# MicroSIP Connection Diagnostic and Fix Script

Write-Host "╔════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║  MICROSIP CONNECTION DIAGNOSTICS           ║" -ForegroundColor Cyan
Write-Host "╚════════════════════════════════════════════╝" -ForegroundColor Cyan
Write-Host ""

# Get your actual IP address
Write-Host "🔍 Finding Your Network Configuration..." -ForegroundColor Yellow
# $localIP = (Get-NetIPAddress -AddressFamily IPv4 | Where-Object { ($_.InterfaceAlias -match 'Wi-Fi' -or $_.InterfaceAlias -match 'Ethernet') -and $_.InterfaceAlias -notmatch 'vEthernet' }).IPAddress | Select-Object -First 1
$localIP = (Get-NetIPAddress -AddressFamily IPv4 | Where-Object { $_.InterfaceAlias -notmatch 'vEthernet|Loopback|Bluetooth|WSL' -and $_.IPAddress -notlike "169.254.*" -and $_.IPAddress -notlike "172.*" -and $_.IPAddress -notlike "127.*" }).IPAddress | Select-Object -First 1
$dockerIP = docker inspect my-asterisk --format='{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}'

Write-Host "   Windows Host IP: $localIP" -ForegroundColor White
Write-Host "   Docker Container IP: $dockerIP" -ForegroundColor White
Write-Host ""

# Check container status
Write-Host "🐳 Checking Docker Container..." -ForegroundColor Yellow
$containerStatus = docker ps --filter "name=my-asterisk" --format "{{.Status}}"
if ($containerStatus -match "Up") {
    Write-Host "   ✅ Container is running" -ForegroundColor Green
} else {
    Write-Host "   ❌ Container is NOT running!" -ForegroundColor Red
    exit 1
}
Write-Host ""

# Check port binding
Write-Host "🔌 Checking Port Bindings..." -ForegroundColor Yellow
$ports = docker port my-asterisk
Write-Host $ports -ForegroundColor Gray
Write-Host ""

# Check if port is actually listening
Write-Host "👂 Checking if Port 5060 is Listening..." -ForegroundColor Yellow
$listening = netstat -an | Select-String "5060"
if ($listening) {
    Write-Host "   ✅ Port 5060 is listening" -ForegroundColor Green
    $listening | ForEach-Object { Write-Host "   $_" -ForegroundColor Gray }
} else {
    Write-Host "   ❌ Port 5060 NOT listening!" -ForegroundColor Red
}
Write-Host ""

# Enable SIP debug
Write-Host "🔍 Enabling SIP Debug Logging..." -ForegroundColor Yellow
docker exec my-asterisk asterisk -rx "pjsip set logger on" > $null 2>&1
Write-Host "   ✅ Debug enabled" -ForegroundColor Green
Write-Host ""

# Check endpoints
Write-Host "📞 Checking Asterisk Endpoints..." -ForegroundColor Yellow
docker exec my-asterisk asterisk -rx "pjsip show endpoints"
Write-Host ""

# THE PROBLEM DETECTOR
Write-Host "╔════════════════════════════════════════════╗" -ForegroundColor Red
Write-Host "║  PROBLEM DETECTION                         ║" -ForegroundColor Red
Write-Host "╚════════════════════════════════════════════╝" -ForegroundColor Red
Write-Host ""

Write-Host "⚠️  LIKELY ISSUE: Docker UDP Forwarding" -ForegroundColor Yellow
Write-Host ""
Write-Host "Docker on Windows has issues with UDP localhost forwarding!" -ForegroundColor Yellow
Write-Host ""

# SOLUTION 1
Write-Host "╔════════════════════════════════════════════╗" -ForegroundColor Green
Write-Host "║  SOLUTION 1: Use Your Real IP Address     ║" -ForegroundColor Green
Write-Host "╚════════════════════════════════════════════╝" -ForegroundColor Green
Write-Host ""
Write-Host "In MicroSIP, CHANGE:" -ForegroundColor Yellow
Write-Host "   From: SIP Server = localhost" -ForegroundColor Red
Write-Host "   To:   SIP Server = $localIP" -ForegroundColor Green
Write-Host ""
Write-Host "Also CHANGE:" -ForegroundColor Yellow
Write-Host "   From: Domain = localhost" -ForegroundColor Red
Write-Host "   To:   Domain = $localIP" -ForegroundColor Green
Write-Host ""

# SOLUTION 2
Write-Host "╔════════════════════════════════════════════╗" -ForegroundColor Green
Write-Host "║  SOLUTION 2: Use Container IP Directly    ║" -ForegroundColor Green
Write-Host "╚════════════════════════════════════════════╝" -ForegroundColor Green
Write-Host ""
Write-Host "In MicroSIP, try:" -ForegroundColor Yellow
Write-Host "   SIP Server = $dockerIP" -ForegroundColor Green
Write-Host "   Domain     = $dockerIP" -ForegroundColor Green
Write-Host ""
Write-Host "⚠️  NOTE: This requires adding route or network mode change" -ForegroundColor Yellow
Write-Host ""

# SOLUTION 3
Write-Host "╔════════════════════════════════════════════╗" -ForegroundColor Green
Write-Host "║  SOLUTION 3: Restart with Host Network    ║" -ForegroundColor Green
Write-Host "╚════════════════════════════════════════════╝" -ForegroundColor Green
Write-Host ""
Write-Host "⚠️  WARNING: Host network mode doesn't fully work on Windows Docker Desktop" -ForegroundColor Red
Write-Host "   But we can try binding to specific IP..." -ForegroundColor Yellow
Write-Host ""

# Configuration Summary
Write-Host "╔════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║  RECOMMENDED MICROSIP SETTINGS             ║" -ForegroundColor Cyan
Write-Host "╚════════════════════════════════════════════╝" -ForegroundColor Cyan
Write-Host ""
Write-Host "DELETE your current account and create NEW with:" -ForegroundColor Yellow
Write-Host ""
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Gray
Write-Host "Account Name:  Asterisk Test" -ForegroundColor White
Write-Host ""
Write-Host "SIP Server:    $localIP" -ForegroundColor Green -NoNewline
Write-Host " ← USE THIS!" -ForegroundColor Yellow
Write-Host ""
Write-Host "Username:      1001" -ForegroundColor White
Write-Host ""
Write-Host "Password:      pass1001" -ForegroundColor White
Write-Host ""
Write-Host "Domain:        $localIP" -ForegroundColor Green -NoNewline
Write-Host " ← USE THIS!" -ForegroundColor Yellow
Write-Host ""
Write-Host "Login:         1001" -ForegroundColor White
Write-Host ""
Write-Host "Port:          5060" -ForegroundColor White
Write-Host ""
Write-Host "Transport:     UDP" -ForegroundColor White
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Gray
Write-Host ""

# Test connectivity
Write-Host "🧪 Testing Connectivity..." -ForegroundColor Yellow
Write-Host ""
Write-Host "1. Testing localhost:" -ForegroundColor White
$pingLocal = Test-NetConnection -ComputerName 127.0.0.1 -InformationLevel Quiet
if ($pingLocal) {
    Write-Host "   ✅ Can reach 127.0.0.1" -ForegroundColor Green
} else {
    Write-Host "   ❌ Cannot reach 127.0.0.1" -ForegroundColor Red
}

Write-Host "2. Testing your IP ($localIP):" -ForegroundColor White
$pingReal = Test-NetConnection -ComputerName $localIP -InformationLevel Quiet
if ($pingReal) {
    Write-Host "   ✅ Can reach $localIP" -ForegroundColor Green
} else {
    Write-Host "   ❌ Cannot reach $localIP" -ForegroundColor Red
}
Write-Host ""

# Create test file
Write-Host "💾 Creating config file for reference..." -ForegroundColor Yellow
$configText = @"
═══════════════════════════════════════════════
MICROSIP CONFIGURATION - $(Get-Date -Format "yyyy-MM-dd HH:mm")
═══════════════════════════════════════════════

YOUR WINDOWS IP: $localIP
DOCKER CONTAINER IP: $dockerIP

MICROSIP SETTINGS TO USE:
─────────────────────────────────────────────
Account Name:  Asterisk 1001

SIP Server:    $localIP    ← USE YOUR REAL IP!
               NOT "localhost"

Username:      1001
Password:      pass1001
Domain:        $localIP    ← SAME AS SIP SERVER!
Login:         1001
Port:          5060
Transport:     UDP

NETWORK TAB:
─────────────────────────────────────────────
Transport:     UDP
Port:          5060
☑ Use random port

AUDIO TAB:
─────────────────────────────────────────────
Codec:         PCMU (G.711u) ONLY
               Disable all others!

═══════════════════════════════════════════════

WHY THIS WORKS:
Docker on Windows has issues forwarding UDP from
localhost to containers. Using your real IP 
($localIP) bypasses this issue.

═══════════════════════════════════════════════
"@

$configText | Out-File -FilePath ".\MICROSIP-CONFIG-NOW.txt" -Encoding UTF8
Write-Host "   ✅ Saved to: MICROSIP-CONFIG-NOW.txt" -ForegroundColor Green
Write-Host ""

# Final instructions
Write-Host "╔════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║  NEXT STEPS                                ║" -ForegroundColor Cyan
Write-Host "╚════════════════════════════════════════════╝" -ForegroundColor Cyan
Write-Host ""
Write-Host "1. Open MicroSIP" -ForegroundColor White
Write-Host "2. DELETE your current account" -ForegroundColor White
Write-Host "3. Add NEW account with IP: $localIP" -ForegroundColor Green
Write-Host "4. Click OK and wait for green icon" -ForegroundColor White
Write-Host "5. Try to dial 999 for echo test" -ForegroundColor White
Write-Host ""
Write-Host "If it STILL doesn't work, run:" -ForegroundColor Yellow
Write-Host "   docker logs my-asterisk -f" -ForegroundColor White
Write-Host ""
Write-Host "Then try to register and watch for SIP traffic" -ForegroundColor Yellow
Write-Host ""
Write-Host "Press any key to continue..." -ForegroundColor Gray
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
