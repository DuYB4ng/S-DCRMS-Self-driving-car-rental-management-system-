# ===== Stage 1: build =====
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

COPY CustomerService.csproj ./
RUN dotnet restore

COPY . ./
RUN dotnet publish "CustomerService.csproj" -c Release -o /app/publish

# ===== Stage 2: runtime =====
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS runtime
WORKDIR /app

COPY --from=build /app/publish ./

ENV ASPNETCORE_URLS=http://+:8085
ENV ASPNETCORE_ENVIRONMENT=Development

EXPOSE 8085

ENTRYPOINT ["dotnet", "CustomerService.dll"]