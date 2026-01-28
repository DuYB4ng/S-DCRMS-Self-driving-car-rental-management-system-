import { LayoutDashboard, Users, Car, ShoppingBag, Settings, LogOut } from "lucide-react";
import { Link, useLocation, useNavigate } from "react-router-dom";

const Sidebar = () => {
  const location = useLocation();
  const navigate = useNavigate();

  const menuItems = [
    { icon: LayoutDashboard, label: "Dashboard", path: "/admin" },
    { icon: Users, label: "Users", path: "/admin/users" },
    { icon: ShoppingBag, label: "Orders", path: "/admin/orders" }, // Placeholder
    { icon: Car, label: "Cars", path: "/admin/cars" }, // Placeholder
    { icon: Settings, label: "Settings", path: "/admin/settings" }, // Placeholder
  ];

  const handleLogout = () => {
    localStorage.removeItem("token");
    localStorage.removeItem("role");
    navigate("/login");
  };

  return (
    <div className="sidebar">
      {/* Logo */}
      <div className="sidebar-logo">
        <h1>CONCEPT ADMIN</h1>
      </div>

      {/* Menu */}
      <div className="sidebar-menu">
        <p className="menu-label">MENU</p>
        <nav>
          {menuItems.map((item) => {
            const isActive = location.pathname === item.path;
            const Icon = item.icon;
            
            return (
              <Link
                key={item.path}
                to={item.path}
                className={`nav-link ${isActive ? "active" : ""}`}
              >
                <Icon size={20} style={{ marginRight: 12 }} />
                {item.label}
              </Link>
            );
          })}
        </nav>
      </div>

      {/* Footer / Logout */}
      <div className="sidebar-footer">
        <button onClick={handleLogout} className="logout-btn">
          <LogOut size={20} style={{ marginRight: 12 }} />
          Logout
        </button>
      </div>
    </div>
  );
};

export default Sidebar;
