// src/api/paymentApi.js
import api from "./client";

// Lấy toàn bộ payment (nếu cần dùng sau này)
export const getAllPayments = async () => {
  const res = await api.get("/api/payment");
  return res.data;
};

// Tạo payment mới gắn với 1 booking
export const createPayment = async (data) => {
  const res = await api.post("/api/payment", data);
  return res.data;
};
