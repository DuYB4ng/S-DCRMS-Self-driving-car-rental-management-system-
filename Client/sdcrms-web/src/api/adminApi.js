import axiosClient from "./axiosClient";

const API_BASE = "/admin";

// Get all admins
export const getAllAdmins = async () => {
  const response = await axiosClient.get(API_BASE);
  return response.data;
};

// Get admin by ID
export const getAdminById = async (id) => {
  const response = await axiosClient.get(`${API_BASE}/${id}`);
  return response.data;
};

// Get dashboard statistics
export const getDashboardData = async () => {
  const response = await axiosClient.get(`${API_BASE}/dashboard`);
  return response.data;
};

// Create new admin
export const createAdmin = async (adminData) => {
  const response = await axiosClient.post(API_BASE, adminData);
  return response.data;
};

// Promote user to different role
export const promoteUser = async (userId, newRole) => {
  const response = await axiosClient.post(
    `${API_BASE}/promote-user/${userId}?newRole=${newRole}`
  );
  return response.data;
};

export default {
  getAllAdmins,
  getAdminById,
  getDashboardData,
  createAdmin,
  promoteUser,
};
