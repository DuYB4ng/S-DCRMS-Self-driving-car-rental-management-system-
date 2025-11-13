import { createBrowserRouter } from "react-router-dom";
import OwnerCarPage from "./pages/OwnerCarPage";
import Login from "./pages/Login";

export const router = createBrowserRouter([
  { path: "/owner", element: <OwnerCarPage /> },
  { path: "/login", element: <Login /> },
]);
