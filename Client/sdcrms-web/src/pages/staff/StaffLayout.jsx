import React from "react";

export default function StaffLayout({ children }) {
  return (
    <div className="staff-wrapper" style={{ display: "flex" }}>
      {/* Sidebar */}
      <aside
        style={{
          width: "240px",
          background: "#222",
          color: "#fff",
          padding: "20px",
        }}
      >
        <h2>Staff Panel</h2>
        <ul>
          <li>
            <a href="/staff">Dashboard</a>
          </li>
          <li>
            <a href="/staff/owners">Owners</a>
          </li>
          <li>
            <a href="/staff/ownercars">Owner Cars</a>
          </li>
          <li>
            <a href="/staff/customers">Customers</a>
          </li>
          <li>
            <a href="/staff/reports">Reports</a>
          </li>
          <li>
            <a href="/staff/notifications">Notifications</a>
          </li>
        </ul>
      </aside>

      {/* Nội dung */}
      <main style={{ flex: 1, padding: "20px" }}>{children}</main>
    </div>
  );
}
