import axiosClient from "./axiosClient";

// Lấy tất cả user
export const getAllUsers = async () => {
  const response = await axiosClient.get("/api/users");
  return response.data;
};

// Lấy tất cả admin (nếu backend có endpoint riêng)
export const getAllAdmins = async () => {
  const response = await axiosClient.get("/api/admins");
  return response.data;
};

// Đồng bộ user từ Firebase về DB
export const syncUser = async (userSyncDto) => {
  const response = await axiosClient.post("/api/users/sync", userSyncDto);
  return response.data;
};

export default axiosClient;
