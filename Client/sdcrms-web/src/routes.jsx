import { createBrowserRouter } from "react-router-dom";
import App from "./App";

import OwnerCarPage from "./pages/OwnerCarPage";
import Login from "./pages/Login";
import BookingPage from "./pages/BookingPage";
import PaymentPage from "./pages/PaymentPage";
import ReviewPage from "./pages/ReviewPage";

import StaffRoutes from "./pages/staff/StaffRoutes";
import StaffGuard from "./guards/StaffGuard";

import PaymentResultPage from "./pages/PaymentResultPage";

export const router = createBrowserRouter([
  {
    path: "/",
    element: <App />,
    children: [
      { path: "booking", element: <BookingPage /> },
      { path: "owner", element: <OwnerCarPage /> },
      { path: "login", element: <Login /> },
      { path: "payment", element: <PaymentPage /> },
      { path: "review", element: <ReviewPage /> },
      { path: "payment-result", element: <PaymentResultPage /> },
    ],
  },

  // ⭐ STAFF ROUTE KHÁC HOÀN TOÀN, KHÔNG ẢNH HƯỞNG LOGIN
  {
    path: "/staff/*",
    element: (
      <StaffGuard>
        <StaffRoutes />
      </StaffGuard>
    ),
  },
]);
