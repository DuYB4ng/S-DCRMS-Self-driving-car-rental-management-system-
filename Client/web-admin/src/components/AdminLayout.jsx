import { Link } from "react-router-dom";

export default function AdminLayout({ children }) {
  return (
    <div style={{ display: "flex", minHeight: "100vh" }}>
      <aside style={{ width: 220, background: "#ffffffff", color: "#fff", padding: 20 }}>
        <h3>Admin Panel</h3>
        <ul style={{ listStyle: "none", padding: 0 }}>
          <li><Link to="/admin" style={{ color: "#fff" }}>Dashboard</Link></li>
          <li><Link to="/admin/users" style={{ color: "#fff" }}>Users</Link></li>
        </ul>
      </aside>

      <main style={{ flex: 1, padding: 20 }}>
        {children}
      </main>
    </div>
  );
}
