# ==================== STAGE 1: BUILD ====================
FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build
WORKDIR /src

# 1️⃣ Copy file csproj riêng trước để tận dụng cache layer của Docker
COPY *.csproj ./
RUN dotnet restore

# 2️⃣ Copy toàn bộ source code sau khi restore xong
COPY . ./

# 3️⃣ Build + Publish app (Release mode)
RUN dotnet publish -c Release -o /app/publish

# ==================== STAGE 2: RUNTIME ====================
FROM mcr.microsoft.com/dotnet/aspnet:9.0 AS runtime
WORKDIR /app

COPY --from=build /app/publish .

# 4️⃣ Cấu hình cổng chạy ứng dụng
ENV ASPNETCORE_URLS=http://+:8089
ENV ASPNETCORE_ENVIRONMENT=Development

EXPOSE 8089

ENTRYPOINT ["dotnet", "AuthService.dll"]
