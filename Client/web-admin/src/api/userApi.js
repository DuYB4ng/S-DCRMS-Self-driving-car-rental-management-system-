import axiosClient from "./axiosClient";

export const getAllUsers = async () => {
  return await axiosClient.get("/users");
};

export const promoteUser = async (id, role) => {
  return await axiosClient.post(`/users/${id}/promote`, { role });
};

export const getUserByEmail = async (email) => {
  return await axiosClient.get(`/users/email/${email}`);
};
