import axios from "axios";
import { auth } from "../utils/firebase";

const axiosClient = axios.create({
  baseURL: import.meta.env.VITE_API_BASE_URL,
  headers: { "Content-Type": "application/json" },
});

// Gắn Firebase ID Token vào header Authorization
axiosClient.interceptors.request.use(async (config) => {
  const user = auth.currentUser;
  if (user) {
    const token = await user.getIdToken(); // Firebase tự refresh khi gần hết hạn
    config.headers.Authorization = `Bearer ${token}`;
  }
  return config;
});

export default axiosClient;
