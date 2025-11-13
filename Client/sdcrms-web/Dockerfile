# Stage 1: build
FROM node:20 AS build
WORKDIR /app

#copy package files de tan dung cache
COPY package*.json ./

#cai dependencies
RUN npm install

#copy toan bo source code
COPY . .

#build production
RUN npm run build

# Stage 2: Serve static files
FROM nginx:alpine
WORKDIR /usr/share/nginx/html

# Xóa file mặc định của nginx
RUN rm -rf ./*

# Copy file cấu hình Nginx tùy chỉnh (nếu có)
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Copy bản build từ stage 1
COPY --from=build /app/dist .

# Expose cổng
EXPOSE 80

# Run Nginx
CMD ["nginx", "-g", "daemon off;"]