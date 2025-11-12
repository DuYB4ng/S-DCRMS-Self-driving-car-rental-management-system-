# =========================
# STAGE 1: BUILD
# =========================
FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build
WORKDIR /src

# Copy file csproj và restore dependencies
COPY reiviewService.csproj ./
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

# Thiết lập environment (chạy trên cổng mặc định 80)
ENV ASPNETCORE_ENVIRONMENT=Development
ENV ASPNETCORE_URLS=http://+:8082
ENV DOTNET_SYSTEM_GLOBALIZATION_INVARIANT=false

# Expose cổng 80 (trong container)
EXPOSE 8082

ENTRYPOINT ["dotnet", "reiviewService.dll"]
