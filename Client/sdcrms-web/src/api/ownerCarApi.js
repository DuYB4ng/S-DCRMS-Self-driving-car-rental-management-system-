import axiosClient from "./axiosClient";

const API_BASE = "/OwnerCar";

export const getAllOwnerCars = async () => {
  const res = await axiosClient.get(API_BASE);
  return res.data;
};

export const createOwnerCar = async (data) => {
  const res = await axiosClient.post(API_BASE, data);
  return res.data;
};

export const updateOwnerCar = async (id, data) => {
  const res = await axiosClient.put(`${API_BASE}/${id}`, data);
  return res.data;
};

export const deleteOwnerCar = async (id) => {
  const res = await axiosClient.delete(`${API_BASE}/${id}`);
  return res.data;
};
