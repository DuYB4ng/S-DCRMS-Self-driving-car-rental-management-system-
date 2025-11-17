import { useState } from "react";
import { createBooking } from "../api/bookingApi";
import Button from "./Button";

export default function BookingForm({ onCreated }) {
  const [startDate, setStartDate] = useState("");
  const [endDate, setEndDate] = useState("");
  const [checkIn, setCheckIn] = useState(false);
  const [checkOut, setCheckOut] = useState(false);
  const [error, setError] = useState("");
  const [loading, setLoading] = useState(false);

  const handleSubmit = async (e) => {
    e.preventDefault();
    setError("");

    if (!startDate || !endDate) {
      setError("Vui lòng chọn đầy đủ Start Date và End Date.");
      return;
    }

    const start = new Date(startDate);
    const end = new Date(endDate);

    if (isNaN(start) || isNaN(end)) {
      setError("Ngày không hợp lệ.");
      return;
    }

    if (start > end) {
      setError("Start Date phải trước hoặc bằng End Date.");
      return;
    }

    try {
      setLoading(true);
      await createBooking({
        startDate: start.toISOString(),
        endDate: end.toISOString(),
        checkIn,
        checkOut,
      });

      // reset form
      setStartDate("");
      setEndDate("");
      setCheckIn(false);
      setCheckOut(false);

      onCreated?.();
    } catch (err) {
      console.error(err);
      setError("Tạo booking thất bại, vui lòng thử lại.");
    } finally {
      setLoading(false);
    }
  };

  return (
    <form
      onSubmit={handleSubmit}
      className="bg-white shadow rounded p-4 space-y-4"
    >
      <h2 className="text-xl font-semibold mb-2">Tạo Booking</h2>

      {error && (
        <div className="text-red-600 text-sm bg-red-50 border border-red-200 px-3 py-2 rounded">
          {error}
        </div>
      )}

      <div className="flex flex-col gap-2">
        <label className="font-medium">Start Date</label>
        <input
          type="datetime-local"
          className="border rounded px-3 py-2"
          value={startDate}
          onChange={(e) => setStartDate(e.target.value)}
        />
      </div>

      <div className="flex flex-col gap-2">
        <label className="font-medium">End Date</label>
        <input
          type="datetime-local"
          className="border rounded px-3 py-2"
          value={endDate}
          onChange={(e) => setEndDate(e.target.value)}
        />
      </div>

      <div className="flex gap-4">
        <label className="inline-flex items-center gap-2">
          <input
            type="checkbox"
            checked={checkIn}
            onChange={(e) => setCheckIn(e.target.checked)}
          />
          <span>Check In</span>
        </label>
        <label className="inline-flex items-center gap-2">
          <input
            type="checkbox"
            checked={checkOut}
            onChange={(e) => setCheckOut(e.target.checked)}
          />
          <span>Check Out</span>
        </label>
      </div>

      <Button type="submit" variant="primary" disabled={loading}>
        {loading ? "Đang tạo..." : "Tạo Booking"}
      </Button>
    </form>
  );
}
