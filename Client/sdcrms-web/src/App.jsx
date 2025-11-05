import React from "react";
import { Link, Outlet } from "react-router-dom";

function App() {
  return (
    <div>
      {/* Thanh điều hướng đơn giản */}
      <nav className="bg-gray-800 text-white p-4 flex gap-4">
        <Link to="/" className="hover:underline">
          Trang chủ
        </Link>
        <Link to="/owner" className="hover:underline">
          Quản lý chủ xe
        </Link>
      </nav>

      {/* Khu vực render nội dung page */}
      <main className="p-6">
        <Outlet />  {/* ✅ Route con (OwnerCarPage) hiển thị tại đây */}
      </main>
    </div>
  );
}

export default App;
