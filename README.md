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

#### Tech Stack

- ⚛️ React 19.1.1 + Vite 7.1.7
- 🎨 Tailwind CSS 3.4.1
- 🔄 React Router 7.9.5
- 📡 Axios 1.13.1
- 🎯 Lucide React Icons
- 🔥 Firebase 12.5.0
- 🎨 Google Fonts (Poppins)

#### Design System

```css
Primary Color: #2E7D9A
Secondary Color: #F5F9FA
Success: #10B981
Warning: #F59E0B
Danger: #EF4444
Font: Poppins (Google Fonts)
```

#### Pages & Features

##### 1️⃣ Dashboard (`/dashboard`)

- ✅ Welcome banner with user greeting
- ✅ 4 key metrics cards:
  - 📊 Total Revenue with growth indicator
  - 🚗 Total Cars with fleet count
  - 📅 Total Bookings with trend
  - 👥 Total Customers with increase rate
- ✅ Fleet breakdown chart (Available, Rented, Maintenance)
- ✅ Quick access grid (6 main functions)
- ✅ Recent activities timeline
- ✅ Responsive grid layout

##### 2️⃣ Car Management (`/car-management`)

- ✅ **Full CRUD Operations**
  - ➕ Add new car (11-field modal form)
  - ✏️ Edit car details (pre-filled form)
  - 👁️ View car details (comprehensive modal)
  - 🗑️ Delete car (with confirmation)
- ✅ **Car List Features**
  - Search by name/brand
  - Filter by status (Available, Rented, Maintenance)
  - Status badges with color coding
  - Action buttons (View, Edit, Delete)
- ✅ **Detail Modal**
  - Full car specifications (2-column layout)
  - Gradient pricing card
  - Statistics section (trips, rating, revenue)
  - Car image display
  - Action buttons
- ✅ **Form Fields**
  - Name, Brand, Type, License Plate
  - Year, Price, Transmission
  - Seats, Fuel Type, Color
  - Status, Image URL
- ✅ Auto-generated Car IDs (CAR001, CAR002...)

##### 3️⃣ Notification Management (`/notification`)

- ✅ **CRUD Operations**
  - Create single notification
  - Broadcast to multiple users
  - Edit notification (title & message)
  - Mark as read/unread
  - Delete notification
- ✅ **Mock Data System**
  - USE_MOCK toggle for offline mode
  - 5 sample notifications
  - Realistic API delays (300-500ms)
  - Auto-increment IDs
- ✅ **Notification Types**
  - Info (blue badge)
  - Warning (yellow badge)
  - Error (red badge)
  - Success (green badge)
- ✅ **Features**
  - Filter by user ID
  - Unread count badge
  - Timestamp display
  - Color-coded by type
  - Action buttons (Edit, Delete, Mark as Read)

##### 4️⃣ Reports & Analytics (`/reports`)

- ✅ **Revenue Statistics**
  - Total revenue with trend
  - Average revenue per booking
  - Monthly growth percentage
  - Export functionality
- ✅ **Booking Trends**
  - Monthly booking chart
  - Peak season analysis
  - Booking vs cancellation rate
  - Progress bar visualization
- ✅ **Customer Statistics**
  - Total customers
  - New customers this month
  - Customer retention rate
  - Average bookings per customer
- ✅ **Top Performing Cars**
  - Ranked list with badges
  - Revenue per car
  - Booking count
  - Customer ratings
- ✅ **Payment Methods**
  - Credit card usage (45%)
  - Bank transfer (30%)
  - E-wallet (20%)
  - Cash (5%)
  - Progress bars with percentages
- ✅ **Compliance Metrics**
  - Active vehicles percentage
  - Insurance coverage
  - Maintenance completion
  - Documentation status
  - Circular progress indicators
- ✅ **Gradient Backgrounds**
  - 6 unique gradient combinations
  - Blue-green for bookings
  - Purple-pink for customers
  - Orange-yellow for top cars
  - Cyan-blue for payments
  - Green-emerald for compliance
- ✅ **Advanced Animations**
  - Staggered fade-in-up (100-150ms delays)
  - Slide-in-right for charts
  - Progress bar fill animations (1000-2000ms)
  - Hover scale & rotate effects
  - Smooth 60fps transitions
  - Reduced motion support

##### 5️⃣ Admin Management (`/admin-management`)

- ✅ Admin list with dashboard cards
- ✅ Create admin form (8 fields)
- ✅ Form validation
- ✅ Role-based access
- ✅ API integration

##### 6️⃣ User Management (`/user-management`)

- 🚧 User CRUD (In Progress)
- 🚧 Role assignment
- 🚧 User profile viewing

##### 7️⃣ Booking Management (`/booking-management`)

- 📅 Planned: Booking list & details
- 📅 Planned: Status tracking
- 📅 Planned: Check-in/check-out

##### 8️⃣ Payment Management (`/payment-management`)

- 💳 Planned: Transaction history
- 💳 Planned: Invoice generation
- 💳 Planned: Refund processing

##### 9️⃣ Settings (`/settings`)

- ⚙️ System configuration
- ⚙️ User preferences
- ⚙️ Security settings

##### 🔟 Profile (`/profile`)

- 👤 User profile editing
- 👤 Password change
- 👤 Activity log

#### Shared Components

##### Layout

- ✅ **Sidebar Navigation**
  - Collapsible on mobile
  - Active route highlighting
  - Icon + text labels
  - Smooth transitions
  - Logout button
- ✅ **Header**
  - Menu toggle (mobile)
  - Search bar (desktop)
  - Notification bell with badge
  - User profile dropdown
  - Gradient background (#2E7D9A)
- ✅ **Breadcrumbs** (if needed)

##### UI Components

- ✅ **Cards** - Gradient backgrounds with hover effects
- ✅ **Modals** - Create, Edit, Detail, Delete confirmations
- ✅ **Forms** - Validation, error handling, loading states
- ✅ **Buttons** - Primary, secondary, danger variants
- ✅ **Badges** - Status indicators with color coding
- ✅ **Tables** - Sortable, searchable, filterable
- ✅ **Charts** - Progress bars, stat cards
- ✅ **Icons** - Lucide React icon library

#### Animation System

##### Keyframe Animations (index.css)

```css
@keyframes fade-in-up - opacity 0→1, translateY 20px→0
@keyframes slide-in-right - opacity 0→1, translateX -30px→0
@keyframes progress-fill - width 0%→100%
@keyframes draw-circle - SVG stroke animation;
```

##### Timing & Delays

- Base duration: 600ms (fade/slide)
- Progress bars: 1000-2000ms
- Stagger delays: 100-150ms
- Hover transitions: 300-500ms
- Easing: cubic-bezier(0.4, 0, 0.2, 1)

##### Micro-interactions

- Hover scale (1.05-1.1x)
- Hover rotate (6 degrees)
- Shadow elevation on hover
- Active state scale (0.95x)
- Button press feedback

#### API Integration

##### Mock Data System

- ✅ USE_MOCK toggle for offline development
- ✅ Realistic API delays (300-500ms)
- ✅ Full CRUD simulation
- ✅ Auto-increment IDs
- ✅ Sample data for testing

##### API Services

- `/api/adminApi.js` - Admin CRUD operations
- `/api/notificationApi.js` - Notification CRUD with mock support
- `/api/carApi.js` - Car management (planned)
- `/api/bookingApi.js` - Booking operations (planned)

#### Responsive Design

- ✅ Mobile-first approach
- ✅ Breakpoints:
  - `sm`: 640px
  - `md`: 768px
  - `lg`: 1024px
  - `xl`: 1280px
  - `2xl`: 1536px
- ✅ Collapsible sidebar on mobile
- ✅ Responsive grid layouts
- ✅ Touch-friendly buttons (min 44px)
- ✅ Optimized for tablets & desktop

#### Performance Optimizations

- ✅ Code splitting with React Router
- ✅ Lazy loading for routes
- ✅ Optimized images (Unsplash placeholders)
- ✅ CSS purging with Tailwind
- ✅ Vite HMR for fast development
- ✅ Custom scrollbar (8px width)

#### Accessibility Features

- ✅ Semantic HTML elements
- ✅ ARIA labels for icons
- ✅ Keyboard navigation support
- ✅ Focus visible outlines
- ✅ Color contrast compliance (WCAG 2.1)
- ✅ Reduced motion support (`prefers-reduced-motion`)
- ✅ Screen reader friendly

#### Development Tools

- ✅ Vite dev server (localhost:5175)
- ✅ Hot Module Replacement (HMR)
- ✅ PostCSS for Tailwind processing
- ✅ ESLint configuration
- ✅ Environment variables (.env)

#### Build & Deployment

```bash
# Development
npm run dev

# Build for production
npm run build

# Preview production build
npm run preview

# Run tests (if configured)
npm run test
```

#### Future Enhancements

- 📅 Real-time updates with WebSocket
- 📅 PDF export for reports
- 📅 Advanced filtering & sorting
- 📅 Data visualization with Chart.js
- 📅 Internationalization (i18n)
- 📅 Dark mode support
- 📅 Offline PWA capabilities
- 📅 Image upload with compression

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
