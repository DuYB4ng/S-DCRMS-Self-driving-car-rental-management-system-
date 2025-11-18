import React, { useState } from "react";
import {
  Shield,
  AlertTriangle,
  Eye,
  XIcon,
  Ban,
  CheckCircle,
  Clock,
  TrendingUp,
  DollarSign,
  User,
  Car,
  CreditCard,
  MapPin,
  Phone,
  Calendar,
  Activity,
} from "lucide-react";

const FraudDetectionPage = () => {
  // Mock data for suspicious activities
  const [alerts, setAlerts] = useState([
    {
      alertID: "FRD001",
      type: "Payment",
      severity: "High",
      status: "Pending",
      title: "Giao dịch thanh toán bất thường",
      description:
        "Phát hiện 5 giao dịch thanh toán thất bại liên tiếp từ cùng một tài khoản",
      userID: "USR12345",
      userName: "Nguyễn Văn A",
      userEmail: "nguyenvana@example.com",
      userPhone: "+84912345678",
      relatedEntity: "Payment #PAY789",
      amount: "15,000,000đ",
      timestamp: "2024-11-18 14:30:00",
      ipAddress: "103.92.28.15",
      location: "Hà Nội, Vietnam",
      riskScore: 85,
      indicators: [
        "Multiple failed payments",
        "Unusual transaction time",
        "New payment method",
      ],
    },
    {
      alertID: "FRD002",
      type: "Account",
      severity: "Critical",
      status: "Investigating",
      title: "Tài khoản đăng ký giả mạo",
      description:
        "Phát hiện tài khoản sử dụng thông tin giả mạo và ảnh CMND không hợp lệ",
      userID: "USR67890",
      userName: "Trần Thị B",
      userEmail: "fake_email@tempmail.com",
      userPhone: "+84987654321",
      relatedEntity: "Registration #REG456",
      amount: null,
      timestamp: "2024-11-18 10:15:00",
      ipAddress: "45.118.135.20",
      location: "TP. HCM, Vietnam",
      riskScore: 95,
      indicators: [
        "Temporary email service",
        "Invalid ID photo",
        "VPN/Proxy detected",
        "Phone number already used",
      ],
    },
    {
      alertID: "FRD003",
      type: "Booking",
      severity: "Medium",
      status: "Pending",
      title: "Đặt xe liên tục và hủy",
      description:
        "Người dùng đặt và hủy 8 lần trong 2 ngày, có thể gây thiệt hại cho chủ xe",
      userID: "USR11111",
      userName: "Lê Văn C",
      userEmail: "levanc@example.com",
      userPhone: "+84901234567",
      relatedEntity: "Bookings #BKG101-108",
      amount: "120,000,000đ",
      timestamp: "2024-11-17 18:45:00",
      ipAddress: "171.244.55.88",
      location: "Đà Nẵng, Vietnam",
      riskScore: 72,
      indicators: [
        "Multiple cancellations",
        "High value bookings",
        "Short booking duration",
      ],
    },
    {
      alertID: "FRD004",
      type: "Review",
      severity: "Low",
      status: "Resolved",
      title: "Đánh giá spam và giả mạo",
      description:
        "Phát hiện 15 đánh giá 1 sao cho cùng một chủ xe từ tài khoản mới tạo",
      userID: "USR22222",
      userName: "Phạm Thị D",
      userEmail: "competitor@fake.com",
      userPhone: "+84909876543",
      relatedEntity: "Car Owner #OWN555",
      amount: null,
      timestamp: "2024-11-16 22:00:00",
      ipAddress: "113.161.45.12",
      location: "Hà Nội, Vietnam",
      riskScore: 68,
      indicators: [
        "Fake reviews pattern",
        "New account with no bookings",
        "Targeting single owner",
      ],
    },
    {
      alertID: "FRD005",
      type: "Car Listing",
      severity: "High",
      status: "Pending",
      title: "Xe đăng ký giả mạo",
      description:
        "Biển số xe không tồn tại trong database và ảnh xe lấy từ internet",
      userID: "USR33333",
      userName: "Hoàng Văn E",
      userEmail: "hoangvane@example.com",
      userPhone: "+84912345098",
      relatedEntity: "Car #CAR999",
      amount: null,
      timestamp: "2024-11-18 09:20:00",
      ipAddress: "14.231.178.45",
      location: "Cần Thơ, Vietnam",
      riskScore: 88,
      indicators: [
        "Invalid license plate",
        "Stock photos detected",
        "Duplicate car description",
      ],
    },
  ]);

  const [showDetailModal, setShowDetailModal] = useState(false);
  const [selectedAlert, setSelectedAlert] = useState(null);

  // Statistics
  const totalAlerts = alerts.length;
  const pendingAlerts = alerts.filter((a) => a.status === "Pending").length;
  const criticalAlerts = alerts.filter((a) => a.severity === "Critical").length;
  const avgRiskScore = (
    alerts.reduce((sum, a) => sum + a.riskScore, 0) / totalAlerts
  ).toFixed(0);

  // Handle actions
  const handleViewDetail = (alert) => {
    setSelectedAlert(alert);
    setShowDetailModal(true);
  };

  const handleResolve = (alertID) => {
    setAlerts(
      alerts.map((alert) =>
        alert.alertID === alertID ? { ...alert, status: "Resolved" } : alert
      )
    );
  };

  const handleBlock = (alertID) => {
    if (
      window.confirm(
        "Bạn có chắc muốn chặn người dùng này? Họ sẽ không thể sử dụng dịch vụ nữa."
      )
    ) {
      setAlerts(
        alerts.map((alert) =>
          alert.alertID === alertID ? { ...alert, status: "Blocked" } : alert
        )
      );
    }
  };

  const handleInvestigate = (alertID) => {
    setAlerts(
      alerts.map((alert) =>
        alert.alertID === alertID
          ? { ...alert, status: "Investigating" }
          : alert
      )
    );
  };

  const getSeverityColor = (severity) => {
    switch (severity) {
      case "Critical":
        return "from-red-500 to-red-600";
      case "High":
        return "from-orange-500 to-orange-600";
      case "Medium":
        return "from-yellow-500 to-yellow-600";
      case "Low":
        return "from-blue-500 to-blue-600";
      default:
        return "from-gray-500 to-gray-600";
    }
  };

  const getStatusBadge = (status) => {
    switch (status) {
      case "Pending":
        return "bg-yellow-100 text-yellow-700";
      case "Investigating":
        return "bg-blue-100 text-blue-700";
      case "Resolved":
        return "bg-green-100 text-green-700";
      case "Blocked":
        return "bg-red-100 text-red-700";
      default:
        return "bg-gray-100 text-gray-700";
    }
  };

  return (
    <div className="p-6 bg-[#F5F9FA] min-h-screen">
      {/* Header */}
      <div className="mb-6">
        <h1 className="text-3xl font-bold text-[#2C3E50] mb-2">
          Phát hiện gian lận
        </h1>
        <p className="text-[#7F8C8D]">
          Giám sát và xử lý các hoạt động đáng ngờ trong hệ thống
        </p>
      </div>

      {/* Statistics Cards */}
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-4 mb-6">
        <div className="bg-gradient-to-br from-red-50 to-red-100 rounded-xl p-5 shadow-md border border-red-200">
          <div className="flex items-center justify-between">
            <div>
              <p className="text-red-600 text-sm font-medium mb-1">
                Tổng cảnh báo
              </p>
              <p className="text-[#2C3E50] text-3xl font-bold">{totalAlerts}</p>
            </div>
            <div className="bg-red-500 p-3 rounded-xl">
              <AlertTriangle className="w-8 h-8 text-white" />
            </div>
          </div>
        </div>

        <div className="bg-gradient-to-br from-yellow-50 to-yellow-100 rounded-xl p-5 shadow-md border border-yellow-200">
          <div className="flex items-center justify-between">
            <div>
              <p className="text-yellow-600 text-sm font-medium mb-1">
                Chờ xử lý
              </p>
              <p className="text-[#2C3E50] text-3xl font-bold">
                {pendingAlerts}
              </p>
            </div>
            <div className="bg-yellow-500 p-3 rounded-xl">
              <Clock className="w-8 h-8 text-white" />
            </div>
          </div>
        </div>

        <div className="bg-gradient-to-br from-orange-50 to-orange-100 rounded-xl p-5 shadow-md border border-orange-200">
          <div className="flex items-center justify-between">
            <div>
              <p className="text-orange-600 text-sm font-medium mb-1">
                Mức độ cao
              </p>
              <p className="text-[#2C3E50] text-3xl font-bold">
                {criticalAlerts}
              </p>
            </div>
            <div className="bg-orange-500 p-3 rounded-xl">
              <Shield className="w-8 h-8 text-white" />
            </div>
          </div>
        </div>

        <div className="bg-gradient-to-br from-purple-50 to-purple-100 rounded-xl p-5 shadow-md border border-purple-200">
          <div className="flex items-center justify-between">
            <div>
              <p className="text-purple-600 text-sm font-medium mb-1">
                Điểm rủi ro TB
              </p>
              <p className="text-[#2C3E50] text-3xl font-bold">
                {avgRiskScore}
              </p>
            </div>
            <div className="bg-purple-500 p-3 rounded-xl">
              <TrendingUp className="w-8 h-8 text-white" />
            </div>
          </div>
        </div>
      </div>

      {/* Fraud Detection Dashboard */}
      <div className="grid grid-cols-1 lg:grid-cols-3 gap-6 mb-6">
        {/* Fraud Types Chart */}
        <div className="bg-white rounded-xl p-6 shadow-md">
          <h3 className="text-[#2C3E50] font-bold text-lg mb-4">
            Loại gian lận
          </h3>
          <div className="space-y-3">
            {[
              { type: "Payment", count: 1, color: "bg-red-500" },
              { type: "Account", count: 1, color: "bg-orange-500" },
              { type: "Booking", count: 1, color: "bg-yellow-500" },
              { type: "Review", count: 1, color: "bg-blue-500" },
              { type: "Car Listing", count: 1, color: "bg-purple-500" },
            ].map((item, index) => (
              <div key={index}>
                <div className="flex items-center justify-between mb-1">
                  <span className="text-[#2C3E50] text-sm font-medium">
                    {item.type}
                  </span>
                  <span className="text-[#7F8C8D] text-sm">{item.count}</span>
                </div>
                <div className="w-full bg-gray-100 rounded-full h-2">
                  <div
                    className={`${item.color} h-2 rounded-full`}
                    style={{ width: `${(item.count / totalAlerts) * 100}%` }}
                  />
                </div>
              </div>
            ))}
          </div>
        </div>

        {/* Risk Levels */}
        <div className="bg-white rounded-xl p-6 shadow-md">
          <h3 className="text-[#2C3E50] font-bold text-lg mb-4">
            Mức độ nghiêm trọng
          </h3>
          <div className="space-y-4">
            {[
              { level: "Critical", count: 1, color: "red" },
              { level: "High", count: 2, color: "orange" },
              { level: "Medium", count: 1, color: "yellow" },
              { level: "Low", count: 1, color: "blue" },
            ].map((item, index) => (
              <div
                key={index}
                className={`bg-${item.color}-50 p-4 rounded-xl border border-${item.color}-200`}
              >
                <div className="flex items-center justify-between">
                  <span
                    className={`text-${item.color}-700 font-semibold text-sm`}
                  >
                    {item.level}
                  </span>
                  <span className={`text-${item.color}-600 text-2xl font-bold`}>
                    {item.count}
                  </span>
                </div>
              </div>
            ))}
          </div>
        </div>

        {/* Recent Actions */}
        <div className="bg-white rounded-xl p-6 shadow-md">
          <h3 className="text-[#2C3E50] font-bold text-lg mb-4">
            Hành động gần đây
          </h3>
          <div className="space-y-3">
            <div className="flex items-start gap-3 pb-3 border-b border-gray-100">
              <div className="bg-red-100 p-2 rounded-lg">
                <Ban className="w-4 h-4 text-red-600" />
              </div>
              <div className="flex-1">
                <p className="text-[#2C3E50] text-sm font-semibold">
                  Đã chặn người dùng
                </p>
                <p className="text-[#7F8C8D] text-xs">USR67890 - 2 giờ trước</p>
              </div>
            </div>

            <div className="flex items-start gap-3 pb-3 border-b border-gray-100">
              <div className="bg-green-100 p-2 rounded-lg">
                <CheckCircle className="w-4 h-4 text-green-600" />
              </div>
              <div className="flex-1">
                <p className="text-[#2C3E50] text-sm font-semibold">
                  Giải quyết cảnh báo
                </p>
                <p className="text-[#7F8C8D] text-xs">FRD004 - 5 giờ trước</p>
              </div>
            </div>

            <div className="flex items-start gap-3">
              <div className="bg-blue-100 p-2 rounded-lg">
                <Activity className="w-4 h-4 text-blue-600" />
              </div>
              <div className="flex-1">
                <p className="text-[#2C3E50] text-sm font-semibold">
                  Đang điều tra
                </p>
                <p className="text-[#7F8C8D] text-xs">FRD002 - 1 ngày trước</p>
              </div>
            </div>
          </div>
        </div>
      </div>

      {/* Alerts List */}
      <div className="bg-white rounded-xl shadow-md overflow-hidden">
        <div className="p-6 bg-gradient-to-r from-red-500 to-orange-500 text-white">
          <h2 className="text-2xl font-bold">Cảnh báo gian lận</h2>
          <p className="text-white/90 text-sm mt-1">
            Danh sách các hoạt động đáng ngờ cần xem xét
          </p>
        </div>

        <div className="divide-y divide-gray-100">
          {alerts.map((alert) => (
            <div
              key={alert.alertID}
              className="p-6 hover:bg-gray-50 transition-colors"
            >
              <div className="flex items-start gap-4">
                {/* Risk Score Circle */}
                <div className="flex-shrink-0">
                  <div
                    className={`w-16 h-16 rounded-full flex items-center justify-center bg-gradient-to-br ${getSeverityColor(
                      alert.severity
                    )} text-white shadow-lg`}
                  >
                    <div className="text-center">
                      <p className="text-2xl font-bold">{alert.riskScore}</p>
                      <p className="text-xs">Risk</p>
                    </div>
                  </div>
                </div>

                {/* Alert Content */}
                <div className="flex-1 min-w-0">
                  <div className="flex items-start justify-between mb-2">
                    <div className="flex-1">
                      <div className="flex items-center gap-2 mb-1">
                        <h3 className="text-[#2C3E50] font-bold text-lg">
                          {alert.title}
                        </h3>
                        <span
                          className={`px-2 py-1 rounded-full text-xs font-semibold ${getStatusBadge(
                            alert.status
                          )}`}
                        >
                          {alert.status}
                        </span>
                      </div>
                      <p className="text-[#7F8C8D] text-sm mb-2">
                        {alert.description}
                      </p>
                    </div>
                  </div>

                  {/* Alert Details Grid */}
                  <div className="grid grid-cols-2 lg:grid-cols-4 gap-3 mb-3">
                    <div className="bg-blue-50 p-3 rounded-lg">
                      <div className="flex items-center gap-2 mb-1">
                        <User className="w-4 h-4 text-blue-600" />
                        <p className="text-blue-600 text-xs font-medium">
                          Người dùng
                        </p>
                      </div>
                      <p className="text-[#2C3E50] text-sm font-semibold truncate">
                        {alert.userName}
                      </p>
                      <p className="text-[#7F8C8D] text-xs">{alert.userID}</p>
                    </div>

                    <div className="bg-purple-50 p-3 rounded-lg">
                      <div className="flex items-center gap-2 mb-1">
                        <AlertTriangle className="w-4 h-4 text-purple-600" />
                        <p className="text-purple-600 text-xs font-medium">
                          Loại
                        </p>
                      </div>
                      <p className="text-[#2C3E50] text-sm font-semibold">
                        {alert.type}
                      </p>
                      <p className="text-[#7F8C8D] text-xs">
                        {alert.severity} severity
                      </p>
                    </div>

                    <div className="bg-green-50 p-3 rounded-lg">
                      <div className="flex items-center gap-2 mb-1">
                        <MapPin className="w-4 h-4 text-green-600" />
                        <p className="text-green-600 text-xs font-medium">
                          Vị trí
                        </p>
                      </div>
                      <p className="text-[#2C3E50] text-sm font-semibold truncate">
                        {alert.location}
                      </p>
                      <p className="text-[#7F8C8D] text-xs truncate">
                        {alert.ipAddress}
                      </p>
                    </div>

                    <div className="bg-orange-50 p-3 rounded-lg">
                      <div className="flex items-center gap-2 mb-1">
                        <Clock className="w-4 h-4 text-orange-600" />
                        <p className="text-orange-600 text-xs font-medium">
                          Thời gian
                        </p>
                      </div>
                      <p className="text-[#2C3E50] text-sm font-semibold">
                        {alert.timestamp.split(" ")[0]}
                      </p>
                      <p className="text-[#7F8C8D] text-xs">
                        {alert.timestamp.split(" ")[1]}
                      </p>
                    </div>
                  </div>

                  {/* Indicators */}
                  <div className="mb-3">
                    <p className="text-[#2C3E50] text-xs font-semibold mb-2">
                      Chỉ số đáng ngờ:
                    </p>
                    <div className="flex flex-wrap gap-2">
                      {alert.indicators.map((indicator, index) => (
                        <span
                          key={index}
                          className="px-2 py-1 bg-red-50 text-red-700 text-xs rounded-full border border-red-200"
                        >
                          {indicator}
                        </span>
                      ))}
                    </div>
                  </div>

                  {/* Action Buttons */}
                  <div className="flex items-center gap-2">
                    <button
                      onClick={() => handleViewDetail(alert)}
                      className="px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition-all flex items-center gap-2 text-sm font-semibold"
                    >
                      <Eye className="w-4 h-4" />
                      Xem chi tiết
                    </button>

                    {alert.status === "Pending" && (
                      <>
                        <button
                          onClick={() => handleInvestigate(alert.alertID)}
                          className="px-4 py-2 bg-yellow-600 text-white rounded-lg hover:bg-yellow-700 transition-all text-sm font-semibold"
                        >
                          Điều tra
                        </button>
                        <button
                          onClick={() => handleResolve(alert.alertID)}
                          className="px-4 py-2 bg-green-600 text-white rounded-lg hover:bg-green-700 transition-all flex items-center gap-2 text-sm font-semibold"
                        >
                          <CheckCircle className="w-4 h-4" />
                          Giải quyết
                        </button>
                        <button
                          onClick={() => handleBlock(alert.alertID)}
                          className="px-4 py-2 bg-red-600 text-white rounded-lg hover:bg-red-700 transition-all flex items-center gap-2 text-sm font-semibold"
                        >
                          <Ban className="w-4 h-4" />
                          Chặn
                        </button>
                      </>
                    )}
                  </div>
                </div>
              </div>
            </div>
          ))}
        </div>
      </div>

      {/* Detail Modal */}
      {showDetailModal && selectedAlert && (
        <div className="fixed inset-0 bg-black/50 flex items-center justify-center z-50 p-4">
          <div className="bg-white rounded-2xl max-w-4xl w-full max-h-[90vh] overflow-y-auto">
            <div
              className={`sticky top-0 bg-gradient-to-r ${getSeverityColor(
                selectedAlert.severity
              )} text-white p-6 flex items-center justify-between rounded-t-2xl`}
            >
              <div>
                <h2 className="text-2xl font-bold mb-1">
                  {selectedAlert.title}
                </h2>
                <p className="text-white/90 text-sm">{selectedAlert.alertID}</p>
              </div>
              <button
                onClick={() => setShowDetailModal(false)}
                className="p-2 hover:bg-white/20 rounded-lg transition-all"
              >
                <XIcon className="w-6 h-6" />
              </button>
            </div>

            <div className="p-6">
              {/* Risk Score */}
              <div className="bg-gradient-to-br from-red-50 to-orange-50 p-6 rounded-xl mb-6 text-center">
                <p className="text-[#7F8C8D] text-sm mb-2">Điểm rủi ro</p>
                <p className="text-6xl font-bold text-red-600 mb-2">
                  {selectedAlert.riskScore}
                </p>
                <p className="text-[#2C3E50] font-semibold">
                  {selectedAlert.severity} Risk Level
                </p>
              </div>

              {/* User Information */}
              <div className="mb-6">
                <h3 className="text-[#2C3E50] font-bold text-lg mb-4">
                  Thông tin người dùng
                </h3>
                <div className="grid grid-cols-2 gap-4">
                  <div className="bg-gray-50 p-4 rounded-xl">
                    <div className="flex items-center gap-2 mb-2">
                      <User className="w-5 h-5 text-[#2E7D9A]" />
                      <p className="text-[#7F8C8D] text-sm font-medium">
                        Họ tên
                      </p>
                    </div>
                    <p className="text-[#2C3E50] font-semibold">
                      {selectedAlert.userName}
                    </p>
                  </div>

                  <div className="bg-gray-50 p-4 rounded-xl">
                    <div className="flex items-center gap-2 mb-2">
                      <User className="w-5 h-5 text-[#2E7D9A]" />
                      <p className="text-[#7F8C8D] text-sm font-medium">
                        User ID
                      </p>
                    </div>
                    <p className="text-[#2C3E50] font-semibold">
                      {selectedAlert.userID}
                    </p>
                  </div>

                  <div className="bg-gray-50 p-4 rounded-xl">
                    <div className="flex items-center gap-2 mb-2">
                      <Phone className="w-5 h-5 text-[#2E7D9A]" />
                      <p className="text-[#7F8C8D] text-sm font-medium">
                        Điện thoại
                      </p>
                    </div>
                    <p className="text-[#2C3E50] font-semibold">
                      {selectedAlert.userPhone}
                    </p>
                  </div>

                  <div className="bg-gray-50 p-4 rounded-xl">
                    <div className="flex items-center gap-2 mb-2">
                      <MapPin className="w-5 h-5 text-[#2E7D9A]" />
                      <p className="text-[#7F8C8D] text-sm font-medium">
                        Email
                      </p>
                    </div>
                    <p className="text-[#2C3E50] font-semibold">
                      {selectedAlert.userEmail}
                    </p>
                  </div>
                </div>
              </div>

              {/* Alert Details */}
              <div className="mb-6">
                <h3 className="text-[#2C3E50] font-bold text-lg mb-4">
                  Chi tiết cảnh báo
                </h3>
                <div className="bg-yellow-50 border border-yellow-200 rounded-xl p-4 mb-4">
                  <p className="text-[#2C3E50]">{selectedAlert.description}</p>
                </div>

                <div className="grid grid-cols-2 gap-4">
                  <div className="bg-gray-50 p-4 rounded-xl">
                    <p className="text-[#7F8C8D] text-sm mb-1">Liên quan đến</p>
                    <p className="text-[#2C3E50] font-semibold">
                      {selectedAlert.relatedEntity}
                    </p>
                  </div>

                  <div className="bg-gray-50 p-4 rounded-xl">
                    <p className="text-[#7F8C8D] text-sm mb-1">IP Address</p>
                    <p className="text-[#2C3E50] font-semibold">
                      {selectedAlert.ipAddress}
                    </p>
                  </div>

                  <div className="bg-gray-50 p-4 rounded-xl">
                    <p className="text-[#7F8C8D] text-sm mb-1">Vị trí</p>
                    <p className="text-[#2C3E50] font-semibold">
                      {selectedAlert.location}
                    </p>
                  </div>

                  <div className="bg-gray-50 p-4 rounded-xl">
                    <p className="text-[#7F8C8D] text-sm mb-1">Thời gian</p>
                    <p className="text-[#2C3E50] font-semibold">
                      {selectedAlert.timestamp}
                    </p>
                  </div>
                </div>
              </div>

              {/* Indicators */}
              <div className="mb-6">
                <h3 className="text-[#2C3E50] font-bold text-lg mb-4">
                  Các dấu hiệu đáng ngờ
                </h3>
                <div className="space-y-2">
                  {selectedAlert.indicators.map((indicator, index) => (
                    <div
                      key={index}
                      className="flex items-center gap-3 bg-red-50 p-3 rounded-lg border border-red-200"
                    >
                      <AlertTriangle className="w-5 h-5 text-red-600 flex-shrink-0" />
                      <p className="text-[#2C3E50] font-medium">{indicator}</p>
                    </div>
                  ))}
                </div>
              </div>

              {/* Actions */}
              <div className="flex gap-3">
                <button
                  onClick={() => {
                    handleResolve(selectedAlert.alertID);
                    setShowDetailModal(false);
                  }}
                  className="flex-1 bg-green-600 text-white py-3 rounded-lg font-semibold hover:bg-green-700 transition-all flex items-center justify-center gap-2"
                >
                  <CheckCircle className="w-5 h-5" />
                  Giải quyết
                </button>
                <button
                  onClick={() => {
                    handleBlock(selectedAlert.alertID);
                    setShowDetailModal(false);
                  }}
                  className="flex-1 bg-red-600 text-white py-3 rounded-lg font-semibold hover:bg-red-700 transition-all flex items-center justify-center gap-2"
                >
                  <Ban className="w-5 h-5" />
                  Chặn người dùng
                </button>
                <button
                  onClick={() => setShowDetailModal(false)}
                  className="flex-1 bg-gray-200 text-[#2C3E50] py-3 rounded-lg font-semibold hover:bg-gray-300 transition-all"
                >
                  Đóng
                </button>
              </div>
            </div>
          </div>
        </div>
      )}
    </div>
  );
};

export default FraudDetectionPage;
