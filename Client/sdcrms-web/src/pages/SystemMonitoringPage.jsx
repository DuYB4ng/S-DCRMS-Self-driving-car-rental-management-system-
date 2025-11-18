import React, { useState, useEffect } from "react";
import {
  Activity,
  Server,
  Database,
  Cpu,
  HardDrive,
  Users,
  Car,
  AlertTriangle,
  CheckCircle,
  TrendingUp,
  Clock,
  Wifi,
} from "lucide-react";

const SystemMonitoringPage = () => {
  const [systemHealth, setSystemHealth] = useState(98.5);
  const [activeUsers, setActiveUsers] = useState(145);

  // System Status Cards
  const systemStats = [
    {
      title: "Server Status",
      value: "Online",
      status: "healthy",
      icon: Server,
      details: "Uptime: 99.9%",
      color: "#10B981",
    },
    {
      title: "Database",
      value: "Active",
      status: "healthy",
      icon: Database,
      details: "Response: 12ms",
      color: "#3B82F6",
    },
    {
      title: "API Services",
      value: "Running",
      status: "healthy",
      icon: Wifi,
      details: "Requests: 1.2K/min",
      color: "#10B981",
    },
    {
      title: "CPU Usage",
      value: "45%",
      status: "warning",
      icon: Cpu,
      details: "4 cores active",
      color: "#F59E0B",
    },
  ];

  // Real-time metrics
  const metrics = [
    {
      label: "Active Sessions",
      value: activeUsers,
      icon: Users,
      color: "#3B82F6",
    },
    { label: "Active Bookings", value: 56, icon: Car, color: "#10B981" },
    { label: "Pending Payments", value: 12, icon: Clock, color: "#F59E0B" },
    { label: "System Alerts", value: 3, icon: AlertTriangle, color: "#EF4444" },
  ];

  // System logs
  const systemLogs = [
    {
      time: "8:45 PM",
      type: "info",
      message: "Database backup completed successfully",
      icon: CheckCircle,
    },
    {
      time: "8:30 PM",
      type: "warning",
      message: "High CPU usage detected (75%)",
      icon: AlertTriangle,
    },
    {
      time: "8:15 PM",
      type: "info",
      message: "Payment gateway sync completed",
      icon: CheckCircle,
    },
    {
      time: "8:00 PM",
      type: "info",
      message: "50 new user registrations today",
      icon: Users,
    },
    {
      time: "7:45 PM",
      type: "warning",
      message: "API rate limit approaching (85%)",
      icon: AlertTriangle,
    },
  ];

  // Performance metrics
  const performanceData = [
    { name: "Memory Usage", value: 62, max: 100, unit: "%", color: "#3B82F6" },
    { name: "Disk Space", value: 78, max: 100, unit: "%", color: "#10B981" },
    {
      name: "Network I/O",
      value: 45,
      max: 100,
      unit: "Mbps",
      color: "#F59E0B",
    },
    { name: "API Response", value: 12, max: 100, unit: "ms", color: "#10B981" },
  ];

  // Simulate real-time updates
  useEffect(() => {
    const interval = setInterval(() => {
      setActiveUsers((prev) => prev + Math.floor(Math.random() * 5 - 2));
      setSystemHealth(98 + Math.random() * 2);
    }, 3000);

    return () => clearInterval(interval);
  }, []);

  return (
    <div className="p-6 bg-[#F5F9FA] min-h-screen">
      {/* Header */}
      <div className="mb-6">
        <h1 className="text-3xl font-bold text-[#2C3E50] mb-2">
          Giám sát hệ thống
        </h1>
        <p className="text-[#7F8C8D]">
          Theo dõi hiệu suất và trạng thái hệ thống thời gian thực
        </p>
      </div>

      {/* System Health Overview */}
      <div className="bg-gradient-to-br from-[#2E7D9A] to-[#3498DB] rounded-2xl p-8 mb-6 text-white shadow-xl">
        <div className="flex items-center justify-between">
          <div>
            <p className="text-white/90 text-sm mb-1">
              Sức khỏe hệ thống tổng thể
            </p>
            <h2 className="text-5xl font-bold mb-2">
              {systemHealth.toFixed(1)}%
            </h2>
            <p className="text-white/80 text-sm">
              Tất cả dịch vụ hoạt động bình thường
            </p>
          </div>
          <div className="bg-white/20 backdrop-blur-sm rounded-2xl p-6">
            <Activity className="w-16 h-16 text-white" />
          </div>
        </div>
      </div>

      {/* System Status Grid */}
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-4 mb-6">
        {systemStats.map((stat, index) => {
          const Icon = stat.icon;
          return (
            <div key={index} className="bg-white rounded-xl p-5 shadow-md">
              <div className="flex items-start justify-between mb-3">
                <div
                  className="p-3 rounded-xl"
                  style={{ backgroundColor: `${stat.color}1A` }}
                >
                  <Icon className="w-6 h-6" style={{ color: stat.color }} />
                </div>
                {stat.status === "healthy" ? (
                  <CheckCircle className="w-5 h-5 text-green-500" />
                ) : (
                  <AlertTriangle className="w-5 h-5 text-yellow-500" />
                )}
              </div>
              <h3 className="text-[#7F8C8D] text-sm mb-1">{stat.title}</h3>
              <p className="text-[#2C3E50] text-xl font-bold mb-1">
                {stat.value}
              </p>
              <p className="text-[#7F8C8D] text-xs">{stat.details}</p>
            </div>
          );
        })}
      </div>

      {/* Metrics Grid */}
      <div className="grid grid-cols-2 lg:grid-cols-4 gap-4 mb-6">
        {metrics.map((metric, index) => {
          const Icon = metric.icon;
          return (
            <div key={index} className="bg-white rounded-xl p-5 shadow-md">
              <div
                className="p-3 rounded-xl mb-3 inline-block"
                style={{ backgroundColor: `${metric.color}1A` }}
              >
                <Icon className="w-5 h-5" style={{ color: metric.color }} />
              </div>
              <p className="text-[#7F8C8D] text-xs mb-1">{metric.label}</p>
              <p className="text-[#2C3E50] text-2xl font-bold">
                {metric.value}
              </p>
            </div>
          );
        })}
      </div>

      <div className="grid lg:grid-cols-3 gap-6">
        {/* Performance Metrics */}
        <div className="lg:col-span-2 bg-white rounded-xl p-6 shadow-md">
          <h2 className="text-[#2C3E50] text-lg font-bold mb-5">
            Hiệu suất hệ thống
          </h2>
          <div className="space-y-5">
            {performanceData.map((item, index) => (
              <div key={index}>
                <div className="flex items-center justify-between mb-2">
                  <span className="text-[#2C3E50] text-sm font-medium">
                    {item.name}
                  </span>
                  <span className="text-[#7F8C8D] text-sm">
                    {item.value} {item.unit}
                  </span>
                </div>
                <div className="w-full bg-gray-100 rounded-full h-3 overflow-hidden">
                  <div
                    className="h-full rounded-full transition-all duration-300"
                    style={{
                      width: `${item.value}%`,
                      backgroundColor: item.color,
                    }}
                  />
                </div>
              </div>
            ))}
          </div>

          {/* User Roles Overview */}
          <div className="mt-6 pt-6 border-t border-gray-100">
            <h3 className="text-[#2C3E50] text-base font-bold mb-4">
              Vai trò người dùng
            </h3>
            <div className="grid grid-cols-3 gap-4">
              <div className="text-center p-4 bg-blue-50 rounded-xl">
                <p className="text-[#3B82F6] text-2xl font-bold">1,234</p>
                <p className="text-[#7F8C8D] text-xs mt-1">Khách hàng</p>
              </div>
              <div className="text-center p-4 bg-green-50 rounded-xl">
                <p className="text-[#10B981] text-2xl font-bold">45</p>
                <p className="text-[#7F8C8D] text-xs mt-1">Tài xế</p>
              </div>
              <div className="text-center p-4 bg-purple-50 rounded-xl">
                <p className="text-[#8B5CF6] text-2xl font-bold">8</p>
                <p className="text-[#7F8C8D] text-xs mt-1">Admin</p>
              </div>
            </div>
          </div>
        </div>

        {/* System Logs */}
        <div className="bg-white rounded-xl p-6 shadow-md">
          <h2 className="text-[#2C3E50] text-lg font-bold mb-5">
            Nhật ký hệ thống
          </h2>
          <div className="space-y-4 max-h-[600px] overflow-y-auto">
            {systemLogs.map((log, index) => {
              const Icon = log.icon;
              const colorClass =
                log.type === "warning"
                  ? "bg-yellow-50 text-yellow-600"
                  : "bg-green-50 text-green-600";

              return (
                <div
                  key={index}
                  className="flex items-start gap-3 pb-4 border-b border-gray-100 last:border-0"
                >
                  <div className={`rounded-lg p-2 ${colorClass}`}>
                    <Icon className="w-4 h-4" />
                  </div>
                  <div className="flex-1 min-w-0">
                    <p className="text-[#2C3E50] text-sm font-medium mb-1">
                      {log.message}
                    </p>
                    <p className="text-[#7F8C8D] text-xs">{log.time}</p>
                  </div>
                </div>
              );
            })}
          </div>
        </div>
      </div>
    </div>
  );
};

export default SystemMonitoringPage;
