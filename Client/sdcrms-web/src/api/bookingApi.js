import api from "./client";

export const getAllBookings = async () => {
  const res = await api.get("/api/booking");
  return res.data;
};

export const createBooking = async (data) => {
  const res = await api.post("/api/booking", data);
  return res.data;
};

// (mới) cập nhật booking nếu cần sau này
export const updateBooking = async (id, data) => {
  const res = await api.put(`/api/booking/${id}`, data);
  return res.data;
};

// (mới) xoá booking
export const deleteBooking = async (id) => {
  await api.delete(`/api/booking/${id}`);
};
