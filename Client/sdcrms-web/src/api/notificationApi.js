import axiosClient from "./axiosClient";

// Get all notifications
export const getAllNotifications = async () => {
  const response = await axiosClient.get("/notification");
  return response.data;
};

// Get notification by ID
export const getNotificationById = async (id) => {
  const response = await axiosClient.get(`/notification/${id}`);
  return response.data;
};

// Get user notifications
export const getUserNotifications = async (userId) => {
  const response = await axiosClient.get(`/notification/user/${userId}`);
  return response.data;
};

// Create notification
export const createNotification = async (notificationData) => {
  const response = await axiosClient.post("/notification", notificationData);
  return response.data;
};

// Broadcast notification to all users
export const broadcastNotification = async (notificationData) => {
  const response = await axiosClient.post(
    "/notification/broadcast",
    notificationData
  );
  return response.data;
};

// Update notification
export const updateNotification = async (id, notificationData) => {
  const response = await axiosClient.put(
    `/notification/${id}`,
    notificationData
  );
  return response.data;
};

// Mark notification as read
export const markAsRead = async (id) => {
  const response = await axiosClient.put(`/notification/${id}/read`);
  return response.data;
};

// Delete notification
export const deleteNotification = async (id) => {
  const response = await axiosClient.delete(`/notification/${id}`);
  return response.data;
};
