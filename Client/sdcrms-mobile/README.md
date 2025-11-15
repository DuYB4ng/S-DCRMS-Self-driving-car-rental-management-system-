# SDCRMS Mobile App

Flutter mobile application for Self-Driving Car Rental Management System using MVVM architecture.

## 🏗️ Architecture

This app follows the **MVVM (Model-View-ViewModel)** pattern:

```
lib/
├── core/
│   ├── constants/
│   │   └── api_constants.dart      # API base URL and endpoints
│   └── network/
│       └── api_client.dart         # Dio HTTP client singleton
├── models/
│   ├── admin.dart                  # Admin model with JSON serialization
│   └── notification.dart           # Notification model
├── services/
│   ├── admin_service.dart          # Admin API calls
│   └── notification_service.dart   # Notification API calls
├── viewmodels/
│   ├── admin_viewmodel.dart        # Admin state management
│   └── notification_viewmodel.dart # Notification state management
├── views/
│   ├── admin/
│   │   ├── admin_list_page.dart    # Admin list with dashboard
│   │   └── create_admin_page.dart  # Create admin form
│   ├── notification/
│   │   └── notification_page.dart  # Notification list
│   └── auth/
│       └── login_page.dart         # Login screen
└── main.dart                       # App entry point
```

## 📱 Features

### Admin Management
- ✅ Dashboard with statistics (Total Admins, Users, Staff, Customers)
- ✅ View all admins with details
- ✅ Create new admin with complete form validation
- ✅ Pull-to-refresh functionality
- ✅ Loading states and error handling

### Notifications
- ✅ View all notifications
- ✅ Unread count badge
- ✅ Mark as read functionality
- ✅ Swipe to delete
- ✅ Color-coded notification types (Info, Warning, Error, Success)
- ✅ Timestamp formatting

### Authentication
- ✅ Login screen with email/password
- ✅ Form validation
- ✅ Password visibility toggle
- ⚠️ JWT authentication (TODO: integrate with backend)

## 🛠️ Setup Instructions

### Prerequisites
1. **Install Flutter SDK**
   - Download from: https://docs.flutter.dev/get-started/install
   - Extract to `C:\src\flutter`
   - Add `C:\src\flutter\bin` to PATH
   - Run `flutter doctor` to verify installation

2. **Backend Requirements**
   - ASP.NET Core backend running at `localhost:5100`
   - Docker containers (SQL Server + Admin Service) must be running

### Installation Steps

1. **Navigate to project directory**
   ```bash
   cd "d:\Trifuu\các môn học\XD phần mềm hướng đối tượng\Project\Client\sdcrms_mobile"
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Generate JSON serialization code** (if needed)
   ```bash
   flutter pub run build_runner build
   ```

4. **Run the app**
   ```bash
   # Android Emulator
   flutter run

   # Physical Device
   flutter run -d <device-id>
   ```

## 🌐 Network Configuration

### Android Emulator
- Backend URL: `http://10.0.2.2:5100`
- The emulator maps `10.0.2.2` to the host machine's `localhost`

### Physical Device
- Update `lib/core/constants/api_constants.dart`:
  ```dart
  static const String baseUrl = 'http://<YOUR_LOCAL_IP>:5100';
  ```
- Find your local IP: `ipconfig` (Windows) or `ifconfig` (Mac/Linux)

## 📦 Dependencies

### Production
- `provider: ^6.1.1` - State management
- `dio: ^5.4.0` - HTTP client
- `json_annotation: ^4.8.1` - JSON serialization annotations
- `shared_preferences: ^2.2.2` - Local storage
- `intl: ^0.19.0` - Date formatting
- `logger: ^2.0.2` - Logging

### Development
- `flutter_lints: ^3.0.0` - Linting rules
- `build_runner: ^2.4.7` - Code generation
- `json_serializable: ^6.7.1` - JSON code generator

## 🎯 API Endpoints

### Admin Endpoints
- `GET /api/Admin` - Get all admins
- `GET /api/Admin/dashboard` - Get dashboard statistics
- `POST /api/Admin/create` - Create new admin
- `POST /api/Admin/promote/{userId}` - Promote user to admin

### Notification Endpoints
- `GET /api/Notification` - Get all notifications
- `GET /api/Notification/user/{userId}` - Get user notifications
- `POST /api/Notification` - Create notification
- `PUT /api/Notification/{id}/read` - Mark as read
- `DELETE /api/Notification/{id}` - Delete notification

## 🧪 Testing

```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage
```

## 🚀 Build

### Android APK
```bash
flutter build apk --release
```

### Android App Bundle (for Play Store)
```bash
flutter build appbundle --release
```

### iOS (requires macOS)
```bash
flutter build ios --release
```

## 📝 TODO

- [ ] Implement JWT authentication with backend
- [ ] Add token storage and refresh logic
- [ ] Implement user profile screen
- [ ] Add pagination for admin list
- [ ] Add search and filter functionality
- [ ] Implement push notifications
- [ ] Add offline mode with local caching
- [ ] Add unit tests and widget tests
- [ ] Add integration tests

## 🐛 Troubleshooting

### Common Issues

1. **"Failed to fetch" error**
   - Ensure backend is running at `localhost:5100`
   - Check Docker containers: `docker ps`
   - Verify API URL in `api_constants.dart`

2. **Build errors**
   - Run `flutter clean`
   - Run `flutter pub get`
   - Rebuild the app

3. **Network errors on physical device**
   - Update base URL to your local IP address
   - Ensure device is on the same network as development machine

## 📄 License

This project is part of an academic assignment for Object-Oriented Software Development course.
