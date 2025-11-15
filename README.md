# 🚗 S-DCRMS - Self-Driving Car Rental Management System

[![.NET](https://img.shields.io/badge/.NET-8.0-512BD4?logo=dotnet)](https://dotnet.microsoft.com/)
[![React](https://img.shields.io/badge/React-18.x-61DAFB?logo=react)](https://reactjs.org/)
[![Flutter](https://img.shields.io/badge/Flutter-3.38.1-02569B?logo=flutter)](https://flutter.dev/)
[![SQL Server](https://img.shields.io/badge/SQL%20Server-2022-CC2927?logo=microsoft-sql-server)](https://www.microsoft.com/sql-server)
[![Docker](https://img.shields.io/badge/Docker-Compose-2496ED?logo=docker)](https://www.docker.com/)

**Hệ thống quản lý cho thuê xe tự lái** | _Self-Driving Car Rental Management System_

> 📚 Academic Project - Object-Oriented Software Development Course  
> 🎓 University Assignment - Semester 2025

[System Diagram](https://app.diagrams.net/#G1BhdIVSWBMGQ57wZNI3nHC3cF-_3Z33-o#%7B%22pageId%22%3A%22h4wHcX7NKcpAACmK_krO%22%7D)

---

## 📋 Table of Contents

- [Overview](#-overview)
- [Tech Stack](#-tech-stack)
- [System Architecture](#-system-architecture)
- [Features](#-features)
- [Roadmap](#-roadmap)
- [Getting Started](#-getting-started)
- [Project Structure](#-project-structure)
- [API Documentation](#-api-documentation)
- [Team](#-team)

---

## 🎯 Overview

S-DCRMS provides a comprehensive platform for self-drive car rental operations, enabling seamless interactions between car owners, customers, staff, and administrators.

### Context

The demand for self-drive car rentals has grown rapidly due to:

- ✨ **Flexibility** - Rent anytime, anywhere
- 💰 **Cost-effectiveness** - No driver fees
- 🔒 **Privacy** - Independent travel experience
- 🌐 **Convenience** - Web & mobile accessibility

### Target Users

| Role          | Platform | Responsibilities                                |
| ------------- | -------- | ----------------------------------------------- |
| **Car Owner** | Mobile   | Manage cars, bookings, customers, payments      |
| **Customer**  | Mobile   | Search, book, review, pay for rentals           |
| **Staff**     | Web      | Support users, manage feedback, reports         |
| **Admin**     | Web      | System oversight, policies, compliance, revenue |

---

## 🛠️ Tech Stack

### Backend

```
🔹 Framework: ASP.NET Core 8.0
🔹 Database: SQL Server 2022
🔹 ORM: Entity Framework Core
🔹 Authentication: JWT (HS256)
🔹 Password Hashing: PBKDF2 (100k iterations)
🔹 Containerization: Docker + Docker Compose
🔹 Health Checks: Custom middleware
```

### Frontend - Web

```
⚛️ Framework: React 18.x
🎨 Styling: Tailwind CSS
⚡ Build Tool: Vite
🔄 State Management: React Hooks
📡 HTTP Client: Fetch API
🌐 Routing: React Router v6
```

### Frontend - Mobile

```
📱 Framework: Flutter 3.38.1
🏗️ Architecture: MVVM Pattern
📊 State Management: Provider
🌐 HTTP Client: Dio
💾 Local Storage: SharedPreferences
🎨 UI: Material Design 3
```

### DevOps & Tools

```
🐳 Docker Desktop
🔧 VS Code + Extensions
📝 Postman/Thunder Client (API Testing)
🗄️ SQL Server Management Studio
```

---

## 🏗️ System Architecture

```
┌─────────────────────────────────────────────────────────┐
│                    Client Layer                         │
├──────────────────────┬──────────────────────────────────┤
│   Web Application    │     Mobile Application          │
│   (React + Vite)     │     (Flutter + MVVM)            │
│   - Admin Portal     │     - Customer App              │
│   - Staff Dashboard  │     - Car Owner App             │
└──────────────────────┴──────────────────────────────────┘
                            ↕️ HTTPS/REST API
┌─────────────────────────────────────────────────────────┐
│              API Gateway / Load Balancer                │
└─────────────────────────────────────────────────────────┘
                            ↕️
┌─────────────────────────────────────────────────────────┐
│                  Microservices Layer                    │
├──────────────────────┬──────────────────────────────────┤
│  Admin Service       │   Notification Service          │
│  (Port: 5100)        │   (Port: 5200)                  │
│  - User Management   │   - Push Notifications          │
│  - Dashboard Stats   │   - Email/SMS Alerts            │
│  - System Monitoring │   - Real-time Updates           │
└──────────────────────┴──────────────────────────────────┘
                            ↕️
┌─────────────────────────────────────────────────────────┐
│                   Data Layer                            │
│          SQL Server 2022 (Docker Container)             │
│          - AdminDb (Admin & Users)                      │
│          - NotificationDb (Alerts & Messages)           │
└─────────────────────────────────────────────────────────┘
```

---

## ✨ Features

### 🔐 Admin Service (Completed)

#### Dashboard

- 📊 Total Admins count
- 👥 User statistics (mock data - User Service pending)
- 👨‍💼 Staff count (mock data)
- 🙋 Customer count (mock data)

#### Admin Management

- ✅ View all admins with details
- ✅ Create new admin (8-field form)
  - First Name, Last Name
  - Email, Password
  - Phone Number
  - Sex (Male/Female/Other)
  - Birthday (Date Picker)
  - Address
- ✅ Promote user to admin role
- ✅ Form validation & error handling

#### Authentication & Security

- ✅ JWT token generation (HS256)
- ✅ PBKDF2 password hashing
- ✅ Role-based authorization
- ✅ CORS configuration

### 🔔 Notification Service (Completed)

#### Features

- ✅ Create notifications (single & broadcast)
- ✅ View all notifications
- ✅ Filter by user ID
- ✅ Mark as read/unread
- ✅ Delete notifications
- ✅ Notification types (Info, Warning, Error, Success)
- ✅ Bulk insert optimization

#### Mobile UI

- 📱 Real-time notification list
- 🔴 Unread count badge
- 🎨 Color-coded by type
- ↔️ Swipe to delete
- 🕒 Timestamp formatting
- 🔄 Pull to refresh

### 🌐 Web Application (React)

#### Admin Portal

- ✅ Admin list with dashboard cards
- ✅ Create admin form with validation
- ✅ Responsive design (Tailwind CSS)
- ✅ Error boundaries & loading states
- ✅ Route: `/admin-management`

### 📱 Mobile Application (Flutter)

#### Architecture

- ✅ MVVM Pattern implemented
- ✅ Provider state management
- ✅ Repository pattern
- ✅ Clean separation of concerns

#### Screens

- 🔐 Login Page (form validation)
- 📋 Admin List Page (dashboard + list)
- ➕ Create Admin Page (8 fields)
- 🔔 Notification Page (list + actions)

#### Core Features

- ✅ API client with Dio
- ✅ JSON serialization
- ✅ Error handling
- ✅ Loading states
- ✅ Pull-to-refresh
- ✅ Form validation

---

## 🗺️ Roadmap

### ✅ Phase 1: Foundation (Completed)

- [x] Project setup & architecture design
- [x] Backend microservices (Admin, Notification)
- [x] SQL Server database schema
- [x] Docker containerization
- [x] Health checks & middleware
- [x] JWT authentication
- [x] CORS configuration
- [x] React web application
- [x] Flutter mobile app with MVVM
- [x] Admin management CRUD
- [x] Notification system

### 🚧 Phase 2: Core Features (In Progress)

- [ ] **User Service** (Customer, Staff, Car Owner)
  - [ ] User registration & authentication
  - [ ] Profile management
  - [ ] Role-based access control
- [ ] **Car Service**
  - [ ] Car listing & management
  - [ ] Car search & filters
  - [ ] Availability calendar
  - [ ] Pricing management
- [ ] **Booking Service**
  - [ ] Booking creation & management
  - [ ] Check-in/check-out flow
  - [ ] Booking status tracking
  - [ ] Cancellation policies
- [ ] **Payment Service**
  - [ ] Payment gateway integration
  - [ ] Transaction history
  - [ ] Invoice generation
  - [ ] Refund handling

### 📅 Phase 3: Advanced Features (Planned)

- [ ] **Review & Rating System**
  - [ ] Customer reviews
  - [ ] Rating aggregation
  - [ ] Review moderation
- [ ] **Reporting & Analytics**
  - [ ] Revenue reports
  - [ ] Booking statistics
  - [ ] User activity logs
  - [ ] Export to Excel/PDF
- [ ] **AI Integration (Optional)**
  - [ ] Chatbot for booking assistance
  - [ ] Dynamic pricing algorithm
  - [ ] Fraud detection
  - [ ] Smart recommendations
- [ ] **Real-time Features**
  - [ ] Push notifications (Firebase)
  - [ ] Live chat support
  - [ ] Real-time booking updates
- [ ] **Mobile Enhancements**
  - [ ] Offline mode
  - [ ] GPS tracking
  - [ ] QR code check-in
  - [ ] Biometric authentication

### 🎯 Phase 4: Testing & Deployment

- [ ] Unit testing (Backend)
- [ ] Widget testing (Flutter)
- [ ] Integration testing
- [ ] End-to-end testing
- [ ] Performance optimization
- [ ] Security audit
- [ ] CI/CD pipeline
- [ ] Production deployment

### 📚 Phase 5: Documentation

- [ ] Software Requirement Specification (SRS)
- [ ] System Architecture Document (SAD)
- [ ] API Documentation (Swagger)
- [ ] User Manual
- [ ] Installation Guide
- [ ] Test Plan & Results
- [ ] Deployment Guide

---

## 🚀 Getting Started

### Prerequisites

```bash
# Required
- Docker Desktop
- .NET 8.0 SDK
- Node.js 18+ & npm
- Flutter SDK 3.38+

# Optional
- SQL Server Management Studio
- Postman/Thunder Client
- Android Studio (for mobile emulator)
```

### Installation

#### 1️⃣ Clone Repository

```bash
git clone https://github.com/DuYB4ng/S-DCRMS-Self-driving-car-rental-management-system-.git
cd S-DCRMS-Self-driving-car-rental-management-system-
```

#### 2️⃣ Start Docker Services

```bash
# Start SQL Server + Admin Service
docker-compose up -d

# Check container status
docker ps

# View logs
docker logs sdcrms-admin-service
docker logs sdcrms-sqlserver
```

#### 3️⃣ Run React Web App

```bash
cd Client/sdcrms-web
npm install
npm run dev

# App runs at: http://localhost:5173
```

#### 4️⃣ Run Flutter Mobile App

```bash
cd Client/sdcrms-mobile

# Install dependencies
flutter pub get

# Run on Chrome (fastest for testing)
flutter run -d chrome

# Run on Android Emulator
flutter run

# Run on Windows Desktop
flutter run -d windows
```

### Configuration

#### Backend (appsettings.json)

```json
{
  "ConnectionStrings": {
    "AdminConnection": "Server=localhost,1433;Database=AdminDb;User Id=sa;Password=YourStrong@Passw0rd;TrustServerCertificate=True;"
  },
  "JwtSettings": {
    "Secret": "your-super-secret-key-min-32-chars",
    "Issuer": "SDCRMS",
    "Audience": "SDCRMSClient",
    "ExpirationHours": 24
  },
  "AllowedOrigins": ["http://localhost:5173"]
}
```

#### Mobile (api_constants.dart)

```dart
class ApiConstants {
  // Android Emulator
  static const String baseUrl = 'http://10.0.2.2:5100';

  // Physical Device (replace with your local IP)
  // static const String baseUrl = 'http://192.168.1.100:5100';
}
```

---

## 📂 Project Structure

```
S-DCRMS/
├── 📁 Server/                          # Backend ASP.NET Core
│   ├── Program.cs                      # App entry point
│   ├── 📁 Controllers/
│   │   ├── AdminController.cs          # Admin CRUD + Dashboard
│   │   ├── AuthController.cs           # JWT Authentication
│   │   └── NotificationController.cs   # Notification CRUD
│   ├── 📁 Models/
│   │   ├── Admin.cs                    # Admin entity
│   │   ├── Users.cs                    # Base user entity
│   │   ├── Notification.cs             # Notification entity
│   │   └── Enums/                      # User roles, status
│   ├── 📁 DTOs/
│   │   ├── Admin/                      # Admin DTOs
│   │   ├── Auth/                       # Auth DTOs
│   │   └── Notification/               # Notification DTOs
│   ├── 📁 DbContext/
│   │   └── AdminDbContext.cs           # EF Core context
│   ├── 📁 Services/
│   │   ├── AdminServices.cs            # Business logic
│   │   ├── JwtService.cs               # Token generation
│   │   ├── PasswordHasher.cs           # PBKDF2 hashing
│   │   └── NotificationServices.cs     # Notification logic
│   ├── 📁 Repositories/
│   │   ├── Admin/                      # Admin repository
│   │   └── NotificationRepository.cs   # Notification repo
│   └── 📁 Authorization/
│       └── AuthorizationExtensions.cs  # JWT config
│
├── 📁 Client/
│   ├── 📁 sdcrms-web/                  # React Web App
│   │   ├── index.html
│   │   ├── vite.config.js
│   │   ├── tailwind.config.js
│   │   └── 📁 src/
│   │       ├── App.jsx                 # Main app component
│   │       ├── routes.jsx              # React Router config
│   │       ├── 📁 pages/
│   │       │   ├── AdminPage.jsx       # Admin management
│   │       │   ├── Dashboard.jsx       # Dashboard
│   │       │   └── Login.jsx           # Login page
│   │       ├── 📁 components/          # Reusable components
│   │       ├── 📁 api/                 # API calls
│   │       └── 📁 styles/              # CSS files
│   │
│   └── 📁 sdcrms-mobile/               # Flutter Mobile App
│       ├── pubspec.yaml                # Flutter dependencies
│       └── 📁 lib/
│           ├── main.dart               # App entry point
│           ├── 📁 core/
│           │   ├── 📁 constants/
│           │   │   └── api_constants.dart
│           │   └── 📁 network/
│           │       └── api_client.dart # Dio HTTP client
│           ├── 📁 models/
│           │   ├── admin.dart          # Admin model
│           │   └── notification.dart   # Notification model
│           ├── 📁 services/
│           │   ├── admin_service.dart  # Admin API calls
│           │   └── notification_service.dart
│           ├── 📁 viewmodels/
│           │   ├── admin_viewmodel.dart     # Admin state
│           │   └── notification_viewmodel.dart
│           └── 📁 views/
│               ├── 📁 admin/
│               │   ├── admin_list_page.dart
│               │   └── create_admin_page.dart
│               ├── 📁 notification/
│               │   └── notification_page.dart
│               └── 📁 auth/
│                   └── login_page.dart
│
├── 📁 bin/                             # Build output
├── 📁 obj/                             # Temp build files
├── docker-compose.yaml                 # Docker services
├── Dockerfile                          # Backend container
├── SDCRMS.sln                          # Solution file
├── SDCRMS.csproj                       # Project file
├── appsettings.json                    # App configuration
└── README.md                           # This file
```

---

## 📡 API Documentation

### Base URL

```
http://localhost:5100/api
```

### Admin Endpoints

#### Get All Admins

```http
GET /Admin
Authorization: Bearer {token}

Response 200 OK:
[
  {
    "userID": 1,
    "firstName": "John",
    "lastName": "Doe",
    "email": "john.doe@admin.com",
    "phoneNumber": "+84123456789",
    "role": "Admin",
    "sex": "Male",
    "birthday": "1990-01-01T00:00:00",
    "address": "123 Main St, City",
    "createdAt": "2025-11-15T10:00:00"
  }
]
```

#### Get Dashboard Statistics

```http
GET /Admin/dashboard
Authorization: Bearer {token}

Response 200 OK:
{
  "totalAdmins": 5,
  "totalUsers": 0,
  "totalStaff": 0,
  "totalCustomers": 0
}
```

#### Create Admin

```http
POST /Admin/create
Content-Type: application/json

Request Body:
{
  "firstName": "Jane",
  "lastName": "Smith",
  "email": "jane.smith@admin.com",
  "password": "SecurePass123!",
  "phoneNumber": "+84987654321",
  "sex": "Female",
  "birthday": "1995-05-15T00:00:00",
  "address": "456 Oak Ave, District 1"
}

Response 200 OK:
{
  "message": "Admin created successfully",
  "adminId": 6
}
```

#### Promote User to Admin

```http
POST /Admin/promote/{userId}
Content-Type: application/json

Request Body:
{
  "newRole": "Admin"
}

Response 200 OK:
{
  "message": "User promoted successfully"
}
```

### Notification Endpoints

#### Get All Notifications

```http
GET /Notification
Authorization: Bearer {token}

Response 200 OK:
[
  {
    "notificationID": 1,
    "userID": 2,
    "title": "Booking Confirmed",
    "message": "Your booking #1234 has been confirmed",
    "isRead": false,
    "createdAt": "2025-11-15T14:30:00",
    "notificationType": "Info"
  }
]
```

#### Get User Notifications

```http
GET /Notification/user/{userId}
Authorization: Bearer {token}
```

#### Create Notification

```http
POST /Notification
Content-Type: application/json

Request Body:
{
  "userID": 2,
  "title": "Payment Reminder",
  "message": "Your payment is due tomorrow",
  "notificationType": "Warning"
}

Response 201 Created
```

#### Broadcast Notification

```http
POST /Notification/broadcast
Content-Type: application/json

Request Body:
{
  "userIDs": [1, 2, 3, 4, 5],
  "title": "System Maintenance",
  "message": "Scheduled maintenance tonight at 2 AM",
  "notificationType": "Info"
}

Response 200 OK
```

#### Mark as Read

```http
PUT /Notification/{id}/read
Authorization: Bearer {token}

Response 200 OK
```

#### Delete Notification

```http
DELETE /Notification/{id}
Authorization: Bearer {token}

Response 204 No Content
```

### Authentication

#### Login (TODO)

```http
POST /Auth/login
Content-Type: application/json

Request Body:
{
  "email": "admin@sdcrms.com",
  "password": "Admin123!"
}

Response 200 OK:
{
  "token": "eyJhbGc...",
  "expiresAt": "2025-11-16T10:00:00"
}
```

---

## 👥 Team

**Course**: Object-Oriented Software Development  
**Semester**: 2025  
**Branch**: `trieu`  
**Repository**: [S-DCRMS on GitHub](https://github.com/DuYB4ng/S-DCRMS-Self-driving-car-rental-management-system-)

---

## 📄 License

This project is an academic assignment and is not licensed for commercial use.

---

## 🤝 Contributing

This is a university project. Contributions are limited to team members only.

---

## 📞 Support

For questions or issues related to this project:

- 📧 Email: [triuu1212@gmail.com]
- 🐛 Issues: [GitHub Issues](https://github.com/DuYB4ng/S-DCRMS-Self-driving-car-rental-management-system-/issues)
- 📝 Pull Requests: [Active PR #2](https://github.com/DuYB4ng/S-DCRMS-Self-driving-car-rental-management-system-/pull/2)

---

<div align="center">

**Built with ❤️ using .NET, React, and Flutter**

[![GitHub](https://img.shields.io/badge/GitHub-DuYB4ng-181717?logo=github)](https://github.com/DuYB4ng)

</div>
