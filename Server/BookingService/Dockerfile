# ===== Stage 1: build =====
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

COPY BookingService.csproj ./
RUN dotnet restore

COPY . ./
RUN dotnet publish "BookingService.csproj" -c Release -o /app/publish

# ===== Stage 2: runtime =====
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS runtime
WORKDIR /app

COPY --from=build /app/publish ./

ENV ASPNETCORE_URLS=http://+:8083
ENV ASPNETCORE_ENVIRONMENT=Development

EXPOSE 8083

ENTRYPOINT ["dotnet", "BookingService.dll"]
