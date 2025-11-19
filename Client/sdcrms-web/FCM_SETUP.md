# 🔔 Hướng dẫn setup FCM cho Web

## 📋 Checklist Setup

### 1. **Cấu hình Firebase Console**

1. Vào [Firebase Console](https://console.firebase.google.com/project/fir-dcrms)
2. Project Settings > Cloud Messaging
3. Trong **Web Push certificates**, click **Generate key pair**
4. Copy **VAPID Key** (key pair này)

### 2. **Cấu hình Environment Variables**

Tạo file `.env.local` trong thư mục `sdcrms-web`:

```bash
# API Backend
VITE_API_BASE_URL=http://localhost:5100/api

# Firebase Config (lấy từ Firebase Console > Project Settings > General)
VITE_FIREBASE_API_KEY=AIza...
VITE_FIREBASE_AUTH_DOMAIN=fir-dcrms.firebaseapp.com
VITE_FIREBASE_PROJECT_ID=fir-dcrms
VITE_FIREBASE_STORAGE_BUCKET=fir-dcrms.firebasestorage.app
VITE_FIREBASE_MESSAGING_SENDER_ID=111461949750
VITE_FIREBASE_APP_ID=1:111461949750:web:...
VITE_FIREBASE_VAPID_KEY=BNx... (VAPID key từ bước 1)
```

### 3. **Cập nhật Service Worker**

Mở file `public/firebase-messaging-sw.js` và thay:

- `YOUR_API_KEY` → VITE_FIREBASE_API_KEY
- `YOUR_MESSAGING_SENDER_ID` → VITE_FIREBASE_MESSAGING_SENDER_ID
- `YOUR_APP_ID` → VITE_FIREBASE_APP_ID

### 4. **Register Service Worker trong App**

Thêm vào `main.jsx`:

```javascript
// Register service worker for FCM
if ("serviceWorker" in navigator) {
  navigator.serviceWorker
    .register("/firebase-messaging-sw.js")
    .then((registration) => {
      console.log("✅ Service Worker registered:", registration);
    })
    .catch((err) => {
      console.error("❌ Service Worker registration failed:", err);
    });
}
```

### 5. **Sử dụng trong Component**

```jsx
import { NotificationToast } from "./components/NotificationToast";

function App() {
  return (
    <>
      <NotificationToast />
      {/* Your app content */}
    </>
  );
}
```

## 🚀 Chạy Web App

```bash
cd Client/sdcrms-web
npm install
npm run dev
```

## 🧪 Test Notifications

### A. Test từ Frontend:

1. Mở web app
2. Click nút "Bật thông báo"
3. Allow notifications trong browser
4. FCM token sẽ tự động đăng ký với backend

### B. Test từ Backend:

```bash
# Gửi notification qua API
POST http://localhost:5100/api/notification
Authorization: Bearer <jwt_token>
Content-Type: application/json

{
  "userID": 123,
  "title": "Test Notification",
  "message": "This is a test message"
}
```

### C. Test Broadcast:

```bash
POST http://localhost:5100/api/notification/broadcast
Authorization: Bearer <admin_jwt_token>
Content-Type: application/json

{
  "title": "Broadcast Test",
  "message": "Sent to all users"
}
```

## 📱 API Endpoints Available

### Notification APIs:

- `GET /api/notification` - Get all notifications
- `GET /api/notification/{id}` - Get by ID
- `GET /api/notification/user/{userId}` - Get user notifications
- `POST /api/notification` - Create notification (Admin)
- `POST /api/notification/broadcast` - Broadcast (Admin)
- `PUT /api/notification/{id}` - Update notification
- `PUT /api/notification/{id}/read` - Mark as read
- `DELETE /api/notification/{id}` - Delete notification

### FCM Token APIs:

- `POST /api/fcm/register` - Register FCM token
- `DELETE /api/fcm/unregister` - Unregister token
- `GET /api/fcm/my-tokens` - Get my tokens
- `GET /api/fcm/all-tokens` - Get all tokens (Admin)
- `DELETE /api/fcm/cleanup-inactive` - Cleanup old tokens (Admin)

## 🔧 Troubleshooting

### Notifications không hiện?

1. Kiểm tra browser console có errors không
2. Verify service worker đã đăng ký: `chrome://serviceworker-internals`
3. Kiểm tra notification permission: `Notification.permission`
4. Test bằng cURL hoặc Postman trước

### FCM Token không register?

1. Kiểm tra VAPID key đúng chưa
2. Verify Firebase config trong `.env.local`
3. Xem network tab có API call `/api/fcm/register` không

### Background notifications không work?

1. Service worker phải được serve qua HTTPS (hoặc localhost)
2. Kiểm tra file `firebase-messaging-sw.js` có trong `/public`
3. Clear browser cache và unregister service worker cũ

## 📚 Files đã tạo:

- ✅ `src/api/fcmApi.js` - FCM API client
- ✅ `src/services/firebaseMessaging.js` - FCM service
- ✅ `src/hooks/useNotifications.js` - React hook
- ✅ `src/components/NotificationToast.jsx` - UI component
- ✅ `public/firebase-messaging-sw.js` - Service worker
- ✅ `.env.example` - Template environment variables
- ✅ `src/api/notificationApi.js` - Updated to use axiosClient
