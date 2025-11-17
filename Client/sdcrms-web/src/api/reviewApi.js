// src/api/reviewApi.js
import api from "./client";

export const getAllReviews = async () => {
  const res = await api.get("/api/review");
  return res.data;
};

export const createReview = async (data) => {
  const res = await api.post("/api/review", data);
  return res.data;
};
