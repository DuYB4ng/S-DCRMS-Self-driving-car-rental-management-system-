// src/api/staffApi.js
import axiosClient from "./axiosClient";

const STAFF_BASE = "/staff";

// Lấy toàn bộ staff
export const getAllStaffs = async () => {
  const res = await axiosClient.get(STAFF_BASE);
  return res.data;
};

// Lấy staff theo id
export const getStaffById = async (id) => {
  const res = await axiosClient.get(`${STAFF_BASE}/${id}`);
  return res.data;
};

// Tạo staff mới (chỉ cần FirebaseUid)
export const createStaff = async (firebaseUid) => {
  const res = await axiosClient.post(STAFF_BASE, { firebaseUid });
  return res.data;
};

// Cập nhật staff
export const updateStaff = async (id, firebaseUid) => {
  const res = await axiosClient.put(`${STAFF_BASE}/${id}`, { firebaseUid });
  return res.data;
};

// Xoá staff
export const deleteStaff = async (id) => {
  const res = await axiosClient.delete(`${STAFF_BASE}/${id}`);
  return res.data;
};

// Lấy notifications của staff (dùng id staff)
export const getStaffNotifications = async (id) => {
  const res = await axiosClient.get(`${STAFF_BASE}/${id}/notifications`);
  return res.data;
};
