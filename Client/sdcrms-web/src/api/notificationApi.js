const API_BASE_URL = "http://localhost:5100/api";

// Get all notifications
export const getAllNotifications = async () => {
  const response = await fetch(`${API_BASE_URL}/notification`);
  if (!response.ok) throw new Error("Failed to fetch notifications");
  return response.json();
};

// Get notification by ID
export const getNotificationById = async (id) => {
  const response = await fetch(`${API_BASE_URL}/notification/${id}`);
  if (!response.ok) throw new Error("Failed to fetch notification");
  return response.json();
};

// Get user notifications
export const getUserNotifications = async (userId) => {
  const response = await fetch(`${API_BASE_URL}/notification/user/${userId}`);
  if (!response.ok) throw new Error("Failed to fetch user notifications");
  return response.json();
};

// Create notification
export const createNotification = async (notificationData) => {
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
  const response = await fetch(`${API_BASE_URL}/notification/${id}/read`, {
    method: "PUT",
  });
  if (!response.ok) throw new Error("Failed to mark as read");
  return response.status === 204 ? null : response.json();
};

// Delete notification
export const deleteNotification = async (id) => {
  const response = await fetch(`${API_BASE_URL}/notification/${id}`, {
    method: "DELETE",
  });
  if (!response.ok) throw new Error("Failed to delete notification");
  return response.status === 204 ? null : response.json();
};
