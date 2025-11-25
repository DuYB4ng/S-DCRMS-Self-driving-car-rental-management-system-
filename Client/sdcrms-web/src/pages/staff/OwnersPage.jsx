import React, { useEffect, useMemo, useState } from "react";
import axiosClient from "../../api/axiosClient";
import { useNavigate } from "react-router-dom";

const PAGE_SIZE = 5;

const OwnersPage = () => {
  const [owners, setOwners] = useState([]);
  const [loading, setLoading] = useState(false);

  const [search, setSearch] = useState("");
  const [page, setPage] = useState(1);

  const [isModalOpen, setIsModalOpen] = useState(false);
  const [editingOwner, setEditingOwner] = useState(null); // null = tạo mới
  const [form, setForm] = useState({
    firebaseUid: "",
    drivingLicence: "",
    licenceIssueDate: "",
    licenceExpiryDate: "",
    isActive: true,
  });

  const [error, setError] = useState("");
  const [globalError, setGlobalError] = useState("");

  const navigate = useNavigate();

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

  const getOwnerId = (o) => o.ownerCarId ?? o.OwnerCarId;

  // ----- Load danh sách chủ xe -----
  const fetchOwners = async () => {
    setLoading(true);
    setGlobalError("");

    try {
      // Nếu baseURL có /api thì sửa path thành "/ownercar"
      const res = await axiosClient.get("/ownercar");
      const data = Array.isArray(res.data) ? res.data : [];
      setOwners(data);
    } catch (err) {
      console.error(err);
      setGlobalError("Không thể tải danh sách chủ xe. Vui lòng thử lại sau.");
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    fetchOwners();
  }, []);

  // ----- Tìm kiếm + phân trang -----
  const filteredOwners = useMemo(() => {
    const keyword = search.trim().toLowerCase();
    if (!keyword) return owners;

    return owners.filter((o) => {
      const firebaseUid = (o.firebaseUid ?? o.FirebaseUid ?? "").toLowerCase();
      const drivingLicence = (
        o.drivingLicence ??
        o.DrivingLicence ??
        ""
      ).toLowerCase();

      return firebaseUid.includes(keyword) || drivingLicence.includes(keyword);
    });
  }, [owners, search]);

  const totalPages = Math.max(1, Math.ceil(filteredOwners.length / PAGE_SIZE));

  const pageData = useMemo(() => {
    const safePage = Math.min(page, totalPages);
    const start = (safePage - 1) * PAGE_SIZE;
    return filteredOwners.slice(start, start + PAGE_SIZE);
  }, [filteredOwners, page, totalPages]);

  // ----- Mở/đóng modal -----
  const openCreateModal = () => {
    setEditingOwner(null);
    setForm({
      firebaseUid: "",
      drivingLicence: "",
      licenceIssueDate: "",
      licenceExpiryDate: "",
      isActive: true,
    });
    setError("");
    setIsModalOpen(true);
  };

  const openEditModal = (owner) => {
    const firebaseUid = owner.firebaseUid ?? owner.FirebaseUid ?? "";
    const drivingLicence = owner.drivingLicence ?? owner.DrivingLicence ?? "";
    const licenceIssueDate =
      owner.licenceIssueDate ?? owner.LicenceIssueDate ?? "";
    const licenceExpiryDate =
      owner.licenceExpiryDate ?? owner.LicenceExpiryDate ?? "";
    const isActive = owner.isActive ?? owner.IsActive ?? true;

    setEditingOwner(owner);
    setForm({
      firebaseUid,
      drivingLicence,
      licenceIssueDate: toInputDate(licenceIssueDate),
      licenceExpiryDate: toInputDate(licenceExpiryDate),
      isActive,
    });
    setError("");
    setIsModalOpen(true);
  };

  const closeModal = () => {
    setIsModalOpen(false);
  };

  // ----- Submit form: Tạo / Cập nhật chủ xe -----
  const handleSubmit = async (e) => {
    e.preventDefault();
    setError("");

    const isEdit = !!editingOwner;
    const {
      firebaseUid,
      drivingLicence,
      licenceIssueDate,
      licenceExpiryDate,
      isActive,
    } = form;

    if (!drivingLicence.trim() || !licenceIssueDate || !licenceExpiryDate) {
      setError("Vui lòng nhập đầy đủ thông tin GPLX và ngày cấp/hết hạn.");
      return;
    }

    if (!isEdit && !firebaseUid.trim()) {
      setError("Vui lòng nhập Firebase UID cho chủ xe mới.");
      return;
    }

    const issue = new Date(licenceIssueDate);
    const expiry = new Date(licenceExpiryDate);
    if (issue > expiry) {
      setError("Ngày cấp không được lớn hơn ngày hết hạn.");
      return;
    }

    try {
      if (isEdit) {
        // Cập nhật chủ xe: PUT /api/ownercar/{ownerId}
        const ownerId = getOwnerId(editingOwner);
        if (!ownerId) {
          setError("Không xác định được ID chủ xe.");
          return;
        }

        const payload = {
          DrivingLicence: drivingLicence.trim(),
          LicenceIssueDate: licenceIssueDate,
          LicenceExpiryDate: licenceExpiryDate,
          IsActive: !!isActive,
        };

        const res = await axiosClient.put(`/ownercar/${ownerId}`, payload);

        const updated = res?.data;

        setOwners((prev) =>
          prev.map((o) =>
            getOwnerId(o) === ownerId
              ? updated ?? {
                  ...o,
                  DrivingLicence: payload.DrivingLicence,
                  LicenceIssueDate: payload.LicenceIssueDate,
                  LicenceExpiryDate: payload.LicenceExpiryDate,
                  IsActive: payload.IsActive,
                }
              : o
          )
        );
      } else {
        // Tạo chủ xe: POST /api/ownercar
        const payload = {
          firebaseUid: firebaseUid.trim(),
          DrivingLicence: drivingLicence.trim(),
          LicenceIssueDate: licenceIssueDate,
          LicenceExpiryDate: licenceExpiryDate,
        };

        const res = await axiosClient.post("/ownercar", payload);
        const created = res?.data;

        const fallback = {
          OwnerCarId:
            owners.length > 0
              ? (getOwnerId(owners[owners.length - 1]) ?? 0) + 1
              : 1,
          firebaseUid: payload.firebaseUid,
          DrivingLicence: payload.DrivingLicence,
          LicenceIssueDate: payload.LicenceIssueDate,
          LicenceExpiryDate: payload.LicenceExpiryDate,
          Cars: [],
          IsActive: true,
          CreatedAt: new Date().toISOString(),
        };

        const newOwner = created ?? fallback;

        const newList = [...owners, newOwner];
        setOwners(newList);

        const newTotalPages = Math.max(
          1,
          Math.ceil(newList.length / PAGE_SIZE)
        );
        setPage(newTotalPages);
      }

      setIsModalOpen(false);
    } catch (err) {
      console.error(err);
      setError("Không thể lưu thông tin chủ xe. Vui lòng thử lại.");
    }
  };

  // ----- Xoá chủ xe -----
  const handleDeleteOwner = async (owner) => {
    const ownerId = getOwnerId(owner);
    if (!ownerId) return;

    const ok = window.confirm("Bạn có chắc muốn xoá chủ xe này?");
    if (!ok) return;

    try {
      await axiosClient.delete(`/ownercar/${ownerId}`);

      const updated = owners.filter((o) => getOwnerId(o) !== ownerId);
      setOwners(updated);

      const newTotal = Math.max(1, Math.ceil(updated.length / PAGE_SIZE));
      if (page > newTotal) setPage(newTotal);
    } catch (err) {
      console.error(err);
      alert("Xoá chủ xe thất bại. Vui lòng thử lại.");
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
    badgeActive: {
      display: "inline-block",
      padding: "2px 8px",
      borderRadius: 999,
      fontSize: 12,
      fontWeight: 600,
      backgroundColor: "#dcfce7",
      color: "#166534",
    },
    badgeInactive: {
      display: "inline-block",
      padding: "2px 8px",
      borderRadius: 999,
      fontSize: 12,
      fontWeight: 600,
      backgroundColor: "#fee2e2",
      color: "#b91c1c",
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
          <h1 style={styles.title}>Quản lý chủ xe</h1>

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
              + Thêm chủ xe
            </button>
          </div>
        </div>

        {globalError && <div style={styles.globalError}>{globalError}</div>}
        {loading && <div>Đang tải danh sách chủ xe...</div>}

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
                  <th style={styles.th}>Trạng thái</th>
                  <th style={styles.th}>Hành động</th>
                </tr>
              </thead>
              <tbody>
                {pageData.map((o) => {
                  const ownerId = getOwnerId(o);
                  const firebaseUid = o.firebaseUid ?? o.FirebaseUid ?? "";
                  const drivingLicence =
                    o.drivingLicence ?? o.DrivingLicence ?? "";
                  const licenceIssueDate =
                    o.licenceIssueDate ?? o.LicenceIssueDate;
                  const licenceExpiryDate =
                    o.licenceExpiryDate ?? o.LicenceExpiryDate;
                  const isActive = o.isActive ?? o.IsActive ?? true;

                  return (
                    <tr key={ownerId}>
                      <td style={styles.td}>{ownerId}</td>
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
                      <td style={styles.td}>{drivingLicence}</td>
                      <td style={styles.td}>{formatDate(licenceIssueDate)}</td>
                      <td style={styles.td}>{formatDate(licenceExpiryDate)}</td>
                      <td style={styles.td}>
                        {isActive ? (
                          <span style={styles.badgeActive}>Hoạt động</span>
                        ) : (
                          <span style={styles.badgeInactive}>Vô hiệu hóa</span>
                        )}
                      </td>
                      <td style={styles.td}>
                        <div style={styles.actionButtons}>
                          <button
                            type="button"
                            style={{
                              ...styles.smallBtn,
                              ...styles.primaryOutlineBtn,
                            }}
                            onClick={() =>
                              navigate(`/staff/owners/${ownerId}/cars`)
                            }
                          >
                            Xe
                          </button>
                          <button
                            type="button"
                            style={styles.smallBtn}
                            onClick={() => openEditModal(o)}
                          >
                            Sửa
                          </button>
                          <button
                            type="button"
                            style={{ ...styles.smallBtn, ...styles.dangerBtn }}
                            onClick={() => handleDeleteOwner(o)}
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
                    <td style={styles.td} colSpan={7}>
                      Không có chủ xe nào phù hợp.
                    </td>
                  </tr>
                )}
              </tbody>
            </table>

            {/* Phân trang */}
            <div style={styles.paginationRow}>
              <span>
                Tổng: <b>{filteredOwners.length}</b> chủ xe – Trang {page}/
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

      {/* Modal thêm / sửa chủ xe */}
      {isModalOpen && (
        <div style={styles.modalBackdrop} onClick={closeModal}>
          <div
            style={styles.modal}
            onClick={(e) => {
              e.stopPropagation();
            }}
          >
            <h2 style={styles.modalTitle}>
              {editingOwner ? "Cập nhật chủ xe" : "Thêm chủ xe mới"}
            </h2>
            <form onSubmit={handleSubmit}>
              {!editingOwner && (
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

              {editingOwner && (
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
                  value={form.drivingLicence}
                  onChange={(e) =>
                    setForm((f) => ({
                      ...f,
                      drivingLicence: e.target.value,
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
                  value={form.licenceIssueDate}
                  onChange={(e) =>
                    setForm((f) => ({
                      ...f,
                      licenceIssueDate: e.target.value,
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
                  value={form.licenceExpiryDate}
                  onChange={(e) =>
                    setForm((f) => ({
                      ...f,
                      licenceExpiryDate: e.target.value,
                    }))
                  }
                  required
                />
              </div>

              {editingOwner && (
                <div style={styles.modalField}>
                  <label>
                    <input
                      type="checkbox"
                      checked={form.isActive}
                      onChange={(e) =>
                        setForm((f) => ({
                          ...f,
                          isActive: e.target.checked,
                        }))
                      }
                    />{" "}
                    Chủ xe đang hoạt động
                  </label>
                </div>
              )}

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

export default OwnersPage;
