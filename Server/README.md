# SDCRMS Admin & Notification Microservice

## 📋 Overview

This is the Admin & Notification microservice for the Self-Driving Car Rental Management System (SDCRMS). It handles admin user management, authentication, and notification broadcasting.

## Features

### Admin Management

- ✅ JWT Authentication
- ✅ Password Hashing (PBKDF2)
- ✅ Role-based Authorization (Admin, Staff, Customer)
- ✅ CRUD operations for Admin users
- ✅ Dashboard with statistics
- ✅ User promotion (change roles)

### Notification Management

- ✅ Create notifications for specific users
- ✅ Broadcast notifications to all users
- ✅ Mark notifications as read
- ✅ Filter notifications by user
- ✅ CRUD operations

## Tech Stack

- **Framework**: ASP.NET Core 8.0
- **Database**: SQL Server 2022
- **ORM**: Entity Framework Core
- **Authentication**: JWT (JSON Web Tokens)
- **Containerization**: Docker & Docker Compose
- **API Documentation**: Swagger/OpenAPI

## Project Structure

```
Server/
├── Authorization/
│   └── AuthorizationExtensions.cs    # Role-based policies
├── Controllers/
│   ├── AdminController.cs            # Admin endpoints
│   ├── AuthController.cs             # Login/Register
│   └── NotificationController.cs     # Notification endpoints
├── Data/
│   └── AdminDbContextFactory.cs      # EF Core factory
├── DbContext/
│   ├── AdminDbContext.cs             # Admin DB context
│   └── AppDbContext.cs               # Legacy context
├── DTOs/
│   ├── Admin/                        # Admin DTOs
│   ├── Auth/                         # Auth DTOs
│   └── Notification/                 # Notification DTOs
├── Mapper/
│   ├── AdminMapper.cs                # Admin mappings
│   └── NotificationMapper.cs         # Notification mappings
├── Middleware/
│   └── RequestLoggingMiddleware.cs   # Request logging
├── Models/
│   ├── Admin.cs
│   ├── Notification.cs
│   ├── Users.cs
│   └── Enums/UserRole.cs
├── Repositories/
│   ├── Admin/AdminRepository.cs
│   └── NotificationRepository.cs
├── Services/
│   ├── AdminServices.cs
│   ├── JwtService.cs
│   ├── NotificationServices.cs
│   └── PasswordHasher.cs
├── Program.cs                        # Entry point
├── appsettings.json                  # Development config
└── appsettings.Production.json       # Production config
```

## Production (Docker)

Environment variables are set in `compose.yaml`

## Running the Service

### Local Development

```bash
cd Server
dotnet restore
dotnet run
```

Access Swagger: `http://localhost:5100/swagger`

### Docker Compose

```bash
# Build and run
docker-compose up --build

# Run in detached mode
docker-compose up -d

# Stop services
docker-compose down

# View logs
docker-compose logs -f admin-service
```

### Health Check

```bash
curl http://localhost:5100/health
```

## Authentication

### Register First Admin

```bash
POST http://localhost:5100/api/auth/register-admin
Content-Type: application/json

{
  "email": "admin@sdcrms.com",
  "password": "Admin123!",
  "firstName": "Admin",
  "lastName": "User",
  "phoneNumber": "+84123456789",
  "sex": "Male",
  "birthday": "1990-01-01",
  "address": "123 Street, City"
}
```

### Login

```bash
POST http://localhost:5100/api/auth/login
Content-Type: application/json

{
  "email": "admin@sdcrms.com",
  "password": "Admin123!"
}
```

Response includes JWT token:

```json
{
  "email": "admin@sdcrms.com",
  "role": "Admin",
  "firstName": "Admin",
  "lastName": "User",
  "token": "eyJhbGciOiJIUzI1NiIs..."
}
```

### Using JWT Token

Add to request headers:

```
Authorization: Bearer eyJhbGciOiJIUzI1NiIs...
```

## API Endpoints

### Admin Endpoints

| Method | Endpoint                                         | Description      | Auth  |
| ------ | ------------------------------------------------ | ---------------- | ----- |
| GET    | `/api/admin`                                     | Get all admins   | Admin |
| GET    | `/api/admin/{id}`                                | Get admin by ID  | Admin |
| GET    | `/api/admin/dashboard`                           | Get statistics   | Admin |
| POST   | `/api/admin`                                     | Create new admin | Admin |
| POST   | `/api/admin/promote-user/{userId}?newRole=Staff` | Promote user     | Admin |

### Notification Endpoints

| Method | Endpoint                          | Description              | Auth          |
| ------ | --------------------------------- | ------------------------ | ------------- |
| GET    | `/api/notification`               | Get all notifications    | Authenticated |
| GET    | `/api/notification/{id}`          | Get notification by ID   | Authenticated |
| GET    | `/api/notification/user/{userId}` | Get user's notifications | Authenticated |
| POST   | `/api/notification`               | Create notification      | Admin         |
| POST   | `/api/notification/broadcast`     | Broadcast to all users   | Admin         |
| PUT    | `/api/notification/{id}`          | Update notification      | Admin         |
| PUT    | `/api/notification/{id}/read`     | Mark as read             | Authenticated |
| DELETE | `/api/notification/{id}`          | Delete notification      | Admin         |

### Auth Endpoints

| Method | Endpoint                   | Description    | Auth     |
| ------ | -------------------------- | -------------- | -------- |
| POST   | `/api/auth/login`          | Login          | Public   |
| POST   | `/api/auth/register-admin` | Register admin | Public\* |

\*First admin can self-register, subsequent admins require existing admin authorization

## Security Features

- ✅ PBKDF2 password hashing (100,000 iterations)
- ✅ JWT token-based authentication
- ✅ Role-based authorization policies
- ✅ HTTPS support (production)
- ✅ SQL injection prevention (EF Core parameterized queries)
- ✅ CORS configuration

## Monitoring

### Health Check

```bash
GET /health
```

Returns 200 OK if service is healthy

### Logs

Request/Response logging via custom middleware

## 🐛 Troubleshooting

### Database Connection Issues

```bash
# Check SQL Server is running
docker ps | grep sqlserver

# View SQL Server logs
docker logs sdcrms-sqlserver
```

### Service Not Starting

```bash
# Check service logs
docker logs sdcrms-admin-service

# Rebuild image
docker-compose build --no-cache admin-service
```

## Next Steps

- [ ] Add distributed caching (Redis)
- [ ] Implement API Gateway (Ocelot/YARP)
- [ ] Add message queue (RabbitMQ)
- [ ] Implement circuit breaker (Polly)
- [ ] Add distributed tracing (OpenTelemetry)
- [ ] Setup CI/CD pipeline
- [ ] Add integration tests

## License

MIT License

## 👥 Contributors

- Trieu (Backend Developer)

---

Last Updated: ng.5 thg.11, 2025
