import { useEffect, useState } from "react";
import { getAllBookings } from "../api/bookingApi";

export default function BookingList({ reload }) {
  const [bookings, setBookings] = useState([]);

  useEffect(() => {
    load();
  }, [reload]);

  const load = async () => {
    try {
      const data = await getAllBookings();
      setBookings(data);
    } catch (err) {
      console.error(err);
      alert("Không load được danh sách booking");
    }
  };

  return (
    <div>
      <h2 className="text-xl font-bold mb-3">Danh sách Booking</h2>

      <table className="w-full border-collapse border">
        <thead>
          <tr className="bg-gray-100">
            <th className="border p-2">ID</th>
            <th className="border p-2">Start</th>
            <th className="border p-2">End</th>
            <th className="border p-2">CheckIn</th>
            <th className="border p-2">CheckOut</th>
          </tr>
        </thead>
        <tbody>
          {bookings.map((b) => (
            <tr key={b.bookingID}>
              <td className="border p-2">{b.bookingID}</td>
              <td className="border p-2">{new Date(b.startDate).toLocaleString()}</td>
              <td className="border p-2">{new Date(b.endDate).toLocaleString()}</td>
              <td className="border p-2">{b.checkIn ? "✔️" : "❌"}</td>
              <td className="border p-2">{b.checkOut ? "✔️" : "❌"}</td>
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  );
}
