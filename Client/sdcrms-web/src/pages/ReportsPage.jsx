import React, { useState } from "react";
import {
  BarChart3,
  TrendingUp,
  DollarSign,
  Users,
  Car,
  Calendar,
  Download,
  FileText,
  PieChart,
  Activity,
  CreditCard,
  ArrowUp,
  ArrowDown,
} from "lucide-react";

const ReportsPage = () => {
  const [selectedPeriod, setSelectedPeriod] = useState("month");

  // Revenue Statistics
  const revenueStats = [
    {
      title: "Tổng doanh thu",
      value: "245,000,000đ",
      change: "+15.3%",
      trend: "up",
      icon: DollarSign,
      color: "#10B981",
    },
    {
      title: "Doanh thu hôm nay",
      value: "8,500,000đ",
      change: "+8.2%",
      trend: "up",
      icon: TrendingUp,
      color: "#3B82F6",
    },
    {
      title: "Giao dịch tháng này",
      value: "1,234",
      change: "+12.5%",
      trend: "up",
      icon: CreditCard,
      color: "#F59E0B",
    },
    {
      title: "Chi phí vận hành",
      value: "45,000,000đ",
      change: "-5.2%",
      trend: "down",
      icon: Activity,
      color: "#EF4444",
    },
  ];

  // Booking Statistics
  const bookingStats = [
    { month: "T1", bookings: 145, revenue: 45 },
    { month: "T2", bookings: 178, revenue: 52 },
    { month: "T3", bookings: 195, revenue: 58 },
    { month: "T4", bookings: 220, revenue: 65 },
    { month: "T5", bookings: 245, revenue: 72 },
    { month: "T6", bookings: 268, revenue: 80 },
  ];

  // Top performing cars
  const topCars = [
    {
      name: "Toyota Camry",
      bookings: 156,
      revenue: "45,000,000đ",
      rating: 4.8,
      color: "#3B82F6",
    },
    {
      name: "Honda City",
      bookings: 134,
      revenue: "38,000,000đ",
      rating: 4.6,
      color: "#10B981",
    },
    {
      name: "Mazda 3",
      bookings: 120,
      revenue: "35,000,000đ",
      rating: 4.7,
      color: "#F59E0B",
    },
    {
      name: "Hyundai Accent",
      bookings: 98,
      revenue: "28,000,000đ",
      rating: 4.5,
      color: "#8B5CF6",
    },
  ];

  // Payment method statistics
  const paymentMethods = [
    { name: "MoMo", percentage: 35, amount: "85,750,000đ", color: "#EC4899" },
    { name: "VNPay", percentage: 28, amount: "68,600,000đ", color: "#3B82F6" },
    {
      name: "ZaloPay",
      percentage: 20,
      amount: "49,000,000đ",
      color: "#06B6D4",
    },
    {
      name: "Ngân hàng",
      percentage: 12,
      amount: "29,400,000đ",
      color: "#10B981",
    },
    {
      name: "Tiền mặt",
      percentage: 5,
      amount: "12,250,000đ",
      color: "#F59E0B",
    },
  ];

  // Customer statistics
  const customerStats = [
    { label: "Tổng khách hàng", value: "1,234", change: "+12.5%" },
    { label: "Khách hàng mới", value: "145", change: "+8.3%" },
    { label: "Khách hàng thân thiết", value: "456", change: "+15.7%" },
    { label: "Tỷ lệ giữ chân", value: "87.5%", change: "+3.2%" },
  ];

  // Compliance metrics
  const complianceMetrics = [
    { name: "Giao dịch được xác thực", value: 98.5, status: "excellent" },
    { name: "Tuân thủ thanh toán", value: 99.2, status: "excellent" },
    { name: "Bảo mật dữ liệu", value: 100, status: "excellent" },
    { name: "Xử lý khiếu nại", value: 95.8, status: "good" },
  ];

  return (
    <div className="p-6 bg-[#F5F9FA] min-h-screen">
      {/* Header */}
      <div className="flex items-center justify-between mb-6">
        <div>
          <h1 className="text-3xl font-bold text-[#2C3E50] mb-2">
            Báo cáo & Thống kê
          </h1>
          <p className="text-[#7F8C8D]">
            Phân tích chi tiết về doanh thu, giao dịch và hiệu suất
          </p>
        </div>
        <div className="flex gap-3">
          <select
            value={selectedPeriod}
            onChange={(e) => setSelectedPeriod(e.target.value)}
            className="px-4 py-2 bg-white border border-gray-200 rounded-lg text-[#2C3E50] text-sm focus:outline-none focus:ring-2 focus:ring-[#2E7D9A] hover:border-[#2E7D9A] transition-all duration-300 ease-out cursor-pointer"
          >
            <option value="day">Hôm nay</option>
            <option value="week">Tuần này</option>
            <option value="month">Tháng này</option>
            <option value="year">Năm này</option>
          </select>
          <button className="flex items-center gap-2 bg-[#2E7D9A] text-white px-4 py-2 rounded-lg hover:bg-[#236a80] hover:shadow-lg hover:scale-105 active:scale-95 transition-all duration-300 ease-out text-sm font-medium">
            <Download className="w-4 h-4 transition-transform duration-300 group-hover:translate-y-0.5" />
            Xuất báo cáo
          </button>
        </div>
      </div>

      {/* Revenue Stats */}
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-4 mb-6">
        {revenueStats.map((stat, index) => {
          const Icon = stat.icon;
          const TrendIcon = stat.trend === "up" ? ArrowUp : ArrowDown;
          const trendColor = stat.trend === "up" ? "#10B981" : "#EF4444";

          return (
            <div
              key={index}
              className="bg-gradient-to-br from-white to-gray-50 rounded-xl p-5 shadow-md hover:shadow-xl hover:-translate-y-1 transition-all duration-500 ease-out animate-fade-in-up"
              style={{ animationDelay: `${index * 100}ms` }}
            >
              <div className="flex items-start justify-between mb-3">
                <div
                  className="p-3 rounded-xl shadow-sm hover:scale-110 transition-transform duration-300 ease-out"
                  style={{ backgroundColor: `${stat.color}1A` }}
                >
                  <Icon
                    className="w-5 h-5 transition-transform duration-300"
                    style={{ color: stat.color }}
                  />
                </div>
                <div
                  className="flex items-center gap-1 text-xs font-bold px-2 py-1 rounded-full"
                  style={{
                    backgroundColor: `${trendColor}1A`,
                    color: trendColor,
                  }}
                >
                  <TrendIcon className="w-3 h-3" />
                  {stat.change}
                </div>
              </div>
              <p className="text-[#7F8C8D] text-xs mb-1">{stat.title}</p>
              <p className="text-[#2C3E50] text-xl font-bold">{stat.value}</p>
            </div>
          );
        })}
      </div>

      <div className="grid lg:grid-cols-3 gap-6 mb-6">
        {/* Booking Trends */}
        <div className="lg:col-span-2 bg-gradient-to-br from-blue-50 via-white to-green-50 rounded-xl p-6 shadow-md">
          <h2 className="text-[#2C3E50] text-lg font-bold mb-5">
            Xu hướng đặt xe và doanh thu
          </h2>
          <div className="space-y-4">
            {bookingStats.map((stat, index) => (
              <div
                key={index}
                className="flex items-center gap-4 animate-slide-in-right"
                style={{ animationDelay: `${index * 100}ms` }}
              >
                <span className="text-[#7F8C8D] text-sm font-medium w-12">
                  {stat.month}
                </span>
                <div className="flex-1">
                  <div className="flex items-center gap-2 mb-1">
                    <div className="flex-1 bg-blue-100 rounded-full h-3 overflow-hidden">
                      <div
                        className="bg-[#3B82F6] h-full rounded-full transition-all duration-1000 ease-out animate-progress-fill"
                        style={{
                          width: `${(stat.bookings / 300) * 100}%`,
                          animationDelay: `${index * 150}ms`,
                        }}
                      />
                    </div>
                    <span className="text-[#2C3E50] text-sm font-bold w-12">
                      {stat.bookings}
                    </span>
                  </div>
                  <div className="flex items-center gap-2">
                    <div className="flex-1 bg-green-100 rounded-full h-3 overflow-hidden">
                      <div
                        className="bg-[#10B981] h-full rounded-full transition-all duration-1000 ease-out animate-progress-fill"
                        style={{
                          width: `${(stat.revenue / 100) * 100}%`,
                          animationDelay: `${index * 150 + 75}ms`,
                        }}
                      />
                    </div>
                    <span className="text-[#10B981] text-sm font-bold w-12">
                      {stat.revenue}M
                    </span>
                  </div>
                </div>
              </div>
            ))}
          </div>

          <div className="flex gap-6 mt-6 pt-4 border-t border-gray-100">
            <div className="flex items-center gap-2">
              <div className="w-3 h-3 bg-[#3B82F6] rounded-full" />
              <span className="text-[#7F8C8D] text-xs">Số lượng đặt xe</span>
            </div>
            <div className="flex items-center gap-2">
              <div className="w-3 h-3 bg-[#10B981] rounded-full" />
              <span className="text-[#7F8C8D] text-xs">Doanh thu (triệu)</span>
            </div>
          </div>
        </div>

        {/* Customer Stats */}
        <div className="bg-gradient-to-br from-purple-50 via-white to-pink-50 rounded-xl p-6 shadow-md">
          <h2 className="text-[#2C3E50] text-lg font-bold mb-5">
            Thống kê khách hàng
          </h2>
          <div className="space-y-4">
            {customerStats.map((stat, index) => (
              <div
                key={index}
                className="animate-fade-in-up hover:bg-gray-50 p-2 rounded-lg transition-all duration-300 cursor-pointer"
                style={{ animationDelay: `${index * 100}ms` }}
              >
                <div className="flex items-center justify-between mb-2">
                  <span className="text-[#7F8C8D] text-sm">{stat.label}</span>
                  <span className="text-green-600 text-xs font-bold transition-transform duration-300 hover:scale-110">
                    {stat.change}
                  </span>
                </div>
                <p className="text-[#2C3E50] text-2xl font-bold transition-all duration-300">
                  {stat.value}
                </p>
                {index < customerStats.length - 1 && (
                  <div className="mt-3 border-b border-gray-100" />
                )}
              </div>
            ))}
          </div>
        </div>
      </div>

      <div className="grid lg:grid-cols-2 gap-6">
        {/* Top Performing Cars */}
        <div className="bg-gradient-to-br from-orange-50 via-white to-yellow-50 rounded-xl p-6 shadow-md">
          <h2 className="text-[#2C3E50] text-lg font-bold mb-5">
            Xe có doanh thu cao nhất
          </h2>
          <div className="space-y-4">
            {topCars.map((car, index) => (
              <div
                key={index}
                className="flex items-center gap-4 p-4 bg-gradient-to-r from-white to-gray-50 rounded-xl hover:shadow-lg hover:scale-105 hover:-translate-y-1 transition-all duration-500 ease-out cursor-pointer animate-fade-in-up"
                style={{ animationDelay: `${index * 100}ms` }}
              >
                <div
                  className="w-12 h-12 rounded-xl flex items-center justify-center text-white font-bold text-lg hover:rotate-6 transition-transform duration-300 ease-out"
                  style={{ backgroundColor: car.color }}
                >
                  {index + 1}
                </div>
                <div className="flex-1">
                  <h3 className="text-[#2C3E50] font-bold mb-1">{car.name}</h3>
                  <div className="flex items-center gap-3 text-xs text-[#7F8C8D]">
                    <span>{car.bookings} lượt đặt</span>
                    <span>•</span>
                    <span>⭐ {car.rating}</span>
                  </div>
                </div>
                <div className="text-right">
                  <p className="text-[#2C3E50] font-bold">{car.revenue}</p>
                </div>
              </div>
            ))}
          </div>
        </div>

        {/* Payment Methods */}
        <div className="bg-gradient-to-br from-cyan-50 via-white to-blue-50 rounded-xl p-6 shadow-md">
          <h2 className="text-[#2C3E50] text-lg font-bold mb-5">
            Phương thức thanh toán
          </h2>
          <div className="space-y-4">
            {paymentMethods.map((method, index) => (
              <div
                key={index}
                className="animate-fade-in-up"
                style={{ animationDelay: `${index * 100}ms` }}
              >
                <div className="flex items-center justify-between mb-2">
                  <span className="text-[#2C3E50] text-sm font-medium">
                    {method.name}
                  </span>
                  <div className="text-right">
                    <p className="text-[#2C3E50] text-sm font-bold transition-all duration-300">
                      {method.percentage}%
                    </p>
                    <p className="text-[#7F8C8D] text-xs">{method.amount}</p>
                  </div>
                </div>
                <div className="w-full bg-gray-100 rounded-full h-2 overflow-hidden">
                  <div
                    className="h-full rounded-full transition-all duration-1000 ease-out animate-progress-fill hover:opacity-80"
                    style={{
                      width: `${method.percentage}%`,
                      backgroundColor: method.color,
                      animationDelay: `${index * 150}ms`,
                    }}
                  />
                </div>
              </div>
            ))}
          </div>
        </div>
      </div>

      {/* Compliance Metrics */}
      <div className="bg-gradient-to-br from-green-50 via-white to-emerald-50 rounded-xl p-6 shadow-md mt-6">
        <h2 className="text-[#2C3E50] text-lg font-bold mb-5">
          Tuân thủ và Bảo mật
        </h2>
        <div className="grid md:grid-cols-4 gap-6">
          {complianceMetrics.map((metric, index) => (
            <div
              key={index}
              className="text-center animate-fade-in-up hover:scale-110 transition-transform duration-500 ease-out cursor-pointer"
              style={{ animationDelay: `${index * 150}ms` }}
            >
              <div className="relative w-24 h-24 mx-auto mb-3">
                <svg className="w-24 h-24 transform -rotate-90">
                  <circle
                    cx="48"
                    cy="48"
                    r="40"
                    stroke="#E5E7EB"
                    strokeWidth="8"
                    fill="none"
                  />
                  <circle
                    cx="48"
                    cy="48"
                    r="40"
                    stroke={
                      metric.status === "excellent" ? "#10B981" : "#3B82F6"
                    }
                    strokeWidth="8"
                    fill="none"
                    strokeDasharray={`${2 * Math.PI * 40}`}
                    strokeDashoffset={`${
                      2 * Math.PI * 40 * (1 - metric.value / 100)
                    }`}
                    strokeLinecap="round"
                    className="transition-all duration-2000 ease-out"
                    style={{
                      animation: "draw-circle 2s ease-out forwards",
                      animationDelay: `${index * 200}ms`,
                    }}
                  />
                </svg>
                <div className="absolute inset-0 flex items-center justify-center">
                  <span className="text-[#2C3E50] text-xl font-bold">
                    {metric.value}%
                  </span>
                </div>
              </div>
              <p className="text-[#2C3E50] text-sm font-medium">
                {metric.name}
              </p>
            </div>
          ))}
        </div>
      </div>
    </div>
  );
};

export default ReportsPage;
