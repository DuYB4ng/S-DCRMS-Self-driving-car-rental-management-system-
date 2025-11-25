import React, { useState } from "react";
import { Outlet, useLocation } from "react-router-dom";
import Sidebar from "./components/Sidebar";
import Header from "./components/Header";

function App() {
  const [sidebarOpen, setSidebarOpen] = useState(false);
  const location = useLocation();

  // Nếu đang ở trang login, không hiển thị sidebar/header
  const isLoginPage = location.pathname === "/login";

  // Nếu đang ở staff route, không hiển thị sidebar admin/header
  const isStaffPage = location.pathname.startsWith("/staff");

  // Nếu đang ở ownercar route, cũng không hiển thị sidebar admin/header
  const isOwnerCarPage = location.pathname.startsWith("/ownercar");

  if (isLoginPage || isStaffPage || isOwnerCarPage) {
    return <Outlet />;
  }

  return (
    <div className="flex h-screen bg-gray-50">
      <Sidebar isOpen={sidebarOpen} onClose={() => setSidebarOpen(false)} />

      <div className="flex-1 flex flex-col overflow-hidden">
        <Header onMenuClick={() => setSidebarOpen(true)} />

        <main className="flex-1 overflow-y-auto">
          <Outlet />
        </main>
      </div>
    </div>
  );
}

export default App;
