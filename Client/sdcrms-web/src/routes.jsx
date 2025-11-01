import { createBrowserRouter } from "react-router-dom";
import App from "./App";
import OwnerCarPage from "./pages/OwnerCarPage";
export const router = createBrowserRouter([
  {
    path: "/",
    element: <App/>,// Layout chung
    children: [
      { path: "/", element: <App/> },
      { path: "/owner", element: <OwnerCarPage/>}
    ],
  },
]);
