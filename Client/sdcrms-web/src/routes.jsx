import { createBrowserRouter } from "react-router-dom";
import App from "./App";
import OwnerCarPage from "./pages/OwnerCarPage";
import Login from "./pages/Login";
export const router = createBrowserRouter([
  {
    path: "/",
    element: <App/>,// Layout chung
    children: [
      { path: "/", element: <App/> },
      { path: "/owner", element: <OwnerCarPage/> },
      { path: "/login", element: <Login/> }
    ],
  },
]);
