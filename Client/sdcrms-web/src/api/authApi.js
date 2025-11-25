import axios from "axios";

const API_BASE = `${import.meta.env.VITE_API_BASE_URL}/auth`;

/**
 * Login Admin
 * @param {Object} credentials - { email, password }
 */
export const loginAdmin = async (credentials) => {
  const res = await axios.post(`${API_BASE}/login`, credentials);
  return res.data;
};

/**
 * Register new user (if needed)
 */
export const registerUser = async (userData) => {
  const res = await axios.post(`${API_BASE}/register`, userData);
  return res.data;
};

export default {
  loginAdmin,
  registerUser,
};
