import { useState } from "react";
import { useNavigate } from "react-router-dom";
import { signInWithEmailAndPassword } from "firebase/auth";
import { auth } from "../firebase";

export default function LoginUnified() {
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [error, setError] = useState("");
  const [loading, setLoading] = useState(false);
  const [tab, setTab] = useState("admin"); // "admin" | "user"
  const navigate = useNavigate();

  const handleLogin = async (e) => {
    e.preventDefault();
    setError("");
    setLoading(true);

    try {
      const userCredential = await signInWithEmailAndPassword(
        auth,
        email,
        password
      );
      const token = await userCredential.user.getIdToken();
      const tokenResult = await userCredential.user.getIdTokenResult();

      // Nếu role là Admin thì là admin, còn lại (User, Staff, ...) đều vào staff dashboard
      let role = "Staff";
      if (tokenResult.claims.role === "Admin") {
        role = "Admin";
      } else if (
        tokenResult.claims.role === "User" ||
        tokenResult.claims.role === "Staff"
      ) {
        role = "Staff";
      } else {
        // fallback: nếu không có role hoặc role khác, vẫn cho vào staff
        role = "Staff";
      }

      localStorage.setItem("adminToken", token);
      localStorage.setItem(
        "adminUser",
        JSON.stringify({
          email: userCredential.user.email,
          uid: userCredential.user.uid,
          role: role,
        })
      );

      alert("Đăng nhập thành công!");
      if (role === "Admin") {
        navigate("/admin");
      } else {
        navigate("/staff/dashboard");
      }
    } catch (err) {
      let errorMessage = "Đăng nhập thất bại";
      if (
        err.code === "auth/invalid-credential" ||
        err.code === "auth/wrong-password"
      ) {
        errorMessage = "Email hoặc mật khẩu không đúng";
      } else if (err.code === "auth/user-not-found") {
        errorMessage = "Tài khoản không tồn tại";
      } else if (err.code === "auth/invalid-email") {
        errorMessage = "Email không hợp lệ";
      }
      setError(errorMessage);
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="min-h-screen flex items-center justify-center relative overflow-hidden bg-gradient-to-br from-[#2E7D9A] to-[#5DADE2]">
      <div className="bg-white p-8 rounded-2xl shadow-2xl max-w-md w-full mx-4 relative z-10 backdrop-blur-sm">
        <div className="flex justify-center mb-6">
          <div className="w-20 h-20 bg-gradient-to-br from-[#2E7D9A] to-[#3498DB] rounded-full flex items-center justify-center shadow-lg">
            <svg
              className="w-12 h-12 text-white"
              fill="currentColor"
              viewBox="0 0 24 24"
            >
              <path d="M18.92 6.01C18.72 5.42 18.16 5 17.5 5h-11c-.66 0-1.21.42-1.42 1.01L3 12v8c0 .55.45 1 1 1h1c.55 0 1-.45 1-1v-1h12v1c0 .55.45 1 1 1h1c.55 0 1-.45 1-1v-8l-2.08-5.99zM6.5 16c-.83 0-1.5-.67-1.5-1.5S5.67 13 6.5 13s1.5.67 1.5 1.5S7.33 16 6.5 16zm11 0c-.83 0-1.5-.67-1.5-1.5s.67-1.5 1.5-1.5 1.5.67 1.5 1.5-.67 1.5-1.5 1.5zM5 11l1.5-4.5h11L19 11H5z" />
            </svg>
          </div>
        </div>
        <div className="flex mb-6">
          <button
            className={`flex-1 py-2 rounded-l-lg font-semibold transition-all ${
              tab === "admin"
                ? "bg-[#2E7D9A] text-white"
                : "bg-gray-100 text-gray-600"
            }`}
            onClick={() => setTab("admin")}
            type="button"
          >
            Admin
          </button>
          <button
            className={`flex-1 py-2 rounded-r-lg font-semibold transition-all ${
              tab === "user"
                ? "bg-[#3498DB] text-white"
                : "bg-gray-100 text-gray-600"
            }`}
            onClick={() => setTab("user")}
            type="button"
          >
            User/Staff
          </button>
        </div>
        <form onSubmit={handleLogin}>
          <input
            type="email"
            placeholder="Email"
            value={email}
            onChange={(e) => setEmail(e.target.value)}
            required
            className="border-2 border-gray-200 rounded-lg w-full mb-3 p-3 focus:ring-2 focus:ring-[#2E7D9A] focus:border-[#2E7D9A] outline-none transition-all"
          />
          <input
            type="password"
            placeholder="Mật khẩu"
            value={password}
            onChange={(e) => setPassword(e.target.value)}
            required
            className="border-2 border-gray-200 rounded-lg w-full mb-4 p-3 focus:ring-2 focus:ring-[#2E7D9A] focus:border-[#2E7D9A] outline-none transition-all"
          />
          <button
            disabled={loading}
            className="bg-gradient-to-r from-[#2E7D9A] to-[#3498DB] hover:from-[#26697F] hover:to-[#2E7D9A] text-white px-4 py-3 rounded-lg w-full font-semibold disabled:bg-gray-400 transition-all shadow-lg hover:shadow-xl"
          >
            {loading
              ? "Đang đăng nhập..."
              : `Đăng nhập ${tab === "admin" ? "Admin" : "User"}`}
          </button>
          {error && (
            <div className="mt-3 p-3 bg-red-50 border border-red-200 rounded-lg">
              <p className="text-red-600 text-sm text-center">{error}</p>
            </div>
          )}
          <div className="mt-6 pt-4 border-t border-gray-200">
            <p className="text-gray-400 text-xs text-center">
              🔒 Đăng nhập bằng Firebase Authentication
            </p>
          </div>
        </form>
      </div>
    </div>
  );
}
