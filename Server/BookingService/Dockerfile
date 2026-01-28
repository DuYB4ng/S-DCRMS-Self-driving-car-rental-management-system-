# ===== Stage 1: build =====
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

# 1) Copy csproj cho BookingService và Redis.Shared
COPY BookingService/BookingService.csproj BookingService/
COPY Redis.Shared/Redis.Shared.csproj Redis.Shared/

# 2) Restore theo csproj của BookingService (nó sẽ tự kéo luôn Redis.Shared)
RUN dotnet restore BookingService/BookingService.csproj

# 3) Copy toàn bộ source (folder Server) vào container
COPY . .
RUN ls -la /src/BookingService/Models

# 4) Publish
WORKDIR /src/BookingService
RUN dotnet publish -c Release -o /app/publish

# ===== Stage 2: runtime =====
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS runtime
WORKDIR /app

COPY --from=build /app/publish ./

ENV ASPNETCORE_URLS=http://+:8083
ENV ASPNETCORE_ENVIRONMENT=Development

EXPOSE 8083

ENTRYPOINT ["dotnet", "BookingService.dll"]
