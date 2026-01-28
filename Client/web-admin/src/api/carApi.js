import axiosClient from "./axiosClient";

// Car APIs
export const getAllCars = async () => {
  return await axiosClient.get("/car");
};

export const getCarById = async (id) => {
  return await axiosClient.get(`/car/${id}`);
};

export const createCar = async (data) => {
  return await axiosClient.post("/car", data);
};

export const updateCar = async (id, data) => {
  return await axiosClient.put(`/car/${id}`, data);
};

export const deleteCar = async (id) => {
  return await axiosClient.delete(`/car/${id}`);
};

export const getAvailableCars = async () => {
  return await axiosClient.get("/car/available");
};

// Maintenance APIs
export const getAllMaintenances = async () => {
  return await axiosClient.get("/maintenance");
};

// Owner APIs
export const getAllOwnerCars = async () => {
    return await axiosClient.get("/ownercar");
};
