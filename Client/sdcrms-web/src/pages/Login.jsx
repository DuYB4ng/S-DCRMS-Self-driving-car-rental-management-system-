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
  const handleSignUp = async (e) => {
  e.preventDefault();
  setError("");

  const name = e.target.name.value;
  const email = e.target.email.value;
  const password = e.target.password.value;

  try {
    const res = await fetch("http://localhost:8000/api/auth/signup", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({
        displayName: name,
        email: email,
        password: password
      })
    });

    const data = await res.json();
    console.log("Signup response:", data);

    if (!res.ok) {
      throw new Error(data.error || "Signup failed");
    }

    alert("Signup successful!");
    setIsSignUp(false);
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
          <form id="signUpForm" onSubmit={handleSignUp}>
            <h2>Create Account</h2>

            <input type="text" name="name" placeholder="Name" required />
            <input type="email" name="email" placeholder="Email" required />
            <input type="password" name="password" placeholder="Password" required />
            <input type="password" name="confirmPassword" placeholder="Confirm Password" required />

            <button type="submit">Sign Up</button>

            {error && <div className="error-message">{error}</div>}
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
