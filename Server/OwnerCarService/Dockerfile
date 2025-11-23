# Stage 1: build
FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build
WORKDIR /src

# Copy csproj files
COPY OwnerCarService/OwnerCarService.csproj OwnerCarService/
COPY Redis.Shared/Redis.Shared.csproj Redis.Shared/

# Restore only for OwnerCarService
RUN dotnet restore OwnerCarService/OwnerCarService.csproj

# Copy toàn bộ source
COPY . .

# Build + publish
WORKDIR /src/OwnerCarService
RUN dotnet publish -c Release -o /app/publish

# Stage 2: runtime
FROM mcr.microsoft.com/dotnet/aspnet:9.0 AS runtime
WORKDIR /app

COPY --from=build /app/publish .

ENV ASPNETCORE_URLS=http://+:8081
ENV ASPNETCORE_ENVIRONMENT=Development

EXPOSE 8081

ENTRYPOINT ["dotnet", "OwnerCarService.dll"]
