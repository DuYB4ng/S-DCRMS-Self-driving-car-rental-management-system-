import { Routes, Route } from "react-router-dom";
import OwnerLayout from "./OwnerLayout";

// Các page trong module OwnerCar
import DashboardPage from "./DashboardPage.jsx";
import BookingPage from "./BookingPage.jsx";
import BookingManagementPage from "./BookingManagementPage.jsx";
import CarManagementPage from "./CarManagementPage.jsx";
import PaymentPage from "./PaymentPage.jsx";
import PaymentResultPage from "./PaymentResultPage.jsx";

export default function OwnerRoutes() {
  return (
    <OwnerLayout>
      <Routes>
        {/* /ownercar */}
        <Route index element={<DashboardPage />} />

        {/* /ownercar/dashboard */}
        <Route path="dashboard" element={<DashboardPage />} />

        {/* /ownercar/booking */}
        <Route path="booking" element={<BookingPage />} />

        {/* /ownercar/booking-management */}
        <Route path="booking-management" element={<BookingManagementPage />} />

        {/* /ownercar/car-management */}
        <Route path="car-management" element={<CarManagementPage />} />

        {/* /ownercar/payment */}
        <Route path="payment" element={<PaymentPage />} />

        {/* /ownercar/payment/result */}
        <Route path="payment/result" element={<PaymentResultPage />} />
      </Routes>
    </OwnerLayout>
  );
}
