# SDCRMS - Self-Driving Car Rental Management System

## 🚀 Quick Start (1 lệnh duy nhất)

### Windows PowerShell:

```powershell
./start.ps1
```

Hoặc trực tiếp:

```powershell
docker-compose -f docker-compose.simple.yml up -d --build
```

### Dừng tất cả:

```powershell
./stop.ps1
```

---

## 📍 Services URLs

- **Frontend (Web Admin):** http://localhost:5173
- **API Gateway:** http://localhost:8000
- **Admin Service:** http://localhost:5001
- **Notification Service:** http://localhost:5002

---

## 🔑 Default Login

```
Email:    admin@sdcrms.com
Password: Admin123@
```

---

## 🐳 Docker Commands

```powershell
# Start all services
docker-compose -f docker-compose.simple.yml up -d --build

# View logs
docker-compose -f docker-compose.simple.yml logs -f

# View specific service logs
docker-compose -f docker-compose.simple.yml logs -f adminservice

# Stop all services
docker-compose -f docker-compose.simple.yml down

# Rebuild specific service
docker-compose -f docker-compose.simple.yml up -d --build web-client
```

---

## 🏗️ Architecture

```
Frontend (React + Vite) :5173
    ↓
API Gateway (Ocelot) :8000
    ↓
├─ Admin Service :5001
└─ Notification Service :5002
```

---

## ✅ Features

- ✅ Firebase Authentication (Login)
- ✅ Protected Routes (ProtectedRoute wrapper)
- ✅ JWT Token Authentication
- ✅ Firebase Cloud Messaging (Push Notifications)
- ✅ Microservices Architecture
- ✅ Docker Compose orchestration
- ✅ Logout functionality
- ✅ Auto redirect to /login when not authenticated

---

## 📦 Tech Stack

### Backend

- ASP.NET Core 8.0
- Entity Framework Core (In-Memory)
- Ocelot API Gateway
- Firebase Admin SDK
- JWT Authentication

### Frontend

- React 18
- Vite
- React Router v6
- Tailwind CSS
- Firebase Auth
- Axios

### DevOps

- Docker & Docker Compose
- Nginx (for static serving)

---

## 📝 Development

### Run with npm (development)

```powershell
cd Client/sdcrms-web
npm install
npm run dev
```

### Run backend services locally

```powershell
cd Server/AdminService
dotnet run

cd Server/NotificationService
dotnet run

cd Server/Gateway
dotnet run
```

---

## 🔧 TODO

- [ ] RBAC middleware cho backend
- [ ] Verify Firebase token ở backend
- [ ] Refresh Token flow
- [ ] Hiển thị features theo role
- [ ] MySQL database (hiện tại dùng In-Memory)

---

## 📄 License

MIT
