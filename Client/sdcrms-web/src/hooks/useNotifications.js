import { useEffect, useState } from "react";
import {
  setupFCM,
  onMessageListener,
  showNotification,
} from "../services/firebaseMessaging";

/**
 * React Hook để quản lý FCM notifications
 */
export const useNotifications = () => {
  const [fcmToken, setFcmToken] = useState(null);
  const [notification, setNotification] = useState(null);
  const [isSupported, setIsSupported] = useState(true);

  useEffect(() => {
    // Setup FCM khi component mount
    const initFCM = async () => {
      try {
        if (!("Notification" in window)) {
          console.warn("Browser không hỗ trợ notifications");
          setIsSupported(false);
          return;
        }

        const token = await setupFCM();
        setFcmToken(token);
      } catch (error) {
        console.error("Error initializing FCM:", error);
      }
    };

    initFCM();

    // Listen for foreground messages
    onMessageListener()
      .then((payload) => {
        console.log("📬 Received notification:", payload);
        setNotification(payload);

        // Show notification
        if (payload.notification) {
          showNotification(payload.notification.title, {
            body: payload.notification.body,
            icon: "/logo.png",
            badge: "/badge.png",
          });
        }
      })
      .catch((err) => console.error("Failed to listen for messages:", err));
  }, []);

  return {
    fcmToken,
    notification,
    isSupported,
    clearNotification: () => setNotification(null),
  };
};
