#!/usr/bin/env pwsh
# Script khởi động full stack SDCRMS

Write-Host "🚀 Starting SDCRMS Full Stack..." -ForegroundColor Cyan

# Chuyển về thư mục project
Set-Location $PSScriptRoot

# Build và start tất cả services
docker-compose -f docker-compose.simple.yml up -d --build

Write-Host ""
Write-Host "✅ All services started!" -ForegroundColor Green
Write-Host ""
Write-Host "📍 URLs:" -ForegroundColor Yellow
Write-Host "   Frontend:  http://localhost:5173"
Write-Host "   Gateway:   http://localhost:8000"
Write-Host "   Admin API: http://localhost:5001"
Write-Host "   Notif API: http://localhost:5002"
Write-Host ""
Write-Host "🔑 Default Admin Login:" -ForegroundColor Yellow
Write-Host "   Email:    admin@sdcrms.com"
Write-Host "   Password: Admin123@"
Write-Host ""
Write-Host "📊 View logs: docker-compose -f docker-compose.simple.yml logs -f" -ForegroundColor Cyan
Write-Host "🛑 Stop all:  docker-compose -f docker-compose.simple.yml down" -ForegroundColor Red
