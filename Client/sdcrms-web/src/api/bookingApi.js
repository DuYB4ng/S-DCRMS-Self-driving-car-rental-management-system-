import api from "./client";

export const getAllBookings = async () => {
  const res = await api.get("/api/booking");
  return res.data;
};

export const createBooking = async (data) => {
  const res = await api.post("/api/booking", data);
  return res.data;
};