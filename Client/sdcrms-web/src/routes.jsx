import { createBrowserRouter } from "react-router-dom";
import App from "./App";
import OwnerCarPage from "./pages/OwnerCarPage";
import Login from "./pages/Login";
import AdminPage from "./pages/AdminPage";
import NotificationPage from "./pages/NotificationPage";

export const router = createBrowserRouter([
  {
    path: "/",
    element: <App />, // Layout chung với navbar
    children: [
      {
        index: true, // Route mặc định cho "/"
        element: (
          <div className="text-center mt-10">
            <h1 className="text-3xl font-bold">Chào mừng đến với S-DCRMS</h1>
            <p className="text-gray-600 mt-4">
              Hệ thống quản lý cho thuê xe tự lái
            </p>
          </div>
        ),
      },
      { path: "owner", element: <OwnerCarPage /> },
      { path: "login", element: <Login /> },
      { path: "admin", element: <AdminPage /> },
      { path: "notifications", element: <NotificationPage /> },
    ],
  },
]);
