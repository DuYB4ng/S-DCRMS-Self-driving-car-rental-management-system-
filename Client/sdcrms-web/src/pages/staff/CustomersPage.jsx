import React, { useEffect, useMemo, useState } from "react";
import axiosClient from "../../api/axiosClient";

const PAGE_SIZE = 5;

const CustomersPage = () => {
  const [customers, setCustomers] = useState([]);
  const [loading, setLoading] = useState(false);

  const [search, setSearch] = useState("");
  const [page, setPage] = useState(1);

  const [isModalOpen, setIsModalOpen] = useState(false);
  const [editingCustomer, setEditingCustomer] = useState(null); // null = tạo mới
  const [form, setForm] = useState({
    firebaseUid: "",
    drivingLicense: "",
    licenseIssueDate: "",
    licenseExpiryDate: "",
  });

  const [error, setError] = useState("");
  const [globalError, setGlobalError] = useState("");

  // ----- Helpers -----
  const toInputDate = (value) => {
    if (!value) return "";
    const d = new Date(value);
    if (Number.isNaN(d.getTime())) return "";
    const y = d.getFullYear();
    const m = String(d.getMonth() + 1).padStart(2, "0");
    const day = String(d.getDate()).padStart(2, "0");
    return `${y}-${m}-${day}`;
  };

  const formatDate = (value) => {
    if (!value) return "";
    const d = new Date(value);
    if (Number.isNaN(d.getTime())) return "";
    return d.toLocaleDateString("vi-VN");
  };

  const getCustomerId = (c) => c.customerId ?? c.CustomerId;

  // ----- Load danh sách customer -----
  const fetchCustomers = async () => {
    setLoading(true);
    setGlobalError("");

    try {
      // Nếu baseURL = http://localhost:8000/api thì đổi path thành "/customer"
      const res = await axiosClient.get("/customer");
      const data = Array.isArray(res.data) ? res.data : [];
      setCustomers(data);
    } catch (err) {
      console.error(err);
      setGlobalError(
        "Không thể tải danh sách khách hàng. Vui lòng thử lại sau."
      );
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    fetchCustomers();
  }, []);

  // ----- Tìm kiếm + phân trang -----
  const filteredCustomers = useMemo(() => {
    const keyword = search.trim().toLowerCase();
    if (!keyword) return customers;

    return customers.filter((c) => {
      const firebaseUid = (c.firebaseUid ?? c.FirebaseUid ?? "").toLowerCase();
      const drivingLicense = (
        c.drivingLicense ??
        c.DrivingLicense ??
        ""
      ).toLowerCase();

      return firebaseUid.includes(keyword) || drivingLicense.includes(keyword);
    });
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

  // ----- Modal -----
  const openCreateModal = () => {
    setEditingCustomer(null);
    setForm({
      firebaseUid: "",
      drivingLicense: "",
      licenseIssueDate: "",
      licenseExpiryDate: "",
    });
    setError("");
    setIsModalOpen(true);
  };

  const openEditModal = (customer) => {
    const firebaseUid = customer.firebaseUid ?? customer.FirebaseUid ?? "";
    const drivingLicense =
      customer.drivingLicense ?? customer.DrivingLicense ?? "";
    const licenseIssueDate =
      customer.licenseIssueDate ?? customer.LicenseIssueDate ?? "";
    const licenseExpiryDate =
      customer.licenseExpiryDate ?? customer.LicenseExpiryDate ?? "";

    setEditingCustomer(customer);
    setForm({
      firebaseUid,
      drivingLicense,
      licenseIssueDate: toInputDate(licenseIssueDate),
      licenseExpiryDate: toInputDate(licenseExpiryDate),
    });
    setError("");
    setIsModalOpen(true);
  };

  const closeModal = () => {
    setIsModalOpen(false);
  };

  // ----- Submit: Tạo / Cập nhật -----
  const handleSubmit = async (e) => {
    e.preventDefault();
    setError("");

    const isEdit = !!editingCustomer;
    const { firebaseUid, drivingLicense, licenseIssueDate, licenseExpiryDate } =
      form;

    if (!drivingLicense.trim() || !licenseIssueDate || !licenseExpiryDate) {
      setError("Vui lòng nhập đầy đủ thông tin GPLX và ngày cấp/hết hạn.");
      return;
    }

    if (!isEdit && !firebaseUid.trim()) {
      setError("Vui lòng nhập Firebase UID cho khách hàng mới.");
      return;
    }

    const issue = new Date(licenseIssueDate);
    const expiry = new Date(licenseExpiryDate);
    if (issue > expiry) {
      setError("Ngày cấp không được lớn hơn ngày hết hạn.");
      return;
    }

    try {
      if (isEdit) {
        // PUT /api/customer/{id}
        const customerId = getCustomerId(editingCustomer);
        if (!customerId) {
          setError("Không xác định được ID khách hàng.");
          return;
        }

        const payload = {
          customerId,
          FirebaseUid: firebaseUid.trim(),
          DrivingLicense: drivingLicense.trim(),
          LicenseIssueDate: licenseIssueDate,
          LicenseExpiryDate: licenseExpiryDate,
        };

        const res = await axiosClient.put(`/customer/${customerId}`, payload);

        const updated = res?.data;

        setCustomers((prev) =>
          prev.map((c) =>
            getCustomerId(c) === customerId
              ? updated ?? {
                  ...c,
                  FirebaseUid: payload.FirebaseUid,
                  DrivingLicense: payload.DrivingLicense,
                  LicenseIssueDate: payload.LicenseIssueDate,
                  LicenseExpiryDate: payload.LicenseExpiryDate,
                }
              : c
          )
        );
      } else {
        // POST /api/customer
        const payload = {
          FirebaseUid: firebaseUid.trim(),
          DrivingLicense: drivingLicense.trim(),
          LicenseIssueDate: licenseIssueDate,
          LicenseExpiryDate: licenseExpiryDate,
        };

        const res = await axiosClient.post("/customer", payload);
        const created = res?.data;

        const fallback = {
          CustomerId:
            customers.length > 0
              ? (getCustomerId(customers[customers.length - 1]) ?? 0) + 1
              : 1,
          FirebaseUid: payload.FirebaseUid,
          DrivingLicense: payload.DrivingLicense,
          LicenseIssueDate: payload.LicenseIssueDate,
          LicenseExpiryDate: payload.LicenseExpiryDate,
        };

        const newCustomer = created ?? fallback;

        const newList = [...customers, newCustomer];
        setCustomers(newList);

        const newTotalPages = Math.max(
          1,
          Math.ceil(newList.length / PAGE_SIZE)
        );
        setPage(newTotalPages);
      }

      setIsModalOpen(false);
    } catch (err) {
      console.error(err);
      setError("Không thể lưu thông tin khách hàng. Vui lòng thử lại.");
    }
  };

  // ----- Xoá khách hàng -----
  const handleDeleteCustomer = async (customer) => {
    const customerId = getCustomerId(customer);
    if (!customerId) return;

    const ok = window.confirm("Bạn có chắc muốn xoá khách hàng này?");
    if (!ok) return;

    try {
      await axiosClient.delete(`/customer/${customerId}`);

      const updated = customers.filter((c) => getCustomerId(c) !== customerId);
      setCustomers(updated);

      const newTotal = Math.max(1, Math.ceil(updated.length / PAGE_SIZE));
      if (page > newTotal) setPage(newTotal);
    } catch (err) {
      console.error(err);
      alert("Xoá khách hàng thất bại. Vui lòng thử lại.");
    }
  };

  // ----- Styles -----
  const styles = {
    page: {
      padding: "24px 32px",
      backgroundColor: "#f3f4f6",
      minHeight: "100vh",
      boxSizing: "border-box",
    },
    card: {
      maxWidth: 1100,
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
      minWidth: 260,
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
      fontSize: 13,
      fontWeight: 600,
      padding: "10px 12px",
      borderBottom: "2px solid #e5e7eb",
      color: "#111827",
      whiteSpace: "nowrap",
    },
    td: {
      fontSize: 13,
      padding: "10px 12px",
      borderBottom: "1px solid #f3f4f6",
      color: "#111827",
      verticalAlign: "middle",
    },
    badge: {
      display: "inline-block",
      padding: "2px 8px",
      borderRadius: 999,
      fontSize: 12,
      fontWeight: 600,
      backgroundColor: "#eff6ff",
      color: "#1d4ed8",
    },
    actionButtons: {
      display: "flex",
      gap: 6,
    },
    smallBtn: {
      padding: "4px 8px",
      borderRadius: 6,
      border: "1px solid #d1d5db",
      backgroundColor: "#fff",
      cursor: "pointer",
      fontSize: 12,
    },
    dangerBtn: {
      borderColor: "#fecaca",
      color: "#b91c1c",
      backgroundColor: "#fef2f2",
    },
    primaryOutlineBtn: {
      borderColor: "#bfdbfe",
      color: "#1d4ed8",
      backgroundColor: "#eff6ff",
    },
    globalError: {
      color: "#b91c1c",
      backgroundColor: "#fee2e2",
      padding: "8px 12px",
      borderRadius: 8,
      fontSize: 13,
      marginBottom: 8,
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
      width: 420,
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
              placeholder="Tìm theo Firebase UID hoặc số GPLX..."
              value={search}
              onChange={(e) => {
                setSearch(e.target.value);
                setPage(1);
              }}
            />
            <button
              type="button"
              style={styles.addButton}
              onClick={openCreateModal}
            >
              + Thêm khách hàng
            </button>
          </div>
        </div>

        {globalError && <div style={styles.globalError}>{globalError}</div>}
        {loading && <div>Đang tải danh sách khách hàng...</div>}

        {!loading && (
          <>
            <table style={styles.table}>
              <thead>
                <tr>
                  <th style={styles.th}>ID</th>
                  <th style={styles.th}>Firebase UID</th>
                  <th style={styles.th}>Số GPLX</th>
                  <th style={styles.th}>Ngày cấp</th>
                  <th style={styles.th}>Ngày hết hạn</th>
                  <th style={styles.th}>Hành động</th>
                </tr>
              </thead>
              <tbody>
                {pageData.map((c) => {
                  const customerId = getCustomerId(c);
                  const firebaseUid = c.firebaseUid ?? c.FirebaseUid ?? "";
                  const drivingLicense =
                    c.drivingLicense ?? c.DrivingLicense ?? "";
                  const licenseIssueDate =
                    c.licenseIssueDate ?? c.LicenseIssueDate;
                  const licenseExpiryDate =
                    c.licenseExpiryDate ?? c.LicenseExpiryDate;

                  return (
                    <tr key={customerId}>
                      <td style={styles.td}>{customerId}</td>
                      <td style={styles.td}>
                        <span
                          style={{
                            fontFamily: "monospace",
                            fontSize: 12,
                            wordBreak: "break-all",
                          }}
                        >
                          {firebaseUid}
                        </span>
                      </td>
                      <td style={styles.td}>{drivingLicense}</td>
                      <td style={styles.td}>{formatDate(licenseIssueDate)}</td>
                      <td style={styles.td}>{formatDate(licenseExpiryDate)}</td>
                      <td style={styles.td}>
                        <div style={styles.actionButtons}>
                          <button
                            type="button"
                            style={{
                              ...styles.smallBtn,
                              ...styles.primaryOutlineBtn,
                            }}
                            onClick={() => openEditModal(c)}
                          >
                            Sửa
                          </button>
                          <button
                            type="button"
                            style={{ ...styles.smallBtn, ...styles.dangerBtn }}
                            onClick={() => handleDeleteCustomer(c)}
                          >
                            Xoá
                          </button>
                        </div>
                      </td>
                    </tr>
                  );
                })}
                {pageData.length === 0 && (
                  <tr>
                    <td style={styles.td} colSpan={6}>
                      Không có khách hàng nào phù hợp.
                    </td>
                  </tr>
                )}
              </tbody>
            </table>

            {/* Phân trang */}
            <div style={styles.paginationRow}>
              <span>
                Tổng: <b>{filteredCustomers.length}</b> khách hàng – Trang{" "}
                {page}/{totalPages}
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
                    ...(page === totalPages
                      ? styles.paginationBtnDisabled
                      : {}),
                  }}
                  disabled={page === totalPages}
                  onClick={() => setPage((p) => Math.min(totalPages, p + 1))}
                >
                  Sau »
                </button>
              </div>
            </div>
          </>
        )}
      </div>

      {/* Modal thêm / sửa khách hàng */}
      {isModalOpen && (
        <div style={styles.modalBackdrop} onClick={closeModal}>
          <div
            style={styles.modal}
            onClick={(e) => {
              e.stopPropagation();
            }}
          >
            <h2 style={styles.modalTitle}>
              {editingCustomer ? "Cập nhật khách hàng" : "Thêm khách hàng mới"}
            </h2>
            <form onSubmit={handleSubmit}>
              {!editingCustomer && (
                <div style={styles.modalField}>
                  <label>Firebase UID</label>
                  <input
                    style={styles.modalInput}
                    value={form.firebaseUid}
                    onChange={(e) =>
                      setForm((f) => ({
                        ...f,
                        firebaseUid: e.target.value,
                      }))
                    }
                    placeholder="UID của user trong Firebase / UserService"
                    required
                  />
                </div>
              )}

              {editingCustomer && (
                <div style={styles.modalField}>
                  <label>Firebase UID</label>
                  <input
                    style={styles.modalInput}
                    value={form.firebaseUid}
                    disabled
                  />
                </div>
              )}

              <div style={styles.modalField}>
                <label>Số giấy phép lái xe</label>
                <input
                  style={styles.modalInput}
                  value={form.drivingLicense}
                  onChange={(e) =>
                    setForm((f) => ({
                      ...f,
                      drivingLicense: e.target.value,
                    }))
                  }
                  required
                />
              </div>

              <div style={styles.modalField}>
                <label>Ngày cấp</label>
                <input
                  style={styles.modalInput}
                  type="date"
                  value={form.licenseIssueDate}
                  onChange={(e) =>
                    setForm((f) => ({
                      ...f,
                      licenseIssueDate: e.target.value,
                    }))
                  }
                  required
                />
              </div>

              <div style={styles.modalField}>
                <label>Ngày hết hạn</label>
                <input
                  style={styles.modalInput}
                  type="date"
                  value={form.licenseExpiryDate}
                  onChange={(e) =>
                    setForm((f) => ({
                      ...f,
                      licenseExpiryDate: e.target.value,
                    }))
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
