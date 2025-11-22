import { useState } from "react";
import { useNavigate } from "react-router-dom";
import { signInWithEmailAndPassword } from "firebase/auth";
import { auth } from "../firebase";

export default function Login() {
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [error, setError] = useState("");
  const [loading, setLoading] = useState(false);
  const navigate = useNavigate();

  const handleLogin = async (e) => {
    e.preventDefault();
    setError("");
    setLoading(true);

    try {
      // Login với Firebase Auth
      const userCredential = await signInWithEmailAndPassword(
        auth,
        email,
        password
      );

      // Lấy Firebase ID Token
      const token = await userCredential.user.getIdToken();
      console.log("Firebase Token:", token);

      // Decode token để lấy custom claims (role)
      const tokenResult = await userCredential.user.getIdTokenResult();
      const role =
        tokenResult.claims.role || tokenResult.claims.admin ? "Admin" : "Staff";

      // Lưu token vào localStorage
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
      navigate("/");
    } catch (err) {
      console.error("Login error:", err);

      // Xử lý lỗi Firebase
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
    <div
      className="min-h-screen flex items-center justify-center relative overflow-hidden"
      style={{
        background:
          "linear-gradient(135deg, #2E7D9A 0%, #3498DB 50%, #5DADE2 100%)",
      }}
    >
      {/* Background decorative elements */}
      <div className="absolute inset-0 overflow-hidden">
        <div className="absolute -top-40 -right-40 w-80 h-80 bg-white/10 rounded-full blur-3xl"></div>
        <div className="absolute -bottom-40 -left-40 w-80 h-80 bg-white/10 rounded-full blur-3xl"></div>
      </div>

      <form
        onSubmit={handleLogin}
        className="bg-white p-8 rounded-2xl shadow-2xl max-w-md w-full mx-4 relative z-10 backdrop-blur-sm"
      >
        {/* Logo */}
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

        <h2 className="text-3xl font-bold text-gray-800 mb-2 text-center">
          S-DCRMS
        </h2>
        <p className="text-gray-500 text-sm text-center mb-6">
          Self-Driving Car Rental Management System
        </p>
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
          {loading ? "Đang đăng nhập..." : "Đăng nhập"}
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
  );
}
