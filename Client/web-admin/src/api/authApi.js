import axiosClient from "./axiosClient";

export const login = (data) => {
  return axiosClient.post("/auth/login", data);
};