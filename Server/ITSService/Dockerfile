# ==================== STAGE 1: BUILD ====================
FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build
WORKDIR /src

# Copy file csproj
COPY *.csproj ./
RUN dotnet restore

# Copy source code
COPY . ./

# Build + Publish
RUN dotnet publish -c Release -o /app/publish

# ==================== STAGE 2: RUNTIME ====================
FROM mcr.microsoft.com/dotnet/aspnet:9.0 AS runtime
WORKDIR /app

# Copy from build stage
COPY --from=build /app/publish .

# Configure port
ENV ASPNETCORE_URLS=http://+:8090
ENV ASPNETCORE_ENVIRONMENT=Development

EXPOSE 8090

ENTRYPOINT ["dotnet", "ITSService.dll"]
