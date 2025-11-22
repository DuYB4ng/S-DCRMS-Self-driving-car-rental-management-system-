const API_BASE = "/api/payment";

// Lấy danh sách tất cả payment
export const getAllPayments = async () => {
  const res = await axiosClient.get(API_BASE);
  return res.data;
};

// Tạo mới payment
export const createPayment = async (data) => {
  const res = await axiosClient.post(API_BASE, data);
  return res.data;
};

// Cập nhật payment
export const updatePayment = async (id, data) => {
  const res = await axiosClient.put(`${API_BASE}/${id}`, data);
  return res.data;
};

// Xóa payment
export const deletePayment = async (id) => {
  const res = await axiosClient.delete(`${API_BASE}/${id}`);
  return res.data;
};
