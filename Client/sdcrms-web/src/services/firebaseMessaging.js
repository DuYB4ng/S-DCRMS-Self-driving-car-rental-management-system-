import { getMessaging, getToken, onMessage } from "firebase/messaging";
import { app } from "../firebase";
import { registerFCMToken } from "../api/fcmApi";

const messaging = getMessaging(app);

// Firebase Cloud Messaging VAPID key từ Firebase Console
// Project Settings > Cloud Messaging > Web Push certificates
const VAPID_KEY = import.meta.env.VITE_FIREBASE_VAPID_KEY;

/**
 * Request notification permission và lấy FCM token
 */
export const requestNotificationPermission = async () => {
  try {
    const permission = await Notification.requestPermission();

    if (permission === "granted") {
      console.log("✅ Notification permission granted");

      // Lấy FCM registration token
      const token = await getToken(messaging, {
        vapidKey: VAPID_KEY,
      });

      if (token) {
        console.log("✅ FCM Token:", token);

        // Đăng ký token với backend
        await registerFCMToken(token, "Web");
        console.log("✅ Token registered with backend");

        return token;
      } else {
        console.log("❌ No registration token available");
        return null;
      }
    } else {
      console.log("❌ Notification permission denied");
      return null;
    }
  } catch (error) {
    console.error("Error getting notification permission:", error);
    throw error;
  }
};

/**
 * Listen for foreground messages
 */
export const onMessageListener = () =>
  new Promise((resolve) => {
    onMessage(messaging, (payload) => {
      console.log("📬 Received foreground message:", payload);
      resolve(payload);
    });
  });

/**
 * Show notification trong app
 */
export const showNotification = (title, options) => {
  if ("Notification" in window && Notification.permission === "granted") {
    new Notification(title, options);
  }
};

/**
 * Setup FCM cho web app
 */
export const setupFCM = async () => {
  try {
    // Check if browser supports notifications
    if (!("Notification" in window)) {
      console.warn("⚠️ This browser does not support notifications");
      return null;
    }

    // Check if permission already granted
    if (Notification.permission === "granted") {
      const token = await getToken(messaging, { vapidKey: VAPID_KEY });
      if (token) {
        await registerFCMToken(token, "Web");
        return token;
      }
    }

    // Request permission
    return await requestNotificationPermission();
  } catch (error) {
    console.error("Error setting up FCM:", error);
    return null;
  }
};
