// Firebase Cloud Messaging Service Worker
// This file must be in the /public folder

importScripts(
  "https://www.gstatic.com/firebasejs/10.7.1/firebase-app-compat.js"
);
importScripts(
  "https://www.gstatic.com/firebasejs/10.7.1/firebase-messaging-compat.js"
);

// Khởi tạo Firebase trong service worker
// Lấy config từ Firebase Console > Project Settings
firebase.initializeApp({
  apiKey: "YOUR_API_KEY",
  authDomain: "fir-dcrms.firebaseapp.com",
  projectId: "fir-dcrms",
  storageBucket: "fir-dcrms.firebasestorage.app",
  messagingSenderId: "YOUR_MESSAGING_SENDER_ID",
  appId: "YOUR_APP_ID",
});

const messaging = firebase.messaging();

// Handle background messages
messaging.onBackgroundMessage((payload) => {
  console.log("📬 Received background message:", payload);

  const notificationTitle = payload.notification?.title || "New Notification";
  const notificationOptions = {
    body: payload.notification?.body || "You have a new message",
    icon: "/logo.png",
    badge: "/badge.png",
    tag: payload.data?.notificationID || "default",
    data: payload.data,
  };

  self.registration.showNotification(notificationTitle, notificationOptions);
});

// Handle notification click
self.addEventListener("notificationclick", (event) => {
  console.log("🔔 Notification clicked:", event.notification);

  event.notification.close();

  // Mở hoặc focus vào app window
  event.waitUntil(
    clients
      .matchAll({ type: "window", includeUncontrolled: true })
      .then((clientList) => {
        // Nếu có window đang mở, focus vào nó
        for (const client of clientList) {
          if (client.url === "/" && "focus" in client) {
            return client.focus();
          }
        }

        // Nếu không, mở window mới
        if (clients.openWindow) {
          return clients.openWindow("/");
        }
      })
  );
});
