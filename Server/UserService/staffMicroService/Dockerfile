# =========================
# STAGE 1: BUILD
# =========================
FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build
WORKDIR /src

# 1️⃣ Copy file csproj và restore dependencies trước (tối ưu cache layer)
COPY staffMicroService.csproj ./
RUN dotnet restore

# 2️⃣ Copy toàn bộ source code sau (để chỉ rebuild khi code thay đổi)
COPY . .

# 3️⃣ Build và publish ứng dụng
RUN dotnet publish -c Release -o /app/publish

# =========================
# STAGE 2: RUNTIME
# =========================
FROM mcr.microsoft.com/dotnet/aspnet:9.0 AS runtime
WORKDIR /app

# Copy kết quả build từ stage trước
COPY --from=build /app/publish .

# ✅ Thêm timezone và globalization để hiển thị tiếng Việt, ngày/giờ chính xác
RUN apt-get update && apt-get install -y --no-install-recommends tzdata \
    && rm -rf /var/lib/apt/lists/*

# Set timezone VN
ENV TZ=Asia/Ho_Chi_Minh

# ✅ Thiết lập biến môi trường cho ASP.NET Core
ENV ASPNETCORE_ENVIRONMENT=Development
ENV ASPNETCORE_URLS=http://+:8084
ENV DOTNET_SYSTEM_GLOBALIZATION_INVARIANT=false

# ✅ Cổng public trong container
EXPOSE 8084

# ✅ Điểm vào ứng dụng
ENTRYPOINT ["dotnet", "staffMicroService.dll"]
