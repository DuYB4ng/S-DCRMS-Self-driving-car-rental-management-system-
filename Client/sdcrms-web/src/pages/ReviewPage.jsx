import { useEffect, useState } from "react";
import { getAllReviews } from "../api/reviewApi";

export default function ReviewPage() {
  const [reviews, setReviews] = useState([]);
  const [loading, setLoading] = useState(false);

  const load = async () => {
    try {
      setLoading(true);
      const data = await getAllReviews();
      setReviews(data);
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
      <h1 className="text-2xl font-bold mb-4">Danh sách Review</h1>

      {loading ? (
        <div>Đang tải...</div>
      ) : (
        <div className="overflow-x-auto bg-white border rounded">
          <table className="min-w-full border-collapse">
            <thead>
              <tr className="bg-gray-100">
                <th className="border px-3 py-2">ID</th>
                <th className="border px-3 py-2">BookingID</th>
                <th className="border px-3 py-2">Rating</th>
                <th className="border px-3 py-2">Comment</th>
                <th className="border px-3 py-2">Review Date</th>
              </tr>
            </thead>
            <tbody>
              {reviews.length === 0 ? (
                <tr>
                  <td colSpan={5} className="text-center py-4 text-gray-500">
                    Chưa có review nào
                  </td>
                </tr>
              ) : (
                reviews.map((r) => (
                  <tr key={r.reviewID}>
                    <td className="border px-3 py-2">{r.reviewID}</td>
                    <td className="border px-3 py-2">{r.bookingID}</td>
                    <td className="border px-3 py-2">{r.rating}</td>
                    <td className="border px-3 py-2">{r.comment}</td>
                    <td className="border px-3 py-2">
                      {r.reviewDate
                        ? new Date(r.reviewDate).toLocaleString()
                        : ""}
                    </td>
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
