import { createBrowserRouter } from "react-router-dom";
import App from "./App";
import OwnerCars from "./pages/OwnerCars";
export const router = createBrowserRouter([
  {
    path: "/",
    element: <App/>,// Layout chung
    children: [
      { path: "/", element: <App/> },
      { path: "/owner", element: <OwnerCars/>}
    ],
  },
]);
