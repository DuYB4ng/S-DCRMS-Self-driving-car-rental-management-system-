// src/pages/ReportsPage.tsx
import React, { useState } from "react";

type Filter = {
  fromDate: string;
  toDate: string;
};

const ReportsPage: React.FC = () => {
  const [filter, setFilter] = useState<Filter>({
    fromDate: "",
    toDate: "",
  });

  // Dữ liệu demo, sau này bạn thay bằng dữ liệu API
  const rows = [
    {
      id: 1,
      name: "Nguyễn Văn A",
      type: "Thuê xe",
      count: 3,
      revenue: 4500000,
    },
    { id: 2, name: "Trần Thị B", type: "Thuê xe", count: 5, revenue: 7500000 },
    { id: 3, name: "Lê Văn C", type: "Trả xe", count: 2, revenue: 2000000 },
  ];

  const styles = {
    page: {
      padding: "24px 32px",
      backgroundColor: "#f3f4f6",
      minHeight: "100vh",
      boxSizing: "border-box" as const,
    },
    title: {
      margin: 0,
      fontSize: "26px",
      fontWeight: 700,
      color: "#111827",
    },
    subtitle: {
      marginTop: 6,
      marginBottom: 20,
      fontSize: "14px",
      color: "#4b5563",
    },
    filterRow: {
      display: "flex",
      alignItems: "center",
      gap: 12,
      marginBottom: 16,
      flexWrap: "wrap" as const,
    },
    filterLabel: {
      fontSize: "14px",
      color: "#374151",
      fontWeight: 500,
    },
    filterInput: {
      padding: "6px 10px",
      borderRadius: 8,
      border: "1px solid #d1d5db",
      fontSize: "14px",
    },
    filterButton: {
      padding: "8px 14px",
      borderRadius: 999,
      border: "none",
      backgroundColor: "#2563eb",
      color: "#fff",
      fontSize: "14px",
      fontWeight: 600,
      cursor: "pointer",
    },
    cardRow: {
      display: "grid",
      gridTemplateColumns: "repeat(3, minmax(0, 1fr))",
      gap: 16,
      marginBottom: 20,
    },
    card: {
      backgroundColor: "#ffffff",
      borderRadius: 16,
      padding: "14px 16px",
      border: "1px solid #e5e7eb",
      boxShadow: "0 6px 18px rgba(15, 23, 42, 0.06)",
    },
    cardTitle: {
      fontSize: "13px",
      color: "#6b7280",
      marginBottom: 4,
    },
    cardValue: {
      fontSize: "22px",
      fontWeight: 700,
      color: "#111827",
    },
    tableWrapper: {
      marginTop: 12,
      backgroundColor: "#ffffff",
      borderRadius: 16,
      border: "1px solid #e5e7eb",
      boxShadow: "0 6px 18px rgba(15, 23, 42, 0.06)",
      overflow: "hidden",
    },
    table: {
      width: "100%",
      borderCollapse: "collapse" as const,
      fontSize: "14px",
    },
    th: {
      textAlign: "left" as const,
      padding: "10px 16px",
      backgroundColor: "#eff6ff",
      color: "#1f2937",
      borderBottom: "1px solid #e5e7eb",
    },
    td: {
      padding: "10px 16px",
      borderBottom: "1px solid #e5e7eb",
      color: "#111827",
    },
    trHover: {
      backgroundColor: "#f9fafb",
    },
  };

  const totalTrips = rows.reduce((sum, r) => sum + r.count, 0);
  const totalRevenue = rows.reduce((sum, r) => sum + r.revenue, 0);

  const handleApplyFilter = () => {
    console.log("Filter:", filter);
    // TODO: gọi API với fromDate & toDate
  };

  return (
    <div style={styles.page}>
      <h1 style={styles.title}>Thống kê</h1>
      <p style={styles.subtitle}>
        Xem nhanh số lượt thuê xe và doanh thu theo khoảng thời gian.
      </p>

      {/* Bộ lọc thời gian */}
      <div style={styles.filterRow}>
        <div>
          <div style={styles.filterLabel}>Từ ngày</div>
          <input
            type="date"
            style={styles.filterInput}
            value={filter.fromDate}
            onChange={(e) =>
              setFilter((f) => ({ ...f, fromDate: e.target.value }))
            }
          />
        </div>
        <div>
          <div style={styles.filterLabel}>Đến ngày</div>
          <input
            type="date"
            style={styles.filterInput}
            value={filter.toDate}
            onChange={(e) =>
              setFilter((f) => ({ ...f, toDate: e.target.value }))
            }
          />
        </div>
        <button
          type="button"
          style={styles.filterButton}
          onClick={handleApplyFilter}
        >
          Áp dụng
        </button>
      </div>

      {/* 3 card tổng quan */}
      <div style={styles.cardRow}>
        <div style={styles.card}>
          <div style={styles.cardTitle}>Tổng số lượt giao dịch</div>
          <div style={styles.cardValue}>{totalTrips}</div>
        </div>
        <div style={styles.card}>
          <div style={styles.cardTitle}>Tổng doanh thu (VNĐ)</div>
          <div style={styles.cardValue}>
            {totalRevenue.toLocaleString("vi-VN")}
          </div>
        </div>
        <div style={styles.card}>
          <div style={styles.cardTitle}>Số khách hàng tham gia</div>
          <div style={styles.cardValue}>{rows.length}</div>
        </div>
      </div>

      {/* Bảng chi tiết */}
      <div style={styles.tableWrapper}>
        <table style={styles.table}>
          <thead>
            <tr>
              <th style={styles.th}>STT</th>
              <th style={styles.th}>Tên</th>
              <th style={styles.th}>Loại</th>
              <th style={styles.th}>Số lượt</th>
              <th style={styles.th}>Doanh thu (VNĐ)</th>
            </tr>
          </thead>
          <tbody>
            {rows.map((r, index) => (
              <tr
                key={r.id}
                style={index % 2 === 0 ? undefined : styles.trHover}
              >
                <td style={styles.td}>{index + 1}</td>
                <td style={styles.td}>{r.name}</td>
                <td style={styles.td}>{r.type}</td>
                <td style={styles.td}>{r.count}</td>
                <td style={styles.td}>{r.revenue.toLocaleString("vi-VN")}</td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    </div>
  );
};

export default ReportsPage;
