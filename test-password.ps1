# MicroSIP Password Troubleshooting Script

Write-Host "╔════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║  MICROSIP PASSWORD TROUBLESHOOTER          ║" -ForegroundColor Cyan
Write-Host "╚════════════════════════════════════════════╝" -ForegroundColor Cyan
Write-Host ""

# Check 1: Container Status
Write-Host "1️⃣ Checking Docker Container..." -ForegroundColor Yellow
$containerStatus = docker ps --filter "name=my-asterisk" --format "{{.Status}}"

if ($containerStatus) {
    Write-Host "✅ Container is running: $containerStatus" -ForegroundColor Green
} else {
    Write-Host "❌ Container NOT running!" -ForegroundColor Red
    Write-Host "   Fix: docker start my-asterisk" -ForegroundColor Yellow
    exit 1
}
Write-Host ""

# Check 2: Auth Configuration
Write-Host "2️⃣ Checking Auth Configuration for 1001..." -ForegroundColor Yellow
$authConfig = docker exec my-asterisk asterisk -rx "pjsip show auth 1001" 2>$null

if ($authConfig -match "username=1001") {
    Write-Host "✅ Username configured: 1001" -ForegroundColor Green
} else {
    Write-Host "❌ Username NOT found!" -ForegroundColor Red
}

if ($authConfig -match "password=pass1001") {
    Write-Host "✅ Password configured: pass1001" -ForegroundColor Green
} else {
    Write-Host "⚠️  Password might be different!" -ForegroundColor Red
    Write-Host "   Current auth config:" -ForegroundColor Yellow
    Write-Host $authConfig
}
Write-Host ""

# Check 3: Endpoint Configuration
Write-Host "3️⃣ Checking Endpoint Configuration..." -ForegroundColor Yellow
$endpointConfig = docker exec my-asterisk asterisk -rx "pjsip show endpoint 1001" 2>$null

if ($endpointConfig -match "1001") {
    Write-Host "✅ Endpoint 1001 exists" -ForegroundColor Green
} else {
    Write-Host "❌ Endpoint 1001 NOT found!" -ForegroundColor Red
}
Write-Host ""

# Check 4: Port Listening
Write-Host "4️⃣ Checking if SIP Port is Open..." -ForegroundColor Yellow
$portCheck = netstat -an | Select-String "5060"

if ($portCheck) {
    Write-Host "✅ Port 5060 is listening" -ForegroundColor Green
    $portCheck | ForEach-Object { Write-Host "   $_" -ForegroundColor Gray }
} else {
    Write-Host "❌ Port 5060 NOT listening!" -ForegroundColor Red
}
Write-Host ""

# Check 5: Recent Errors
Write-Host "5️⃣ Checking for Recent Errors..." -ForegroundColor Yellow
$recentErrors = docker logs my-asterisk --tail 30 2>&1 | Select-String -Pattern "error|failed|401|403|407" -CaseSensitive:$false

if ($recentErrors) {
    Write-Host "⚠️  Found some errors/warnings:" -ForegroundColor Yellow
    $recentErrors | Select-Object -First 5 | ForEach-Object { Write-Host "   $_" -ForegroundColor Red }
} else {
    Write-Host "✅ No recent errors found" -ForegroundColor Green
}
Write-Host ""

# Check 6: Config File
Write-Host "6️⃣ Checking pjsip.conf File..." -ForegroundColor Yellow
$configPath = "C:\continer\work\code\asterisk-project\config\pjsip.conf"

if (Test-Path $configPath) {
    Write-Host "✅ Config file exists" -ForegroundColor Green
    
    $configContent = Get-Content $configPath -Raw
    
    if ($configContent -match "username=1001") {
        Write-Host "✅ Username 1001 found in config" -ForegroundColor Green
    }
    
    if ($configContent -match "password=pass1001") {
        Write-Host "✅ Password pass1001 found in config" -ForegroundColor Green
    } else {
        Write-Host "⚠️  Password might be different in config file!" -ForegroundColor Yellow
        Write-Host "   Check the file manually" -ForegroundColor Yellow
    }
    
    $lastModified = (Get-Item $configPath).LastWriteTime
    Write-Host "   Last modified: $lastModified" -ForegroundColor Gray
} else {
    Write-Host "❌ Config file NOT found!" -ForegroundColor Red
}
Write-Host ""

# Summary
Write-Host "╔════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║  DIAGNOSIS SUMMARY                         ║" -ForegroundColor Cyan
Write-Host "╚════════════════════════════════════════════╝" -ForegroundColor Cyan
Write-Host ""

Write-Host "📋 MicroSIP Settings to Use:" -ForegroundColor Yellow
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Gray
Write-Host "Account Name:  Asterisk 1001" -ForegroundColor White
Write-Host "SIP Server:    127.0.0.1" -ForegroundColor White
Write-Host "Username:      1001" -ForegroundColor White
Write-Host "Password:      pass1001" -ForegroundColor White -NoNewline
Write-Host " ← Copy this exactly!" -ForegroundColor Yellow
Write-Host "Domain:        127.0.0.1" -ForegroundColor White
Write-Host "Login:         1001" -ForegroundColor White
Write-Host "Port:          5060" -ForegroundColor White
Write-Host "Transport:     UDP" -ForegroundColor White
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Gray
Write-Host ""

Write-Host "💡 Common Fixes:" -ForegroundColor Cyan
Write-Host "   1. Restart Asterisk: docker restart my-asterisk" -ForegroundColor Gray
Write-Host "   2. Delete and re-add account in MicroSIP" -ForegroundColor Gray
Write-Host "   3. Make sure NO SPACES in password field" -ForegroundColor Gray
Write-Host "   4. Use 127.0.0.1 instead of localhost" -ForegroundColor Gray
Write-Host ""

# Enable debug logging
Write-Host "🔍 Enabling SIP Debug Logging..." -ForegroundColor Yellow
docker exec my-asterisk asterisk -rx "pjsip set logger on" > $null 2>&1
Write-Host "✅ Debug logging enabled" -ForegroundColor Green
Write-Host ""
Write-Host "Now try to register MicroSIP and run:" -ForegroundColor Cyan
Write-Host "   docker logs my-asterisk --tail 30" -ForegroundColor White
Write-Host "to see what's happening" -ForegroundColor Cyan
Write-Host ""
