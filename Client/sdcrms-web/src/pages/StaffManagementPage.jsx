import React, { useState } from "react";
import {
  Users,
  PlusIcon,
  SearchIcon,
  FilterIcon,
  EditIcon,
  TrashIcon,
  EyeIcon,
  XIcon,
  PhoneIcon,
  MailIcon,
  BriefcaseIcon,
  CalendarIcon,
  MapPinIcon,
  UserCheck,
  UserX,
  Clock,
} from "lucide-react";

const StaffManagementPage = () => {
  // Mock data for staff
  const [staffList, setStaffList] = useState([
    {
      staffID: "STF001",
      firstName: "Nguyễn",
      lastName: "Văn A",
      email: "vana@sdcrms.com",
      phoneNumber: "+84912345678",
      position: "Customer Support",
      department: "Customer Service",
      status: "Active",
      joinDate: "2024-01-15",
      salary: "12,000,000đ",
      shift: "Morning",
      performance: 95,
      tasksCompleted: 245,
      avatar:
        "https://ui-avatars.com/api/?name=Nguyen+Van+A&background=2E7D9A&color=fff",
    },
    {
      staffID: "STF002",
      firstName: "Trần",
      lastName: "Thị B",
      email: "thib@sdcrms.com",
      phoneNumber: "+84987654321",
      position: "Technical Support",
      department: "IT",
      status: "Active",
      joinDate: "2024-02-20",
      salary: "15,000,000đ",
      shift: "Afternoon",
      performance: 92,
      tasksCompleted: 198,
      avatar:
        "https://ui-avatars.com/api/?name=Tran+Thi+B&background=3498DB&color=fff",
    },
    {
      staffID: "STF003",
      firstName: "Lê",
      lastName: "Văn C",
      email: "vanc@sdcrms.com",
      phoneNumber: "+84901234567",
      position: "Fleet Manager",
      department: "Operations",
      status: "Active",
      joinDate: "2023-11-10",
      salary: "18,000,000đ",
      shift: "Full Day",
      performance: 98,
      tasksCompleted: 312,
      avatar:
        "https://ui-avatars.com/api/?name=Le+Van+C&background=10B981&color=fff",
    },
    {
      staffID: "STF004",
      firstName: "Phạm",
      lastName: "Thị D",
      email: "thid@sdcrms.com",
      phoneNumber: "+84909876543",
      position: "Marketing Staff",
      department: "Marketing",
      status: "On Leave",
      joinDate: "2024-03-05",
      salary: "13,000,000đ",
      shift: "Morning",
      performance: 88,
      tasksCompleted: 156,
      avatar:
        "https://ui-avatars.com/api/?name=Pham+Thi+D&background=F59E0B&color=fff",
    },
    {
      staffID: "STF005",
      firstName: "Hoàng",
      lastName: "Văn E",
      email: "vane@sdcrms.com",
      phoneNumber: "+84912345098",
      position: "Accountant",
      department: "Finance",
      status: "Active",
      joinDate: "2023-09-18",
      salary: "16,000,000đ",
      shift: "Morning",
      performance: 96,
      tasksCompleted: 289,
      avatar:
        "https://ui-avatars.com/api/?name=Hoang+Van+E&background=8B5CF6&color=fff",
    },
  ]);

  const [showAddModal, setShowAddModal] = useState(false);
  const [showEditModal, setShowEditModal] = useState(false);
  const [showDetailModal, setShowDetailModal] = useState(false);
  const [selectedStaff, setSelectedStaff] = useState(null);
  const [searchTerm, setSearchTerm] = useState("");
  const [filterStatus, setFilterStatus] = useState("All");

  const [newStaff, setNewStaff] = useState({
    firstName: "",
    lastName: "",
    email: "",
    phoneNumber: "",
    position: "",
    department: "",
    salary: "",
    shift: "Morning",
    joinDate: "",
  });

  // Statistics
  const totalStaff = staffList.length;
  const activeStaff = staffList.filter((s) => s.status === "Active").length;
  const onLeaveStaff = staffList.filter((s) => s.status === "On Leave").length;
  const avgPerformance = (
    staffList.reduce((sum, s) => sum + s.performance, 0) / totalStaff
  ).toFixed(1);

  // Handle Add Staff
  const handleAddStaff = (e) => {
    e.preventDefault();
    const newStaffData = {
      staffID: `STF${String(staffList.length + 1).padStart(3, "0")}`,
      ...newStaff,
      status: "Active",
      performance: 0,
      tasksCompleted: 0,
      avatar: `https://ui-avatars.com/api/?name=${newStaff.firstName}+${newStaff.lastName}&background=2E7D9A&color=fff`,
    };
    setStaffList([...staffList, newStaffData]);
    setShowAddModal(false);
    setNewStaff({
      firstName: "",
      lastName: "",
      email: "",
      phoneNumber: "",
      position: "",
      department: "",
      salary: "",
      shift: "Morning",
      joinDate: "",
    });
  };

  // Handle Edit Staff
  const handleEditStaff = (staff) => {
    setSelectedStaff(staff);
    setNewStaff({
      firstName: staff.firstName,
      lastName: staff.lastName,
      email: staff.email,
      phoneNumber: staff.phoneNumber,
      position: staff.position,
      department: staff.department,
      salary: staff.salary,
      shift: staff.shift,
      joinDate: staff.joinDate,
    });
    setShowEditModal(true);
  };

  const handleUpdateStaff = (e) => {
    e.preventDefault();
    setStaffList(
      staffList.map((staff) =>
        staff.staffID === selectedStaff.staffID
          ? { ...staff, ...newStaff }
          : staff
      )
    );
    setShowEditModal(false);
    setSelectedStaff(null);
    setNewStaff({
      firstName: "",
      lastName: "",
      email: "",
      phoneNumber: "",
      position: "",
      department: "",
      salary: "",
      shift: "Morning",
      joinDate: "",
    });
  };

  // Handle View Detail
  const handleViewDetail = (staff) => {
    setSelectedStaff(staff);
    setShowDetailModal(true);
  };

  // Handle Delete Staff
  const handleDeleteStaff = (staffID) => {
    if (window.confirm("Bạn có chắc muốn xóa nhân viên này?")) {
      setStaffList(staffList.filter((staff) => staff.staffID !== staffID));
    }
  };

  // Filter staff
  const filteredStaff = staffList.filter((staff) => {
    const matchSearch =
      staff.firstName.toLowerCase().includes(searchTerm.toLowerCase()) ||
      staff.lastName.toLowerCase().includes(searchTerm.toLowerCase()) ||
      staff.email.toLowerCase().includes(searchTerm.toLowerCase()) ||
      staff.position.toLowerCase().includes(searchTerm.toLowerCase());

    const matchStatus = filterStatus === "All" || staff.status === filterStatus;

    return matchSearch && matchStatus;
  });

  return (
    <div className="p-6 bg-[#F5F9FA] min-h-screen">
      {/* Header */}
      <div className="mb-6">
        <h1 className="text-3xl font-bold text-[#2C3E50] mb-2">
          Quản lý nhân viên
        </h1>
        <p className="text-[#7F8C8D]">
          Quản lý toàn bộ nhân viên và hiệu suất làm việc
        </p>
      </div>

      {/* Statistics Cards */}
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-4 mb-6">
        <div className="bg-gradient-to-br from-blue-50 to-blue-100 rounded-xl p-5 shadow-md border border-blue-200">
          <div className="flex items-center justify-between">
            <div>
              <p className="text-blue-600 text-sm font-medium mb-1">
                Tổng nhân viên
              </p>
              <p className="text-[#2C3E50] text-3xl font-bold">{totalStaff}</p>
            </div>
            <div className="bg-blue-500 p-3 rounded-xl">
              <Users className="w-8 h-8 text-white" />
            </div>
          </div>
        </div>

        <div className="bg-gradient-to-br from-green-50 to-green-100 rounded-xl p-5 shadow-md border border-green-200">
          <div className="flex items-center justify-between">
            <div>
              <p className="text-green-600 text-sm font-medium mb-1">
                Đang làm việc
              </p>
              <p className="text-[#2C3E50] text-3xl font-bold">{activeStaff}</p>
            </div>
            <div className="bg-green-500 p-3 rounded-xl">
              <UserCheck className="w-8 h-8 text-white" />
            </div>
          </div>
        </div>

        <div className="bg-gradient-to-br from-yellow-50 to-yellow-100 rounded-xl p-5 shadow-md border border-yellow-200">
          <div className="flex items-center justify-between">
            <div>
              <p className="text-yellow-600 text-sm font-medium mb-1">
                Nghỉ phép
              </p>
              <p className="text-[#2C3E50] text-3xl font-bold">
                {onLeaveStaff}
              </p>
            </div>
            <div className="bg-yellow-500 p-3 rounded-xl">
              <UserX className="w-8 h-8 text-white" />
            </div>
          </div>
        </div>

        <div className="bg-gradient-to-br from-purple-50 to-purple-100 rounded-xl p-5 shadow-md border border-purple-200">
          <div className="flex items-center justify-between">
            <div>
              <p className="text-purple-600 text-sm font-medium mb-1">
                Hiệu suất TB
              </p>
              <p className="text-[#2C3E50] text-3xl font-bold">
                {avgPerformance}%
              </p>
            </div>
            <div className="bg-purple-500 p-3 rounded-xl">
              <BriefcaseIcon className="w-8 h-8 text-white" />
            </div>
          </div>
        </div>
      </div>

      {/* Action Bar */}
      <div className="bg-white rounded-xl p-4 mb-6 shadow-md">
        <div className="flex flex-col lg:flex-row gap-4 items-center justify-between">
          <div className="flex gap-3 w-full lg:w-auto">
            <div className="relative flex-1 lg:w-80">
              <SearchIcon className="absolute left-3 top-1/2 -translate-y-1/2 w-5 h-5 text-[#7F8C8D]" />
              <input
                type="text"
                placeholder="Tìm kiếm nhân viên..."
                value={searchTerm}
                onChange={(e) => setSearchTerm(e.target.value)}
                className="w-full pl-10 pr-4 py-2.5 border border-gray-200 rounded-lg focus:outline-none focus:ring-2 focus:ring-[#2E7D9A] focus:border-transparent"
              />
            </div>

            <select
              value={filterStatus}
              onChange={(e) => setFilterStatus(e.target.value)}
              className="px-4 py-2.5 border border-gray-200 rounded-lg focus:outline-none focus:ring-2 focus:ring-[#2E7D9A] bg-white"
            >
              <option value="All">Tất cả</option>
              <option value="Active">Đang làm việc</option>
              <option value="On Leave">Nghỉ phép</option>
            </select>
          </div>

          <button
            onClick={() => setShowAddModal(true)}
            className="bg-[#2E7D9A] text-white px-5 py-2.5 rounded-lg hover:bg-[#236a80] transition-all flex items-center gap-2 w-full lg:w-auto justify-center shadow-md hover:shadow-lg"
          >
            <PlusIcon className="w-5 h-5" />
            Thêm nhân viên
          </button>
        </div>
      </div>

      {/* Staff Table */}
      <div className="bg-white rounded-xl shadow-md overflow-hidden">
        <div className="overflow-x-auto">
          <table className="w-full">
            <thead className="bg-gradient-to-r from-[#2E7D9A] to-[#3498DB] text-white">
              <tr>
                <th className="px-6 py-4 text-left text-sm font-semibold">
                  Nhân viên
                </th>
                <th className="px-6 py-4 text-left text-sm font-semibold">
                  Vị trí
                </th>
                <th className="px-6 py-4 text-left text-sm font-semibold">
                  Phòng ban
                </th>
                <th className="px-6 py-4 text-left text-sm font-semibold">
                  Ca làm
                </th>
                <th className="px-6 py-4 text-left text-sm font-semibold">
                  Hiệu suất
                </th>
                <th className="px-6 py-4 text-left text-sm font-semibold">
                  Trạng thái
                </th>
                <th className="px-6 py-4 text-center text-sm font-semibold">
                  Hành động
                </th>
              </tr>
            </thead>
            <tbody className="divide-y divide-gray-100">
              {filteredStaff.map((staff, index) => (
                <tr
                  key={staff.staffID}
                  className="hover:bg-blue-50 transition-colors"
                >
                  <td className="px-6 py-4">
                    <div className="flex items-center gap-3">
                      <img
                        src={staff.avatar}
                        alt={`${staff.firstName} ${staff.lastName}`}
                        className="w-10 h-10 rounded-full border-2 border-[#2E7D9A]"
                      />
                      <div>
                        <p className="text-[#2C3E50] font-semibold">
                          {staff.firstName} {staff.lastName}
                        </p>
                        <p className="text-[#7F8C8D] text-xs">
                          {staff.staffID}
                        </p>
                      </div>
                    </div>
                  </td>
                  <td className="px-6 py-4">
                    <p className="text-[#2C3E50] font-medium">
                      {staff.position}
                    </p>
                  </td>
                  <td className="px-6 py-4">
                    <p className="text-[#2C3E50]">{staff.department}</p>
                  </td>
                  <td className="px-6 py-4">
                    <div className="flex items-center gap-2">
                      <Clock className="w-4 h-4 text-[#7F8C8D]" />
                      <span className="text-[#2C3E50] text-sm">
                        {staff.shift}
                      </span>
                    </div>
                  </td>
                  <td className="px-6 py-4">
                    <div className="flex items-center gap-2">
                      <div className="flex-1 bg-gray-200 rounded-full h-2 w-24">
                        <div
                          className={`h-2 rounded-full ${
                            staff.performance >= 95
                              ? "bg-green-500"
                              : staff.performance >= 85
                              ? "bg-blue-500"
                              : "bg-yellow-500"
                          }`}
                          style={{ width: `${staff.performance}%` }}
                        />
                      </div>
                      <span className="text-[#2C3E50] text-sm font-semibold">
                        {staff.performance}%
                      </span>
                    </div>
                  </td>
                  <td className="px-6 py-4">
                    <span
                      className={`px-3 py-1 rounded-full text-xs font-semibold ${
                        staff.status === "Active"
                          ? "bg-green-100 text-green-700"
                          : "bg-yellow-100 text-yellow-700"
                      }`}
                    >
                      {staff.status === "Active" ? "Đang làm" : "Nghỉ phép"}
                    </span>
                  </td>
                  <td className="px-6 py-4">
                    <div className="flex items-center justify-center gap-2">
                      <button
                        onClick={() => handleViewDetail(staff)}
                        className="p-2 text-blue-600 hover:bg-blue-100 rounded-lg transition-all"
                        title="Xem chi tiết"
                      >
                        <EyeIcon className="w-5 h-5" />
                      </button>
                      <button
                        onClick={() => handleEditStaff(staff)}
                        className="p-2 text-green-600 hover:bg-green-100 rounded-lg transition-all"
                        title="Chỉnh sửa"
                      >
                        <EditIcon className="w-5 h-5" />
                      </button>
                      <button
                        onClick={() => handleDeleteStaff(staff.staffID)}
                        className="p-2 text-red-600 hover:bg-red-100 rounded-lg transition-all"
                        title="Xóa"
                      >
                        <TrashIcon className="w-5 h-5" />
                      </button>
                    </div>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      </div>

      {/* Add Staff Modal */}
      {showAddModal && (
        <div className="fixed inset-0 bg-black/50 flex items-center justify-center z-50 p-4">
          <div className="bg-white rounded-2xl max-w-2xl w-full max-h-[90vh] overflow-y-auto">
            <div className="sticky top-0 bg-gradient-to-r from-[#2E7D9A] to-[#3498DB] text-white p-6 flex items-center justify-between rounded-t-2xl">
              <h2 className="text-2xl font-bold">Thêm nhân viên mới</h2>
              <button
                onClick={() => setShowAddModal(false)}
                className="p-2 hover:bg-white/20 rounded-lg transition-all"
              >
                <XIcon className="w-6 h-6" />
              </button>
            </div>

            <form onSubmit={handleAddStaff} className="p-6 space-y-4">
              <div className="grid grid-cols-2 gap-4">
                <div>
                  <label className="block text-[#2C3E50] font-semibold mb-2">
                    Họ <span className="text-red-500">*</span>
                  </label>
                  <input
                    type="text"
                    required
                    value={newStaff.firstName}
                    onChange={(e) =>
                      setNewStaff({ ...newStaff, firstName: e.target.value })
                    }
                    className="w-full px-4 py-2.5 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-[#2E7D9A]"
                  />
                </div>

                <div>
                  <label className="block text-[#2C3E50] font-semibold mb-2">
                    Tên <span className="text-red-500">*</span>
                  </label>
                  <input
                    type="text"
                    required
                    value={newStaff.lastName}
                    onChange={(e) =>
                      setNewStaff({ ...newStaff, lastName: e.target.value })
                    }
                    className="w-full px-4 py-2.5 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-[#2E7D9A]"
                  />
                </div>
              </div>

              <div>
                <label className="block text-[#2C3E50] font-semibold mb-2">
                  Email <span className="text-red-500">*</span>
                </label>
                <input
                  type="email"
                  required
                  value={newStaff.email}
                  onChange={(e) =>
                    setNewStaff({ ...newStaff, email: e.target.value })
                  }
                  className="w-full px-4 py-2.5 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-[#2E7D9A]"
                />
              </div>

              <div>
                <label className="block text-[#2C3E50] font-semibold mb-2">
                  Số điện thoại <span className="text-red-500">*</span>
                </label>
                <input
                  type="tel"
                  required
                  value={newStaff.phoneNumber}
                  onChange={(e) =>
                    setNewStaff({ ...newStaff, phoneNumber: e.target.value })
                  }
                  className="w-full px-4 py-2.5 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-[#2E7D9A]"
                />
              </div>

              <div className="grid grid-cols-2 gap-4">
                <div>
                  <label className="block text-[#2C3E50] font-semibold mb-2">
                    Vị trí <span className="text-red-500">*</span>
                  </label>
                  <input
                    type="text"
                    required
                    value={newStaff.position}
                    onChange={(e) =>
                      setNewStaff({ ...newStaff, position: e.target.value })
                    }
                    className="w-full px-4 py-2.5 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-[#2E7D9A]"
                  />
                </div>

                <div>
                  <label className="block text-[#2C3E50] font-semibold mb-2">
                    Phòng ban <span className="text-red-500">*</span>
                  </label>
                  <select
                    required
                    value={newStaff.department}
                    onChange={(e) =>
                      setNewStaff({ ...newStaff, department: e.target.value })
                    }
                    className="w-full px-4 py-2.5 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-[#2E7D9A]"
                  >
                    <option value="">Chọn phòng ban</option>
                    <option value="Customer Service">Customer Service</option>
                    <option value="IT">IT</option>
                    <option value="Operations">Operations</option>
                    <option value="Marketing">Marketing</option>
                    <option value="Finance">Finance</option>
                    <option value="HR">HR</option>
                  </select>
                </div>
              </div>

              <div className="grid grid-cols-2 gap-4">
                <div>
                  <label className="block text-[#2C3E50] font-semibold mb-2">
                    Lương <span className="text-red-500">*</span>
                  </label>
                  <input
                    type="text"
                    required
                    placeholder="12,000,000đ"
                    value={newStaff.salary}
                    onChange={(e) =>
                      setNewStaff({ ...newStaff, salary: e.target.value })
                    }
                    className="w-full px-4 py-2.5 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-[#2E7D9A]"
                  />
                </div>

                <div>
                  <label className="block text-[#2C3E50] font-semibold mb-2">
                    Ca làm việc <span className="text-red-500">*</span>
                  </label>
                  <select
                    required
                    value={newStaff.shift}
                    onChange={(e) =>
                      setNewStaff({ ...newStaff, shift: e.target.value })
                    }
                    className="w-full px-4 py-2.5 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-[#2E7D9A]"
                  >
                    <option value="Morning">Sáng</option>
                    <option value="Afternoon">Chiều</option>
                    <option value="Night">Tối</option>
                    <option value="Full Day">Cả ngày</option>
                  </select>
                </div>
              </div>

              <div>
                <label className="block text-[#2C3E50] font-semibold mb-2">
                  Ngày vào làm <span className="text-red-500">*</span>
                </label>
                <input
                  type="date"
                  required
                  value={newStaff.joinDate}
                  onChange={(e) =>
                    setNewStaff({ ...newStaff, joinDate: e.target.value })
                  }
                  className="w-full px-4 py-2.5 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-[#2E7D9A]"
                />
              </div>

              <div className="flex gap-3 pt-4">
                <button
                  type="submit"
                  className="flex-1 bg-[#2E7D9A] text-white py-3 rounded-lg font-semibold hover:bg-[#236a80] transition-all"
                >
                  Thêm nhân viên
                </button>
                <button
                  type="button"
                  onClick={() => setShowAddModal(false)}
                  className="flex-1 bg-gray-200 text-[#2C3E50] py-3 rounded-lg font-semibold hover:bg-gray-300 transition-all"
                >
                  Hủy
                </button>
              </div>
            </form>
          </div>
        </div>
      )}

      {/* Edit Staff Modal - Similar structure to Add Modal */}
      {showEditModal && selectedStaff && (
        <div className="fixed inset-0 bg-black/50 flex items-center justify-center z-50 p-4">
          <div className="bg-white rounded-2xl max-w-2xl w-full max-h-[90vh] overflow-y-auto">
            <div className="sticky top-0 bg-gradient-to-r from-green-600 to-green-700 text-white p-6 flex items-center justify-between rounded-t-2xl">
              <h2 className="text-2xl font-bold">Chỉnh sửa nhân viên</h2>
              <button
                onClick={() => setShowEditModal(false)}
                className="p-2 hover:bg-white/20 rounded-lg transition-all"
              >
                <XIcon className="w-6 h-6" />
              </button>
            </div>

            <form onSubmit={handleUpdateStaff} className="p-6 space-y-4">
              {/* Same form fields as Add Modal */}
              <div className="grid grid-cols-2 gap-4">
                <div>
                  <label className="block text-[#2C3E50] font-semibold mb-2">
                    Họ
                  </label>
                  <input
                    type="text"
                    required
                    value={newStaff.firstName}
                    onChange={(e) =>
                      setNewStaff({ ...newStaff, firstName: e.target.value })
                    }
                    className="w-full px-4 py-2.5 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-green-600"
                  />
                </div>

                <div>
                  <label className="block text-[#2C3E50] font-semibold mb-2">
                    Tên
                  </label>
                  <input
                    type="text"
                    required
                    value={newStaff.lastName}
                    onChange={(e) =>
                      setNewStaff({ ...newStaff, lastName: e.target.value })
                    }
                    className="w-full px-4 py-2.5 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-green-600"
                  />
                </div>
              </div>

              <div>
                <label className="block text-[#2C3E50] font-semibold mb-2">
                  Email
                </label>
                <input
                  type="email"
                  required
                  value={newStaff.email}
                  onChange={(e) =>
                    setNewStaff({ ...newStaff, email: e.target.value })
                  }
                  className="w-full px-4 py-2.5 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-green-600"
                />
              </div>

              <div>
                <label className="block text-[#2C3E50] font-semibold mb-2">
                  Số điện thoại
                </label>
                <input
                  type="tel"
                  required
                  value={newStaff.phoneNumber}
                  onChange={(e) =>
                    setNewStaff({ ...newStaff, phoneNumber: e.target.value })
                  }
                  className="w-full px-4 py-2.5 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-green-600"
                />
              </div>

              <div className="grid grid-cols-2 gap-4">
                <div>
                  <label className="block text-[#2C3E50] font-semibold mb-2">
                    Vị trí
                  </label>
                  <input
                    type="text"
                    required
                    value={newStaff.position}
                    onChange={(e) =>
                      setNewStaff({ ...newStaff, position: e.target.value })
                    }
                    className="w-full px-4 py-2.5 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-green-600"
                  />
                </div>

                <div>
                  <label className="block text-[#2C3E50] font-semibold mb-2">
                    Phòng ban
                  </label>
                  <select
                    required
                    value={newStaff.department}
                    onChange={(e) =>
                      setNewStaff({ ...newStaff, department: e.target.value })
                    }
                    className="w-full px-4 py-2.5 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-green-600"
                  >
                    <option value="Customer Service">Customer Service</option>
                    <option value="IT">IT</option>
                    <option value="Operations">Operations</option>
                    <option value="Marketing">Marketing</option>
                    <option value="Finance">Finance</option>
                    <option value="HR">HR</option>
                  </select>
                </div>
              </div>

              <div className="grid grid-cols-2 gap-4">
                <div>
                  <label className="block text-[#2C3E50] font-semibold mb-2">
                    Lương
                  </label>
                  <input
                    type="text"
                    required
                    value={newStaff.salary}
                    onChange={(e) =>
                      setNewStaff({ ...newStaff, salary: e.target.value })
                    }
                    className="w-full px-4 py-2.5 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-green-600"
                  />
                </div>

                <div>
                  <label className="block text-[#2C3E50] font-semibold mb-2">
                    Ca làm việc
                  </label>
                  <select
                    required
                    value={newStaff.shift}
                    onChange={(e) =>
                      setNewStaff({ ...newStaff, shift: e.target.value })
                    }
                    className="w-full px-4 py-2.5 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-green-600"
                  >
                    <option value="Morning">Sáng</option>
                    <option value="Afternoon">Chiều</option>
                    <option value="Night">Tối</option>
                    <option value="Full Day">Cả ngày</option>
                  </select>
                </div>
              </div>

              <div>
                <label className="block text-[#2C3E50] font-semibold mb-2">
                  Ngày vào làm
                </label>
                <input
                  type="date"
                  required
                  value={newStaff.joinDate}
                  onChange={(e) =>
                    setNewStaff({ ...newStaff, joinDate: e.target.value })
                  }
                  className="w-full px-4 py-2.5 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-green-600"
                />
              </div>

              <div className="flex gap-3 pt-4">
                <button
                  type="submit"
                  className="flex-1 bg-green-600 text-white py-3 rounded-lg font-semibold hover:bg-green-700 transition-all"
                >
                  Cập nhật
                </button>
                <button
                  type="button"
                  onClick={() => setShowEditModal(false)}
                  className="flex-1 bg-gray-200 text-[#2C3E50] py-3 rounded-lg font-semibold hover:bg-gray-300 transition-all"
                >
                  Hủy
                </button>
              </div>
            </form>
          </div>
        </div>
      )}

      {/* Detail Modal */}
      {showDetailModal && selectedStaff && (
        <div className="fixed inset-0 bg-black/50 flex items-center justify-center z-50 p-4">
          <div className="bg-white rounded-2xl max-w-3xl w-full max-h-[90vh] overflow-y-auto">
            <div className="sticky top-0 bg-gradient-to-r from-purple-600 to-purple-700 text-white p-6 flex items-center justify-between rounded-t-2xl">
              <h2 className="text-2xl font-bold">Chi tiết nhân viên</h2>
              <button
                onClick={() => setShowDetailModal(false)}
                className="p-2 hover:bg-white/20 rounded-lg transition-all"
              >
                <XIcon className="w-6 h-6" />
              </button>
            </div>

            <div className="p-6">
              {/* Profile Section */}
              <div className="flex items-center gap-6 mb-6 bg-gradient-to-br from-purple-50 to-blue-50 p-6 rounded-xl">
                <img
                  src={selectedStaff.avatar}
                  alt={`${selectedStaff.firstName} ${selectedStaff.lastName}`}
                  className="w-24 h-24 rounded-full border-4 border-purple-500 shadow-lg"
                />
                <div className="flex-1">
                  <h3 className="text-2xl font-bold text-[#2C3E50] mb-1">
                    {selectedStaff.firstName} {selectedStaff.lastName}
                  </h3>
                  <p className="text-purple-600 font-semibold mb-2">
                    {selectedStaff.position}
                  </p>
                  <div className="flex items-center gap-4">
                    <span
                      className={`px-3 py-1 rounded-full text-sm font-semibold ${
                        selectedStaff.status === "Active"
                          ? "bg-green-100 text-green-700"
                          : "bg-yellow-100 text-yellow-700"
                      }`}
                    >
                      {selectedStaff.status === "Active"
                        ? "Đang làm"
                        : "Nghỉ phép"}
                    </span>
                    <span className="text-[#7F8C8D] text-sm">
                      {selectedStaff.staffID}
                    </span>
                  </div>
                </div>
              </div>

              {/* Info Grid */}
              <div className="grid grid-cols-2 gap-4 mb-6">
                <div className="bg-gray-50 p-4 rounded-xl">
                  <div className="flex items-center gap-2 mb-2">
                    <MailIcon className="w-5 h-5 text-[#2E7D9A]" />
                    <p className="text-[#7F8C8D] text-sm font-medium">Email</p>
                  </div>
                  <p className="text-[#2C3E50] font-semibold">
                    {selectedStaff.email}
                  </p>
                </div>

                <div className="bg-gray-50 p-4 rounded-xl">
                  <div className="flex items-center gap-2 mb-2">
                    <PhoneIcon className="w-5 h-5 text-[#2E7D9A]" />
                    <p className="text-[#7F8C8D] text-sm font-medium">
                      Số điện thoại
                    </p>
                  </div>
                  <p className="text-[#2C3E50] font-semibold">
                    {selectedStaff.phoneNumber}
                  </p>
                </div>

                <div className="bg-gray-50 p-4 rounded-xl">
                  <div className="flex items-center gap-2 mb-2">
                    <BriefcaseIcon className="w-5 h-5 text-[#2E7D9A]" />
                    <p className="text-[#7F8C8D] text-sm font-medium">
                      Phòng ban
                    </p>
                  </div>
                  <p className="text-[#2C3E50] font-semibold">
                    {selectedStaff.department}
                  </p>
                </div>

                <div className="bg-gray-50 p-4 rounded-xl">
                  <div className="flex items-center gap-2 mb-2">
                    <Clock className="w-5 h-5 text-[#2E7D9A]" />
                    <p className="text-[#7F8C8D] text-sm font-medium">
                      Ca làm việc
                    </p>
                  </div>
                  <p className="text-[#2C3E50] font-semibold">
                    {selectedStaff.shift}
                  </p>
                </div>

                <div className="bg-gray-50 p-4 rounded-xl">
                  <div className="flex items-center gap-2 mb-2">
                    <CalendarIcon className="w-5 h-5 text-[#2E7D9A]" />
                    <p className="text-[#7F8C8D] text-sm font-medium">
                      Ngày vào làm
                    </p>
                  </div>
                  <p className="text-[#2C3E50] font-semibold">
                    {selectedStaff.joinDate}
                  </p>
                </div>

                <div className="bg-gray-50 p-4 rounded-xl">
                  <div className="flex items-center gap-2 mb-2">
                    <BriefcaseIcon className="w-5 h-5 text-[#2E7D9A]" />
                    <p className="text-[#7F8C8D] text-sm font-medium">Lương</p>
                  </div>
                  <p className="text-[#2C3E50] font-semibold">
                    {selectedStaff.salary}
                  </p>
                </div>
              </div>

              {/* Performance Stats */}
              <div className="bg-gradient-to-br from-blue-50 to-purple-50 p-6 rounded-xl mb-6">
                <h4 className="text-[#2C3E50] font-bold text-lg mb-4">
                  Thống kê hiệu suất
                </h4>
                <div className="grid grid-cols-2 gap-4">
                  <div className="bg-white p-4 rounded-xl shadow-sm">
                    <p className="text-[#7F8C8D] text-sm mb-1">
                      Hiệu suất làm việc
                    </p>
                    <div className="flex items-center gap-3">
                      <div className="flex-1 bg-gray-200 rounded-full h-3">
                        <div
                          className="bg-gradient-to-r from-blue-500 to-purple-500 h-3 rounded-full"
                          style={{ width: `${selectedStaff.performance}%` }}
                        />
                      </div>
                      <span className="text-[#2C3E50] font-bold text-lg">
                        {selectedStaff.performance}%
                      </span>
                    </div>
                  </div>

                  <div className="bg-white p-4 rounded-xl shadow-sm">
                    <p className="text-[#7F8C8D] text-sm mb-1">
                      Công việc hoàn thành
                    </p>
                    <p className="text-[#2C3E50] font-bold text-2xl">
                      {selectedStaff.tasksCompleted}
                    </p>
                  </div>
                </div>
              </div>

              {/* Action Buttons */}
              <div className="flex gap-3">
                <button
                  onClick={() => {
                    setShowDetailModal(false);
                    handleEditStaff(selectedStaff);
                  }}
                  className="flex-1 bg-green-600 text-white py-3 rounded-lg font-semibold hover:bg-green-700 transition-all flex items-center justify-center gap-2"
                >
                  <EditIcon className="w-5 h-5" />
                  Chỉnh sửa
                </button>
                <button
                  onClick={() => setShowDetailModal(false)}
                  className="flex-1 bg-gray-200 text-[#2C3E50] py-3 rounded-lg font-semibold hover:bg-gray-300 transition-all"
                >
                  Đóng
                </button>
              </div>
            </div>
          </div>
        </div>
      )}
    </div>
  );
};

export default StaffManagementPage;
