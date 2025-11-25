import { Routes, Route } from "react-router-dom";
import StaffLayout from "./StaffLayout";

import DashboardPage from "./DashboardPage.jsx";
import OwnersPage from "./OwnersPage.jsx";
import OwnerCarPage from "./OwnerCarPage.jsx";
import CustomersPage from "./CustomersPage.jsx";
import ReportsPage from "./ReportsPage.jsx";
import NotificationsPage from "./NotificationsPage.jsx";
import OwnerCarsOfOwnerPage from "./OwnerCarsOfOwnerPage.jsx"; // 👈 thêm

export default function StaffRoutes() {
  return (
    <StaffLayout>
      <Routes>
        <Route path="/" element={<DashboardPage />} />
        <Route path="dashboard" element={<DashboardPage />} />
        <Route path="owners" element={<OwnersPage />} />
        {/* Trang con: danh sách xe của 1 chủ xe */}
        <Route path="owners/:ownerId/cars" element={<OwnerCarsOfOwnerPage />} />
        <Route path="ownercars" element={<OwnerCarPage />} />
        <Route path="customers" element={<CustomersPage />} />
        <Route path="reports" element={<ReportsPage />} />
        <Route path="notifications" element={<NotificationsPage />} />
      </Routes>
    </StaffLayout>
  );
}
