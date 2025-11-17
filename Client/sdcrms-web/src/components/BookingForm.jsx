import { useState } from "react";
import { createBooking } from "../api/bookingApi";

export default function BookingForm({ onCreated }) {
  const [startDate, setStartDate] = useState("");
  const [endDate, setEndDate] = useState("");
  const [checkIn, setCheckIn] = useState(false);
  const [checkOut, setCheckOut] = useState(false);

  const handleSubmit = async (e) => {
    e.preventDefault();

    const payload = {
      startDate: new Date(startDate).toISOString(),
      endDate: new Date(endDate).toISOString(),
      checkIn,
      checkOut,
    };

    try {
      const created = await createBooking(payload);
      alert("Created booking #" + created.bookingID);

      if (onCreated) onCreated();
    } catch (err) {
      console.error(err);
      alert("Error creating booking");
    }
  };

  return (
    <form onSubmit={handleSubmit} className="p-4 border rounded mb-6">
      <h2 className="text-xl font-bold mb-4">Tạo Booking</h2>

      <label className="block mb-2">
        Start Date:
        <input
          type="datetime-local"
          className="border p-2 w-full"
          value={startDate}
          onChange={(e) => setStartDate(e.target.value)}
        />
      </label>

      <label className="block mb-2">
        End Date:
        <input
          type="datetime-local"
          className="border p-2 w-full"
          value={endDate}
          onChange={(e) => setEndDate(e.target.value)}
        />
      </label>

      <label className="block mb-1">
        <input
          type="checkbox"
          checked={checkIn}
          onChange={(e) => setCheckIn(e.target.checked)}
        />
        &nbsp;Check In
      </label>

      <label className="block mb-4">
        <input
          type="checkbox"
          checked={checkOut}
          onChange={(e) => setCheckOut(e.target.checked)}
        />
        &nbsp;Check Out
      </label>

      <button className="bg-blue-500 text-white px-4 py-2 rounded" type="submit">
        Tạo Booking
      </button>
    </form>
  );
}
