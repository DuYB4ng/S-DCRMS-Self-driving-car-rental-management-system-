import React from "react";
import { createBrowserRouter } from "react-router-dom";
import App from "./App";
import ProtectedRoute from "./components/ProtectedRoute";

// Lazy load pages to avoid initial load issues
const AdminDashboardPage = React.lazy(() =>
  import("./pages/Admin/DashboardPage")
);
const CarManagementPage = React.lazy(() =>
  import("./pages/Admin/CarManagementPage")
);
const BookingManagementPage = React.lazy(() =>
  import("./pages/Admin/BookingManagementPage")
);
const PaymentPage = React.lazy(() => import("./pages/Admin/PaymentPage"));
const OwnerCarPage = React.lazy(() => import("./pages/Admin/OwnerCarPage"));
const Login = React.lazy(() => import("./pages/Login"));
const AdminPage = React.lazy(() => import("./pages/Admin/AdminPage"));
const NotificationPage = React.lazy(() =>
  import("./pages/Admin/NotificationPage")
);
const SystemMonitoringPage = React.lazy(() =>
  import("./pages/Admin/SystemMonitoringPage")
);
const ReportsPage = React.lazy(() => import("./pages/Admin/ReportsPage"));
const StaffManagementPage = React.lazy(() =>
  import("./pages/Admin/StaffManagementPage")
);
const CompliancePolicyPage = React.lazy(() =>
  import("./pages/Admin/CompliancePolicyPage")
);
const FraudDetectionPage = React.lazy(() =>
  import("./pages/Admin/FraudDetectionPage")
);
const StaffRoutes = React.lazy(() => import("./pages/staff/StaffRoutes"));
const StaffDashboardPage = React.lazy(() =>
  import("./pages/staff/DashboardPage")
);

export const router = createBrowserRouter([
  {
    path: "/",
    element: <App />,
    children: [
      {
        index: true,
        element: (
          <ProtectedRoute>
            <React.Suspense
              fallback={
                <div className="flex items-center justify-center h-screen">
                  <div className="text-xl">Loading...</div>
                </div>
              }
            >
              <StaffDashboardPage />
            </React.Suspense>
          </ProtectedRoute>
        ),
      },
      {
        path: "staff/*",
        element: (
          <ProtectedRoute requiredRole="Staff">
            <React.Suspense fallback={<div>Loading...</div>}>
              <StaffRoutes />
            </React.Suspense>
          </ProtectedRoute>
        ),
      },
      {
        path: "admin",
        element: (
          <ProtectedRoute requiredRole="Admin">
            <AdminDashboardPage />
          </ProtectedRoute>
        ),
      },
      {
        path: "car-management",
        element: (
          <ProtectedRoute requiredRole="Admin">
            <CarManagementPage />
          </ProtectedRoute>
        ),
      },
      {
        path: "booking-management",
        element: (
          <ProtectedRoute requiredRole="Admin">
            <BookingManagementPage />
          </ProtectedRoute>
        ),
      },
      {
        path: "payment",
        element: (
          <ProtectedRoute requiredRole="Admin">
            <PaymentPage />
          </ProtectedRoute>
        ),
      },
      {
        path: "owner",
        element: (
          <ProtectedRoute requiredRole="Admin">
            <OwnerCarPage />
          </ProtectedRoute>
        ),
      },
      {
        path: "admin-management",
        element: (
          <ProtectedRoute requiredRole="Admin">
            <AdminPage />
          </ProtectedRoute>
        ),
      },
      {
        path: "notifications",
        element: (
          <ProtectedRoute>
            <NotificationPage />
          </ProtectedRoute>
        ),
      },
      {
        path: "system-monitoring",
        element: (
          <ProtectedRoute requiredRole="Admin">
            <SystemMonitoringPage />
          </ProtectedRoute>
        ),
      },
      {
        path: "reports",
        element: (
          <ProtectedRoute requiredRole="Admin">
            <ReportsPage />
          </ProtectedRoute>
        ),
      },
      {
        path: "staff-management",
        element: (
          <ProtectedRoute requiredRole="Admin">
            <StaffManagementPage />
          </ProtectedRoute>
        ),
      },
      {
        path: "compliance-policy",
        element: (
          <ProtectedRoute requiredRole="Admin">
            <CompliancePolicyPage />
          </ProtectedRoute>
        ),
      },
      {
        path: "fraud-detection",
        element: (
          <ProtectedRoute requiredRole="Admin">
            <FraudDetectionPage />
          </ProtectedRoute>
        ),
      },
      {
        path: "login",
        element: (
          <React.Suspense
            fallback={
              <div className="flex items-center justify-center h-screen">
                <div className="text-xl">Loading...</div>
              </div>
            }
          >
            <Login />
          </React.Suspense>
        ),
      },
    ],
  },
]);
