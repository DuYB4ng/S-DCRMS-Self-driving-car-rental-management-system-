import React, { useEffect, useState } from "react";
import {
  getAllNotifications,
  getUserNotifications,
  createNotification,
  broadcastNotification,
  updateNotification,
  markAsRead,
  deleteNotification,
} from "../api/notificationApi";

const NotificationPage = () => {
  const [notifications, setNotifications] = useState([]);
  const [showCreateForm, setShowCreateForm] = useState(false);
  const [showBroadcastForm, setShowBroadcastForm] = useState(false);
  const [editingNotification, setEditingNotification] = useState(null);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState("");
  const [filterUserId, setFilterUserId] = useState("");

  // Form state
  const [formData, setFormData] = useState({
    userID: "",
    title: "",
    message: "",
  });

  // Load all notifications
  const loadNotifications = async () => {
    try {
      setLoading(true);
      setError("");
      const data = await getAllNotifications();
      setNotifications(data);
    } catch (err) {
      setError(err.message);
    } finally {
      setLoading(false);
    }
  };

  // Load user-specific notifications
  const loadUserNotifications = async (userId) => {
    try {
      setLoading(true);
      setError("");
      const data = await getUserNotifications(userId);
      setNotifications(data);
    } catch (err) {
      setError(err.message);
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    loadNotifications();
  }, []);

  // Handle filter by user
  const handleFilter = () => {
    if (filterUserId.trim()) {
      loadUserNotifications(filterUserId);
    } else {
      loadNotifications();
    }
  };

  // Handle create notification
  const handleCreateNotification = async (e) => {
    e.preventDefault();
    try {
      setLoading(true);
      await createNotification(formData);
      alert("✅ Notification created successfully!");
      setShowCreateForm(false);
      setFormData({ userID: "", title: "", message: "" });
      loadNotifications();
    } catch (err) {
      alert(`❌ Error: ${err.message}`);
    } finally {
      setLoading(false);
    }
  };

  // Handle broadcast notification
  const handleBroadcast = async (e) => {
    e.preventDefault();
    try {
      setLoading(true);
      await broadcastNotification({
        title: formData.title,
        message: formData.message,
      });
      alert("✅ Notification broadcasted to all users!");
      setShowBroadcastForm(false);
      setFormData({ userID: "", title: "", message: "" });
      loadNotifications();
    } catch (err) {
      alert(`❌ Error: ${err.message}`);
    } finally {
      setLoading(false);
    }
  };

  // Handle update notification
  const handleUpdateNotification = async (e) => {
    e.preventDefault();
    try {
      setLoading(true);
      await updateNotification(editingNotification.notificationID, {
        title: formData.title,
        message: formData.message,
      });
      alert("✅ Notification updated successfully!");
      setEditingNotification(null);
      setFormData({ userID: "", title: "", message: "" });
      loadNotifications();
    } catch (err) {
      alert(`❌ Error: ${err.message}`);
    } finally {
      setLoading(false);
    }
  };

  // Handle mark as read
  const handleMarkAsRead = async (id) => {
    try {
      await markAsRead(id);
      loadNotifications();
    } catch (err) {
      alert(`❌ Error: ${err.message}`);
    }
  };

  // Handle delete
  const handleDelete = async (id) => {
    if (window.confirm("Are you sure you want to delete this notification?")) {
      try {
        await deleteNotification(id);
        alert("✅ Notification deleted!");
        loadNotifications();
      } catch (err) {
        alert(`❌ Error: ${err.message}`);
      }
    }
  };

  // Handle edit
  const handleEdit = (notification) => {
    setEditingNotification(notification);
    setFormData({
      userID: notification.userID,
      title: notification.title,
      message: notification.message,
    });
    setShowCreateForm(true);
    setShowBroadcastForm(false);
  };

  // Reset form
  const resetForm = () => {
    setShowCreateForm(false);
    setShowBroadcastForm(false);
    setEditingNotification(null);
    setFormData({ userID: "", title: "", message: "" });
  };

  return (
    <div className="p-6 max-w-7xl mx-auto">
      <h1 className="text-3xl font-bold mb-6">Notification Management</h1>

      {error && (
        <div className="bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded mb-4">
          {error}
        </div>
      )}

      {/* Action Buttons */}
      <div className="flex flex-wrap gap-4 mb-6">
        <button
          onClick={() => {
            resetForm();
            setShowCreateForm(!showCreateForm);
          }}
          className="px-4 py-2 bg-blue-500 text-white rounded hover:bg-blue-600"
        >
          {showCreateForm && !editingNotification
            ? "Cancel"
            : "+ Create Notification"}
        </button>
        <button
          onClick={() => {
            resetForm();
            setShowBroadcastForm(!showBroadcastForm);
          }}
          className="px-4 py-2 bg-green-500 text-white rounded hover:bg-green-600"
        >
          {showBroadcastForm ? "Cancel" : "📢 Broadcast to All"}
        </button>
        <button
          onClick={loadNotifications}
          className="px-4 py-2 bg-gray-500 text-white rounded hover:bg-gray-600"
        >
          🔄 Refresh
        </button>
      </div>

      {/* Filter Section */}
      <div className="bg-white p-4 rounded-lg shadow-md mb-6">
        <div className="flex gap-4 items-end">
          <div className="flex-1">
            <label className="block text-sm font-medium mb-1">
              Filter by User ID
            </label>
            <input
              type="number"
              value={filterUserId}
              onChange={(e) => setFilterUserId(e.target.value)}
              placeholder="Enter User ID"
              className="w-full border rounded px-3 py-2"
            />
          </div>
          <button
            onClick={handleFilter}
            className="px-4 py-2 bg-purple-500 text-white rounded hover:bg-purple-600"
          >
            🔍 Filter
          </button>
          <button
            onClick={() => {
              setFilterUserId("");
              loadNotifications();
            }}
            className="px-4 py-2 bg-gray-400 text-white rounded hover:bg-gray-500"
          >
            Clear
          </button>
        </div>
      </div>

      {/* Create/Edit Form */}
      {(showCreateForm || editingNotification) && (
        <div className="bg-white p-6 rounded-lg shadow-md mb-6">
          <h2 className="text-xl font-bold mb-4">
            {editingNotification ? "Edit Notification" : "Create Notification"}
          </h2>
          <form
            onSubmit={
              editingNotification
                ? handleUpdateNotification
                : handleCreateNotification
            }
            className="space-y-4"
          >
            {!editingNotification && (
              <div>
                <label className="block text-sm font-medium mb-1">
                  User ID
                </label>
                <input
                  type="number"
                  required
                  value={formData.userID}
                  onChange={(e) =>
                    setFormData({ ...formData, userID: e.target.value })
                  }
                  className="w-full border rounded px-3 py-2"
                  placeholder="Enter User ID"
                />
              </div>
            )}
            <div>
              <label className="block text-sm font-medium mb-1">Title</label>
              <input
                type="text"
                required
                value={formData.title}
                onChange={(e) =>
                  setFormData({ ...formData, title: e.target.value })
                }
                className="w-full border rounded px-3 py-2"
                placeholder="Notification title"
              />
            </div>
            <div>
              <label className="block text-sm font-medium mb-1">Message</label>
              <textarea
                required
                value={formData.message}
                onChange={(e) =>
                  setFormData({ ...formData, message: e.target.value })
                }
                className="w-full border rounded px-3 py-2"
                rows="4"
                placeholder="Notification message"
              />
            </div>
            <div className="flex gap-4">
              <button
                type="submit"
                disabled={loading}
                className="flex-1 bg-blue-500 text-white py-2 rounded hover:bg-blue-600 disabled:bg-gray-400"
              >
                {loading
                  ? "Saving..."
                  : editingNotification
                  ? "Update"
                  : "Create"}
              </button>
              <button
                type="button"
                onClick={resetForm}
                className="px-6 bg-gray-300 text-gray-700 py-2 rounded hover:bg-gray-400"
              >
                Cancel
              </button>
            </div>
          </form>
        </div>
      )}

      {/* Broadcast Form */}
      {showBroadcastForm && (
        <div className="bg-green-50 p-6 rounded-lg shadow-md mb-6 border-2 border-green-300">
          <h2 className="text-xl font-bold mb-4 text-green-800">
            📢 Broadcast to All Users
          </h2>
          <form onSubmit={handleBroadcast} className="space-y-4">
            <div>
              <label className="block text-sm font-medium mb-1">Title</label>
              <input
                type="text"
                required
                value={formData.title}
                onChange={(e) =>
                  setFormData({ ...formData, title: e.target.value })
                }
                className="w-full border rounded px-3 py-2"
                placeholder="Broadcast title"
              />
            </div>
            <div>
              <label className="block text-sm font-medium mb-1">Message</label>
              <textarea
                required
                value={formData.message}
                onChange={(e) =>
                  setFormData({ ...formData, message: e.target.value })
                }
                className="w-full border rounded px-3 py-2"
                rows="4"
                placeholder="Broadcast message to all users"
              />
            </div>
            <button
              type="submit"
              disabled={loading}
              className="w-full bg-green-500 text-white py-2 rounded hover:bg-green-600 disabled:bg-gray-400"
            >
              {loading ? "Broadcasting..." : "📢 Send to All Users"}
            </button>
          </form>
        </div>
      )}

      {/* Notifications List */}
      <div className="bg-white rounded-lg shadow-md overflow-hidden">
        <div className="px-6 py-4 bg-gray-50 border-b">
          <h2 className="text-xl font-bold">
            All Notifications ({notifications.length})
          </h2>
        </div>
        <div className="divide-y divide-gray-200">
          {loading && notifications.length === 0 ? (
            <div className="px-6 py-8 text-center text-gray-500">
              Loading...
            </div>
          ) : notifications.length === 0 ? (
            <div className="px-6 py-8 text-center text-gray-500">
              No notifications found
            </div>
          ) : (
            notifications.map((notification) => (
              <div
                key={notification.notificationID}
                className={`px-6 py-4 hover:bg-gray-50 ${
                  notification.read ? "bg-gray-50" : "bg-white"
                }`}
              >
                <div className="flex items-start justify-between">
                  <div className="flex-1">
                    <div className="flex items-center gap-2 mb-1">
                      <h3 className="font-semibold text-lg">
                        {notification.title}
                      </h3>
                      {!notification.read && (
                        <span className="px-2 py-0.5 bg-blue-500 text-white text-xs rounded-full">
                          New
                        </span>
                      )}
                    </div>
                    <p className="text-gray-700 mb-2">{notification.message}</p>
                    <div className="flex gap-4 text-sm text-gray-500">
                      <span>User ID: {notification.userID}</span>
                      <span>
                        Created:{" "}
                        {new Date(notification.createdAt).toLocaleString()}
                      </span>
                    </div>
                  </div>
                  <div className="flex gap-2 ml-4">
                    {!notification.read && (
                      <button
                        onClick={() =>
                          handleMarkAsRead(notification.notificationID)
                        }
                        className="px-3 py-1 bg-green-500 text-white text-sm rounded hover:bg-green-600"
                      >
                        ✓ Mark Read
                      </button>
                    )}
                    <button
                      onClick={() => handleEdit(notification)}
                      className="px-3 py-1 bg-blue-500 text-white text-sm rounded hover:bg-blue-600"
                    >
                      ✏️ Edit
                    </button>
                    <button
                      onClick={() => handleDelete(notification.notificationID)}
                      className="px-3 py-1 bg-red-500 text-white text-sm rounded hover:bg-red-600"
                    >
                      🗑️ Delete
                    </button>
                  </div>
                </div>
              </div>
            ))
          )}
        </div>
      </div>
    </div>
  );
};

export default NotificationPage;
