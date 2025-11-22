import axios from "axios";

// Register FCM token
export const registerFCMToken = async (token, deviceType = "Web") => {
  try {
    const response = await axiosClient.post("/fcm/register", {
      token,
      deviceType,
    });
    return response.data;
  } catch (error) {
    console.error("Error registering FCM token:", error);
    throw error;
  }
};

// Unregister FCM token
export const unregisterFCMToken = async (token) => {
  try {
    const response = await axiosClient.delete("/fcm/unregister", {
      data: token,
    });
    return response.data;
  } catch (error) {
    console.error("Error unregistering FCM token:", error);
    throw error;
  }
};

// Get my FCM tokens
export const getMyFCMTokens = async () => {
  try {
    const response = await axiosClient.get("/fcm/my-tokens");
    return response.data;
  } catch (error) {
    console.error("Error fetching my FCM tokens:", error);
    throw error;
  }
};

// Get all FCM tokens (Admin only)
export const getAllFCMTokens = async () => {
  try {
    const response = await axiosClient.get("/fcm/all-tokens");
    return response.data;
  } catch (error) {
    console.error("Error fetching all FCM tokens:", error);
    throw error;
  }
};

// Cleanup inactive tokens (Admin only)
export const cleanupInactiveTokens = async () => {
  try {
    const response = await axiosClient.delete("/fcm/cleanup-inactive");
    return response.data;
  } catch (error) {
    console.error("Error cleaning up inactive tokens:", error);
    throw error;
  }
};
