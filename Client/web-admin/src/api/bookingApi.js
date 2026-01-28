import axiosClient from "./axiosClient";

// Get all bookings
export const getAllBookings = async () => {
    return await axiosClient.get("/Booking");
};

// Confirm Return (Admin/Owner action)
export const confirmReturn = async (id) => {
    return await axiosClient.post(`/Booking/${id}/confirm-return`);
};

// Cancel Booking
export const cancelBooking = async (id) => {
    return await axiosClient.post(`/Booking/${id}/cancel`);
};
