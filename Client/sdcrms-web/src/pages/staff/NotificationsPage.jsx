// src/pages/NotificationsPage.tsx
import React, { useState } from "react";
import axiosClient from "../../api/axiosClient";

const NotificationsPage = () => {
  const [title, setTitle] = useState("");
  const [message, setMessage] = useState("");
  const [audience, setAudience] = useState("all");
  const [channel, setChannel] = useState("inapp");
  const [isSending, setIsSending] = useState(false);
  const [success, setSuccess] = useState(null);
  const [error, setError] = useState(null);

  const styles = {
    page: {
      padding: "24px 32px",
      backgroundColor: "#f3f4f6",
      minHeight: "100vh",
      boxSizing: "border-box",
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
    layout: {
      display: "grid",
      gridTemplateColumns: "minmax(0, 2fr) minmax(0, 1.2fr)",
      gap: 20,
      alignItems: "flex-start",
    },
    card: {
      backgroundColor: "#ffffff",
      borderRadius: 16,
      padding: "18px 20px",
      border: "1px solid #e5e7eb",
      boxShadow: "0 6px 18px rgba(15, 23, 42, 0.06)",
    },
    sectionTitle: {
      fontSize: "18px",
      fontWeight: 600,
      marginBottom: 12,
    },
    label: {
      fontSize: "14px",
      fontWeight: 500,
      color: "#374151",
      marginBottom: 4,
      display: "block",
    },
    input: {
      width: "100%",
      padding: "8px 10px",
      borderRadius: 10,
      border: "1px solid #d1d5db",
      fontSize: "14px",
      marginBottom: 12,
    },
    textarea: {
      width: "100%",
      minHeight: 120,
      padding: "8px 10px",
      borderRadius: 10,
      border: "1px solid #d1d5db",
      fontSize: "14px",
      resize: "vertical",
      marginBottom: 12,
    },
    selectRow: {
      display: "flex",
      gap: 10,
      marginBottom: 12,
      flexWrap: "wrap",
    },
    select: {
      flex: 1,
      minWidth: 160,
      padding: "8px 10px",
      borderRadius: 10,
      border: "1px solid #d1d5db",
      fontSize: "14px",
    },
    sendButton: {
      marginTop: 4,
      padding: "10px 18px",
      backgroundColor: "#2563eb",
      color: "#fff",
      border: "none",
      borderRadius: 999,
      fontWeight: 600,
      cursor: "pointer",
      fontSize: "14px",
    },
    disabledButton: {
      opacity: 0.6,
      cursor: "not-allowed",
    },
    alertSuccess: {
      marginTop: 10,
      padding: "8px 10px",
      borderRadius: 10,
      backgroundColor: "#dcfce7",
      color: "#166534",
      fontSize: "13px",
    },
    alertError: {
      marginTop: 10,
      padding: "8px 10px",
      borderRadius: 10,
      backgroundColor: "#fee2e2",
      color: "#b91c1c",
      fontSize: "13px",
    },
    previewTitle: {
      fontSize: "16px",
      fontWeight: 600,
      marginBottom: 8,
    },
    previewBox: {
      padding: "12px 14px",
      borderRadius: 12,
      background:
        "linear-gradient(135deg, rgba(59,130,246,0.08), rgba(37,99,235,0.08))",
      border: "1px solid #bfdbfe",
    },
    previewHeader: {
      fontSize: "13px",
      color: "#4b5563",
      marginBottom: 4,
    },
    previewMessageTitle: {
      fontSize: "15px",
      fontWeight: 600,
      marginBottom: 4,
    },
    previewMessageBody: {
      fontSize: "14px",
      color: "#111827",
      whiteSpace: "pre-line",
    },
    previewMeta: {
      marginTop: 8,
      fontSize: "12px",
      color: "#6b7280",
    },
  };

  const handleSend = async () => {
    setSuccess(null);
    setError(null);
    setIsSending(true);

    try {
      // TODO: đổi endpoint cho đúng backend của bạn
      await axiosClient.post("/notifications/broadcast", {
        title,
        message,
        audience,
        channel,
      });

      setSuccess("Đã gửi thông báo tới toàn hệ thống.");
      setTitle("");
      setMessage("");
    } catch (err) {
      console.error(err);
      setError(err.message ?? "Gửi thông báo thất bại, vui lòng thử lại.");
    } finally {
      setIsSending(false);
    }
  };

  return (
    <div style={styles.page}>
      <h1 style={styles.title}>Gửi thông báo toàn hệ thống</h1>
      <p style={styles.subtitle}>
        Soạn nội dung và gửi thông báo đến toàn bộ hệ thống: nhân viên, chủ xe
        và khách hàng.
      </p>

      <div style={styles.layout}>
        {/* Form soạn thông báo */}
        <div style={styles.card}>
          <h2 style={styles.sectionTitle}>Soạn thông báo</h2>

          <label style={styles.label}>Tiêu đề</label>
          <input
            style={styles.input}
            value={title}
            onChange={(e) => setTitle(e.target.value)}
            placeholder="Ví dụ: Hệ thống bảo trì lúc 22:00 tối nay"
          />

          <label style={styles.label}>Nội dung</label>
          <textarea
            style={styles.textarea}
            value={message}
            onChange={(e) => setMessage(e.target.value)}
            placeholder="Nhập nội dung chi tiết thông báo..."
          />

          <div style={styles.selectRow}>
            <div style={{ flex: 1 }}>
              <label style={styles.label}>Gửi tới</label>
              <select
                style={styles.select}
                value={audience}
                onChange={(e) => setAudience(e.target.value)}
              >
                <option value="all">
                  Tất cả (nhân viên + chủ xe + khách hàng)
                </option>
                <option value="staff">Chỉ nhân viên</option>
                <option value="owners">Chỉ chủ xe</option>
                <option value="customers">Chỉ khách hàng</option>
              </select>
            </div>
            <div style={{ flex: 1 }}>
              <label style={styles.label}>Kênh gửi</label>
              <select
                style={styles.select}
                value={channel}
                onChange={(e) => setChannel(e.target.value)}
              >
                <option value="inapp">Thông báo trong hệ thống</option>
                <option value="email">Email</option>
                <option value="both">Cả hệ thống + Email</option>
              </select>
            </div>
          </div>

          <button
            type="button"
            style={{
              ...styles.sendButton,
              ...(isSending ? styles.disabledButton : {}),
            }}
            onClick={handleSend}
            disabled={isSending}
          >
            {isSending ? "Đang gửi..." : "Gửi thông báo"}
          </button>

          {success && <div style={styles.alertSuccess}>{success}</div>}
          {error && <div style={styles.alertError}>{error}</div>}
        </div>

        {/* Preview thông báo */}
        <div style={styles.card}>
          <h2 style={styles.sectionTitle}>Xem trước</h2>
          <div style={styles.previewBox}>
            <div style={styles.previewHeader}>
              Thông báo sẽ hiển thị trên ứng dụng như sau:
            </div>
            <div style={styles.previewMessageTitle}>
              {title || "Tiêu đề thông báo"}
            </div>
            <div style={styles.previewMessageBody}>
              {message || "Nội dung thông báo sẽ xuất hiện tại đây..."}
            </div>
            <div style={styles.previewMeta}>
              Đối tượng:{" "}
              {
                {
                  all: "Tất cả người dùng",
                  staff: "Nhân viên",
                  owners: "Chủ xe",
                  customers: "Khách hàng",
                }[audience]
              }{" "}
              • Kênh:{" "}
              {
                {
                  inapp: "Trong hệ thống",
                  email: "Email",
                  both: "Trong hệ thống + Email",
                }[channel]
              }
            </div>
          </div>
        </div>
      </div>
    </div>
  );
};

export default NotificationsPage;
