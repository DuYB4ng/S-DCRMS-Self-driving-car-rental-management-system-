import React from "react";

const DashboardPage: React.FC = () => {
  // dữ liệu mẫu, sau này bạn thay bằng API thật
  const totalOwners = 12;
  const totalCustomers = 158;
  const todayReports = 4;

  const styles = {
    page: {
      padding: "24px 32px",
      backgroundColor: "#f3f4f6",
      minHeight: "100vh",
      boxSizing: "border-box" as const,
    },
    title: {
      margin: 0,
      fontSize: "28px",
      fontWeight: 700,
      color: "#111827",
    },
    subtitle: {
      marginTop: 8,
      marginBottom: 20,
      fontSize: "14px",
      color: "#4b5563",
    },
    statsGrid: {
      display: "grid",
      gridTemplateColumns: "repeat(3, minmax(0, 1fr))",
      gap: 16,
      marginBottom: 24,
    },
    statCard: {
      backgroundColor: "#ffffff",
      borderRadius: 16,
      padding: "16px 18px",
      boxShadow: "0 8px 20px rgba(15, 23, 42, 0.06)",
      border: "1px solid #e5e7eb",
    },
    statTitle: {
      fontSize: "14px",
      color: "#6b7280",
      marginBottom: 6,
    },
    statValue: {
      fontSize: "24px",
      fontWeight: 700,
      color: "#111827",
    },
    activityCard: {
      backgroundColor: "#ffffff",
      borderRadius: 16,
      padding: "18px 20px",
      boxShadow: "0 8px 20px rgba(15, 23, 42, 0.06)",
      border: "1px solid #e5e7eb",
    },
    activityTitle: {
      margin: 0,
      marginBottom: 12,
      fontSize: "18px",
      fontWeight: 600,
    },
    activityList: {
      margin: 0,
      paddingLeft: 18,
      fontSize: "14px",
      color: "#111827",
    },
  };

  return (
    <div style={styles.page}>
      <h1 style={styles.title}>Bảng điều khiển</h1>
      <p style={styles.subtitle}>
        Chào mừng bạn đến với trang quản lý nhân viên hệ thống thuê xe tự lái.
      </p>

      {/* 3 ô thống kê */}
      <div style={styles.statsGrid}>
        <div style={styles.statCard}>
          <div style={styles.statTitle}>Tổng số chủ xe</div>
          <div style={styles.statValue}>{totalOwners}</div>
        </div>
        <div style={styles.statCard}>
          <div style={styles.statTitle}>Tổng số khách hàng</div>
          <div style={styles.statValue}>{totalCustomers}</div>
        </div>
        <div style={styles.statCard}>
          <div style={styles.statTitle}>Báo cáo mới hôm nay</div>
          <div style={styles.statValue}>{todayReports}</div>
        </div>
      </div>

      {/* Ô hoạt động gần đây */}
      <div style={styles.activityCard}>
        <h2 style={styles.activityTitle}>Hoạt động gần đây</h2>
        <ul style={styles.activityList}>
          <li>Nhân viên A tạo báo cáo “Xe 51A-12345 bị trầy xước”.</li>
          <li>Nhân viên xác nhận trả xe cho khách Nguyễn Văn C.</li>
          <li>Hệ thống gửi thông báo bảo trì cho 3 xe sắp hết hạn chế.</li>
        </ul>
      </div>
    </div>
  );
};

export default DashboardPage;
