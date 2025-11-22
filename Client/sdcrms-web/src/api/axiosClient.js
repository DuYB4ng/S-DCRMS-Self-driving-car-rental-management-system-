import axios from "axios";
import { auth } from "../utils/firebase";

const axiosClient = axios.create({
  baseURL: import.meta.env.VITE_API_BASE_URL,
  headers: { "Content-Type": "application/json" },
});

// Attach JWT token from localStorage (from Firebase Auth)
axiosClient.interceptors.request.use(
  async (config) => {
    // Get token from localStorage
    let token = localStorage.getItem("adminToken");

    // Refresh token nếu user đang login Firebase
    if (auth.currentUser) {
      try {
        // Force refresh token để luôn có token mới
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
  (error) => {
    return Promise.reject(error);
  }
);

axiosClient.interceptors.response.use(
  (response) => response,
  (error) => Promise.reject(error)
);

export default axiosClient;
