import { useEffect, useState } from "react";
import { useNotifications } from "../hooks/useNotifications";
import { setupFCM } from "../services/firebaseMessaging";
import { Bell } from "lucide-react";

/**
 * Component hiển thị toast notification khi nhận FCM message
 */
export const NotificationToast = () => {
  const { notification, clearNotification } = useNotifications();

  useEffect(() => {
    if (notification) {
      // Auto hide sau 5 giây
      const timer = setTimeout(() => {
        clearNotification();
      }, 5000);

      return () => clearTimeout(timer);
    }
  }, [notification, clearNotification]);

  if (!notification?.notification) return null;

  return (
    <div className="fixed top-4 right-4 z-50 animate-slide-in">
      <div className="bg-white rounded-lg shadow-lg p-4 max-w-sm border-l-4 border-blue-500">
        <div className="flex items-start gap-3">
          <div className="flex-shrink-0">
            <Bell className="w-6 h-6 text-blue-500" />
          </div>
          <div className="flex-1">
            <h4 className="font-semibold text-gray-900 mb-1">
              {notification.notification.title}
            </h4>
            <p className="text-sm text-gray-600">
              {notification.notification.body}
            </p>
          </div>
          <button
            onClick={clearNotification}
            className="flex-shrink-0 text-gray-400 hover:text-gray-600"
          >
            ✕
          </button>
        </div>
      </div>
    </div>
  );
};

/**
 * Button để request notification permission
 */
export const EnableNotificationsButton = () => {
  const { isSupported, fcmToken } = useNotifications();
  const [isLoading, setIsLoading] = useState(false);

  if (!isSupported) {
    return null; // Browser không hỗ trợ
  }

  if (fcmToken) {
    return null; // Đã enable rồi
  }

  const handleEnable = async () => {
    setIsLoading(true);
    try {
      await setupFCM();
    } catch (error) {
      console.error("Error enabling notifications:", error);
    } finally {
      setIsLoading(false);
    }
  };

  return (
    <button
      onClick={handleEnable}
      disabled={isLoading}
      className="flex items-center gap-2 px-4 py-2 bg-blue-500 text-white rounded-lg hover:bg-blue-600 transition disabled:opacity-50"
    >
      <Bell className="w-4 h-4" />
      {isLoading ? "Đang bật..." : "Bật thông báo"}
    </button>
  );
};
