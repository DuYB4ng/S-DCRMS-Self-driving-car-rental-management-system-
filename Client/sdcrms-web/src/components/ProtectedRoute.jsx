import { Navigate } from "react-router-dom";

/**
 * Protected Route - Chỉ cho phép truy cập khi đã đăng nhập
 */
const ProtectedRoute = ({ children }) => {
  const token = localStorage.getItem("adminToken");

  if (!token) {
    // Chưa đăng nhập → redirect về login
    return <Navigate to="/login" replace />;
  }

  // Đã đăng nhập → cho phép truy cập
  return children;
};

export default ProtectedRoute;
