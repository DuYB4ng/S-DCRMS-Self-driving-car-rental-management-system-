import axios from "axios";

const API_URL = "http://localhost:5000/api/admin";

export const adminApi = (token) =>
  axios.create({
    baseURL: API_URL,
    headers: {
      Authorization: `Bearer ${token}`,
      "Content-Type": "application/json",
    },
  });
