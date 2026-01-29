import { useState, useEffect } from "react";
import Sidebar from "../components/admin/Sidebar";
import "../components/admin/Admin.css";
import { getAllBookings, confirmReturn, cancelBooking } from "../api/bookingApi";

const BookingManagement = () => {
    const [bookings, setBookings] = useState([]);
    const [filteredBookings, setFilteredBookings] = useState([]);
    const [statusFilter, setStatusFilter] = useState("All");
    const [loading, setLoading] = useState(false);
    const [error, setError] = useState(null);

    useEffect(() => {
        fetchBookings();
    }, []);

    useEffect(() => {
        if (statusFilter === "All") {
            setFilteredBookings(bookings);
        } else {
            setFilteredBookings(bookings.filter(b => b.status === statusFilter));
        }
    }, [statusFilter, bookings]);

    const fetchBookings = async () => {
        setLoading(true);
        try {
            const res = await getAllBookings();
            // Sort by ID desc or Date desc
            const sorted = res.data.sort((a, b) => new Date(b.createdAt || b.startDate) - new Date(a.createdAt || a.startDate));
            setBookings(sorted);
        } catch (err) {
            console.error("Error fetching bookings:", err);
            setError("Failed to load bookings.");
        } finally {
            setLoading(false);
        }
    };

    const handleConfirmReturn = async (id) => {
        if (!window.confirm("Confirm return for this booking? This will refund deposit and pay owner.")) return;
        try {
            await confirmReturn(id);
            alert("Return confirmed successfully!");
            fetchBookings();
        } catch (err) {
            console.error(err);
            alert("Error confirming return: " + (err.response?.data?.message || err.message));
        }
    };

    const handleCancel = async (id) => {
        if (!window.confirm("Are you sure you want to cancel this booking?")) return;
        try {
            await cancelBooking(id);
            alert("Booking cancelled successfully!");
            fetchBookings();
        } catch (err) {
            console.error(err);
            alert("Error cancelling booking: " + (err.response?.data?.message || err.message));
        }
    };

    const getStatusBadge = (status) => {
        const styles = {
            Pending: { bg: "#fef3c7", color: "#d97706" },
            Approved: { bg: "#d1fae5", color: "#059669" },
            Paid: { bg: "#dbeafe", color: "#2563eb" },
            InProgress: { bg: "#e0e7ff", color: "#4f46e5" },
            Completed: { bg: "#ecfccb", color: "#65a30d" },
            Cancelled: { bg: "#fee2e2", color: "#dc2626" },
            ReturnRequested: { bg: "#ffedd5", color: "#ea580c" }
        };
        const style = styles[status] || { bg: "#f3f4f6", color: "#4b5563" };
        return (
            <span style={{
                padding: "4px 12px", borderRadius: "20px", fontSize: "12px", fontWeight: "600",
                backgroundColor: style.bg, color: style.color
            }}>
                {status}
            </span>
        );
    };

    return (
        <div className="admin-container">
            <Sidebar />
            <main className="main-content">
                <div className="dashboard-page">
                    <div className="header" style={{ marginBottom: "24px" }}>
                        <h2 style={{ margin: 0, color: "#0f172a" }}>Quản lý Đặt Xe</h2>
                        <div style={{ display: "flex", gap: "12px" }}>
                            <select 
                                value={statusFilter} 
                                onChange={(e) => setStatusFilter(e.target.value)}
                                style={{ padding: "8px", borderRadius: "8px", border: "1px solid #cbd5e1" }}
                            >
                                <option value="All">Tất cả trạng thái</option>
                                <option value="Pending">Pending</option>
                                <option value="Paid">Paid</option>
                                <option value="InProgress">In Progress</option>
                                <option value="ReturnRequested">Return Requested</option>
                                <option value="Completed">Completed</option>
                                <option value="Cancelled">Cancelled</option>
                            </select>
                            <button onClick={fetchBookings} style={{ padding: "8px 16px", borderRadius: "8px", border: "none", background: "#0078f1ff", cursor: "pointer" }}>
                                Làm Mới
                            </button>
                        </div>
                    </div>

                    <div className="card">
                        {loading ? (
                            <div style={{ padding: "24px", textAlign: "center" }}>Loading...</div>
                        ) : error ? (
                             <div style={{ padding: "24px", textAlign: "center", color: "red" }}>{error}</div>
                        ) : (
                            <div className="table-container">
                                <table>
                                    <thead>
                                        <tr>
                                            <th>ID</th>
                                            <th>Xe (ID)</th>
                                            <th>Khách hàng (ID)</th>
                                            <th>Từ ngày</th>
                                            <th>Đến ngày</th>
                                            <th>Tổng tiền</th>
                                            <th>Trạng thái</th>
                                            <th>Thao tác</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        {filteredBookings.length > 0 ? filteredBookings.map(item => (
                                            <tr key={item.bookingID}>
                                                <td>#{item.bookingID}</td>
                                                <td>Car #{item.carId}</td>
                                                <td>Cus #{item.customerId}</td>
                                                <td>{new Date(item.startDate).toLocaleDateString()}</td>
                                                <td>{new Date(item.endDate).toLocaleDateString()}</td>
                                                <td>${item.totalPrice}</td>
                                                <td>{getStatusBadge(item.status)}</td>
                                                <td>
                                                    <div style={{ display: "flex", gap: "8px" }}>
                                                        {/* InProgress or ReturnRequested -> Confirm Return */}
                                                        {(item.status === "InProgress" || item.status === "ReturnRequested") && (
                                                            <button 
                                                                onClick={() => handleConfirmReturn(item.bookingID)}
                                                                title="Confirm Return"
                                                                style={{ padding: "4px 8px", background: "#10b981", color: "white", border: "none", borderRadius: "4px", cursor: "pointer" }}
                                                            >
                                                                ✓ Trả xe
                                                            </button>
                                                        )}
                                                        
                                                        {/* Pending/Approved/Paid -> Cancel */}
                                                        {["Pending", "Approved", "Paid"].includes(item.status) && (
                                                            <button 
                                                                onClick={() => handleCancel(item.bookingID)}
                                                                title="Cancel Booking"
                                                                style={{ padding: "4px 8px", background: "#ef4444", color: "white", border: "none", borderRadius: "4px", cursor: "pointer" }}
                                                            >
                                                                ✕ Hủy
                                                            </button>
                                                        )}
                                                    </div>
                                                </td>
                                            </tr>
                                        )) : (
                                            <tr>
                                                <td colSpan="8" style={{ textAlign: "center", padding: "24px", color: "#94a3b8" }}>Không có dữ liệu</td>
                                            </tr>
                                        )}
                                    </tbody>
                                </table>
                            </div>
                        )}
                    </div>
                </div>
            </main>
        </div>
    );
};

export default BookingManagement;
