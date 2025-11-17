#!/bin/bash
set -e

echo "🚀 Starting SQL Server..."
/opt/mssql/bin/sqlservr &

echo "⏳ Waiting for SQL Server to start..."
# Đợi tới khi SQL chấp nhận kết nối
for i in {1..30}; do
  /opt/mssql-tools18/bin/sqlcmd -S localhost -U sa -P "YourStrong!Passw0rd" -Q "SELECT 1" -C &>/dev/null && break
  echo "   ... SQL chưa sẵn sàng, đợi thêm ($i)"
  sleep 2
done

echo "🗄️  Creating StaffDB if not exists..."
/opt/mssql-tools18/bin/sqlcmd -S localhost -U sa -P "YourStrong!Passw0rd" -Q "IF DB_ID('StaffDB') IS NULL CREATE DATABASE StaffDB;" -C

echo "✅ Initialization complete. Keeping container alive..."
wait
