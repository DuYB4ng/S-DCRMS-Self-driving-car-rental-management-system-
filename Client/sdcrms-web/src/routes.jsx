import { createBrowserRouter } from "react-router-dom";
import App from "./App";
import OwnerCarPage from "./pages/OwnerCarPage";
import Login from "./pages/Login";
import BookingPage from "./pages/BookingPage"; // 👈 trang Booking bạn vừa làm

export const router = createBrowserRouter([
  {
    path: "/",
    element: <App />,        // Layout chung (navbar + Outlet)
    children: [
      {
        path: "booking",         
        element: <BookingPage />,
      },
      {
        path: "owner",       // => /owner
        element: <OwnerCarPage />,
      },
      {
        path: "login",       // => /login
        element: <Login />,
      },
    ],
  },
]);
