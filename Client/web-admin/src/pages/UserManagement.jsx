import { useState, useEffect } from "react";
import Sidebar from "../components/admin/Sidebar";
import "../components/admin/Admin.css";
import { getAllUsers, promoteUser, getUserByEmail } from "../api/userApi";

const UserManagement = () => {
    const [users, setUsers] = useState([]);
    const [searchEmail, setSearchEmail] = useState("");
    const [loading, setLoading] = useState(false);
    const [error, setError] = useState(null);

    useEffect(() => {
        fetchUsers();
    }, []);

    const fetchUsers = async () => {
        setLoading(true);
        try {
            const res = await getAllUsers();
            setUsers(res.data);
            setError(null);
        } catch (err) {
            console.error("Error fetching users:", err);
            setError("Failed to load users.");
        } finally {
            setLoading(false);
        }
    };

    const handleSearch = async (e) => {
        e.preventDefault();
        if (!searchEmail) {
            fetchUsers();
            return;
        }

        setLoading(true);
        try {
            const res = await getUserByEmail(searchEmail);
            // API returns a single user object or null/404
            if (res.data) {
                setUsers([res.data]);
            } else {
                 setUsers([]);
            }
            setError(null);
        } catch (err) {
            console.error("Error searching user:", err);
            if (err.response && err.response.status === 404) {
                 setUsers([]);
                 setError("User not found.");
            } else {
                setError("Search failed.");
            }
        } finally {
            setLoading(false);
        }
    };

    const handleRoleChange = async (userId, newRole) => {
        if (!window.confirm(`Bạn có muốn thay đổi thành role ${newRole}?`)) return;

        try {
            await promoteUser(userId, newRole);
            alert("User role updated successfully!");
            fetchUsers(); // Refresh list
        } catch (err) {
            console.error("Error updating user role:", err);
            alert("Failed to update user role.");
        }
    };

    return (
        <div className="admin-container">
            <Sidebar />
            <main className="main-content">
                <div className="dashboard-page">
                    <div className="header" style={{ marginBottom: "24px", borderRadius: "12px", boxShadow: "0 1px 3px rgba(0,0,0,0.1)" }}>
                         <div style={{ display: "flex", gap: "16px", alignItems: "center", width: "100%" }}>
                            <h2 style={{ margin: 0, color: "#0f172a" }}>User Management</h2>
                         </div>
                         <div className="header-profile">
                            <div className="avatar">A</div>
                         </div>
                    </div>

                    <div className="card">
                        <div style={{ display: "flex", justifyContent: "space-between", alignItems: "center", marginBottom: "24px" }}>
                            <h3 className="card-title" style={{ margin: 0 }}>All Users</h3>
                            <form onSubmit={handleSearch} style={{ display: "flex", gap: "8px" }}>
                                <input
                                    type="text"
                                    placeholder="Search by email..."
                                    value={searchEmail}
                                    onChange={(e) => setSearchEmail(e.target.value)}
                                    style={{
                                        padding: "8px 12px",
                                        borderRadius: "6px",
                                        border: "1px solid #e2e8f0",
                                        outline: "none",
                                        minWidth: "250px"
                                    }}
                                />
                                <button type="submit" style={{
                                    backgroundColor: "#3b82f6",
                                    color: "white",
                                    border: "none",
                                    padding: "8px 16px",
                                    borderRadius: "6px",
                                    fontWeight: "500"
                                }}>Search</button>
                                {searchEmail && (
                                     <button type="button" onClick={() => { setSearchEmail(""); fetchUsers(); }} style={{
                                        backgroundColor: "#94a3b8",
                                        color: "white",
                                        border: "none",
                                        padding: "8px 16px",
                                        borderRadius: "6px",
                                        fontWeight: "500"
                                    }}>Clear</button>
                                )}
                            </form>
                        </div>

                        {error && <div style={{ color: "red", marginBottom: "16px" }}>{error}</div>}
                        
                        {loading ? (
                            <div style={{ textAlign: "center", padding: "24px" }}>Loading...</div>
                        ) : (
                            <div className="table-container">
                                {users.length > 0 ? (
                                    <table>
                                        <thead>
                                            <tr>
                                                <th>ID</th>
                                                <th>Name</th>
                                                <th>Email</th>
                                                <th>Phone</th>
                                                <th>Role</th>
                                                <th>Actions</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            {users.map((user) => (
                                                <tr key={user.id || user.ID}> 
                                                    <td>#{user.id || user.ID}</td>
                                                    <td>
                                                        <div style={{ fontWeight: 500 }}>
                                                            {user.firstName} {user.lastName}
                                                        </div>
                                                        <div style={{ fontSize: "12px", color: "#64748b" }}>
                                                            {user.username}
                                                        </div>
                                                    </td>
                                                    <td>{user.email}</td>
                                                    <td>{user.phoneNumber || "N/A"}</td>
                                                    <td>
                                                        <span style={{
                                                            padding: "4px 8px",
                                                            borderRadius: "12px",
                                                            fontSize: "12px",
                                                            fontWeight: "500",
                                                            backgroundColor: user.role === "Admin" ? "#dbeafe" : "#f1f5f9",
                                                            color: user.role === "Admin" ? "#1e40af" : "#475569"
                                                        }}>
                                                            {user.role || "User"}
                                                        </span>
                                                    </td>
                                                    <td>
                                                        <select
                                                            value={user.role || "User"}
                                                            onChange={(e) => handleRoleChange(user.id || user.ID, e.target.value)}
                                                            style={{
                                                                padding: "6px 12px",
                                                                borderRadius: "6px",
                                                                border: "1px solid #e2e8f0",
                                                                fontSize: "14px",
                                                                backgroundColor: "white",
                                                                cursor: "pointer",
                                                                color: "#0f172a"
                                                            }}
                                                        >
                                                            <option value="User">User</option>
                                                            <option value="Admin">Admin</option>
                                                        </select>
                                                    </td>
                                                </tr>
                                            ))}
                                        </tbody>
                                    </table>
                                ) : (
                                    <div style={{ textAlign: "center", padding: "24px", color: "#64748b" }}>No users found.</div>
                                )}
                            </div>
                        )}
                    </div>
                </div>
            </main>
        </div>
    );
};

export default UserManagement;
