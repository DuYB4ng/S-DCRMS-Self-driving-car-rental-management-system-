import { createBrowserRouter } from "react-router-dom";
import App from "./App";
import DashboardPage from "./pages/DashboardPage";
import CarManagementPage from "./pages/CarManagementPage";
import BookingManagementPage from "./pages/BookingManagementPage";
import PaymentPage from "./pages/PaymentPage";
import OwnerCarPage from "./pages/OwnerCarPage";
import Login from "./pages/Login";
import AdminPage from "./pages/AdminPage";
import NotificationPage from "./pages/NotificationPage";
import SystemMonitoringPage from "./pages/SystemMonitoringPage";
import ReportsPage from "./pages/ReportsPage";

export const router = createBrowserRouter([
  {
    path: "/",
    element: <App />,
    children: [
      {
        index: true,
        element: <DashboardPage />,
      },
      { path: "car-management", element: <CarManagementPage /> },
      { path: "booking-management", element: <BookingManagementPage /> },
      { path: "payment", element: <PaymentPage /> },
      { path: "owner", element: <OwnerCarPage /> },
      { path: "login", element: <Login /> },
      { path: "admin-management", element: <AdminPage /> },
      { path: "notifications", element: <NotificationPage /> },
      { path: "system-monitoring", element: <SystemMonitoringPage /> },
      { path: "reports", element: <ReportsPage /> },
    ],
  },
]);
