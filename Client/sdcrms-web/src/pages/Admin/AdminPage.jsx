import React, { useEffect, useState } from "react";
import {
  getDashboardData,
  getAllAdmins,
  createAdmin,
  promoteUser,
} from "../../api/adminApi";
import { getAllUsers } from "../../api/userApi";
import { syncAllFirebaseUsers } from "../../api/syncAllFirebaseUsers";

const AdminPage = () => {
  const [dashboardData, setDashboardData] = useState(null);
  const [admins, setAdmins] = useState([]);
  const [showCreateForm, setShowCreateForm] = useState(false);
  const [showPromoteForm, setShowPromoteForm] = useState(false);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState("");

  // Form states
  const [newAdmin, setNewAdmin] = useState({
    firstName: "",
    lastName: "",
    email: "",
    password: "",
    phoneNumber: "",
    sex: "Male",
    birthday: "",
    address: "",
  });

  const [promoteData, setPromoteData] = useState({
    userId: "",
    newRole: "Staff",
  });

  // Load dashboard data
  const loadDashboard = async () => {
    try {
      setLoading(true);
      const data = await getDashboardData();
      setDashboardData(data);
    } catch (err) {
      setError(err.message);
    } finally {
      setLoading(false);
    }
  };

  // Load all admins
  const loadAdmins = async () => {
    try {
      setLoading(true);
      const data = await getAllAdmins();
      setAdmins(data);
    } catch (err) {
      setError(err.message);
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    loadDashboard();
    loadAdmins();
  }, []);

  // Handle create admin
  const handleCreateAdmin = async (e) => {
    e.preventDefault();
    try {
      setLoading(true);
      await createAdmin(newAdmin);
      alert("✅ Admin created successfully!");
      setShowCreateForm(false);
      setNewAdmin({
        firstName: "",
        lastName: "",
        email: "",
        password: "",
        phoneNumber: "",
        sex: "Male",
        birthday: "",
        address: "",
      });
      loadAdmins();
    } catch (err) {
      alert(`❌ Error: ${err.message}`);
    } finally {
      setLoading(false);
    }
  };

  // Handle promote user
  const handlePromoteUser = async (e) => {
    e.preventDefault();
    try {
      setLoading(true);
      await promoteUser(promoteData.userId, promoteData.newRole);
      alert(`✅ User promoted to ${promoteData.newRole} successfully!`);
      setShowPromoteForm(false);
      setPromoteData({ userId: "", newRole: "Staff" });
    } catch (err) {
      alert(`❌ Error: ${err.message}`);
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="p-6 max-w-7xl mx-auto">
      <h1 className="text-3xl font-bold mb-6">Admin Management</h1>

      {/* Nút đồng bộ tất cả user từ Firebase */}
      <div className="mb-4">
        <button
          onClick={async () => {
            setLoading(true);
            await syncAllFirebaseUsers();
            await loadAdmins();
            setLoading(false);
            alert("Đồng bộ tất cả user từ Firebase thành công!");
          }}
          className="px-4 py-2 bg-yellow-500 text-white rounded hover:bg-yellow-600"
        >
          Đồng bộ tất cả user từ Firebase
        </button>
      </div>

      {/* Thông báo lỗi */}
      {error && (
        <div className="bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded mb-4">
          {error}
        </div>
      )}

      {/* Thống kê bảng điều khiển */}
      <div className="grid grid-cols-1 md:grid-cols-4 gap-4 mb-8">
        <div className="bg-blue-100 p-6 rounded-lg shadow">
          <h3 className="text-lg font-semibold text-blue-800">Total Users</h3>
          <p className="text-3xl font-bold text-blue-900">
            {dashboardData?.totalUsers || 0}
          </p>
        </div>
        <div className="bg-green-100 p-6 rounded-lg shadow">
          <h3 className="text-lg font-semibold text-green-800">Total Admins</h3>
          <p className="text-3xl font-bold text-green-900">
            {dashboardData?.totalAdmins || 0}
          </p>
        </div>
        <div className="bg-purple-100 p-6 rounded-lg shadow">
          <h3 className="text-lg font-semibold text-purple-800">Total Staff</h3>
          <p className="text-3xl font-bold text-purple-900">
            {dashboardData?.totalStaff || 0}
          </p>
        </div>
        <div className="bg-orange-100 p-6 rounded-lg shadow">
          <h3 className="text-lg font-semibold text-orange-800">
            Total Customers
          </h3>
          <p className="text-3xl font-bold text-orange-900">
            {dashboardData?.totalCustomers || 0}
          </p>
        </div>
      </div>

      {/* Action Buttons */}
      <div className="flex gap-4 mb-6">
        <button
          onClick={() => setShowCreateForm(!showCreateForm)}
          className="px-4 py-2 bg-blue-500 text-white rounded hover:bg-blue-600"
        >
          {showCreateForm ? "Cancel" : "+ Create Admin"}
        </button>
        <button
          onClick={() => setShowPromoteForm(!showPromoteForm)}
          className="px-4 py-2 bg-green-500 text-white rounded hover:bg-green-600"
        >
          {showPromoteForm ? "Cancel" : "👤 Promote User"}
        </button>
      </div>

      {/* Create Admin Form */}
      {showCreateForm && (
        <div className="bg-white p-6 rounded-lg shadow-md mb-6">
          <h2 className="text-xl font-bold mb-4">Create New Admin</h2>
          <form onSubmit={handleCreateAdmin} className="space-y-4">
            <div className="grid grid-cols-2 gap-4">
              <div>
                <label className="block text-sm font-medium mb-1">
                  First Name *
                </label>
                <input
                  type="text"
                  required
                  value={newAdmin.firstName}
                  onChange={(e) =>
                    setNewAdmin({ ...newAdmin, firstName: e.target.value })
                  }
                  className="w-full border rounded px-3 py-2"
                />
              </div>
              <div>
                <label className="block text-sm font-medium mb-1">
                  Last Name *
                </label>
                <input
                  type="text"
                  required
                  value={newAdmin.lastName}
                  onChange={(e) =>
                    setNewAdmin({ ...newAdmin, lastName: e.target.value })
                  }
                  className="w-full border rounded px-3 py-2"
                />
              </div>
            </div>
            <div>
              <label className="block text-sm font-medium mb-1">Email *</label>
              <input
                type="email"
                required
                value={newAdmin.email}
                onChange={(e) =>
                  setNewAdmin({ ...newAdmin, email: e.target.value })
                }
                className="w-full border rounded px-3 py-2"
              />
            </div>
            <div>
              <label className="block text-sm font-medium mb-1">
                Password *
              </label>
              <input
                type="password"
                required
                minLength={6}
                value={newAdmin.password}
                onChange={(e) =>
                  setNewAdmin({ ...newAdmin, password: e.target.value })
                }
                className="w-full border rounded px-3 py-2"
              />
            </div>
            <div className="grid grid-cols-2 gap-4">
              <div>
                <label className="block text-sm font-medium mb-1">
                  Phone Number *
                </label>
                <input
                  type="tel"
                  required
                  value={newAdmin.phoneNumber}
                  onChange={(e) =>
                    setNewAdmin({ ...newAdmin, phoneNumber: e.target.value })
                  }
                  className="w-full border rounded px-3 py-2"
                />
              </div>
              <div>
                <label className="block text-sm font-medium mb-1">Sex *</label>
                <select
                  required
                  value={newAdmin.sex}
                  onChange={(e) =>
                    setNewAdmin({ ...newAdmin, sex: e.target.value })
                  }
                  className="w-full border rounded px-3 py-2"
                >
                  <option value="Male">Male</option>
                  <option value="Female">Female</option>
                  <option value="Other">Other</option>
                </select>
              </div>
            </div>
            <div className="grid grid-cols-2 gap-4">
              <div>
                <label className="block text-sm font-medium mb-1">
                  Birthday *
                </label>
                <input
                  type="date"
                  required
                  value={newAdmin.birthday}
                  onChange={(e) =>
                    setNewAdmin({ ...newAdmin, birthday: e.target.value })
                  }
                  className="w-full border rounded px-3 py-2"
                />
              </div>
              <div>
                <label className="block text-sm font-medium mb-1">
                  Address *
                </label>
                <input
                  type="text"
                  required
                  value={newAdmin.address}
                  onChange={(e) =>
                    setNewAdmin({ ...newAdmin, address: e.target.value })
                  }
                  className="w-full border rounded px-3 py-2"
                />
              </div>
            </div>
            <button
              type="submit"
              disabled={loading}
              className="w-full bg-blue-500 text-white py-2 rounded hover:bg-blue-600 disabled:bg-gray-400"
            >
              {loading ? "Creating..." : "Create Admin"}
            </button>
          </form>
        </div>
      )}

      {/* Promote User Form */}
      {showPromoteForm && (
        <div className="bg-white p-6 rounded-lg shadow-md mb-6">
          <h2 className="text-xl font-bold mb-4">Promote User</h2>
          <form onSubmit={handlePromoteUser} className="space-y-4">
            <div>
              <label className="block text-sm font-medium mb-1">User ID</label>
              <input
                type="number"
                required
                value={promoteData.userId}
                onChange={(e) =>
                  setPromoteData({ ...promoteData, userId: e.target.value })
                }
                className="w-full border rounded px-3 py-2"
              />
            </div>
            <div>
              <label className="block text-sm font-medium mb-1">New Role</label>
              <select
                value={promoteData.newRole}
                onChange={(e) =>
                  setPromoteData({ ...promoteData, newRole: e.target.value })
                }
                className="w-full border rounded px-3 py-2"
              >
                <option value="Staff">Staff</option>
                <option value="Admin">Admin</option>
                <option value="Customer">Customer</option>
                <option value="User">User</option>
              </select>
            </div>
            <button
              type="submit"
              disabled={loading}
              className="w-full bg-green-500 text-white py-2 rounded hover:bg-green-600 disabled:bg-gray-400"
            >
              {loading ? "Promoting..." : "Promote User"}
            </button>
          </form>
        </div>
      )}

      {/* Admins List */}
      <div className="bg-white rounded-lg shadow-md overflow-hidden">
        <div className="px-6 py-4 bg-gray-50 border-b">
          <h2 className="text-xl font-bold">All Admins</h2>
        </div>
        <div className="overflow-x-auto">
          <table className="w-full">
            <thead className="bg-gray-100">
              <tr>
                <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">
                  ID
                </th>
                <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">
                  Email
                </th>
                <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">
                  Full Name
                </th>
                <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">
                  Phone
                </th>
                <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">
                  Created
                </th>
              </tr>
            </thead>
            <tbody className="bg-white divide-y divide-gray-200">
              {Array.isArray(admins) && admins.length === 0 ? (
                <tr>
                  <td
                    colSpan="5"
                    className="px-6 py-4 text-center text-gray-500"
                  >
                    {loading ? "Loading..." : "No admins found"}
                  </td>
                </tr>
              ) : (
                (Array.isArray(admins) ? admins : []).map((admin) => (
                  <tr key={admin.userID} className="hover:bg-gray-50">
                    <td className="px-6 py-4 whitespace-nowrap text-sm">
                      {admin.userID}
                    </td>
                    <td className="px-6 py-4 whitespace-nowrap text-sm">
                      {admin.email}
                    </td>
                    <td className="px-6 py-4 whitespace-nowrap text-sm">
                      {admin.fullName}
                    </td>
                    <td className="px-6 py-4 whitespace-nowrap text-sm">
                      {admin.phoneNumber}
                    </td>
                    <td className="px-6 py-4 whitespace-nowrap text-sm">
                      {admin.createdAt
                        ? new Date(admin.createdAt).toLocaleDateString()
                        : "N/A"}
                    </td>
                  </tr>
                ))
              )}
            </tbody>
          </table>
        </div>
      </div>
    </div>
  );
};

export default AdminPage;
