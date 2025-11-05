import { useState } from "react";
import { signInWithEmailAndPassword } from "firebase/auth";
import { auth } from "../utils/firebase";

export default function Login() {
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [error, setError] = useState("");

  const handleLogin = async (e) => {
    e.preventDefault();

    try {
      const userCredential = await signInWithEmailAndPassword(
        auth,
        email,
        password
      );
      const token = await userCredential.user.getIdToken();
      console.log("Firebase Token:", token);

      // Gửi token qua API Gateway
      const res = await fetch("http://localhost:5100/ownercar/cars", {
        headers: {
          Authorization: `Bearer ${token}`,
        },
      });

      if (!res.ok) {
        throw new Error(`HTTP error! status: ${res.status}`);
      }

      const data = await res.json();
      console.log("Data:", data);
      alert("Login successful!");
    } catch (err) {
      console.error("Error:", err);
      setError(err.message);
    }
  };

  return (
    <form onSubmit={handleLogin} className="p-6 max-w-md mx-auto">
      <h2 className="text-xl font-bold mb-4">Đăng nhập</h2>
      <input
        type="email"
        placeholder="Email"
        value={email}
        onChange={(e) => setEmail(e.target.value)}
        className="border rounded w-full mb-2 p-2"
      />
      <input
        type="password"
        placeholder="Mật khẩu"
        value={password}
        onChange={(e) => setPassword(e.target.value)}
        className="border rounded w-full mb-4 p-2"
      />
      <button className="bg-blue-500 text-white px-4 py-2 rounded w-full">
        Đăng nhập
      </button>
      {error && <p className="text-red-500 mt-2">{error}</p>}
    </form>
  );
}
