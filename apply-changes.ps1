# Apply Configuration Changes to Asterisk
# Run this after editing config files

param(
    [Parameter(Mandatory=$false)]
    [ValidateSet("restart", "pjsip", "dialplan", "voicemail", "all")]
    [string]$Action = "restart"
)

Write-Host "╔════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║  APPLY ASTERISK CONFIGURATION CHANGES ║" -ForegroundColor Cyan
Write-Host "╚════════════════════════════════════════╝" -ForegroundColor Cyan
Write-Host ""

# Check if container is running
$containerStatus = docker ps --filter "name=my-asterisk" --format "{{.Status}}"

if (-not $containerStatus) {
    Write-Host "❌ Container 'my-asterisk' is not running!" -ForegroundColor Red
    Write-Host "   Start it first: docker start my-asterisk" -ForegroundColor Yellow
    exit 1
}

Write-Host "✅ Container is running: $containerStatus" -ForegroundColor Green
Write-Host ""

# Perform action based on parameter
switch ($Action) {
    "restart" {
        Write-Host "🔄 Restarting container (safest option)..." -ForegroundColor Yellow
        docker restart my-asterisk
        Write-Host "✅ Container restarted successfully!" -ForegroundColor Green
        Start-Sleep -Seconds 3
    }
    "pjsip" {
        Write-Host "🔄 Reloading PJSIP configuration..." -ForegroundColor Yellow
        docker exec my-asterisk asterisk -rx "pjsip reload"
        Write-Host "✅ PJSIP configuration reloaded!" -ForegroundColor Green
    }
    "dialplan" {
        Write-Host "🔄 Reloading dialplan..." -ForegroundColor Yellow
        docker exec my-asterisk asterisk -rx "dialplan reload"
        Write-Host "✅ Dialplan reloaded!" -ForegroundColor Green
    }
    "voicemail" {
        Write-Host "🔄 Reloading voicemail configuration..." -ForegroundColor Yellow
        docker exec my-asterisk asterisk -rx "voicemail reload"
        Write-Host "✅ Voicemail configuration reloaded!" -ForegroundColor Green
    }
    "all" {
        Write-Host "🔄 Reloading all modules..." -ForegroundColor Yellow
        docker exec my-asterisk asterisk -rx "core reload"
        Write-Host "✅ All modules reloaded!" -ForegroundColor Green
    }
}

Write-Host ""
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Gray
Write-Host ""

# Verify changes
Write-Host "📋 Verifying configuration..." -ForegroundColor Cyan
Write-Host ""

# Show endpoints
Write-Host "Registered Endpoints:" -ForegroundColor Yellow
docker exec my-asterisk asterisk -rx "pjsip show endpoints" | Select-String "1001|1002|1003|Endpoint"

Write-Host ""

# Check for errors
Write-Host "Recent Logs (checking for errors):" -ForegroundColor Yellow
$recentLogs = docker logs my-asterisk --tail 10 2>&1 | Select-String -Pattern "ERROR|WARNING" -CaseSensitive

if ($recentLogs) {
    Write-Host "⚠️  Found warnings/errors:" -ForegroundColor Red
    $recentLogs | ForEach-Object { Write-Host "   $_" -ForegroundColor Red }
} else {
    Write-Host "✅ No errors found in recent logs" -ForegroundColor Green
}

Write-Host ""
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Gray
Write-Host ""
Write-Host "✅ Configuration applied successfully!" -ForegroundColor Green
Write-Host ""
Write-Host "💡 TIP: Test your changes by:" -ForegroundColor Cyan
Write-Host "   • Registering phones" -ForegroundColor Gray
Write-Host "   • Making test calls" -ForegroundColor Gray
Write-Host "   • Checking voicemail" -ForegroundColor Gray
Write-Host ""
