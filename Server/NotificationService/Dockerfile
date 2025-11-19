# NotificationService Dockerfile
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
WORKDIR /app
EXPOSE 5002

FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src
COPY ["SDCRMS.NotificationService.csproj", "."]
RUN dotnet restore "SDCRMS.NotificationService.csproj"
COPY . .
RUN dotnet build "SDCRMS.NotificationService.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "SDCRMS.NotificationService.csproj" -c Release -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
# Copy Firebase credentials
COPY FireBase /app/FireBase
ENV ASPNETCORE_URLS=http://+:5002
ENTRYPOINT ["dotnet", "SDCRMS.NotificationService.dll"]

