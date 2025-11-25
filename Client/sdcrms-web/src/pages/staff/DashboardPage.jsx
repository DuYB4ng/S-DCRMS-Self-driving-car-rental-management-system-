// src/pages/staff/DashboardPage.jsx
import React, { useEffect, useState } from "react";
import { getAllStaffs } from "../../api/staffApi";

const DashboardPage = () => {
  const [staffs, setStaffs] = useState([]);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState("");

  useEffect(() => {
    const fetchStaffs = async () => {
      try {
        setLoading(true);
        const data = await getAllStaffs();
        setStaffs(data);
      } catch (err) {
        console.error(err);
        setError("Không thể tải danh sách nhân viên");
      } finally {
        setLoading(false);
      }
    };

    fetchStaffs();
  }, []);

  if (loading) return <div>Đang tải dữ liệu staff...</div>;
  if (error) return <div className="text-red-500">{error}</div>;

  return (
    <div>
      <h1 className="text-2xl font-bold mb-4">Staff Dashboard</h1>
      <table className="min-w-full border">
        <thead>
          <tr>
            <th className="border px-2 py-1">StaffId</th>
            <th className="border px-2 py-1">FirebaseUid</th>
          </tr>
        </thead>
        <tbody>
          {staffs.map((s) => (
            <tr key={s.staffId}>
              <td className="border px-2 py-1">{s.staffId}</td>
              <td className="border px-2 py-1">{s.firebaseUid}</td>
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  );
};

export default DashboardPage;
