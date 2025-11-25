import { useMemo, useState } from "react";

const PAGE_SIZE = 5;

const CustomersPage = () => {
  const [customers, setCustomers] = useState([
    { id: 1, name: "Lê Văn C", phone: "0912 345 678", rentals: 2 },
    { id: 2, name: "Phạm Thị D", phone: "0987 654 321", rentals: 5 },
  ]);

  const [search, setSearch] = useState("");
  const [page, setPage] = useState(1);

  const [isModalOpen, setIsModalOpen] = useState(false);
  const [form, setForm] = useState({ name: "", phone: "", rentals: "" });
  const [error, setError] = useState("");

  const filteredCustomers = useMemo(() => {
    const keyword = search.trim().toLowerCase();
    if (!keyword) return customers;
    return customers.filter(
      (c) =>
        c.name.toLowerCase().includes(keyword) ||
        c.phone.replace(/\s/g, "").includes(keyword.replace(/\s/g, ""))
    );
  }, [customers, search]);

  const totalPages = Math.max(
    1,
    Math.ceil(filteredCustomers.length / PAGE_SIZE)
  );

  const pageData = useMemo(() => {
    const safePage = Math.min(page, totalPages);
    const start = (safePage - 1) * PAGE_SIZE;
    return filteredCustomers.slice(start, start + PAGE_SIZE);
  }, [filteredCustomers, page, totalPages]);

  const openModal = () => {
    setForm({ name: "", phone: "", rentals: "" });
    setError("");
    setIsModalOpen(true);
  };

  const closeModal = () => {
    setIsModalOpen(false);tôi
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    setError("");

    if (!form.name || !form.phone || !form.rentals) {
      setError("Vui lòng nhập đầy đủ thông tin.");
      return;
    }

    const rentalsNumber = Number(form.rentals);
    if (Number.isNaN(rentalsNumber) || rentalsNumber < 0) {
      setError("Số lần thuê phải là số không âm.");
      return;
    }

    try {
      // Nếu dùng API:
      // const res = await axiosClient.post("/staff/customers", {
      //   name: form.name,
      //   phone: form.phone,
      //   rentals: rentalsNumber,
      // });
      // const newCustomer = res.data;

      const newCustomer = {
        id: customers.length ? customers[customers.length - 1].id + 1 : 1,
        name: form.name,
        phone: form.phone,
        rentals: rentalsNumber,
      };

      setCustomers((prev) => [...prev, newCustomer]);
      setIsModalOpen(false);
      setPage(totalPages);
    } catch (err) {
      console.error(err);
      setError("Không thể tạo khách hàng. Vui lòng thử lại.");
    }
  };

  // Styles tái sử dụng giống OwnersPage
  const styles = {
    page: {
      padding: "24px 32px",
      backgroundColor: "#f3f4f6",
      minHeight: "100vh",
      boxSizing: "border-box",
    },
    card: {
      maxWidth: 900,
      margin: "0 auto",
      backgroundColor: "#ffffff",
      borderRadius: 16,
      border: "1px solid #e5e7eb",
      boxShadow: "0 4px 12px rgba(15, 23, 42, 0.08)",
      padding: 24,
    },
    headerRow: {
      display: "flex",
      justifyContent: "space-between",
      alignItems: "center",
      marginBottom: 16,
    },
    title: {
      fontSize: 24,
      fontWeight: 700,
      margin: 0,
    },
    actionsRow: {
      display: "flex",
      gap: 8,
      alignItems: "center",
    },
    searchInput: {
      borderRadius: 999,
      border: "1px solid #d1d5db",
      padding: "8px 12px",
      fontSize: 14,
      outline: "none",
      minWidth: 200,
    },
    addButton: {
      background: "linear-gradient(135deg, #0ea5e9, #2563eb)",
      color: "#fff",
      border: "none",
      borderRadius: 999,
      padding: "8px 16px",
      fontSize: 14,
      fontWeight: 600,
      cursor: "pointer",
    },
    table: {
      width: "100%",
      borderCollapse: "collapse",
      marginTop: 8,
    },
    th: {
      textAlign: "left",
      fontSize: 14,
      fontWeight: 600,
      padding: "10px 12px",
      borderBottom: "2px solid #e5e7eb",
      color: "#111827",
    },
    td: {
      fontSize: 14,
      padding: "10px 12px",
      borderBottom: "1px solid #f3f4f6",
      color: "#111827",
    },
    paginationRow: {
      marginTop: 12,
      display: "flex",
      justifyContent: "space-between",
      alignItems: "center",
      fontSize: 13,
      color: "#6b7280",
    },
    paginationButtons: {
      display: "flex",
      gap: 8,
    },
    paginationBtn: {
      padding: "4px 10px",
      borderRadius: 8,
      border: "1px solid #d1d5db",
      backgroundColor: "#fff",
      cursor: "pointer",
      fontSize: 13,
    },
    paginationBtnDisabled: {
      opacity: 0.4,
      cursor: "not-allowed",
    },
    modalBackdrop: {
      position: "fixed",
      inset: 0,
      backgroundColor: "rgba(15,23,42,0.35)",
      display: "flex",
      alignItems: "center",
      justifyContent: "center",
      zIndex: 50,
    },
    modal: {
      backgroundColor: "#fff",
      borderRadius: 16,
      padding: 20,
      width: 360,
      boxShadow: "0 12px 30px rgba(15, 23, 42, 0.25)",
    },
    modalTitle: {
      margin: 0,
      marginBottom: 12,
      fontSize: 18,
      fontWeight: 600,
    },
    modalField: {
      marginBottom: 10,
      display: "flex",
      flexDirection: "column",
      gap: 4,
    },
    modalInput: {
      borderRadius: 8,
      border: "1px solid #d1d5db",
      padding: "8px 10px",
      fontSize: 14,
    },
    modalFooter: {
      marginTop: 12,
      display: "flex",
      justifyContent: "flex-end",
      gap: 8,
    },
    cancelBtn: {
      padding: "6px 12px",
      borderRadius: 8,
      border: "1px solid #d1d5db",
      backgroundColor: "#fff",
      cursor: "pointer",
      fontSize: 14,
    },
    saveBtn: {
      padding: "6px 14px",
      borderRadius: 8,
      border: "none",
      backgroundColor: "#2563eb",
      color: "#fff",
      cursor: "pointer",
      fontSize: 14,
      fontWeight: 600,
    },
    errorText: {
      color: "#dc2626",
      fontSize: 13,
      marginTop: 4,
    },
  };

  return (
    <div style={styles.page}>
      <div style={styles.card}>
        <div style={styles.headerRow}>
          <h1 style={styles.title}>Quản lý khách hàng</h1>

          <div style={styles.actionsRow}>
            <input
              style={styles.searchInput}
              placeholder="Tìm theo tên hoặc SĐT..."
              value={search}
              onChange={(e) => {
                setSearch(e.target.value);
                setPage(1);
              }}
            />
            <button type="button" style={styles.addButton} onClick={openModal}>
              + Thêm khách hàng
            </button>
          </div>
        </div>

        <table style={styles.table}>
          <thead>
            <tr>
              <th style={styles.th}>Tên khách</th>
              <th style={styles.th}>SĐT</th>
              <th style={styles.th}>Số lần thuê</th>
            </tr>
          </thead>
          <tbody>
            {pageData.map((c) => (
              <tr key={c.id}>
                <td style={styles.td}>{c.name}</td>
                <td style={styles.td}>{c.phone}</td>
                <td style={styles.td}>{c.rentals}</td>
              </tr>
            ))}
            {pageData.length === 0 && (
              <tr>
                <td style={styles.td} colSpan={3}>
                  Không có khách hàng nào phù hợp.
                </td>
              </tr>
            )}
          </tbody>
        </table>

        <div style={styles.paginationRow}>
          <span>
            Tổng: <b>{filteredCustomers.length}</b> khách – Trang {page}/
            {totalPages}
          </span>
          <div style={styles.paginationButtons}>
            <button
              type="button"
              style={{
                ...styles.paginationBtn,
                ...(page === 1 ? styles.paginationBtnDisabled : {}),
              }}
              disabled={page === 1}
              onClick={() => setPage((p) => Math.max(1, p - 1))}
            >
              « Trước
            </button>
            <button
              type="button"
              style={{
                ...styles.paginationBtn,
                ...(page === totalPages ? styles.paginationBtnDisabled : {}),
              }}
              disabled={page === totalPages}
              onClick={() => setPage((p) => Math.min(totalPages, p + 1))}
            >
              Sau »
            </button>
          </div>
        </div>
      </div>

      {isModalOpen && (
        <div style={styles.modalBackdrop} onClick={closeModal}>
          <div
            style={styles.modal}
            onClick={(e) => {
              e.stopPropagation();
            }}
          >
            <h2 style={styles.modalTitle}>Thêm khách hàng mới</h2>
            <form onSubmit={handleSubmit}>
              <div style={styles.modalField}>
                <label>Họ tên</label>
                <input
                  style={styles.modalInput}
                  value={form.name}
                  onChange={(e) =>
                    setForm((f) => ({ ...f, name: e.target.value }))
                  }
                  required
                />
              </div>
              <div style={styles.modalField}>
                <label>Số điện thoại</label>
                <input
                  style={styles.modalInput}
                  value={form.phone}
                  onChange={(e) =>
                    setForm((f) => ({ ...f, phone: e.target.value }))
                  }
                  required
                />
              </div>
              <div style={styles.modalField}>
                <label>Số lần thuê</label>
                <input
                  style={styles.modalInput}
                  type="number"
                  min={0}
                  value={form.rentals}
                  onChange={(e) =>
                    setForm((f) => ({ ...f, rentals: e.target.value }))
                  }
                  required
                />
              </div>

              {error && <div style={styles.errorText}>{error}</div>}

              <div style={styles.modalFooter}>
                <button
                  type="button"
                  style={styles.cancelBtn}
                  onClick={closeModal}
                >
                  Huỷ
                </button>
                <button type="submit" style={styles.saveBtn}>
                  Lưu
                </button>
              </div>
            </form>
          </div>
        </div>
      )}
    </div>
  );
};

export default CustomersPage;
