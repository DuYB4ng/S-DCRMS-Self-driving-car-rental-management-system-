import { Navigate } from "react-router-dom";

function PrivateRoute({ children }) {
  const token = localStorage.getItem("token");
  const role = localStorage.getItem("role");

  if (!token || (role !== "ADMIN" && role !== "Admin" && role !== "admin")) {
    return <Navigate to="/login" />;
  }

  return children;
}

export default PrivateRoute;
