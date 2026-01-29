import { useState, useEffect } from "react";
import Sidebar from "../components/admin/Sidebar";
import "../components/admin/Admin.css";
import { getAllCars, getAvailableCars, getAllMaintenances, deleteCar, createCar, getAllOwnerCars } from "../api/carApi";

const CarManagement = () => {
    const [activeTab, setActiveTab] = useState("all");
    const [cars, setCars] = useState([]);
    const [owners, setOwners] = useState([]); // Store owners
    const [loading, setLoading] = useState(false);
    const [error, setError] = useState(null);
    const [showModal, setShowModal] = useState(false);

    // Initial Form State
    const initialFormState = {
        nameCar: "",
        licensePlate: "",
        modelYear: new Date().getFullYear(),
        seat: 4,
        typeCar: "Sedan",
        transmission: "Automatic",
        fuelType: "Gasoline",
        fuelConsumption: 0,
        color: "",
        pricePerDay: 0,
        deposit: 0,
        location: "",
        description: "",
        ownerCarID: "", // Changed to empty string to force selection
        registrationDate: "",
        insuranceExpiryDate: "",
        inspectionExpiryDate: "",
        imageUrl: "" // Added image url field
    };
    const [formData, setFormData] = useState(initialFormState);

    useEffect(() => {
        fetchData();
        fetchOwners(); 
    }, [activeTab]);

    const fetchData = async () => {
        setLoading(true);
        setError(null);
        try {
            let res;
            if (activeTab === "all") {
                res = await getAllCars();
            } else if (activeTab === "available") {
                res = await getAvailableCars();
            } else if (activeTab === "maintenance") {
                res = await getAllMaintenances();
            }
            setCars(res.data);
        } catch (err) {
            console.error("Error fetching data:", err);
            setError("Failed to load data.");
        } finally {
            setLoading(false);
        }
    };

    const fetchOwners = async () => {
        try {
            const res = await getAllOwnerCars();
            setOwners(res.data);
        } catch (err) {
            console.error("Error fetching owners:", err);
        }
    };

    const handleDelete = async (id) => {
        if (!window.confirm("Are you sure you want to delete this car?")) return;
        try {
            await deleteCar(id);
            alert("Car deleted successfully");
            fetchData();
        } catch (err) {
            console.error("Error deleting car:", err);
            alert("Failed to delete car.");
        }
    };

    const handleInputChange = (e) => {
        const { name, value } = e.target;
        setFormData(prev => ({
            ...prev,
            [name]: value
        }));
    };

    const handleSubmit = async (e) => {
        e.preventDefault();
        try {
            if (!formData.ownerCarID) {
                alert("Please select an Owner.");
                return;
            }

            const payload = {
                ...formData,
                ownerCarID: parseInt(formData.ownerCarID), // Ensure integer
                imageUrls: formData.imageUrl ? [formData.imageUrl] : []
            };
            
            await createCar(payload);
            alert("Car created successfully!");
            setShowModal(false);
            setFormData(initialFormState);
            fetchData(); 
        } catch (err) {
            console.error("Error creating car:", err);
            alert("Failed to create car: " + (err.response?.data?.message || err.message));
        }
    };

    return (
        <div className="admin-container">
            <Sidebar />
            <main className="main-content">
                <div className="dashboard-page">
                    <div className="header" style={{ marginBottom: "24px", borderRadius: "12px", boxShadow: "0 1px 3px rgba(0,0,0,0.1)" }}>
                         <div style={{ display: "flex", justifyContent: "space-between", alignItems: "center", width: "100%" }}>
                            <div style={{ display: "flex", gap: "16px", alignItems: "center" }}>
                                <h2 style={{ margin: 0, color: "#0f172a" }}>Quản lý Xe</h2>
                            </div>
                            <button style={{
                                backgroundColor: "#60a5fa",
                                color: "white",
                                border: "none",
                                padding: "8px 16px",
                                borderRadius: "6px",
                                fontWeight: "600",
                                cursor: "pointer"
                            }} onClick={() => setShowModal(true)}>
                                + Thêm Xe
                            </button>
                         </div>
                    </div>

                    <div style={{ display: "flex", gap: "12px", marginBottom: "24px" }}>
                        <button onClick={() => setActiveTab("all")} style={{ padding: "8px 16px", borderRadius: "20px", border: "none", backgroundColor: activeTab === "all" ? "#0f172a" : "#fff", color: activeTab === "all" ? "#fff" : "#64748b", fontWeight: "500", cursor: "pointer", transition: "all 0.2s" }}>Tất cả</button>
                        <button onClick={() => setActiveTab("available")} style={{ padding: "8px 16px", borderRadius: "20px", border: "none", backgroundColor: activeTab === "available" ? "#10b981" : "#fff", color: activeTab === "available" ? "#fff" : "#64748b", fontWeight: "500", cursor: "pointer", transition: "all 0.2s" }}>Có sẵn</button>
                        <button onClick={() => setActiveTab("maintenance")} style={{ padding: "8px 16px", borderRadius: "20px", border: "none", backgroundColor: activeTab === "maintenance" ? "#f59e0b" : "#fff", color: activeTab === "maintenance" ? "#fff" : "#64748b", fontWeight: "500", cursor: "pointer", transition: "all 0.2s" }}>Đang bảo trì</button>
                    </div>

                    <div className="card">
                        {loading ? (
                            <div style={{ textAlign: "center", padding: "24px" }}>Loading...</div>
                        ) : error ? (
                            <div style={{ color: "red", padding: "12px" }}>{error}</div>
                        ) : (
                            <div className="table-container">
                                {cars.length > 0 ? (
                                    <table>
                                        <thead>
                                            <tr>
                                                <th>ID</th>
                                                <th>Tên</th>
                                                <th>Biển số</th>
                                                {activeTab === "maintenance" ? (
                                                    <>
                                                        <th>Mô tả</th>
                                                        <th>Chi phí</th>
                                                        <th>Ngày</th>
                                                    </>
                                                ) : (
                                                    <>
                                                        <th>Giá thuê mỗi ngày ($)</th>
                                                        <th>Trạng thái</th>
                                                        <th>Địa điểm</th>
                                                    </>
                                                )}
                                                <th>Thao tác</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            {cars.map((item) => {
                                                const isMaintenance = activeTab === "maintenance";
                                                const id = isMaintenance ? item.maintenanceID : item.carID;
                                                return (
                                                    <tr key={id}> 
                                                        <td>#{id}</td>
                                                        <td>{isMaintenance ? `Car #${item.carID}` : item.nameCar}</td>
                                                        <td>{isMaintenance ? "-" : item.licensePlate}</td>
                                                        {isMaintenance ? (
                                                            <>
                                                                <td>{item.description}</td>
                                                                <td>${item.cost}</td>
                                                                <td>{new Date(item.maintenanceDate).toLocaleDateString()}</td>
                                                            </>
                                                        ) : (
                                                            <>
                                                                <td>${item.pricePerDay}</td>
                                                                <td>
                                                                    <span style={{ padding: "4px 8px", borderRadius: "12px", fontSize: "12px", fontWeight: "500", backgroundColor: item.isAvailable ? "#d1fae5" : "#fee2e2", color: item.isAvailable ? "#065f46" : "#991b1b" }}>
                                                                        {item.isAvailable ? "Available" : "Unavailable"}
                                                                    </span>
                                                                </td>
                                                                <td>{item.location || "N/A"}</td>
                                                            </>
                                                        )}
                                                        <td>
                                                            <div style={{ display: "flex", gap: "8px" }}>
                                                                <button style={{ color: "#3b82f6", background: "none", border: "none", cursor: "pointer", fontWeight: "500" }}>Edit</button>
                                                                <button onClick={() => handleDelete(id)} style={{ color: "#ef4444", background: "none", border: "none", cursor: "pointer", fontWeight: "500" }}>Delete</button>
                                                            </div>
                                                        </td>
                                                    </tr>
                                                );
                                            })}
                                        </tbody>
                                    </table>
                                ) : (
                                    <div style={{ textAlign: "center", padding: "24px", color: "#64748b" }}>No data found.</div>
                                )}
                            </div>
                        )}
                    </div>
                </div>

                {showModal && (
                    <div style={{
                        position: "fixed",
                        top: 0,
                        left: 0,
                        right: 0,
                        bottom: 0,
                        backgroundColor: "rgba(0,0,0,0.5)",
                        display: "flex",
                        alignItems: "center",
                        justifyContent: "center",
                        zIndex: 1000
                    }}>
                        <div style={{
                            backgroundColor: "white",
                            padding: "24px",
                            borderRadius: "12px",
                            width: "90%",
                            maxWidth: "800px",
                            maxHeight: "90vh",
                            overflowY: "auto",
                            boxShadow: "0 4px 6px rgba(0,0,0,0.1)"
                        }}>
                            <div style={{ display: "flex", justifyContent: "space-between", marginBottom: "24px" }}>
                                <h3 style={{ margin: 0 }}>Thêm Xe Mới</h3>
                                <button onClick={() => setShowModal(false)} style={{ border: "none", background: "none", fontSize: "16px", cursor: "pointer" }}>✕</button>
                            </div>
                            
                            <form onSubmit={handleSubmit} style={{ display: "grid", gridTemplateColumns: "1fr 1fr", gap: "16px" }}>
                                <div className="form-group">
                                    <label>Tên Xe</label>
                                    <input required name="nameCar" value={formData.nameCar} onChange={handleInputChange} className="login-input" />
                                </div>
                                <div className="form-group">
                                    <label>Biển số xe</label>
                                    <input required name="licensePlate" value={formData.licensePlate} onChange={handleInputChange} className="login-input" />
                                </div>
                                <div className="form-group">
                                    <label>Năm sản xuất</label>
                                    <input required type="number" name="modelYear" value={formData.modelYear} onChange={handleInputChange} className="login-input" />
                                </div>
                                <div className="form-group">
                                    <label>Số chỗ ngồi</label>
                                    <input required type="number" name="seat" value={formData.seat} onChange={handleInputChange} className="login-input" />
                                </div>
                                <div className="form-group">
                                    <label>Loại xe</label>
                                    <input required name="typeCar" value={formData.typeCar} onChange={handleInputChange} className="login-input" placeholder="e.g. Sedan, SUV" />
                                </div>
                                <div className="form-group">
                                    <label>Hộp số</label>
                                    <select name="transmission" value={formData.transmission} onChange={handleInputChange} className="login-input">
                                        <option value="Automatic">Automatic</option>
                                        <option value="Manual">Manual</option>
                                    </select>
                                </div>
                                <div className="form-group">
                                    <label>Loại nhiên liệu</label>
                                    <select name="fuelType" value={formData.fuelType} onChange={handleInputChange} className="login-input">
                                        <option value="Gasoline">Gasoline</option>
                                        <option value="Diesel">Diesel</option>
                                        <option value="Electric">Electric</option>
                                        <option value="Hybrid">Hybrid</option>
                                    </select>
                                </div>
                                <div className="form-group">
                                    <label>Khối lượng nhiên liệu (L/100km)</label>
                                    <input type="number" name="fuelConsumption" value={formData.fuelConsumption} onChange={handleInputChange} className="login-input" step="0.1" />
                                </div>
                                <div className="form-group">
                                    <label>Màu sắc</label>
                                    <input required name="color" value={formData.color} onChange={handleInputChange} className="login-input" />
                                </div>
                                <div className="form-group">
                                    <label>Giá thuê mỗi ngày ($)</label>
                                    <input required type="number" name="pricePerDay" value={formData.pricePerDay} onChange={handleInputChange} className="login-input" />
                                </div>
                                <div className="form-group">
                                    <label>Đặt cọc ($)</label>
                                    <input required type="number" name="deposit" value={formData.deposit} onChange={handleInputChange} className="login-input" />
                                </div>
                                <div className="form-group">
                                    <label>Địa điểm</label>
                                    <input required name="location" value={formData.location} onChange={handleInputChange} className="login-input" />
                                </div>
                                <div className="form-group">
                                    <label>Chủ sở hữu</label>
                                    <select required name="ownerCarID" value={formData.ownerCarID} onChange={handleInputChange} className="login-input">
                                        <option value="">Select Owner</option>
                                        {owners.map(owner => (
                                            <option key={owner.ownerCarId} value={owner.ownerCarId}>
                                                Owner #{owner.ownerCarId} ({owner.drivingLicence})
                                            </option>
                                        ))}
                                    </select>
                                </div>
                                <div className="form-group">
                                    <label>Ảnh URL</label>
                                    <input name="imageUrl" value={formData.imageUrl} onChange={handleInputChange} className="login-input" placeholder="http://..." />
                                </div>
                                <div className="form-group" style={{ gridColumn: "span 2" }}>
                                    <label>Mô tả</label>
                                    <textarea name="description" value={formData.description} onChange={handleInputChange} className="login-input" rows="3" />
                                </div>
                                
                                <h4 style={{ gridColumn: "span 2", margin: "8px 0" }}>Documents (Dates)</h4>
                                <div className="form-group">
                                    <label>Ngày Đăng Ký</label>
                                    <input required type="date" name="registrationDate" value={formData.registrationDate} onChange={handleInputChange} className="login-input" />
                                </div>
                                <div className="form-group">
                                    <label>Ngày Hết Hạn Bảo Hiểm</label>
                                    <input required type="date" name="insuranceExpiryDate" value={formData.insuranceExpiryDate} onChange={handleInputChange} className="login-input" />
                                </div>
                                <div className="form-group">
                                    <label>Hạn Đăng Kiểm</label>
                                    <input required type="date" name="inspectionExpiryDate" value={formData.inspectionExpiryDate} onChange={handleInputChange} className="login-input" />
                                </div>

                                <div style={{ gridColumn: "span 2", display: "flex", gap: "12px", marginTop: "16px" }}>
                                    <button type="button" onClick={() => setShowModal(false)} style={{
                                        flex: 1, padding: "12px", border: "1px solid #e2e8f0", borderRadius: "8px", background: "white", color: "black", cursor: "pointer", fontWeight: "600"
                                    }}>Hủy</button>
                                    <button type="submit" style={{
                                        flex: 1, padding: "12px", border: "none", borderRadius: "8px", background: "linear-gradient(to right, #60a5fa, #a855f7)", color: "white", cursor: "pointer", fontWeight: "600"
                                    }}>Thêm Xe</button>
                                </div>
                            </form>
                        </div>
                    </div>
                )}
            </main>
        </div>
    );
};

export default CarManagement;
