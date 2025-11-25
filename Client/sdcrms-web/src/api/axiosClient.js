import axios from "axios";
import { auth } from "../firebase";

const axiosClient = axios.create({
  baseURL: import.meta.env.VITE_API_BASE_URL,
  headers: { "Content-Type": "application/json" },
});

// Attach JWT token from localStorage (from Firebase Auth)
axiosClient.interceptors.request.use(
  async (config) => {
    let token = localStorage.getItem("adminToken");
    // Nếu đang login Firebase, luôn refresh token mới nhất
    if (auth.currentUser) {
      try {
        token = await auth.currentUser.getIdToken(true);
        localStorage.setItem("adminToken", token);
      } catch (error) {
        console.error("Failed to refresh token:", error);
      }
    }
    if (token) {
      config.headers.Authorization = `Bearer ${token}`;
    }
    return config;
  },
  (error) => Promise.reject(error)
);

export default axiosClient;
