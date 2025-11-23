import { Routes, Route } from "react-router-dom";
import StaffLayout from "./StaffLayout";

import DashboardPage from "./DashboardPage";
import OwnersPage from "./OwnersPage";
import OwnerCarPage from "./OwnerCarPage";
import CustomersPage from "./CustomersPage";
import ReportsPage from "./ReportsPage";
import NotificationsPage from "./NotificationsPage";

export default function StaffRoutes() {
  return (
    <StaffLayout>
      <Routes>
        <Route path="/" element={<DashboardPage />} />
        <Route path="owners" element={<OwnersPage />} />
        <Route path="ownercars" element={<OwnerCarPage />} />
        <Route path="customers" element={<CustomersPage />} />
        <Route path="reports" element={<ReportsPage />} />
        <Route path="notifications" element={<NotificationsPage />} />
      </Routes>
    </StaffLayout>
  );
}
