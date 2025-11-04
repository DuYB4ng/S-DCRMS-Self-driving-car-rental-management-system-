# =========================
# STAGE 1: BUILD
# =========================
FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build
WORKDIR /src

# Copy file csproj và restore dependencies
COPY OwnerCarConsumer.csproj ./
RUN dotnet restore

# Copy toàn bộ source code
COPY . .

# Build và publish ứng dụng
RUN dotnet publish -c Release -o /app/publish


# =========================
# STAGE 2: RUNTIME
# =========================
FROM mcr.microsoft.com/dotnet/aspnet:9.0 AS runtime
WORKDIR /app

# Copy kết quả build từ stage build
COPY --from=build /app/publish .

# Thiết lập environment
ENV ASPNETCORE_ENVIRONMENT=Development
ENV ASPNETCORE_URLS=http://+:8089
ENV DOTNET_SYSTEM_GLOBALIZATION_INVARIANT=false

# Nếu cần cấu hình kết nối (nên override qua docker-compose)
# ENV KAFKA__BootstrapServers=kafka:9092
# ENV ConnectionStrings__DefaultConnection="Server=db;Database=TelemetryDB;User=sa;Password=YourStrong!Passw0rd;TrustServerCertificate=True"

# Consumer thường không expose port, nhưng để debug thì mở
EXPOSE 8089

ENTRYPOINT ["dotnet", "OwnerCarConsumer.dll"]
