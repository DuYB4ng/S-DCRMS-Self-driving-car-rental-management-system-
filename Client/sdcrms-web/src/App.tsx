import { Routes, Route, Navigate } from "react-router-dom";
import React from "react";
import MainLayout from "./layout/MainLayout";
import DashboardPage from "./pages/DashboardPage";
import OwnersPage from "./pages/OwnersPage";
import CustomersPage from "./pages/CustomersPage";
import ReportsPage from "./pages/ReportsPage";
import NotificationsPage from "./pages/NotificationsPage";
import LoginPage from "./pages/LoginPage";

function App() {
  const isLoggedIn = true; // Tạm thời hardcode, sau này dùng auth thật

  if (!isLoggedIn) {
    return (
      <Routes>
        <Route path="*" element={<Navigate to="/login" />} />
      </Routes>
    );
  }

  return (
    <MainLayout>
      <Routes>
        {/* ⭐ Khi truy cập '/', tự chuyển sang /Dashboard */}
        <Route
          path="/login"
          element={<LoginPage onLoginSuccess={() => setIsLoggedIn(true)} />}
        />

        <Route path="/" element={<Navigate to="/Dashboard" replace />} />

        {/* ⭐ Dashboard chính thức */}
        <Route path="/Dashboard" element={<DashboardPage />} />

        <Route path="/owners" element={<OwnersPage />} />
        <Route path="/customers" element={<CustomersPage />} />
        <Route path="/reports" element={<ReportsPage />} />
        <Route path="/notifications" element={<NotificationsPage />} />

        {/* Bắt các route không tồn tại → chuyển về Dashboard */}
        <Route path="*" element={<Navigate to="/Dashboard" replace />} />
      </Routes>
    </MainLayout>
  );
}

export default App;
