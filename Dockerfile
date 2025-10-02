FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
WORKDIR /app
EXPOSE 5100
EXPOSE 443

# Cấu hình để app chạy trên port 5100
ENV ASPNETCORE_URLS=http://+:5100
ENV ASPNETCORE_HTTP_PORTS=
ENV ASPNETCORE_HTTPS_PORTS=


FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
ARG configuration=Release
WORKDIR /src
COPY ["SDCRMS.csproj", "./"]
RUN dotnet restore "SDCRMS.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "SDCRMS.csproj" -c $configuration -o /app/build

FROM build AS publish
ARG configuration=Release
RUN dotnet publish "SDCRMS.csproj" -c $configuration -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "SDCRMS.dll"]
