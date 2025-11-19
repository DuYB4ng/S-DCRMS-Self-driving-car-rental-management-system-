#!/usr/bin/env pwsh
# Script dừng full stack SDCRMS

Write-Host "🛑 Stopping SDCRMS Full Stack..." -ForegroundColor Red

# Chuyển về thư mục project
Set-Location $PSScriptRoot

# Dừng tất cả services
docker-compose -f docker-compose.simple.yml down

Write-Host ""
Write-Host "✅ All services stopped!" -ForegroundColor Green
