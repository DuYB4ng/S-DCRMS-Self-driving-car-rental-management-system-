import React, { useState } from "react";
import { CreditCardIcon, WalletIcon, BanknoteIcon } from "lucide-react";

const PaymentPage = () => {
  const [selectedFilter, setSelectedFilter] = useState("Tất cả");

  // const payments = [...] // Đã loại bỏ dữ liệu tĩnh, hãy fetch từ API
  const [payments, setPayments] = useState([]);

  const filters = [
    "Tất cả",
    "Chờ xử lý",
    "Đang xử lý",
    "Thành công",
    "Thất bại",
  ];

  const paymentMethods = [
    { name: "MoMo", color: "bg-pink-600", icon: "💳" },
    { name: "VNPay", color: "bg-blue-600", icon: "💳" },
    { name: "ZaloPay", color: "bg-blue-400", icon: "💳" },
    { name: "Ngân hàng", color: "bg-green-600", icon: "🏦" },
    { name: "Tiền mặt", color: "bg-yellow-500", icon: "💵" },
  ];

  const totalAmount = payments.reduce((sum, p) => sum + p.amount, 0);
  const completedAmount = payments
    .filter((p) => p.status === "completed")
    .reduce((sum, p) => sum + p.amount, 0);
  const pendingAmount = payments
    .filter((p) => p.status === "pending" || p.status === "processing")
    .reduce((sum, p) => sum + p.amount, 0);

  const getStatusInfo = (status) => {
    switch (status) {
      case "pending":
        return { text: "Chờ xử lý", color: "bg-yellow-500", icon: "⏳" };
      case "processing":
        return { text: "Đang xử lý", color: "bg-purple-600", icon: "🔄" };
      case "completed":
        return { text: "Thành công", color: "bg-green-600", icon: "✓" };
      case "failed":
        return { text: "Thất bại", color: "bg-red-600", icon: "✕" };
      case "refunded":
        return { text: "Đã hoàn tiền", color: "bg-gray-500", icon: "↩" };
      default:
        return { text: status, color: "bg-gray-500", icon: "?" };
    }
  };

  const getMethodInfo = (method) => {
    switch (method) {
      case "momo":
        return {
          name: "MoMo",
          color: "text-pink-600",
          bgColor: "bg-pink-50",
          icon: "💳",
        };
      case "vnpay":
        return {
          name: "VNPay",
          color: "text-blue-600",
          bgColor: "bg-blue-50",
          icon: "💳",
        };
      case "zalopay":
        return {
          name: "ZaloPay",
          color: "text-blue-400",
          bgColor: "bg-blue-50",
          icon: "💳",
        };
      case "bank_transfer":
        return {
          name: "Chuyển khoản",
          color: "text-green-600",
          bgColor: "bg-green-50",
          icon: "🏦",
        };
      case "cash":
        return {
          name: "Tiền mặt",
          color: "text-yellow-600",
          bgColor: "bg-yellow-50",
          icon: "💵",
        };
      default:
        return {
          name: method,
          color: "text-gray-600",
          bgColor: "bg-gray-50",
          icon: "💰",
        };
    }
  };

  const formatDate = (date) => {
    return new Intl.DateTimeFormat("vi-VN", {
      day: "2-digit",
      month: "2-digit",
      year: "numeric",
      hour: "2-digit",
      minute: "2-digit",
    }).format(date);
  };

  const filteredPayments = payments.filter((payment) => {
    if (selectedFilter === "Tất cả") return true;
    const statusMap = {
      "Chờ xử lý": "pending",
      "Đang xử lý": "processing",
      "Thành công": "completed",
      "Thất bại": "failed",
    };
    return payment.status === statusMap[selectedFilter];
  });

  return (
    <div className="p-6 bg-secondary min-h-screen">
      {/* Header */}
      <h1 className="text-3xl font-bold text-textPrimary mb-6">
        Thanh toán bên thứ ba
      </h1>

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
      <div className="grid md:grid-cols-3 gap-4 mb-6">
        <div className="bg-white rounded-lg p-5 shadow-md">
          <p className="text-textSecondary text-sm mb-1">Tổng</p>
          <p className="text-2xl font-bold text-primary">
            {totalAmount.toLocaleString()}đ
          </p>
        </div>
        <div className="bg-white rounded-lg p-5 shadow-md">
          <p className="text-textSecondary text-sm mb-1">Thành công</p>
          <p className="text-2xl font-bold text-green-600">
            {completedAmount.toLocaleString()}đ
          </p>
        </div>
        <div className="bg-white rounded-lg p-5 shadow-md">
          <p className="text-textSecondary text-sm mb-1">Chờ xử lý</p>
          <p className="text-2xl font-bold text-yellow-600">
            {pendingAmount.toLocaleString()}đ
          </p>
        </div>
      </div>

      {/* Payment Methods */}
      <div className="bg-white rounded-lg p-6 mb-6 shadow-md">
        <h2 className="text-lg font-bold text-textPrimary mb-4">
          Phương thức thanh toán
        </h2>
        <div className="flex flex-wrap gap-3">
          {paymentMethods.map((method, index) => (
            <div
              key={index}
              className="flex items-center gap-3 border border-gray-200 rounded-lg px-4 py-3 hover:border-primary transition"
            >
              <div
                className={`${method.color} w-12 h-12 rounded-full flex items-center justify-center text-2xl`}
              >
                {method.icon}
              </div>
              <div>
                <p className="font-semibold text-textPrimary">{method.name}</p>
              </div>
            </div>
          ))}
        </div>
      </div>

      {/* Payments List */}
      <div className="space-y-4">
        {filteredPayments.map((payment) => {
          const statusInfo = getStatusInfo(payment.status);
          const methodInfo = getMethodInfo(payment.method);

          return (
            <div
              key={payment.id}
              className="bg-white rounded-xl shadow-md hover:shadow-lg transition p-5"
            >
              <div className="flex flex-col lg:flex-row lg:items-center gap-4">
                {/* Method Icon */}
                <div
                  className={`${methodInfo.bgColor} w-16 h-16 rounded-full flex items-center justify-center text-3xl flex-shrink-0`}
                >
                  {methodInfo.icon}
                </div>

                {/* Info */}
                <div className="flex-1">
                  <div className="flex items-start justify-between mb-2">
                    <div>
                      <h3 className="text-lg font-bold text-textPrimary">
                        {payment.id}
                      </h3>
                      <p
                        className={`text-sm font-semibold ${methodInfo.color}`}
                      >
                        {methodInfo.name}
                      </p>
                    </div>
                    <span
                      className={`${statusInfo.color} text-white px-3 py-1 rounded-full text-xs font-bold flex items-center gap-1`}
                    >
                      <span>{statusInfo.icon}</span>
                      {statusInfo.text}
                    </span>
                  </div>

                  <div className="grid md:grid-cols-2 gap-2 text-sm text-textSecondary mb-3">
                    <div className="flex items-center gap-2">
                      <span>👤</span>
                      <span>{payment.customerName}</span>
                    </div>
                    <div className="flex items-center gap-2">
                      <span>📋</span>
                      <span>Đơn hàng: {payment.bookingId}</span>
                    </div>
                    {payment.transactionId && (
                      <div className="flex items-center gap-2">
                        <span>🏷️</span>
                        <span className="text-xs">
                          MGD: {payment.transactionId}
                        </span>
                      </div>
                    )}
                  </div>

                  <div className="flex items-center justify-between pt-3 border-t border-gray-200">
                    <div>
                      <p className="text-2xl font-bold text-primary">
                        {payment.amount.toLocaleString()}đ
                      </p>
                    </div>
                    <p className="text-xs text-textSecondary">
                      {formatDate(payment.createdAt)}
                    </p>
                  </div>
                </div>
              </div>
            </div>
          );
        })}
      </div>

      {/* Empty State */}
      {filteredPayments.length === 0 && (
        <div className="text-center py-12 bg-white rounded-xl">
          <div className="text-6xl mb-4">💳</div>
          <p className="text-textSecondary">Không có giao dịch nào</p>
        </div>
      )}
    </div>
  );
};

export default PaymentPage;
