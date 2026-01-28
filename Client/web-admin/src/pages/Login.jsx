import { useState } from "react";
import { login } from "../api/authApi";
import { useNavigate } from "react-router-dom";
import "./Login.css";

function Login() {
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [error, setError] = useState("");
  const navigate = useNavigate();

  const handleSubmit = async (e) => {
    e.preventDefault();
    setError(""); // Reset error
    try {
      // Gửi email và password lên server
      const res = await login({ email, password });

      // Lưu token
      localStorage.setItem("token", res.data.token);
      localStorage.setItem("role", res.data.role);
      localStorage.setItem("email", res.data.email);

      // Check role admin
      if (res.data.role === "Admin" || res.data.role === "admin") { 
        navigate("/admin");
      } else {
        setError("Bạn không có quyền admin. Role hiện tại: " + res.data.role);
      }
    } catch (err) {
      console.error(err);
      setError("Đăng nhập thất bại: " + (err.response?.data?.message || err.message));
    }
  };

  return (
    <div className="login-container">
      <div className="login-card">
        <div className="login-header">
          <h1>Admin Portal</h1>
          <p>Đăng nhập để quản lý hệ thống</p>
        </div>
        
        {error && <div className="error-message">{error}</div>}

        <form onSubmit={handleSubmit} className="login-form">
          <div className="form-group">
            <label htmlFor="email">Địa chỉ mail</label>
            <input
              id="email"
              type="email"
              className="login-input"
              placeholder="admin@example.com"
              value={email}
              onChange={(e) => setEmail(e.target.value)}
              required
            />
          </div>

          <div className="form-group">
            <label htmlFor="password">Mật khẩu</label>
            <input
              id="password"
              type="password"
              className="login-input"
              placeholder="••••••••"
              value={password}
              onChange={(e) => setPassword(e.target.value)}
              required
            />
          </div>

          <button type="submit" className="login-btn">
            Đăng nhập
          </button>
        </form>
      </div>
    </div>
  );
}

export default Login;
