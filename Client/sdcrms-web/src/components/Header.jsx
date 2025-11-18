import React, { useState, useEffect, useRef } from "react";
import {
  MenuIcon,
  SearchIcon,
  BellIcon,
  UserIcon,
  XIcon,
  Clock,
} from "lucide-react";
import { useNavigate } from "react-router-dom";

const Header = ({ onMenuClick }) => {
  const [showNotifications, setShowNotifications] = useState(false);
  const [notifications, setNotifications] = useState([]);
  const notificationRef = useRef(null);
  const navigate = useNavigate();

  // Mock notifications data
  useEffect(() => {
    const mockNotifications = [
      {
        notificationID: 1,
        title: "🎉 Chào mừng bạn đến với SDCRMS",
        message: "Chúc mừng bạn đã đăng ký tài khoản thành công!",
        createdAt: new Date().toISOString(),
        read: false,
        type: "info",
      },
      {
        notificationID: 2,
        title: "🚗 Xe mới có sẵn",
        message: "VinFast VF9 2023 vừa được thêm vào hệ thống.",
        createdAt: new Date(Date.now() - 3600000).toISOString(),
        read: false,
        type: "success",
      },
      {
        notificationID: 3,
        title: "✅ Đặt xe thành công",
        message: "Booking #BK001 của bạn đã được xác nhận.",
        createdAt: new Date(Date.now() - 7200000).toISOString(),
        read: true,
        type: "success",
      },
      {
        notificationID: 4,
        title: "💳 Thanh toán thành công",
        message: "Bạn đã thanh toán 1.500.000đ cho booking #BK002.",
        createdAt: new Date(Date.now() - 86400000).toISOString(),
        read: true,
        type: "success",
      },
      {
        notificationID: 5,
        title: "⚠️ Nhắc nhở bảo trì",
        message: "Xe Toyota Vios (51A-12345) cần bảo trì định kỳ.",
        createdAt: new Date(Date.now() - 172800000).toISOString(),
        read: false,
        type: "warning",
      },
    ];
    setNotifications(mockNotifications);
  }, []);

  // Close dropdown when clicking outside
  useEffect(() => {
    const handleClickOutside = (event) => {
      if (
        notificationRef.current &&
        !notificationRef.current.contains(event.target)
      ) {
        setShowNotifications(false);
      }
    };

    if (showNotifications) {
      document.addEventListener("mousedown", handleClickOutside);
    }

    return () => {
      document.removeEventListener("mousedown", handleClickOutside);
    };
  }, [showNotifications]);

  const unreadCount = notifications.filter((n) => !n.read).length;

  const formatTimeAgo = (timestamp) => {
    const now = new Date();
    const time = new Date(timestamp);
    const diffInSeconds = Math.floor((now - time) / 1000);

    if (diffInSeconds < 60) return "Vừa xong";
    if (diffInSeconds < 3600)
      return `${Math.floor(diffInSeconds / 60)} phút trước`;
    if (diffInSeconds < 86400)
      return `${Math.floor(diffInSeconds / 3600)} giờ trước`;
    return `${Math.floor(diffInSeconds / 86400)} ngày trước`;
  };

  const handleMarkAsRead = (id) => {
    setNotifications(
      notifications.map((n) =>
        n.notificationID === id ? { ...n, read: true } : n
      )
    );
  };

  const handleViewAll = () => {
    setShowNotifications(false);
    navigate("/notifications");
  };

  return (
    <header className="bg-[#2E7D9A] shadow-lg sticky top-0 z-30">
      <div className="flex items-center justify-between px-6 py-4">
        {/* Left: Menu Button + Search */}
        <div className="flex items-center gap-4 flex-1">
          <button
            onClick={onMenuClick}
            className="lg:hidden text-white p-2 hover:bg-white/10 rounded-lg transition-all duration-200"
          >
            <MenuIcon className="w-6 h-6" />
          </button>

          <div className="hidden md:flex items-center bg-white/20 backdrop-blur-sm rounded-lg px-4 py-2.5 flex-1 max-w-md shadow-sm">
            <SearchIcon className="w-5 h-5 text-white/80" />
            <input
              type="text"
              placeholder="Tìm kiếm..."
              className="bg-transparent border-none outline-none text-white placeholder:text-white/70 ml-2 w-full text-sm"
            />
          </div>
        </div>

        {/* Right: Notifications + Profile */}
        <div className="flex items-center gap-3">
          {/* Notification Bell */}
          <div className="relative" ref={notificationRef}>
            <button
              onClick={() => setShowNotifications(!showNotifications)}
              className="relative p-2.5 text-white hover:bg-white/10 rounded-lg transition-all duration-200"
            >
              <BellIcon className="w-6 h-6" />
              {unreadCount > 0 && (
                <>
                  <span className="absolute top-1.5 right-1.5 w-2.5 h-2.5 bg-red-500 rounded-full border-2 border-[#2E7D9A] animate-pulse" />
                  <span className="absolute -top-1 -right-1 bg-red-500 text-white text-xs font-bold rounded-full w-5 h-5 flex items-center justify-center">
                    {unreadCount}
                  </span>
                </>
              )}
            </button>

            {/* Notification Dropdown */}
            {showNotifications && (
              <div className="absolute right-0 mt-2 w-96 bg-white rounded-xl shadow-2xl overflow-hidden z-50 animate-fade-in-up">
                {/* Header */}
                <div className="bg-gradient-to-r from-[#2E7D9A] to-[#3498DB] p-4 flex items-center justify-between">
                  <div>
                    <h3 className="text-white font-bold text-lg">Thông báo</h3>
                    <p className="text-white/80 text-xs">
                      {unreadCount} thông báo chưa đọc
                    </p>
                  </div>
                  <button
                    onClick={() => setShowNotifications(false)}
                    className="text-white hover:bg-white/20 p-1.5 rounded-lg transition-all"
                  >
                    <XIcon className="w-5 h-5" />
                  </button>
                </div>

                {/* Notification List */}
                <div className="max-h-96 overflow-y-auto">
                  {notifications.length === 0 ? (
                    <div className="p-8 text-center">
                      <BellIcon className="w-12 h-12 text-gray-300 mx-auto mb-2" />
                      <p className="text-gray-500 text-sm">
                        Không có thông báo nào
                      </p>
                    </div>
                  ) : (
                    <div className="divide-y divide-gray-100">
                      {notifications.slice(0, 5).map((notification) => (
                        <div
                          key={notification.notificationID}
                          onClick={() =>
                            handleMarkAsRead(notification.notificationID)
                          }
                          className={`p-4 hover:bg-blue-50 transition-all cursor-pointer ${
                            !notification.read ? "bg-blue-50/50" : ""
                          }`}
                        >
                          <div className="flex items-start gap-3">
                            {!notification.read && (
                              <div className="w-2 h-2 bg-blue-500 rounded-full mt-2 flex-shrink-0" />
                            )}
                            <div className="flex-1 min-w-0">
                              <h4 className="text-[#2C3E50] font-semibold text-sm mb-1">
                                {notification.title}
                              </h4>
                              <p className="text-[#7F8C8D] text-xs mb-2 line-clamp-2">
                                {notification.message}
                              </p>
                              <div className="flex items-center gap-1 text-[#7F8C8D] text-xs">
                                <Clock className="w-3 h-3" />
                                <span>
                                  {formatTimeAgo(notification.createdAt)}
                                </span>
                              </div>
                            </div>
                          </div>
                        </div>
                      ))}
                    </div>
                  )}
                </div>

                {/* Footer */}
                {notifications.length > 0 && (
                  <div className="p-3 bg-gray-50 border-t border-gray-100">
                    <button
                      onClick={handleViewAll}
                      className="w-full text-center text-[#2E7D9A] font-semibold text-sm hover:bg-blue-50 py-2 rounded-lg transition-all"
                    >
                      Xem tất cả thông báo
                    </button>
                  </div>
                )}
              </div>
            )}
          </div>

          <div className="flex items-center gap-3 bg-white/20 backdrop-blur-sm rounded-lg px-4 py-2 shadow-sm">
            <div className="w-9 h-9 bg-white rounded-full flex items-center justify-center shadow-md">
              <UserIcon className="w-5 h-5 text-[#2E7D9A]" />
            </div>
            <div className="hidden md:block">
              <p className="text-white text-sm font-bold leading-tight">
                Admin
              </p>
              <p className="text-white/80 text-xs">Administrator</p>
            </div>
          </div>
        </div>
      </div>
    </header>
  );
};

export default Header;
