$ErrorActionPreference = "Stop"

function Get-LocalIPAddress {
    $ip = (Get-NetIPAddress -AddressFamily IPv4 | Where-Object { 
        $_.InterfaceAlias -notmatch "Loopback|vEthernet|WSL" -and $_.IPAddress -notmatch "^169\.254" 
    } | Select-Object -First 1).IPAddress
    return $ip
}

$newIP = Get-LocalIPAddress

if (-not $newIP) {
    Write-Host "Could not detect local IP address." -ForegroundColor Red
    exit 1
}

Write-Host "Detected Local IP: $newIP" -ForegroundColor Green

$filesToUpdate = @(
    "Client/ThueXe/lib/services/api_service.dart",
    "Client/ThueXe/lib/viewmodels/profile_viewmodel.dart",
    "Client/ThueXe/lib/services/smart_checkin_service.dart",
    "Server/BookingService/appsettings.json",
    "Server/UserService/appsettings.json"
)

# Regex to valid IPv4 address (simple version)
$ipRegex = "\b\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}\b"

foreach ($file in $filesToUpdate) {
    if (Test-Path $file) {
        $content = Get-Content $file -Raw
        if ($content -match $ipRegex) {
            $oldIPMatches = [regex]::Matches($content, $ipRegex)
            # Just take the first match as "old IP" relevant to this context if needed, 
            # or just regex replace all found IPs that look like local network IPs.
            # However, safer to just replace any IPv4 that is NOT 0.0.0.0 or 127.0.0.1 if we want to be generic
            # But the user specifically wants to replace the OLD wifi IP with NEW wifi IP.
            # Since we don't know the "Old" IP definitively without asking, 
            # we will assume the one currently in the file is the one to replace.
            
            # Strategy: Replace any IP that starts with 192.168 or 10. or 172. with the New IP.
            # Assuming standard private ranges.
            
            $newContent = $content -replace "192\.168\.\d{1,3}\.\d{1,3}", $newIP `
                                   -replace "172\.\d{1,3}\.\d{1,3}\.\d{1,3}", $newIP `
                                   -replace "10\.\d{1,3}\.\d{1,3}\.\d{1,3}", $newIP

            if ($content -ne $newContent) {
                 Set-Content -Path $file -Value $newContent -NoNewline
                 Write-Host "Updated: $file" -ForegroundColor Cyan
            } else {
                 Write-Host "No changes needed for: $file (IP might be already up to date)" -ForegroundColor Gray
            }
        } else {
            Write-Host "No IP pattern found in: $file" -ForegroundColor Yellow
        }
    } else {
        Write-Host "File not found: $file" -ForegroundColor Red
    }
}

Write-Host "`nAll files updated to IP: $newIP" -ForegroundColor Green
Write-Host "You should restart your Flutter app and Docker containers now."
Write-Host "Restart Docker command: docker-compose restart apigateway bookingservice userservice"
