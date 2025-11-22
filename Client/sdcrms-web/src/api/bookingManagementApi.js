import axiosClient from "./axiosClient";

// Booking API functions
export const getBookings = async () => {
  const response = await axiosClient.get("/api/booking");
  return response.data;
};

export const createBooking = async (booking) => {
  const response = await axiosClient.post("/api/booking", booking);
  return response.data;
};

export const approveBooking = async (id) => {
  const response = await axiosClient.post(`/api/booking/approve/${id}`);
  return response.data;
};

export const rejectBooking = async (id) => {
  const response = await axiosClient.post(`/api/booking/reject/${id}`);
  return response.data;
};

export default axiosClient;
