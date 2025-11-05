import { useState } from "react";
import { signInWithEmailAndPassword } from "firebase/auth";
import { auth } from "../utils/firebase";
import "../assets/css/login.css";

export default function Login() {
  const [isSignUp, setIsSignUp] = useState(false);
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [error, setError] = useState("");

  const handleLogin = async (e) => {
    e.preventDefault();
    setError("");

    try {
      const userCredential = await signInWithEmailAndPassword(auth, email, password);
      const token = await userCredential.user.getIdToken();
      console.log("Firebase Token:", token);

      const res = await fetch("https://localhost:8000/ownercar/cars", {
        headers: { Authorization: `Bearer ${token}` },
      });

      const data = await res.json();
      console.log("Data:", data);
    } catch (err) {
      console.error(err);
      setError(err.message);
    }
  };

  return (
    <div className="body">
      <div className={`container ${isSignUp ? "activate" : ""}`}>
      {/* SIGN UP FORM */}
      <div className="form-container sign-up-container">
        <form id="signUpForm">
          <h2>Create Account</h2>
          <input type="text" placeholder="Name" required />
          <input type="email" placeholder="Email" required />
          <input type="password" placeholder="Password" required />
          <input type="password" placeholder="Confirm Password" required />
          <button type="submit">Sign Up</button>
          <div className="error-message" id="signUpError"></div>
        </form>
      </div>

      {/* SIGN IN FORM */}
      <div className="form-container sign-in-container">
        <form onSubmit={handleLogin}>
          <h1>Sign in</h1>
          <input
            type="email"
            placeholder="Email"
            value={email}
            onChange={(e) => setEmail(e.target.value)}
            required
          />
          <input
            type="password"
            placeholder="Password"
            value={password}
            onChange={(e) => setPassword(e.target.value)}
            required
          />
          <a href="#">Forgot your password?</a>
          <button type="submit">Sign In</button>
          {error && <div className="error-message">{error}</div>}
        </form>
      </div>

      {/* OVERLAY */}
      <div className="overlay-container">
        <div className="overlay">
          <div className="overlay-panel overlay-left">
            <h1>Welcome Back!</h1>
            <p>To keep connected with us please login with your personal info</p>
            <button type="button" className="ghost" onClick={() => setIsSignUp(false)}>
              Sign In
            </button>
          </div>
          <div className="overlay-panel overlay-right">
            <h1>Hello, Friend!</h1>
            <p>Enter your personal details and start your journey with us</p>
            <button type="button" className="ghost" onClick={() => setIsSignUp(true)}>
              Sign Up
            </button>
          </div>
        </div>
      </div>
    </div>
    </div>
  );
}
