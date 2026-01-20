$url = "http://localhost:8000/api/trafficsign/recognize"

$body = @{
    imageUrl = "https://example.com/test-sign.jpg"
    latitude = 10.762622
    longitude = 106.660172
    timestamp = (Get-Date).ToString("yyyy-MM-ddTHH:mm:ssZ")
} | ConvertTo-Json

Write-Host "📡 Sending request to ITS Service: $url"
Write-Host "📦 Payload: $body"

try {
    $response = Invoke-RestMethod -Uri $url -Method Post -Body $body -ContentType "application/json"
    Write-Host "`n✅ Response Received:" -ForegroundColor Green
    $response | Format-List
} catch {
    Write-Host "`n❌ Error:" -ForegroundColor Red
    Write-Host $_.Exception.Message
}
