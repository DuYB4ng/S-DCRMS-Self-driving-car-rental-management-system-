# ==================== STAGE 1: BUILD ====================
FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build
WORKDIR /src

# 1️⃣ Copy firebase file TRƯỚC (để tận dụng cache)
COPY FireBase/FireBaseToken.json ./FireBaseToken.json

# 2️⃣ Copy file csproj riêng trước để tận dụng cache layer của Docker
COPY *.csproj ./
RUN dotnet restore

# 3️⃣ Copy toàn bộ source code sau khi restore xong
COPY . ./

# 4️⃣ Build + Publish app (Release mode)
RUN dotnet publish -c Release -o /app/publish

# ==================== STAGE 2: RUNTIME ====================
FROM mcr.microsoft.com/dotnet/aspnet:9.0 AS runtime
WORKDIR /app

# 5️⃣ Copy từ build stage
COPY --from=build /app/publish .
COPY --from=build /src/FireBase/FireBaseToken.json /app/FireBaseToken.json
# 6️⃣ Cấu hình cổng chạy ứng dụng
ENV ASPNETCORE_URLS=http://+:8089
ENV ASPNETCORE_ENVIRONMENT=Development

EXPOSE 8089

ENTRYPOINT ["dotnet", "AuthService.dll"]