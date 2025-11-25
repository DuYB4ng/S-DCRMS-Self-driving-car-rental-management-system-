import React, { useState, useEffect } from "react";
import { Link, useLocation } from "react-router-dom";
import {
  HomeIcon,
  CarIcon,
  CalendarIcon,
  CreditCardIcon,
  BellIcon,
  LogOutIcon,
  Users,
  Shield,
  AlertTriangle,
  BarChart3,
  Activity,
  UserCog,
  FileText,
} from "lucide-react";

const Sidebar = ({ isOpen, onClose }) => {
  const location = useLocation();
  const [userRole, setUserRole] = useState(null);

  useEffect(() => {
    // Lấy user role từ localStorage
    const userStr = localStorage.getItem("adminUser");
    if (userStr) {
      try {
        const user = JSON.parse(userStr);
        setUserRole(user.role || "Staff"); // Default Staff nếu không có role
      } catch {
        setUserRole("Staff");
      }
    }
  }, []);

  const menuItems = [
    {
      path: "/",
      icon: HomeIcon,
      label: "Dashboard",
      roles: ["Admin", "Staff"],
    },
    {
      path: "/car-management",
      icon: CarIcon,
      label: "Quản lý xe",
      roles: ["Admin", "Staff"],
    },
    {
      path: "/booking-management",
      icon: CalendarIcon,
      label: "Quản lý đặt xe",
      roles: ["Admin", "Staff"],
    },
    {
      path: "/payment",
      icon: CreditCardIcon,
      label: "Thanh toán",
      roles: ["Admin", "Staff"],
    },
    {
      path: "/staff-management",
      icon: Users,
      label: "Quản lý nhân viên",
      roles: ["Admin"],
    },
    {
      path: "/compliance-policy",
      icon: Shield,
      label: "Chính sách tuân thủ",
      roles: ["Admin"],
    },
    {
      path: "/fraud-detection",
      icon: AlertTriangle,
      label: "Phát hiện gian lận",
      roles: ["Admin"],
    },
    {
      path: "/reports",
      icon: BarChart3,
      label: "Báo cáo",
      roles: ["Admin", "Staff"],
    },
    {
      path: "/system-monitoring",
      icon: Activity,
      label: "Giám sát hệ thống",
      roles: ["Admin"],
    },
    {
      path: "/notifications",
      icon: BellIcon,
      label: "Thông báo",
      roles: ["Admin", "Staff"],
    },
    {
      path: "/admin-management",
      icon: UserCog,
      label: "Quản lý Admin",
      roles: ["Admin"],
    },
  ];

  // Filter menu items theo role
  const filteredMenuItems = menuItems.filter(
    (item) => !item.roles || item.roles.includes(userRole)
  );

  const isActive = (path) => location.pathname === path;

  return (
    <>
      {/* Overlay for mobile */}
      {isOpen && (
        <div
          className="fixed inset-0 bg-black/50 z-40 lg:hidden"
          onClick={onClose}
        />
      )}

      {/* Sidebar */}
      <aside
        className={`
          fixed lg:static inset-y-0 left-0 z-50
          w-64 bg-white shadow-lg
          transform transition-transform duration-300 ease-in-out
          ${isOpen ? "translate-x-0" : "-translate-x-full lg:translate-x-0"}
        `}
      >
        {/* Header */}
        <div className="bg-gradient-to-br from-[#2E7D9A] to-[#3498DB] p-6 shadow-md">
          <div className="flex items-center justify-center mb-3">
            <div className="w-16 h-16 bg-white rounded-full flex items-center justify-center shadow-lg">
              <svg
                className="w-10 h-10 text-[#2E7D9A]"
                fill="currentColor"
                viewBox="0 0 24 24"
              >
                <path d="M12 2L2 7v10c0 5.55 3.84 10.74 9 12 5.16-1.26 9-6.45 9-12V7l-10-5z" />
              </svg>
            </div>
          </div>
          <h2 className="text-white text-xl font-black text-center tracking-wide drop-shadow-md">
            SDCRMS Admin
          </h2>
        </div>

        {/* Menu Items */}
        <nav className="p-4">
          {filteredMenuItems.map((item) => {
            const Icon = item.icon;
            const active = isActive(item.path);
            return (
              <Link
                key={item.path}
                to={item.path}
                onClick={onClose}
                className={`
                  flex items-center gap-3 px-4 py-3 mb-2 rounded-lg
                  transition-all duration-200
                  ${
                    active
                      ? "bg-[#2E7D9A] text-white shadow-md"
                      : "text-[#2C3E50] hover:bg-blue-50"
                  }
                `}
              >
                <Icon className="w-5 h-5" />
                <span className="text-sm font-medium">{item.label}</span>
              </Link>
            );
          })}

          {/* Divider */}
          <div className="border-t border-gray-200 my-4" />

          {/* Logout */}
          <button
            onClick={() => {
              if (window.confirm("Bạn có chắc muốn đăng xuất?")) {
                alert("Đã đăng xuất");
              }
            }}
            className="w-full flex items-center gap-3 px-4 py-3 rounded-lg text-[#2C3E50] hover:bg-red-50 hover:text-[#EF4444] transition-all"
          >
            <LogOutIcon className="w-5 h-5" />
            <span className="text-sm font-medium">Đăng xuất</span>
          </button>
        </nav>
      </aside>
    </>
  );
};

export default Sidebar;
