import React from "react";
import { NavLink } from "react-router-dom";

const linkBase: React.CSSProperties = {
  display: "flex",
  alignItems: "center",
  gap: 8,
  padding: "10px 12px",
  textDecoration: "none",
  color: "#374151",
  borderRadius: 999,
  marginBottom: 6,
  fontSize: 14,
  fontWeight: 500,
};

const activeStyle: React.CSSProperties = {
  ...linkBase,
  backgroundColor: "var(--primary)",
  color: "#ffffff",
};

const Sidebar: React.FC = () => {
  return (
    <aside
      style={{
        width: 240,
        padding: 20,
        backgroundColor: "var(--sidebar-bg)",
        borderRight: "1px solid #e5e7eb",
        display: "flex",
        flexDirection: "column",
        gap: 16,
      }}
    >
      {/* Logo + tên hệ thống */}
      <div>
        <div
          style={{
            width: 32,
            height: 32,
            borderRadius: 999,
            backgroundColor: "var(--primary)",
            display: "flex",
            alignItems: "center",
            justifyContent: "center",
            color: "#fff",
            fontWeight: 700,
            marginBottom: 8,
          }}
        >
          S
        </div>
        <div style={{ fontSize: 18, fontWeight: 700 }}>Ban nhân viên</div>
        <div style={{ fontSize: 12, color: "var(--text-sub)" }}>
          Hệ thống thuê xe tự lái
        </div>
      </div>

      {/* Menu */}
      <nav style={{ marginTop: 8 }}>
        <NavLink
          to="/Dashboard"
          style={({ isActive }) => (isActive ? activeStyle : linkBase)}
        >
          Bảng điều khiển
        </NavLink>

        <NavLink
          to="/owners"
          style={({ isActive }) => (isActive ? activeStyle : linkBase)}
        >
          Quản lý chủ xe
        </NavLink>

        <NavLink
          to="/customers"
          style={({ isActive }) => (isActive ? activeStyle : linkBase)}
        >
          Quản lý khách hàng
        </NavLink>

        <NavLink
          to="/reports"
          style={({ isActive }) => (isActive ? activeStyle : linkBase)}
        >
          Báo cáo
        </NavLink>

        <NavLink
          to="/notifications"
          style={({ isActive }) => (isActive ? activeStyle : linkBase)}
        >
          Thông báo
        </NavLink>
      </nav>
    </aside>
  );
};

export default Sidebar;
