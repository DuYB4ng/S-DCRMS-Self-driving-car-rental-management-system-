import React from "react";
import { Link, useLocation } from "react-router-dom";
import {
  HomeIcon,
  CarIcon,
  CalendarIcon,
  CreditCardIcon,
  BellIcon,
  LogOutIcon,
} from "lucide-react";

const Sidebar = ({ isOpen, onClose }) => {
  const location = useLocation();

  const menuItems = [
    { path: "/", icon: HomeIcon, label: "Dashboard" },
    { path: "/car-management", icon: CarIcon, label: "Quản lý xe" },
    {
      path: "/booking-management",
      icon: CalendarIcon,
      label: "Quản lý đặt xe",
    },
    { path: "/payment", icon: CreditCardIcon, label: "Thanh toán" },
    { path: "/notifications", icon: BellIcon, label: "Thông báo" },
  ];

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
          {menuItems.map((item) => {
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
