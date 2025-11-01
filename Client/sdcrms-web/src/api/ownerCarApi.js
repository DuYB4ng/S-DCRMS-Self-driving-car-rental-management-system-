import axios from "axios";

const API_BASE = "http://localhost:5188/api/OwnerCar"; // Đổi theo port thật

export const getAllOwnerCars = async () => {
  const res = await axios.get(`${API_BASE}`);
  return res.data;
};

export const createOwnerCar = async (data) => {
  const res = await axios.post(`${API_BASE}`, data);
  return res.data;
};

export const updateOwnerCar = async (id, data) => {
  const res = await axios.put(`${API_BASE}/${id}`, data);
  return res.data;
};

export const deleteOwnerCar = async (id) => {
  const res = await axios.delete(`${API_BASE}/${id}`);
  return res.data;
};
