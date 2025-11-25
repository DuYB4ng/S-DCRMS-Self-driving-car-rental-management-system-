import React from "react";
import { Link } from "react-router-dom";
import {
  Users,
  Car,
  DollarSign,
  ShieldCheck,
  BarChart3,
  Wallet,
  TrendingUp,
  Plus,
  Activity,
  Calendar,
  CreditCard,
  AlertCircle,
} from "lucide-react";

const DashboardPage = () => {
  return (
    <div className="p-6 bg-[#F5F9FA] min-h-screen">
      {/* Welcome Banner giống mobile */}
      <div className="bg-gradient-to-br from-[#2E7D9A] to-[#3498DB] rounded-2xl p-8 mb-6 shadow-xl">
        <div className="flex items-center justify-between">
          <div className="flex-1">
            <p className="text-white/90 text-sm mb-1 font-medium">
              Chào mừng trở lại!
            </p>
            <h1 className="text-white text-3xl font-bold mb-3">
              OwnerCar Dashboard
            </h1>
            <p className="text-white text-sm">Sức khỏe hệ thống: 98.5%</p>
          </div>
          <div className="bg-white/20 backdrop-blur-sm rounded-2xl p-6">
            <ShieldCheck className="w-12 h-12 text-white" />
          </div>
        </div>
      </div>

      {/* Stats Grid giống mobile chính xác */}
      <div className="grid grid-cols-2 lg:grid-cols-4 gap-4 mb-6">
        {/* Card 1: Tổng người dùng */}
        <div className="bg-white rounded-xl p-5 shadow-md">
          <div className="flex items-start justify-between mb-3">
            <div className="bg-blue-50 p-3 rounded-xl">
              <Users className="w-5 h-5 text-[#3B82F6]" />
            </div>
            <span className="bg-green-50 text-green-600 text-xs font-bold px-2 py-1 rounded-md">
              +12.5%
            </span>
          </div>
          <p className="text-[#7F8C8D] text-xs mb-1">Tổng người dùng</p>
          <p className="text-[#2C3E50] text-2xl font-bold">1234</p>
        </div>

        {/* Card 2: Đặt xe hoạt động */}
        <div className="bg-white rounded-xl p-5 shadow-md">
          <div className="flex items-start justify-between mb-3">
            <div className="bg-green-50 p-3 rounded-xl">
              <Car className="w-5 h-5 text-[#10B981]" />
            </div>
            <span className="bg-green-50 text-green-600 text-xs font-bold px-2 py-1 rounded-md">
              +8.3%
            </span>
          </div>
          <p className="text-[#7F8C8D] text-xs mb-1">Đặt xe hoạt động</p>
          <p className="text-[#2C3E50] text-2xl font-bold">56</p>
        </div>

        {/* Card 3: Doanh thu */}
        <div className="bg-white rounded-xl p-5 shadow-md">
          <div className="flex items-start justify-between mb-3">
            <div className="bg-yellow-50 p-3 rounded-xl">
              <DollarSign className="w-5 h-5 text-[#F59E0B]" />
            </div>
            <span className="bg-green-50 text-green-600 text-xs font-bold px-2 py-1 rounded-md">
              +15.7%
            </span>
          </div>
          <p className="text-[#7F8C8D] text-xs mb-1">Doanh thu</p>
          <p className="text-[#2C3E50] text-2xl font-bold">125K</p>
        </div>

        {/* Card 4: Tổng xe */}
        <div className="bg-white rounded-xl p-5 shadow-md">
          <div className="flex items-start justify-between mb-3">
            <div className="bg-[#2E7D9A]/10 p-3 rounded-xl">
              <Car className="w-5 h-5 text-[#2E7D9A]" />
            </div>
            <span className="bg-green-50 text-green-600 text-xs font-bold px-2 py-1 rounded-md">
              +5.2%
            </span>
          </div>
          <p className="text-[#7F8C8D] text-xs mb-1">Tổng xe</p>
          <p className="text-[#2C3E50] text-2xl font-bold">89</p>
        </div>
      </div>

      {/* Fleet Section giống mobile */}
      <div className="bg-white rounded-xl p-6 mb-6 shadow-md">
        <div className="flex items-center justify-between mb-5">
          <h2 className="text-[#2C3E50] text-lg font-bold">Đội xe của tôi</h2>
          <Link
            to="/car-management"
            className="flex items-center gap-2 text-[#2E7D9A] hover:bg-[#2E7D9A]/5 px-3 py-2 rounded-lg transition text-sm font-medium"
          >
            <Plus className="w-4 h-4" />
            Thêm xe
          </Link>
        </div>
        <div className="grid grid-cols-2 lg:grid-cols-4 gap-4">
          {/* Sedan */}
          <div className="bg-blue-50 border-2 border-blue-100 rounded-xl p-4">
            <div className="flex flex-col items-center">
              <div className="bg-blue-100 rounded-full p-2 mb-2">
                <Car className="w-5 h-5 text-[#3B82F6]" />
              </div>
              <p className="text-[#3B82F6] text-2xl font-bold mb-1">32</p>
              <p className="text-[#7F8C8D] text-xs">Sedan</p>
            </div>
          </div>

          {/* SUV */}
          <div className="bg-green-50 border-2 border-green-100 rounded-xl p-4">
            <div className="flex flex-col items-center">
              <div className="bg-green-100 rounded-full p-2 mb-2">
                <Car className="w-5 h-5 text-[#10B981]" />
              </div>
              <p className="text-[#10B981] text-2xl font-bold mb-1">24</p>
              <p className="text-[#7F8C8D] text-xs">SUV</p>
            </div>
          </div>

          {/* Hatchback */}
          <div className="bg-yellow-50 border-2 border-yellow-100 rounded-xl p-4">
            <div className="flex flex-col items-center">
              <div className="bg-yellow-100 rounded-full p-2 mb-2">
                <Car className="w-5 h-5 text-[#F59E0B]" />
              </div>
              <p className="text-[#F59E0B] text-2xl font-bold mb-1">18</p>
              <p className="text-[#7F8C8D] text-xs">Hatchback</p>
            </div>
          </div>

          {/* MPV */}
          <div className="bg-red-50 border-2 border-red-100 rounded-xl p-4">
            <div className="flex flex-col items-center">
              <div className="bg-red-100 rounded-full p-2 mb-2">
                <Car className="w-5 h-5 text-[#EF4444]" />
              </div>
              <p className="text-[#EF4444] text-2xl font-bold mb-1">15</p>
              <p className="text-[#7F8C8D] text-xs">MPV</p>
            </div>
          </div>
        </div>
      </div>

      {/* Main Functions Grid giống mobile */}
      <div className="grid grid-cols-2 lg:grid-cols-4 gap-4 mb-6">
        {/* Giám sát hệ thống */}
        <Link
          to="/system-monitoring"
          className="bg-white rounded-xl p-6 shadow-md hover:shadow-lg transition"
        >
          <div className="flex flex-col items-center text-center">
            <div className="bg-[#2E7D9A]/10 rounded-xl p-4 mb-3">
              <ShieldCheck className="w-7 h-7 text-[#2E7D9A]" />
            </div>
            <p className="text-[#2C3E50] text-sm font-semibold">
              Giám sát hệ thống
            </p>
          </div>
        </Link>

        {/* Báo cáo */}
        <Link
          to="/reports"
          className="bg-white rounded-xl p-6 shadow-md hover:shadow-lg transition"
        >
          <div className="flex flex-col items-center text-center">
            <div className="bg-blue-50 rounded-xl p-4 mb-3">
              <BarChart3 className="w-7 h-7 text-[#3B82F6]" />
            </div>
            <p className="text-[#2C3E50] text-sm font-semibold">Báo cáo</p>
          </div>
        </Link>

        {/* Giao dịch */}
        <Link
          to="/payment"
          className="bg-white rounded-xl p-6 shadow-md hover:shadow-lg transition"
        >
          <div className="flex flex-col items-center text-center">
            <div className="bg-green-50 rounded-xl p-4 mb-3">
              <Wallet className="w-7 h-7 text-[#10B981]" />
            </div>
            <p className="text-[#2C3E50] text-sm font-semibold">Giao dịch</p>
          </div>
        </Link>

        {/* Quản lý xe */}
        <Link
          to="/car-management"
          className="bg-white rounded-xl p-6 shadow-md hover:shadow-lg transition"
        >
          <div className="flex flex-col items-center text-center">
            <div className="bg-yellow-50 rounded-xl p-4 mb-3">
              <Car className="w-7 h-7 text-[#F59E0B]" />
            </div>
            <p className="text-[#2C3E50] text-sm font-semibold">Quản lý xe</p>
          </div>
        </Link>
      </div>

      {/* Recent Activities giống mobile */}
      <div className="bg-white rounded-xl p-6 shadow-md">
        <h2 className="text-[#2C3E50] text-lg font-bold mb-5">
          Hoạt động gần đây
        </h2>
        <div className="space-y-4">
          <div className="flex items-start gap-3 pb-4 border-b border-gray-100">
            <div className="bg-blue-50 rounded-lg p-2">
              <Calendar className="w-5 h-5 text-[#3B82F6]" />
            </div>
            <div className="flex-1">
              <p className="text-[#2C3E50] text-sm font-medium mb-1">
                Đặt xe mới #1234
              </p>
              <p className="text-[#7F8C8D] text-xs">
                Toyota Camry - 5 phút trước
              </p>
            </div>
          </div>

          <div className="flex items-start gap-3 pb-4 border-b border-gray-100">
            <div className="bg-green-50 rounded-lg p-2">
              <CreditCard className="w-5 h-5 text-[#10B981]" />
            </div>
            <div className="flex-1">
              <p className="text-[#2C3E50] text-sm font-medium mb-1">
                Thanh toán hoàn tất
              </p>
              <p className="text-[#7F8C8D] text-xs">
                #5678 - 2,500,000đ - 15 phút trước
              </p>
            </div>
          </div>

          <div className="flex items-start gap-3 pb-4 border-b border-gray-100">
            <div className="bg-yellow-50 rounded-lg p-2">
              <AlertCircle className="w-5 h-5 text-[#F59E0B]" />
            </div>
            <div className="flex-1">
              <p className="text-[#2C3E50] text-sm font-medium mb-1">
                Xe cần bảo trì
              </p>
              <p className="text-[#7F8C8D] text-xs">Honda City - 1 giờ trước</p>
            </div>
          </div>

          <div className="flex items-start gap-3">
            <div className="bg-purple-50 rounded-lg p-2">
              <Users className="w-5 h-5 text-[#8B5CF6]" />
            </div>
            <div className="flex-1">
              <p className="text-[#2C3E50] text-sm font-medium mb-1">
                Khách hàng mới
              </p>
              <p className="text-[#7F8C8D] text-xs">
                Nguyễn Văn A - 2 giờ trước
              </p>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
};

export default DashboardPage;
