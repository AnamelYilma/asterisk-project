param()

$ErrorActionPreference = 'Stop'

Write-Host "ASTERISK / MICROSIP SANITY CHECK" -ForegroundColor Cyan
Write-Host ""

# 1) Container
$containerStatus = docker ps --filter "name=my-asterisk" --format "{{.Status}}"
if (-not $containerStatus) {
    Write-Host "Container my-asterisk is not running." -ForegroundColor Red
    Write-Host "Start it with: docker start my-asterisk" -ForegroundColor Yellow
    exit 1
}

Write-Host "Container: $containerStatus" -ForegroundColor Green

# 2) Detect the published SIP host port
$sipPortMapping = docker port my-asterisk 5060/udp 2>$null
$sipPortText = ($sipPortMapping | Out-String).Trim()
$sipHostPort = if ($sipPortText -match ':(\d+)$') { $Matches[1] } else { '5060' }
Write-Host "SIP host port: $sipHostPort" -ForegroundColor Green

# 3) Auth and endpoint objects
$authConfig = docker exec my-asterisk asterisk -rx "pjsip show auth auth1001" 2>$null
if ($authConfig -match 'auth1001/1001') {
    Write-Host "Auth object auth1001 is present." -ForegroundColor Green
} else {
    Write-Host "Auth object auth1001 was not found." -ForegroundColor Red
}

$endpointConfig = docker exec my-asterisk asterisk -rx "pjsip show endpoint 1001" 2>$null
if ($endpointConfig -match 'Endpoint:\s+1001') {
    Write-Host "Endpoint 1001 is present." -ForegroundColor Green
} else {
    Write-Host "Endpoint 1001 was not found." -ForegroundColor Red
}

# 4) Host port listening
$udpListening = Get-NetUDPEndpoint -LocalPort $sipHostPort -ErrorAction SilentlyContinue
if ($udpListening) {
    Write-Host "Host UDP port $sipHostPort is listening." -ForegroundColor Green
} else {
    Write-Host "Host UDP port $sipHostPort is not listening." -ForegroundColor Red
}

# 5) Recent errors
$recentErrors = docker logs my-asterisk --tail 30 2>&1 | Select-String -Pattern 'error|failed|401|403|407' -CaseSensitive:$false
if ($recentErrors) {
    Write-Host "Recent log warnings/errors:" -ForegroundColor Yellow
    $recentErrors | Select-Object -First 5 | ForEach-Object { Write-Host "  $_" -ForegroundColor Red }
} else {
    Write-Host "No recent errors found in logs." -ForegroundColor Green
}

Write-Host ""
Write-Host "Recommended MicroSIP settings for this host:" -ForegroundColor Cyan
Write-Host "Server:    127.0.0.1" -ForegroundColor White
Write-Host "Username:  1001" -ForegroundColor White
Write-Host "Password:  pass1001" -ForegroundColor White
Write-Host "Domain:    127.0.0.1" -ForegroundColor White
Write-Host "Port:      $sipHostPort" -ForegroundColor White
Write-Host "Transport: UDP" -ForegroundColor White

Write-Host ""
Write-Host "If registration still fails, run:" -ForegroundColor Cyan
Write-Host "docker logs my-asterisk --tail 30" -ForegroundColor White
Write-Host 'docker exec -it my-asterisk asterisk -rx "pjsip set logger on"' -ForegroundColor White
