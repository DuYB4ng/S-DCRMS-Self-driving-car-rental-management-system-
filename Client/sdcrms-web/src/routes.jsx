import React from "react";
import { createBrowserRouter } from "react-router-dom";
import App from "./App";
import ProtectedRoute from "./components/ProtectedRoute";

// Lazy load pages to avoid initial load issues
const DashboardPage = React.lazy(() => import("./pages/DashboardPage"));
const CarManagementPage = React.lazy(() => import("./pages/CarManagementPage"));
const BookingManagementPage = React.lazy(() =>
  import("./pages/BookingManagementPage")
);
const PaymentPage = React.lazy(() => import("./pages/PaymentPage"));
const OwnerCarPage = React.lazy(() => import("./pages/OwnerCarPage"));
const Login = React.lazy(() => import("./pages/Login"));
const AdminPage = React.lazy(() => import("./pages/AdminPage"));
const NotificationPage = React.lazy(() => import("./pages/NotificationPage"));
const SystemMonitoringPage = React.lazy(() =>
  import("./pages/SystemMonitoringPage")
);
const ReportsPage = React.lazy(() => import("./pages/ReportsPage"));
const StaffManagementPage = React.lazy(() =>
  import("./pages/StaffManagementPage")
);
const CompliancePolicyPage = React.lazy(() =>
  import("./pages/CompliancePolicyPage")
);
const FraudDetectionPage = React.lazy(() =>
  import("./pages/FraudDetectionPage")
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
              <DashboardPage />
            </React.Suspense>
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
      {
        path: "car-management",
        element: (
          <ProtectedRoute>
            <CarManagementPage />
          </ProtectedRoute>
        ),
      },
      {
        path: "booking-management",
        element: (
          <ProtectedRoute>
            <BookingManagementPage />
          </ProtectedRoute>
        ),
      },
      {
        path: "payment",
        element: (
          <ProtectedRoute>
            <PaymentPage />
          </ProtectedRoute>
        ),
      },
      {
        path: "owner",
        element: (
          <ProtectedRoute>
            <OwnerCarPage />
          </ProtectedRoute>
        ),
      },
      {
        path: "admin-management",
        element: (
          <ProtectedRoute>
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
          <ProtectedRoute>
            <SystemMonitoringPage />
          </ProtectedRoute>
        ),
      },
      {
        path: "reports",
        element: (
          <ProtectedRoute>
            <ReportsPage />
          </ProtectedRoute>
        ),
      },
      {
        path: "staff-management",
        element: (
          <ProtectedRoute>
            <StaffManagementPage />
          </ProtectedRoute>
        ),
      },
      {
        path: "compliance-policy",
        element: (
          <ProtectedRoute>
            <CompliancePolicyPage />
          </ProtectedRoute>
        ),
      },
      {
        path: "fraud-detection",
        element: (
          <ProtectedRoute>
            <FraudDetectionPage />
          </ProtectedRoute>
        ),
      },
    ],
  },
]);
