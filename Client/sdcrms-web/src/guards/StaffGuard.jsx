import { useEffect, useState } from "react";
import { Navigate } from "react-router-dom";
import { auth } from "../utils/firebase";
import { onAuthStateChanged } from "firebase/auth";

export default function StaffGuard({ children }) {
  const [loading, setLoading] = useState(true);
  const [allowed, setAllowed] = useState(false);

  useEffect(() => {
    const unsubscribe = onAuthStateChanged(auth, async (user) => {
      // ❌ Chưa đăng nhập → không cho vào
      if (!user) {
        console.log("StaffGuard: no user");
        setAllowed(false);
        setLoading(false);
        return;
      }

      try {
        const token = await user.getIdToken(true);

        console.log(
          "StaffGuard: CALLING verifyToken WITH TOKEN:",
          token.substring(0, 20) + "..."
        );

        const res = await fetch("http://localhost:8000/api/auth/verifyToken", {
          method: "POST",
          headers: { "Content-Type": "application/json" },
          body: JSON.stringify({ idToken: token }),
        });

        console.log("StaffGuard: STATUS FROM API:", res.status);
        const data = await res.json().catch(() => null);
        console.log("StaffGuard: DATA FROM API:", data);

        if (!res.ok || !data) {
          setAllowed(false);
          setLoading(false);
          return;
        }

        const role = (data.role || "").toLowerCase();
        console.log("StaffGuard: role =", role);

        // ✅ Cho Staff / Admin vào panel staff
        if (role === "staff" || role === "admin") {
          setAllowed(true);
        } else {
          setAllowed(false);
        }
      } catch (err) {
        console.error("StaffGuard error:", err);
        setAllowed(false);
      } finally {
        setLoading(false);
      }
    });

    // cleanup listener khi unmount
    return () => unsubscribe();
  }, []);

  if (loading) {
    return <div className="p-6">Đang kiểm tra quyền truy cập...</div>;
  }

  if (!allowed) {
    // ❌ Không đủ quyền → quay về trang login
    return <Navigate to="/login" replace />;
  }

  // ✅ Đúng quyền → render children
  return children;
}
