import { useEffect, useState } from "react";
import { getAllBookings } from "../api/bookingApi";
import { createPayment } from "../api/paymentApi";
import { createReview } from "../api/reviewApi";

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
    }
  };

  // 👉 Tạo payment cho 1 booking
  const handlePayment = async (booking) => {
    const amountStr = window.prompt(
      `Nhập số tiền thanh toán cho booking #${booking.bookingID}:`,
      "0"
    );
    if (amountStr === null) return; // bấm Cancel

    const amount = parseFloat(amountStr);
    if (isNaN(amount) || amount <= 0) {
      alert("Số tiền không hợp lệ");
      return;
    }

    try {
      await createPayment({
        paymentDate: new Date().toISOString(),
        amount,
        method: "Cash",       // tạm thời cố định, sau này cho chọn
        status: "Completed",  // hoặc "Pending"
        bookingID: booking.bookingID,
      });

      alert("Tạo payment thành công!");
    } catch (err) {
      console.error(err);
      alert("Tạo payment thất bại");
    }
  };

  // 👉 Tạo review cho 1 booking
  const handleReview = async (booking) => {
    const ratingStr = window.prompt(
      `Nhập rating (1-5) cho booking #${booking.bookingID}:`,
      "5"
    );
    if (ratingStr === null) return;

    const rating = parseInt(ratingStr, 10);
    if (isNaN(rating) || rating < 1 || rating > 5) {
      alert("Rating phải từ 1 đến 5");
      return;
    }

    const comment = window.prompt("Nhập nhận xét:", "");
    if (comment === null) return;

    try {
      await createReview({
        rating,
        comment,
        reviewDate: new Date().toISOString(),
        bookingID: booking.bookingID,
      });

      alert("Tạo review thành công!");
    } catch (err) {
      console.error(err);
      alert("Tạo review thất bại");
    }
  };

  return (
    <div className="mt-8">
      <h2 className="text-xl font-bold mb-2">Danh sách Booking</h2>

      <table className="w-full border-collapse border">
        <thead>
          <tr>
            <th className="border p-2">ID</th>
            <th className="border p-2">Start</th>
            <th className="border p-2">End</th>
            <th className="border p-2">CheckIn</th>
            <th className="border p-2">CheckOut</th>
            <th className="border p-2">Thanh toán</th>
            <th className="border p-2">Đánh giá</th>
          </tr>
        </thead>
        <tbody>
          {bookings.map((b) => (
            <tr key={b.bookingID}>
              <td className="border p-2">{b.bookingID}</td>
              <td className="border p-2">
                {new Date(b.startDate).toLocaleString()}
              </td>
              <td className="border p-2">
                {new Date(b.endDate).toLocaleString()}
              </td>
              <td className="border p-2">{b.checkIn ? "✔️" : "❌"}</td>
              <td className="border p-2">{b.checkOut ? "✔️" : "❌"}</td>

              {/* Nút Payment */}
              <td className="border p-2">
                <button onClick={() => handlePayment(b)}>Thanh toán</button>
              </td>

              {/* Nút Review */}
              <td className="border p-2">
                <button onClick={() => handleReview(b)}>Đánh giá</button>
              </td>
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  );
}
