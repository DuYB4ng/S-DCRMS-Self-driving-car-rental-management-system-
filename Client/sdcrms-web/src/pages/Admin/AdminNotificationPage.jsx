import React, { useEffect, useState } from "react";
import {
  BellIcon,
  CheckIcon,
  Trash2Icon,
  PlusIcon, // Đã xóa XIcon thừa
  RadioIcon,
  Edit2Icon,
} from "lucide-react";
import {
  getAllNotifications,
  getUserNotifications,
  createNotification,
  broadcastNotification,
  updateNotification,
  markAsRead,
  deleteNotification,
} from "../../api/notificationApi";
import { useNotifications } from "../../hooks/useNotifications";

const NotificationPage = () => {
  const [notifications, setNotifications] = useState([]);
  const [selectedFilter, setSelectedFilter] = useState("Tất cả");
  const [showCreateForm, setShowCreateForm] = useState(false);
  const [showBroadcastForm, setShowBroadcastForm] = useState(false);
  const [editingNotification, setEditingNotification] = useState(null);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState("");
  const [filterUserId, setFilterUserId] = useState("");
  const [formData, setFormData] = useState({
    userID: "",
    title: "",
    message: "",
  });

  const filters = ["Tất cả", "Chưa đọc", "Đã đọc"];

  const { notification } = useNotifications();

  // --- SỬA 1: Đảm bảo luôn set mảng (Array) ---
  const loadNotifications = async () => {
    try {
      setLoading(true);
      setError("");
      const data = await getAllNotifications();
      // Nếu data null/undefined thì gán mảng rỗng []
      setNotifications(Array.isArray(data) ? data : []);
    } catch (err) {
      console.error(err);
      setError(err.message || "Lỗi tải thông báo");
      setNotifications([]); // Gán mảng rỗng khi lỗi
    } finally {
      setLoading(false);
    }
  };

  const loadUserNotifications = async (userId) => {
    try {
      setLoading(true);
      setError("");
      const data = await getUserNotifications(userId);
      setNotifications(Array.isArray(data) ? data : []);
    } catch (err) {
      console.error(err);
      setError(err.message);
      setNotifications([]);
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    loadNotifications();
  }, []);

  useEffect(() => {
    if (notification) {
      loadNotifications();
    }
    // eslint-disable-next-line
  }, [notification]);

  const handleFilter = () => {
    if (filterUserId.trim()) {
      loadUserNotifications(filterUserId);
    } else {
      loadNotifications();
    }
  };

  const handleCreateNotification = async (e) => {
    e.preventDefault();
    try {
      setLoading(true);
      await createNotification(formData);
      alert("✅ Tạo thông báo thành công!");
      setShowCreateForm(false);
      setFormData({ userID: "", title: "", message: "" });
      loadNotifications();
    } catch (err) {
      alert(`❌ Lỗi: ${err.message}`);
    } finally {
      setLoading(false);
    }
  };

  const handleBroadcast = async (e) => {
    e.preventDefault();
    try {
      setLoading(true);
      await broadcastNotification({
        title: formData.title,
        message: formData.message,
      });
      alert("✅ Đã gửi thông báo tới tất cả người dùng!");
      setShowBroadcastForm(false);
      setFormData({ userID: "", title: "", message: "" });
      loadNotifications();
    } catch (err) {
      alert(`❌ Lỗi: ${err.message}`);
    } finally {
      setLoading(false);
    }
  };

  const handleUpdateNotification = async (e) => {
    e.preventDefault();
    if (!editingNotification) return; // Safety check
    try {
      setLoading(true);
      await updateNotification(editingNotification.notificationID, {
        title: formData.title,
        message: formData.message,
      });
      alert("✅ Cập nhật thông báo thành công!");
      setEditingNotification(null);
      setFormData({ userID: "", title: "", message: "" });
      setShowCreateForm(false);
      loadNotifications();
    } catch (err) {
      alert(`❌ Lỗi: ${err.message}`);
    } finally {
      setLoading(false);
    }
  };

  const handleMarkAsRead = async (id) => {
    try {
      await markAsRead(id);
      loadNotifications();
    } catch (err) {
      alert(`❌ Lỗi: ${err.message}`);
    }
  };

  const markAllAsRead = async () => {
    // Safety check: notifications phải là mảng
    const safeNotifications = Array.isArray(notifications) ? notifications : [];
    try {
      for (const notif of safeNotifications.filter((n) => !n.read)) {
        if (notif?.notificationID) {
          // Kiểm tra ID tồn tại
          await markAsRead(notif.notificationID);
        }
      }
      loadNotifications();
    } catch (err) {
      alert(`❌ Lỗi: ${err.message}`);
    }
  };

  const handleDelete = async (id) => {
    if (window.confirm("Bạn có chắc muốn xóa thông báo này?")) {
      try {
        await deleteNotification(id);
        loadNotifications();
      } catch (err) {
        alert(`❌ Lỗi: ${err.message}`);
      }
    }
  };

  const deleteAll = async () => {
    const safeNotifications = Array.isArray(notifications) ? notifications : [];
    if (window.confirm("Bạn có chắc muốn xóa tất cả thông báo?")) {
      try {
        for (const notif of safeNotifications) {
          if (notif?.notificationID) {
            await deleteNotification(notif.notificationID);
          }
        }
        loadNotifications();
      } catch (err) {
        alert(`❌ Lỗi: ${err.message}`);
      }
    }
  };

  const handleEdit = (notification) => {
    setEditingNotification(notification);
    setFormData({
      userID: notification.userID || "", // Fallback nếu null
      title: notification.title || "",
      message: notification.message || "",
    });
    setShowCreateForm(true);
    setShowBroadcastForm(false);
  };

  const resetForm = () => {
    setShowCreateForm(false);
    setShowBroadcastForm(false);
    setEditingNotification(null);
    setFormData({ userID: "", title: "", message: "" });
  };

  const getTimeAgo = (timestamp) => {
    if (!timestamp) return "";
    const date = new Date(timestamp);
    // Kiểm tra ngày hợp lệ
    if (isNaN(date.getTime())) return "Ngày không hợp lệ";

    const seconds = Math.floor((Date.now() - date.getTime()) / 1000);
    if (seconds < 60) return "Vừa xong";
    const minutes = Math.floor(seconds / 60);
    if (minutes < 60) return `${minutes} phút trước`;
    const hours = Math.floor(minutes / 60);
    if (hours < 24) return `${hours} giờ trước`;
    const days = Math.floor(hours / 24);
    return `${days} ngày trước`;
  };

  // --- SỬA 2: Lọc an toàn ---
  const safeNotifications = Array.isArray(notifications) ? notifications : [];

  const filteredNotifications = safeNotifications.filter((notif) => {
    if (!notif) return false;
    if (selectedFilter === "Tất cả") return true;
    if (selectedFilter === "Chưa đọc") return !notif.read;
    if (selectedFilter === "Đã đọc") return notif.read;
    return true;
  });

  const unreadCount = safeNotifications.filter((n) => !n?.read).length;

  return (
    <div className="p-6 bg-secondary min-h-screen">
      {/* Header */}
      <div className="flex flex-col md:flex-row md:items-center md:justify-between mb-6">
        <div className="flex items-center gap-3 mb-4 md:mb-0">
          <h1 className="text-3xl font-bold text-textPrimary">Thông báo</h1>
          {unreadCount > 0 && (
            <span className="bg-red-500 text-white text-sm font-bold px-3 py-1 rounded-full">
              {unreadCount}
            </span>
          )}
        </div>

        {/* ... (Phần nút bấm giữ nguyên) ... */}
        <div className="flex flex-wrap gap-3">
          <button
            onClick={() => {
              resetForm();
              setShowCreateForm(!showCreateForm);
            }}
            className="bg-purple-600 text-white px-4 py-2 rounded-lg hover:opacity-90 transition flex items-center gap-2 text-sm font-medium shadow-md"
          >
            <PlusIcon className="w-4 h-4" />
            Tạo mới
          </button>
          <button
            onClick={() => {
              resetForm();
              setShowBroadcastForm(!showBroadcastForm);
            }}
            className="bg-green-600 text-white px-4 py-2 rounded-lg hover:opacity-90 transition flex items-center gap-2 text-sm font-medium shadow-md"
          >
            <RadioIcon className="w-4 h-4" />
            Gửi tất cả
          </button>
          <button
            onClick={markAllAsRead}
            className="bg-[#2E7D9A] text-white px-4 py-2 rounded-lg hover:opacity-90 transition flex items-center gap-2 text-sm font-medium"
          >
            <CheckIcon className="w-4 h-4" />
            Đánh dấu đã đọc
          </button>
          <button
            onClick={deleteAll}
            className="bg-red-600 text-white px-4 py-2 rounded-lg hover:opacity-90 transition flex items-center gap-2 text-sm font-medium"
          >
            <Trash2Icon className="w-4 h-4" />
            Xóa tất cả
          </button>
        </div>
      </div>

      {/* Error Alert */}
      {error && (
        <div className="bg-red-50 border-l-4 border-red-500 text-red-600 px-4 py-3 rounded-lg mb-6 shadow-md">
          <p className="font-medium">Lỗi: {error}</p>
        </div>
      )}

      {/* Forms (Giữ nguyên phần Form, chỉ render lại phần Input cho gọn nếu cần) */}
      {(showCreateForm || editingNotification) && (
        <div className="bg-white rounded-xl shadow-md p-6 mb-6">
          <h2 className="text-xl font-bold text-textPrimary mb-4">
            {editingNotification ? "Chỉnh sửa thông báo" : "Tạo thông báo mới"}
          </h2>
          <form
            onSubmit={
              editingNotification
                ? handleUpdateNotification
                : handleCreateNotification
            }
            className="space-y-4"
          >
            {/* Form Inputs code của bạn ở đây giữ nguyên */}
            {!editingNotification && (
              <div>
                <label className="block text-sm font-medium text-textPrimary mb-2">
                  User ID
                </label>
                <input
                  type="number"
                  required
                  value={formData.userID}
                  onChange={(e) =>
                    setFormData({ ...formData, userID: e.target.value })
                  }
                  className="w-full border border-gray-300 rounded-lg px-4 py-2 focus:outline-none focus:ring-2 focus:ring-primary"
                  placeholder="Nhập User ID"
                />
              </div>
            )}
            <div>
              <label className="block text-sm font-medium text-textPrimary mb-2">
                Tiêu đề
              </label>
              <input
                type="text"
                required
                value={formData.title}
                onChange={(e) =>
                  setFormData({ ...formData, title: e.target.value })
                }
                className="w-full border border-gray-300 rounded-lg px-4 py-2 focus:outline-none focus:ring-2 focus:ring-primary"
                placeholder="Tiêu đề thông báo"
              />
            </div>
            <div>
              <label className="block text-sm font-medium text-textPrimary mb-2">
                Nội dung
              </label>
              <textarea
                required
                value={formData.message}
                onChange={(e) =>
                  setFormData({ ...formData, message: e.target.value })
                }
                className="w-full border border-gray-300 rounded-lg px-4 py-2 focus:outline-none focus:ring-2 focus:ring-primary"
                rows="4"
                placeholder="Nội dung thông báo"
              />
            </div>
            <div className="flex gap-3">
              <button
                type="submit"
                disabled={loading}
                className="flex-1 bg-[#2E7D9A] text-white py-2 rounded-lg hover:opacity-90 transition disabled:bg-gray-400 font-medium"
              >
                {loading
                  ? "Đang xử lý..."
                  : editingNotification
                  ? "Cập nhật"
                  : "Tạo"}
              </button>
              <button
                type="button"
                onClick={resetForm}
                className="px-6 bg-gray-300 text-textPrimary py-2 rounded-lg hover:bg-gray-400 transition font-medium"
              >
                Hủy
              </button>
            </div>
          </form>
        </div>
      )}

      {showBroadcastForm && (
        <div className="bg-green-50 border-2 border-success rounded-xl shadow-md p-6 mb-6">
          {/* Broadcast form code giữ nguyên */}
          <h2 className="text-xl font-bold text-green-600 mb-4 flex items-center gap-2">
            <RadioIcon className="w-6 h-6" />
            Gửi thông báo tới tất cả
          </h2>
          <form onSubmit={handleBroadcast} className="space-y-4">
            <div>
              <label className="block text-sm font-medium text-textPrimary mb-2">
                Tiêu đề
              </label>
              <input
                type="text"
                required
                value={formData.title}
                onChange={(e) =>
                  setFormData({ ...formData, title: e.target.value })
                }
                className="w-full border border-gray-300 rounded-lg px-4 py-2 focus:outline-none focus:ring-2 focus:ring-success"
                placeholder="Tiêu đề thông báo"
              />
            </div>
            <div>
              <label className="block text-sm font-medium text-textPrimary mb-2">
                Nội dung
              </label>
              <textarea
                required
                value={formData.message}
                onChange={(e) =>
                  setFormData({ ...formData, message: e.target.value })
                }
                className="w-full border border-gray-300 rounded-lg px-4 py-2 focus:outline-none focus:ring-2 focus:ring-success"
                rows="4"
                placeholder="Nội dung gửi tới tất cả người dùng"
              />
            </div>
            <button
              type="submit"
              disabled={loading}
              className="w-full bg-green-600 text-white py-2 rounded-lg hover:opacity-90 transition disabled:bg-gray-400 font-medium"
            >
              {loading ? "Đang gửi..." : "📢 Gửi tới tất cả"}
            </button>
          </form>
        </div>
      )}

      {/* Filter by User ID */}
      <div className="bg-white rounded-lg p-4 mb-6 shadow-md">
        {/* Filter inputs giữ nguyên */}
        <div className="flex flex-col md:flex-row gap-4">
          <div className="flex-1">
            <label className="block text-sm font-medium text-textPrimary mb-2">
              Lọc theo User ID
            </label>
            <input
              type="number"
              value={filterUserId}
              onChange={(e) => setFilterUserId(e.target.value)}
              placeholder="Nhập User ID"
              className="w-full border border-gray-300 rounded-lg px-4 py-2 focus:outline-none focus:ring-2 focus:ring-primary"
            />
          </div>
          <div className="flex gap-2 items-end">
            <button
              onClick={handleFilter}
              className="px-6 py-2 bg-purple-500 text-white rounded-lg hover:bg-purple-600 transition font-medium"
            >
              Lọc
            </button>
            <button
              onClick={() => {
                setFilterUserId("");
                loadNotifications();
              }}
              className="px-6 py-2 bg-gray-400 text-white rounded-lg hover:bg-gray-500 transition font-medium"
            >
              Xóa lọc
            </button>
          </div>
        </div>
      </div>

      <div className="bg-white rounded-lg p-4 mb-6 shadow-md">
        <div className="flex flex-wrap gap-2">
          {filters.map((filter) => (
            <button
              key={filter}
              onClick={() => setSelectedFilter(filter)}
              className={`px-4 py-2 rounded-lg font-medium transition ${
                selectedFilter === filter
                  ? "bg-primary text-white"
                  : "bg-gray-100 text-textPrimary hover:bg-gray-200"
              }`}
            >
              {filter}
            </button>
          ))}
        </div>
      </div>

      {/* Notifications List - SỬA 3: Render an toàn hơn với ?. */}
      <div className="space-y-3">
        {loading && notifications.length === 0 ? (
          <div className="text-center py-12 bg-white rounded-xl">
            <div className="animate-spin w-12 h-12 border-4 border-primary border-t-transparent rounded-full mx-auto mb-4"></div>
            <p className="text-textSecondary">Đang tải...</p>
          </div>
        ) : filteredNotifications.length === 0 ? (
          <div className="text-center py-12 bg-white rounded-xl">
            <BellIcon className="w-16 h-16 text-gray-300 mx-auto mb-4" />
            <p className="text-textSecondary text-lg font-medium">
              Không có thông báo nào
            </p>
          </div>
        ) : (
          filteredNotifications.map((notif, idx) => (
            <div
              key={notif?.notificationID || idx} // Fallback key nếu không có ID
              className={`bg-white rounded-xl shadow-md hover:shadow-lg transition overflow-hidden ${
                !notif?.read ? "border-l-4 border-primary" : ""
              }`}
            >
              <div className="p-5">
                <div className="flex items-start gap-4">
                  <div
                    className={`w-12 h-12 rounded-lg ${
                      !notif?.read ? "bg-primary" : "bg-gray-300"
                    } flex items-center justify-center text-2xl flex-shrink-0`}
                  >
                    🔔
                  </div>

                  <div className="flex-1 min-w-0">
                    <div className="flex items-start justify-between gap-3 mb-2">
                      <div className="flex-1">
                        <div className="flex items-center gap-2 mb-1">
                          <h3
                            className={`font-bold text-textPrimary ${
                              !notif?.read ? "text-primary" : ""
                            }`}
                          >
                            {notif?.title || "(Không có tiêu đề)"}
                          </h3>
                          {!notif?.read && (
                            <span className="w-2 h-2 bg-primary rounded-full"></span>
                          )}
                        </div>
                        <span className="bg-purple-50 text-purple-600 text-xs px-2 py-1 rounded-full font-medium inline-block">
                          User ID: {notif?.userID ?? "-"}
                        </span>
                      </div>
                    </div>

                    <p className="text-textSecondary text-sm mb-3">
                      {notif?.message || ""}
                    </p>

                    <div className="flex items-center justify-between">
                      <p className="text-xs text-textSecondary">
                        {getTimeAgo(notif?.createdAt)}
                      </p>
                      <div className="flex gap-2">
                        {!notif?.read && notif?.notificationID && (
                          <button
                            onClick={() =>
                              handleMarkAsRead(notif.notificationID)
                            }
                            className="p-2 text-green-600 hover:bg-green-50 rounded-lg transition"
                            title="Đánh dấu đã đọc"
                          >
                            <CheckIcon className="w-4 h-4" />
                          </button>
                        )}
                        {notif?.notificationID && (
                          <button
                            onClick={() => handleEdit(notif)}
                            className="p-2 text-purple-600 hover:bg-purple-50 rounded-lg transition"
                            title="Chỉnh sửa"
                          >
                            <Edit2Icon className="w-4 h-4" />
                          </button>
                        )}
                        {notif?.notificationID && (
                          <button
                            onClick={() => handleDelete(notif.notificationID)}
                            className="p-2 text-red-600 hover:bg-red-50 rounded-lg transition"
                            title="Xóa"
                          >
                            <Trash2Icon className="w-4 h-4" />
                          </button>
                        )}
                      </div>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          ))
        )}
      </div>
    </div>
  );
};

export default NotificationPage;
