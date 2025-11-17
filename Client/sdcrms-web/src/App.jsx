import React from "react";
import { Link, Outlet } from "react-router-dom";

function App() {
  return (
    <div>
      {/* Thanh điều hướng đơn giản */}
      <nav className="bg-gray-800 text-white p-4 flex gap-4">
        <Link to="/booking" className="hover:underline">
          Booking
        </Link>
        <Link to="/owner" className="hover:underline">
          Quản lý chủ xe
        </Link>
        <Link to="/login" className="hover:underline ml-auto">
          Đăng nhập
        </Link>
      </nav>

      {/* Khu vực render nội dung page */}
      <main className="p-6">
        {/* Các route con sẽ hiển thị ở đây */}
        <Outlet />
      </main>
    </div>
  );
}

export default App;
