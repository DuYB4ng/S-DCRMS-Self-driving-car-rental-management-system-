import React, { useEffect, useState } from "react";
import { useParams, useNavigate } from "react-router-dom";
import axiosClient from "../../api/axiosClient";

const OwnerCarsOfOwnerPage = () => {
  const { ownerId } = useParams();
  const navigate = useNavigate();

  const [owner, setOwner] = useState(null);
  const [cars, setCars] = useState([]);
  const [loading, setLoading] = useState(false);
  const [globalError, setGlobalError] = useState("");

  const [selectedCar, setSelectedCar] = useState(null);
  const [carLoading, setCarLoading] = useState(false);

  const formatDate = (value) => {
    if (!value) return "";
    const d = new Date(value);
    if (Number.isNaN(d.getTime())) return "";
    return d.toLocaleDateString("vi-VN");
  };

  const loadOwner = async () => {
    setLoading(true);
    setGlobalError("");
    try {
      // GET /api/ownercar/{id}
      const res = await axiosClient.get(`/ownercar/${ownerId}`);
      const data = res.data;
      setOwner(data);
      setCars(data.cars ?? data.Cars ?? []);
    } catch (err) {
      console.error(err);
      setGlobalError("Không thể tải thông tin chủ xe hoặc danh sách xe.");
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    if (ownerId) {
      loadOwner();
    }
  }, [ownerId]);

  const handleViewCarDetail = async (carId) => {
    setCarLoading(true);
    setSelectedCar(null);
    setGlobalError("");

    try {
      // GET /api/ownercar/cars/{carId}
      const res = await axiosClient.get(`/ownercar/cars/${carId}`);
      setSelectedCar(res.data);
    } catch (err) {
      console.error(err);
      setGlobalError("Không thể tải chi tiết xe.");
    } finally {
      setCarLoading(false);
    }
  };

  const styles = {
    page: {
      padding: "24px 32px",
      backgroundColor: "#f3f4f6",
      minHeight: "100vh",
      boxSizing: "border-box",
    },
    card: {
      maxWidth: 1200,
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
      fontSize: 22,
      fontWeight: 700,
      margin: 0,
    },
    backBtn: {
      padding: "6px 12px",
      borderRadius: 999,
      border: "1px solid #d1d5db",
      backgroundColor: "#fff",
      cursor: "pointer",
      fontSize: 13,
    },
    ownerInfo: {
      fontSize: 14,
      color: "#374151",
      marginBottom: 12,
    },
    mono: {
      fontFamily: "monospace",
      fontSize: 12,
      wordBreak: "break-all",
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
    smallBtn: {
      padding: "4px 8px",
      borderRadius: 6,
      border: "1px solid #d1d5db",
      backgroundColor: "#fff",
      cursor: "pointer",
      fontSize: 12,
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
    sectionTitle: {
      marginTop: 16,
      fontSize: 16,
      fontWeight: 600,
    },
    detailCard: {
      marginTop: 12,
      padding: 12,
      borderRadius: 12,
      border: "1px solid #e5e7eb",
      backgroundColor: "#f9fafb",
      fontSize: 13,
    },
    detailRow: {
      marginBottom: 4,
    },
  };

  const renderOwnerInfo = () => {
    if (!owner) return null;
    const ownerCarId = owner.ownerCarId ?? owner.OwnerCarId;
    const firebaseUid = owner.firebaseUid ?? owner.FirebaseUid ?? "";
    const drivingLicence = owner.drivingLicence ?? owner.DrivingLicence ?? "";
    const isActive = owner.isActive ?? owner.IsActive ?? true;
    const createdAt = owner.createdAt ?? owner.CreatedAt;
    const updatedAt = owner.updatedAt ?? owner.UpdatedAt;

    return (
      <div style={styles.ownerInfo}>
        <div>
          <b>ID chủ xe:</b> {ownerCarId}
        </div>
        <div>
          <b>Firebase UID:</b> <span style={styles.mono}>{firebaseUid}</span>
        </div>
        <div>
          <b>Số GPLX:</b> {drivingLicence}
        </div>
        <div>
          <b>Trạng thái:</b>{" "}
          {isActive ? (
            <span style={{ color: "#166534" }}>Hoạt động</span>
          ) : (
            <span style={{ color: "#b91c1c" }}>Vô hiệu hóa</span>
          )}
        </div>
        <div>
          <b>Tạo lúc:</b> {formatDate(createdAt)}{" "}
          {updatedAt && (
            <>
              {" "}
              – <b>Cập nhật:</b> {formatDate(updatedAt)}
            </>
          )}
        </div>
      </div>
    );
  };

  const renderCarDetail = () => {
    if (carLoading) {
      return <div style={styles.detailCard}>Đang tải chi tiết xe...</div>;
    }
    if (!selectedCar) return null;

    const carId = selectedCar.carID ?? selectedCar.CarID;
    const nameCar = selectedCar.nameCar ?? selectedCar.NameCar ?? "";
    const licensePlate =
      selectedCar.licensePlate ?? selectedCar.LicensePlate ?? "";
    const modelYear = selectedCar.modelYear ?? selectedCar.ModelYear;
    const seat = selectedCar.seat ?? selectedCar.Seat;
    const typeCar = selectedCar.typeCar ?? selectedCar.TypeCar;
    const transmission = selectedCar.transmission ?? selectedCar.Transmission;
    const fuelType = selectedCar.fuelType ?? selectedCar.FuelType;
    const color = selectedCar.color ?? selectedCar.Color;
    const registrationDate =
      selectedCar.registrationDate ?? selectedCar.RegistrationDate;
    const insuranceExpiryDate =
      selectedCar.insuranceExpiryDate ?? selectedCar.InsuranceExpiryDate;
    const inspectionExpiryDate =
      selectedCar.inspectionExpiryDate ?? selectedCar.InspectionExpiryDate;

    return (
      <div style={styles.detailCard}>
        <div style={styles.detailRow}>
          <b>Car ID:</b> {carId}
        </div>
        <div style={styles.detailRow}>
          <b>Tên xe:</b> {nameCar}
        </div>
        <div style={styles.detailRow}>
          <b>Biển số:</b> {licensePlate}
        </div>
        <div style={styles.detailRow}>
          <b>Năm SX / Số chỗ:</b> {modelYear} – {seat} chỗ
        </div>
        <div style={styles.detailRow}>
          <b>Loại xe / Hộp số:</b> {typeCar} – {transmission}
        </div>
        <div style={styles.detailRow}>
          <b>Nhiên liệu:</b> {fuelType}
        </div>
        <div style={styles.detailRow}>
          <b>Màu xe:</b> {color}
        </div>
        <div style={styles.detailRow}>
          <b>Đăng ký:</b> {formatDate(registrationDate)}
        </div>
        <div style={styles.detailRow}>
          <b>Bảo hiểm hết hạn:</b> {formatDate(insuranceExpiryDate)}
        </div>
        <div style={styles.detailRow}>
          <b>Đăng kiểm hết hạn:</b> {formatDate(inspectionExpiryDate)}
        </div>
      </div>
    );
  };

  return (
    <div style={styles.page}>
      <div style={styles.card}>
        <div style={styles.headerRow}>
          <h1 style={styles.title}>Danh sách xe của chủ xe #{ownerId}</h1>
          <button
            type="button"
            style={styles.backBtn}
            onClick={() => navigate("/staff/owners")}
          >
            ← Quay lại danh sách chủ xe
          </button>
        </div>

        {globalError && <div style={styles.globalError}>{globalError}</div>}
        {loading && <div>Đang tải dữ liệu...</div>}

        {!loading && (
          <>
            {renderOwnerInfo()}

            <h2 style={styles.sectionTitle}>Danh sách xe</h2>
            <table style={styles.table}>
              <thead>
                <tr>
                  <th style={styles.th}>Car ID</th>
                  <th style={styles.th}>Tên xe</th>
                  <th style={styles.th}>Biển số</th>
                  <th style={styles.th}>Năm SX</th>
                  <th style={styles.th}>Số chỗ</th>
                  <th style={styles.th}>Loại / Hộp số</th>
                  <th style={styles.th}>Hành động</th>
                </tr>
              </thead>
              <tbody>
                {cars.map((c) => {
                  const carId = c.carID ?? c.CarID;
                  const nameCar = c.nameCar ?? c.NameCar ?? "";
                  const licensePlate = c.licensePlate ?? c.LicensePlate ?? "";
                  const modelYear = c.modelYear ?? c.ModelYear;
                  const seat = c.seat ?? c.Seat;
                  const typeCar = c.typeCar ?? c.TypeCar;
                  const transmission = c.transmission ?? c.Transmission ?? "";

                  return (
                    <tr key={carId}>
                      <td style={styles.td}>{carId}</td>
                      <td style={styles.td}>{nameCar}</td>
                      <td style={styles.td}>{licensePlate}</td>
                      <td style={styles.td}>{modelYear}</td>
                      <td style={styles.td}>{seat}</td>
                      <td style={styles.td}>
                        {typeCar} / {transmission}
                      </td>
                      <td style={styles.td}>
                        <button
                          type="button"
                          style={{
                            ...styles.smallBtn,
                            ...styles.primaryOutlineBtn,
                          }}
                          onClick={() => handleViewCarDetail(carId)}
                        >
                          Chi tiết
                        </button>
                      </td>
                    </tr>
                  );
                })}
                {cars.length === 0 && (
                  <tr>
                    <td style={styles.td} colSpan={7}>
                      Chủ xe này hiện chưa có xe nào.
                    </td>
                  </tr>
                )}
              </tbody>
            </table>

            {renderCarDetail()}
          </>
        )}
      </div>
    </div>
  );
};

export default OwnerCarsOfOwnerPage;
