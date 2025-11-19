import axios from "axios";

const API_BASE = `${import.meta.env.VITE_API_BASE_URL}/OwnerCar`; // Đổi theo port thật

export const getAllOwnerCars = async () => {
  const res = await axios.get(`${API_BASE}`);
  return res.data;
};

export const createOwnerCar = async (data: any) => {
  const res = await axios.post(`${API_BASE}`, data);
  return res.data;
};

export const updateOwnerCar = async (id: number, data: any) => {
  const res = await axios.put(`${API_BASE}/${id}`, data);
  return res.data;
};

export const deleteOwnerCar = async (id: number) => {
  const res = await axios.delete(`${API_BASE}/${id}`);
  return res.data;
};
