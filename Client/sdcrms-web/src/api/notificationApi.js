const API_BASE_URL = "http://localhost:5100/api";

// Mock data for demo (remove when backend is ready)
const MOCK_NOTIFICATIONS = [
  {
    notificationID: 1,
    userID: 123,
    title: "🎉 Chào mừng bạn đến với SDCRMS",
    message:
      "Chúc mừng bạn đã đăng ký tài khoản thành công! Hãy khám phá các tính năng của chúng tôi.",
    createdAt: new Date().toISOString(),
    read: false,
    linkURL: "",
  },
  {
    notificationID: 2,
    userID: 123,
    title: "🚗 Xe mới có sẵn",
    message:
      "VinFast VF9 2023 vừa được thêm vào hệ thống với giá thuê 1.200.000đ/ngày.",
    createdAt: new Date(Date.now() - 3600000).toISOString(),
    read: false,
    linkURL: "",
  },
  {
    notificationID: 3,
    userID: 456,
    title: "✅ Đặt xe thành công",
    message:
      "Booking #BK001 của bạn đã được xác nhận. Thời gian nhận xe: 20/11/2025",
    createdAt: new Date(Date.now() - 7200000).toISOString(),
    read: true,
    linkURL: "",
  },
  {
    notificationID: 4,
    userID: 789,
    title: "💳 Thanh toán thành công",
    message: "Bạn đã thanh toán 1.500.000đ cho booking #BK002 qua MoMo.",
    createdAt: new Date(Date.now() - 86400000).toISOString(),
    read: true,
    linkURL: "",
  },
  {
    notificationID: 5,
    userID: 123,
    title: "⚠️ Nhắc nhở bảo trì",
    message:
      "Xe Toyota Vios (51A-12345) cần bảo trì định kỳ trong vòng 3 ngày tới.",
    createdAt: new Date(Date.now() - 172800000).toISOString(),
    read: false,
    linkURL: "",
  },
];

let mockNotifications = [...MOCK_NOTIFICATIONS];
let nextId = 6;

const USE_MOCK = true; // Set to false when backend is ready

// Get all notifications
export const getAllNotifications = async () => {
  if (USE_MOCK) {
    return new Promise((resolve) => {
      setTimeout(() => resolve([...mockNotifications]), 500);
    });
  }

  const response = await fetch(`${API_BASE_URL}/notification`);
  if (!response.ok) throw new Error("Failed to fetch notifications");
  return response.json();
};

// Get notification by ID
export const getNotificationById = async (id) => {
  if (USE_MOCK) {
    return new Promise((resolve, reject) => {
      setTimeout(() => {
        const notif = mockNotifications.find(
          (n) => n.notificationID === parseInt(id)
        );
        if (notif) resolve(notif);
        else reject(new Error("Notification not found"));
      }, 300);
    });
  }

  const response = await fetch(`${API_BASE_URL}/notification/${id}`);
  if (!response.ok) throw new Error("Failed to fetch notification");
  return response.json();
};

// Get user notifications
export const getUserNotifications = async (userId) => {
  if (USE_MOCK) {
    return new Promise((resolve) => {
      setTimeout(() => {
        const userNotifs = mockNotifications.filter(
          (n) => n.userID === parseInt(userId)
        );
        resolve(userNotifs);
      }, 500);
    });
  }

  const response = await fetch(`${API_BASE_URL}/notification/user/${userId}`);
  if (!response.ok) throw new Error("Failed to fetch user notifications");
  return response.json();
};

// Create notification
export const createNotification = async (notificationData) => {
  if (USE_MOCK) {
    return new Promise((resolve) => {
      setTimeout(() => {
        const newNotif = {
          notificationID: nextId++,
          userID: parseInt(notificationData.userID),
          title: notificationData.title,
          message: notificationData.message,
          createdAt: new Date().toISOString(),
          read: false,
          linkURL: "",
        };
        mockNotifications.unshift(newNotif);
        resolve(newNotif);
      }, 500);
    });
  }

  const response = await fetch(`${API_BASE_URL}/notification`, {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
    },
    body: JSON.stringify(notificationData),
  });
  if (!response.ok) throw new Error("Failed to create notification");
  return response.json();
};

// Broadcast notification to all users
export const broadcastNotification = async (notificationData) => {
  if (USE_MOCK) {
    return new Promise((resolve) => {
      setTimeout(() => {
        const userIds = [123, 456, 789, 101, 202]; // Mock user IDs
        const newNotifications = userIds.map((userId) => ({
          notificationID: nextId++,
          userID: userId,
          title: notificationData.title,
          message: notificationData.message,
          createdAt: new Date().toISOString(),
          read: false,
          linkURL: "",
        }));
        mockNotifications.unshift(...newNotifications);
        resolve({
          message: "Broadcasted successfully",
          count: newNotifications.length,
        });
      }, 500);
    });
  }

  const response = await fetch(`${API_BASE_URL}/notification/broadcast`, {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
    },
    body: JSON.stringify(notificationData),
  });
  if (!response.ok) throw new Error("Failed to broadcast notification");
  return response.json();
};

// Update notification
export const updateNotification = async (id, notificationData) => {
  if (USE_MOCK) {
    return new Promise((resolve, reject) => {
      setTimeout(() => {
        const index = mockNotifications.findIndex(
          (n) => n.notificationID === parseInt(id)
        );
        if (index !== -1) {
          mockNotifications[index] = {
            ...mockNotifications[index],
            title: notificationData.title,
            message: notificationData.message,
          };
          resolve(null);
        } else {
          reject(new Error("Notification not found"));
        }
      }, 500);
    });
  }

  const response = await fetch(`${API_BASE_URL}/notification/${id}`, {
    method: "PUT",
    headers: {
      "Content-Type": "application/json",
    },
    body: JSON.stringify(notificationData),
  });
  if (!response.ok) throw new Error("Failed to update notification");
  return response.status === 204 ? null : response.json();
};

// Mark notification as read
export const markAsRead = async (id) => {
  if (USE_MOCK) {
    return new Promise((resolve, reject) => {
      setTimeout(() => {
        const notif = mockNotifications.find(
          (n) => n.notificationID === parseInt(id)
        );
        if (notif) {
          notif.read = true;
          resolve(null);
        } else {
          reject(new Error("Notification not found"));
        }
      }, 300);
    });
  }

  const response = await fetch(`${API_BASE_URL}/notification/${id}/read`, {
    method: "PUT",
  });
  if (!response.ok) throw new Error("Failed to mark as read");
  return response.status === 204 ? null : response.json();
};

// Delete notification
export const deleteNotification = async (id) => {
  if (USE_MOCK) {
    return new Promise((resolve, reject) => {
      setTimeout(() => {
        const index = mockNotifications.findIndex(
          (n) => n.notificationID === parseInt(id)
        );
        if (index !== -1) {
          mockNotifications.splice(index, 1);
          resolve(null);
        } else {
          reject(new Error("Notification not found"));
        }
      }, 300);
    });
  }

  const response = await fetch(`${API_BASE_URL}/notification/${id}`, {
    method: "DELETE",
  });
  if (!response.ok) throw new Error("Failed to delete notification");
  return response.status === 204 ? null : response.json();
};
