import { Navigate, useLocation } from "react-router-dom";

/**
 * Protected Route - Chỉ cho phép truy cập khi đã đăng nhập.
 * - Nếu `requiredRole` được truyền, kiểm tra role của user (lưu trong localStorage.adminUser).
 */
const ProtectedRoute = ({ children, requiredRole = null }) => {
  const token = localStorage.getItem("adminToken");
  const location = useLocation();

  if (!token) {
    // Chưa đăng nhập → redirect về login
    return <Navigate to="/login" replace state={{ from: location }} />;
  }

  if (requiredRole) {
    try {
      const userRaw = localStorage.getItem("adminUser");
      const user = userRaw ? JSON.parse(userRaw) : null;
      const role = user?.role || null;

      if (!role || role.toLowerCase() !== requiredRole.toLowerCase()) {
        // Đã đăng nhập nhưng không có role phù hợp → chuyển về trang chính hoặc /web
        return <Navigate to="/" replace />;
      }
    } catch (e) {
      // Nếu parse lỗi thì redirect về login để bắt đăng nhập lại
      return <Navigate to="/login" replace state={{ from: location }} />;
    }
  }

  // Đã đăng nhập (và role phù hợp nếu requiredRole) → cho phép truy cập
  return children;
};

export default ProtectedRoute;
