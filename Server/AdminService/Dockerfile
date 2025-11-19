# AdminService Dockerfile
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
WORKDIR /app
EXPOSE 5001

FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src
COPY ["SDCRMS.AdminService.csproj", "."]
RUN dotnet restore "SDCRMS.AdminService.csproj"
COPY . .
RUN dotnet build "SDCRMS.AdminService.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "SDCRMS.AdminService.csproj" -c Release -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENV ASPNETCORE_URLS=http://+:5001
ENTRYPOINT ["dotnet", "SDCRMS.AdminService.dll"]

