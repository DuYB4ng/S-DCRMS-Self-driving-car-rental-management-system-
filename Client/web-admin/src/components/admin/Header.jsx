import { Search, Bell, Menu } from "lucide-react";
import "./Admin.css";

const Header = () => {
  return (
    <div className="header">
      <div className="search-bar">
        <input type="text" placeholder="Search..." />
      </div>

      <div className="header-profile">
        <Bell size={20} color="#64748b" style={{ cursor: 'pointer' }} />
        <div className="avatar">A</div>
        <span style={{ fontSize: 14, fontWeight: 500, color: "#000000" }}>
          {localStorage.getItem("email") || "Admin"}
        </span>
      </div>
    </div>
  );
};

export default Header;
