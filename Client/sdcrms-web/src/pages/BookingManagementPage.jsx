import React, { useState } from "react";
import {
  RefreshCwIcon,
  PlusIcon,
  CheckCircleIcon,
  XCircleIcon,
} from "lucide-react";

const BookingManagementPage = () => {
  const [selectedFilter, setSelectedFilter] = useState("Tất cả");

  const bookings = [
    {
      id: "BK001",
      customerId: "CUS001",
      customerName: "Nguyễn Văn A",
      customerPhone: "0123456789",
      carId: "CAR001",
      carName: "Toyota Vios 2020",
      carImage: "image/toyota-vios.png",
      startDate: new Date(Date.now() + 86400000),
      endDate: new Date(Date.now() + 259200000),
      totalPrice: 1500000,
      status: "pending",
      pickupLocation: "Sân bay Tân Sơn Nhất",
      dropoffLocation: "Khách sạn Rex",
      createdAt: new Date(Date.now() - 300000),
    },
    {
      id: "BK002",
      customerId: "CUS002",
      customerName: "Trần Thị B",
      customerPhone: "0987654321",
      carId: "CAR002",
      carName: "VinFast VF6 2023",
      carImage: "image/vinfast-vf6.png",
      startDate: new Date(Date.now() + 21600000),
      endDate: new Date(Date.now() + 432000000),
      totalPrice: 4500000,
      status: "confirmed",
      pickupLocation: "Bến xe Miền Đông",
      dropoffLocation: "Vũng Tàu",
      createdAt: new Date(Date.now() - 7200000),
    },
    {
      id: "BK003",
      customerId: "CUS003",
      customerName: "Lê Văn C",
      customerPhone: "0369852147",
      carId: "CAR003",
      carName: "Mazda 3 2018",
      carImage: "image/mazda-3.png",
      startDate: new Date(Date.now() - 43200000),
      endDate: new Date(Date.now() + 129600000),
      totalPrice: 900000,
      status: "in_progress",
      pickupLocation: "Quận 1",
      dropoffLocation: "Quận 7",
      createdAt: new Date(Date.now() - 86400000),
    },
  ];

  const filters = [
    "Tất cả",
    "Chờ xác nhận",
    "Đã xác nhận",
    "Đang thuê",
    "Hoàn thành",
    "Đã hủy",
  ];

  const stats = [
    {
      label: "Chờ xác nhận",
      value: bookings.filter((b) => b.status === "pending").length,
      color: "text-warning",
    },
    {
      label: "Đã xác nhận",
      value: bookings.filter((b) => b.status === "confirmed").length,
      color: "text-accent",
    },
    {
      label: "Đang thuê",
      value: bookings.filter((b) => b.status === "in_progress").length,
      color: "text-success",
    },
  ];

  const getStatusInfo = (status) => {
    switch (status) {
      case "pending":
        return { text: "Chờ xác nhận", color: "bg-warning", icon: "⏳" };
      case "confirmed":
        return { text: "Đã xác nhận", color: "bg-accent", icon: "✓" };
      case "in_progress":
        return { text: "Đang thuê", color: "bg-success", icon: "🚗" };
      case "completed":
        return { text: "Hoàn thành", color: "bg-gray-500", icon: "✔" };
      case "cancelled":
        return { text: "Đã hủy", color: "bg-danger", icon: "✕" };
      default:
        return { text: status, color: "bg-gray-500", icon: "?" };
    }
  };

  const formatDate = (date) => {
    return new Intl.DateTimeFormat("vi-VN", {
      day: "2-digit",
      month: "2-digit",
      hour: "2-digit",
      minute: "2-digit",
    }).format(date);
  };

  const getDaysDiff = (start, end) => {
    return Math.ceil((end - start) / (1000 * 60 * 60 * 24));
  };

  const isNew = (createdAt) => {
    return Date.now() - createdAt < 600000; // 10 minutes
  };

  const filteredBookings = bookings.filter((booking) => {
    if (selectedFilter === "Tất cả") return true;
    const statusMap = {
      "Chờ xác nhận": "pending",
      "Đã xác nhận": "confirmed",
      "Đang thuê": "in_progress",
      "Hoàn thành": "completed",
      "Đã hủy": "cancelled",
    };
    return booking.status === statusMap[selectedFilter];
  });

  return (
    <div className="p-6 bg-secondary min-h-screen">
      {/* Header */}
      <div className="flex flex-col md:flex-row md:items-center md:justify-between mb-6">
        <h1 className="text-3xl font-bold text-textPrimary mb-4 md:mb-0">
          Đặt xe thời gian thực
        </h1>
        <div className="flex gap-3">
          <button className="bg-white text-textPrimary px-4 py-2 rounded-lg hover:bg-gray-50 transition flex items-center gap-2 border border-gray-300">
            <RefreshCwIcon className="w-5 h-5" />
            Làm mới
          </button>
          <button className="bg-[#2E7D9A] text-white px-6 py-3 rounded-lg hover:opacity-90 transition flex items-center gap-2 font-medium shadow-md">
            <PlusIcon className="w-5 h-5" />
            Đặt xe mới
          </button>
        </div>
      </div>

      {/* Filters */}
      <div className="bg-white rounded-lg p-4 mb-6 shadow-md">
        <div className="flex flex-wrap gap-2">
          {filters.map((filter) => (
            <button
              key={filter}
              onClick={() => setSelectedFilter(filter)}
              className={`px-4 py-2 rounded-lg font-medium transition ${
                selectedFilter === filter
                  ? "bg-primary text-white"
                  : "bg-gray-100 text-textPrimary hover:bg-gray-200"
              }`}
            >
              {filter}
            </button>
          ))}
        </div>
      </div>

      {/* Stats */}
      <div className="grid grid-cols-3 gap-4 mb-6">
        {stats.map((stat, index) => (
          <div
            key={index}
            className="bg-white rounded-lg p-4 shadow-md text-center"
          >
            <p className={`text-3xl font-bold ${stat.color}`}>{stat.value}</p>
            <p className="text-textSecondary text-sm mt-1">{stat.label}</p>
          </div>
        ))}
      </div>

      {/* Bookings List */}
      <div className="space-y-4">
        {filteredBookings.map((booking) => {
          const statusInfo = getStatusInfo(booking.status);
          const days = getDaysDiff(booking.startDate, booking.endDate);
          const newBooking = isNew(booking.createdAt);

          return (
            <div
              key={booking.id}
              className={`bg-white rounded-xl shadow-md hover:shadow-lg transition overflow-hidden ${
                newBooking ? "border-2 border-danger" : ""
              }`}
            >
              <div className="p-5">
                <div className="flex flex-col lg:flex-row gap-4">
                  {/* Car Image */}
                  <div className="lg:w-32 h-24 bg-gray-200 rounded-lg overflow-hidden flex-shrink-0">
                    <img
                      src={booking.carImage}
                      alt={booking.carName}
                      className="w-full h-full object-cover"
                    />
                  </div>

                  {/* Info */}
                  <div className="flex-1">
                    <div className="flex items-start justify-between mb-3">
                      <div className="flex items-center gap-3">
                        <h3 className="text-lg font-bold text-textPrimary">
                          {booking.id}
                        </h3>
                        {newBooking && (
                          <span className="bg-danger text-white text-xs font-bold px-2 py-1 rounded">
                            MỚI
                          </span>
                        )}
                      </div>
                      <span
                        className={`${statusInfo.color} text-white px-3 py-1 rounded-full text-xs font-bold flex items-center gap-1`}
                      >
                        <span>{statusInfo.icon}</span>
                        {statusInfo.text}
                      </span>
                    </div>

                    <p className="text-textPrimary font-semibold mb-2">
                      {booking.carName}
                    </p>

                    <div className="grid md:grid-cols-2 gap-3 text-sm">
                      <div className="flex items-center gap-2 text-textSecondary">
                        <span>👤</span>
                        <span>
                          {booking.customerName} - {booking.customerPhone}
                        </span>
                      </div>
                      <div className="flex items-center gap-2 text-textSecondary">
                        <span>📅</span>
                        <span>
                          {formatDate(booking.startDate)} →{" "}
                          {formatDate(booking.endDate)}
                        </span>
                      </div>
                      <div className="flex items-center gap-2 text-textSecondary">
                        <span className="text-success">📍</span>
                        <span>{booking.pickupLocation}</span>
                      </div>
                      <div className="flex items-center gap-2 text-textSecondary">
                        <span className="text-danger">🏁</span>
                        <span>{booking.dropoffLocation}</span>
                      </div>
                    </div>

                    <div className="flex items-center justify-between mt-4 pt-4 border-t border-gray-200">
                      <div>
                        <p className="text-2xl font-bold text-primary">
                          {booking.totalPrice.toLocaleString()}đ
                        </p>
                        <p className="text-xs text-textSecondary">
                          {days} ngày
                        </p>
                      </div>

                      {booking.status === "pending" && (
                        <div className="flex gap-2">
                          <button className="bg-green-600 text-white px-4 py-2 rounded-lg hover:opacity-90 transition flex items-center gap-2 text-sm font-medium">
                            <CheckCircleIcon className="w-4 h-4" />
                            Xác nhận
                          </button>
                          <button className="bg-red-600 text-white px-4 py-2 rounded-lg hover:opacity-90 transition flex items-center gap-2 text-sm font-medium">
                            <XCircleIcon className="w-4 h-4" />
                            Từ chối
                          </button>
                        </div>
                      )}
                    </div>
                  </div>
                </div>
              </div>
            </div>
          );
        })}
      </div>

      {/* Empty State */}
      {filteredBookings.length === 0 && (
        <div className="text-center py-12 bg-white rounded-xl">
          <div className="text-6xl mb-4">📅</div>
          <p className="text-textSecondary">Không có đơn đặt xe nào</p>
        </div>
      )}
    </div>
  );
};

export default BookingManagementPage;
