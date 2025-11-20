import { useEffect, useState } from "react";
import { getAllPayments } from "../api/paymentApi";

const handlePayWithVnPay = async () => {
  try {
    const res = await createVnPayPayment({
      bookingID: selectedBookingId,
      amount: totalAmount,
    });

    // redirect sang trang VNPay sandbox
    window.location.href = res.paymentUrl;
  } catch (err) {
    console.error(err);
    alert("Tạo giao dịch VNPay thất bại");
  }
};

export default function PaymentPage() {
  const [payments, setPayments] = useState([]);
  const [loading, setLoading] = useState(false);

  const load = async () => {
    try {
      setLoading(true);
      const data = await getAllPayments();
      setPayments(data);
    } catch (err) {
      console.error(err);
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    load();
  }, []);

  return (
    <div className="p-4">
      <h1 className="text-2xl font-bold mb-4">Danh sách Payment</h1>

      {loading ? (
        <div>Đang tải...</div>
      ) : (
        <div className="overflow-x-auto bg-white border rounded">
          <table className="min-w-full border-collapse">
            <thead>
              <tr className="bg-gray-100">
                <th className="border px-3 py-2">ID</th>
                <th className="border px-3 py-2">BookingID</th>
                <th className="border px-3 py-2">Payment Date</th>
                <th className="border px-3 py-2">Amount</th>
                <th className="border px-3 py-2">Method</th>
                <th className="border px-3 py-2">Status</th>
              </tr>
            </thead>
            <tbody>
              {payments.length === 0 ? (
                <tr>
                  <td colSpan={6} className="text-center py-4 text-gray-500">
                    Chưa có payment nào
                  </td>
                </tr>
              ) : (
                payments.map((p) => (
                  <tr key={p.paymentID}>
                    <td className="border px-3 py-2">{p.paymentID}</td>
                    <td className="border px-3 py-2">{p.bookingID}</td>
                    <td className="border px-3 py-2">
                      {p.paymentDate
                        ? new Date(p.paymentDate).toLocaleString()
                        : ""}
                    </td>
                    <td className="border px-3 py-2">{p.amount}</td>
                    <td className="border px-3 py-2">{p.method}</td>
                    <td className="border px-3 py-2">{p.status}</td>
                  </tr>
                ))
              )}
            </tbody>
          </table>
        </div>
      )}
    </div>
  );
}
