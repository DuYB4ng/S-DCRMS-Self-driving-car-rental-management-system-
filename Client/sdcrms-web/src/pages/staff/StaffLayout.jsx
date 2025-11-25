import { NavLink } from "react-router-dom";
import Header from "../../components/Header";

const LayoutStaff = ({ children, userRole }) => {
  const menu = [
    { label: "Dashboard", to: "/staff" },
    { label: "Owners", to: "/staff/owners" },
    { label: "Owner Cars", to: "/staff/ownercars" },
    { label: "Customers", to: "/staff/customers" },
    { label: "Reports", to: "/staff/reports" },
    { label: "Notifications", to: "/staff/notifications" },
  ];

  const handleLogout = () => {
    if (window.confirm("Bạn có chắc muốn đăng xuất?")) {
      localStorage.removeItem("adminToken");
      localStorage.removeItem("adminUser");
      window.location.href = "/login";
    }
  };

  return (
    <div style={{ minHeight: "100vh", background: "#f3f4f6" }}>
      <Header />
      <div style={{ display: "flex" }}>
        {/* Sidebar staff */}
        <aside
          style={{
            width: 240,
            background: "#fff",
            color: "#222",
            padding: 0,
            boxShadow: "2px 0 8px 0 rgba(0,0,0,0.04)",
            display: "flex",
            flexDirection: "column",
          }}
        >
          <div
            style={{
              background: "linear-gradient(135deg, #2E7D9A, #3498DB)",
              color: "#fff",
              padding: "32px 0 20px 0",
              textAlign: "center",
            }}
          >
            <div style={{ fontWeight: 900, fontSize: 22, letterSpacing: 1 }}>
              SDCRMS Staff
            </div>
            <div style={{ fontSize: 13, marginTop: 4, opacity: 0.85 }}>
              {userRole === "Staff"
                ? "Nhân viên"
                : userRole === "User"
                ? "Khách hàng"
                : userRole}
            </div>
          </div>

          <nav style={{ flex: 1, padding: "24px 0" }}>
            {menu.map((item) => (
              <NavLink
                key={item.to}
                to={item.to}
                style={({ isActive }) => ({
                  display: "block",
                  padding: "12px 32px",
                  color: isActive ? "#2563eb" : "#222",
                  background: isActive ? "#e0e7ff" : "transparent",
                  fontWeight: isActive ? 700 : 500,
                  borderLeft: isActive
                    ? "4px solid #2563eb"
                    : "4px solid transparent",
                  textDecoration: "none",
                  borderRadius: "0 20px 20px 0",
                  marginBottom: 2,
                  transition: "all 0.18s",
                })}
                end={item.to === "/staff"}
              >
                {item.label}
              </NavLink>
            ))}
          </nav>

          <div style={{ borderTop: "1px solid #e5e7eb", marginTop: 16 }} />

          <button
            onClick={handleLogout}
            style={{
              width: "100%",
              padding: "12px 32px",
              background: "none",
              border: "none",
              color: "#dc2626",
              fontWeight: 600,
              fontSize: 15,
              textAlign: "left",
              cursor: "pointer",
              marginTop: 8,
              borderRadius: "0 20px 20px 0",
              transition: "background 0.18s",
            }}
          >
            Đăng xuất
          </button>
        </aside>

        {/* Nội dung */}
        <main style={{ flex: 1, padding: 32 }}>{children}</main>
      </div>
    </div>
  );
};

export default LayoutStaff;
