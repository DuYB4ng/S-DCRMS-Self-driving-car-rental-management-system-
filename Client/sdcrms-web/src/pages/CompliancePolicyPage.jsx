import React, { useState } from "react";
import {
  Shield,
  FileText,
  PlusIcon,
  SearchIcon,
  EditIcon,
  TrashIcon,
  EyeIcon,
  XIcon,
  CheckCircle,
  AlertTriangle,
  Clock,
  Tag,
  Calendar,
  User,
} from "lucide-react";

const CompliancePolicyPage = () => {
  // Mock data for policies
  const [policies, setPolicies] = useState([
    {
      policyID: "POL001",
      title: "Quy định bảo hiểm xe",
      category: "Insurance",
      description:
        "Tất cả xe cho thuê phải có bảo hiểm trách nhiệm dân sự và bảo hiểm vật chất đầy đủ",
      content:
        "Xe cho thuê phải có:\n1. Bảo hiểm trách nhiệm dân sự bắt buộc\n2. Bảo hiểm vật chất xe (mức 100% giá trị xe)\n3. Bảo hiểm tai nạn cho lái xe và hành khách\n4. Giấy chứng nhận bảo hiểm phải còn hiệu lực\n5. Thông báo công ty bảo hiểm khi có sự cố",
      status: "Active",
      priority: "High",
      effectiveDate: "2024-01-01",
      lastUpdated: "2024-11-15",
      updatedBy: "Admin",
      violations: 2,
      complianceRate: 98,
    },
    {
      policyID: "POL002",
      title: "Quy định bảo trì định kỳ",
      category: "Maintenance",
      description:
        "Lịch bảo dưỡng và kiểm tra xe định kỳ theo quy định của nhà sản xuất",
      content:
        "Yêu cầu bảo dưỡng:\n1. Thay dầu máy mỗi 5,000km hoặc 3 tháng\n2. Kiểm tra phanh mỗi 10,000km\n3. Thay lốp khi độ mòn > 70%\n4. Kiểm tra đăng kiểm định kỳ theo luật\n5. Ghi chép đầy đủ lịch sử bảo dưỡng",
      status: "Active",
      priority: "High",
      effectiveDate: "2024-01-01",
      lastUpdated: "2024-10-20",
      updatedBy: "Admin",
      violations: 5,
      complianceRate: 95,
    },
    {
      policyID: "POL003",
      title: "Quy định kiểm tra khách hàng",
      category: "Customer Verification",
      description:
        "Quy trình xác minh thông tin và giấy tờ khách hàng trước khi cho thuê xe",
      content:
        "Kiểm tra khách hàng:\n1. CMND/CCCD/Passport hợp lệ\n2. Bằng lái xe còn hạn (tối thiểu 1 năm kinh nghiệm)\n3. Xác minh số điện thoại và địa chỉ\n4. Kiểm tra lịch sử thuê xe (nếu có)\n5. Thu đặt cọc theo quy định",
      status: "Active",
      priority: "Critical",
      effectiveDate: "2024-01-01",
      lastUpdated: "2024-11-10",
      updatedBy: "Admin",
      violations: 1,
      complianceRate: 99,
    },
    {
      policyID: "POL004",
      title: "Chính sách hoàn tiền",
      category: "Payment",
      description:
        "Quy định về hoàn tiền khi hủy đặt xe và các trường hợp đặc biệt",
      content:
        "Chính sách hoàn tiền:\n1. Hủy trước 48h: Hoàn 100%\n2. Hủy trước 24h: Hoàn 50%\n3. Hủy dưới 24h: Không hoàn tiền\n4. Xe có vấn đề kỹ thuật: Hoàn 100%\n5. Thời gian xử lý: 5-7 ngày làm việc",
      status: "Active",
      priority: "Medium",
      effectiveDate: "2024-02-01",
      lastUpdated: "2024-09-15",
      updatedBy: "Finance Team",
      violations: 8,
      complianceRate: 92,
    },
    {
      policyID: "POL005",
      title: "Quy định xử lý vi phạm",
      category: "Violation",
      description:
        "Quy trình xử lý khi phát hiện vi phạm từ khách hàng hoặc chủ xe",
      content:
        "Xử lý vi phạm:\n1. Cảnh cáo lần 1: Gửi thông báo\n2. Vi phạm lần 2: Phạt tiền 500,000đ\n3. Vi phạm lần 3: Tạm khóa tài khoản 30 ngày\n4. Vi phạm nghiêm trọng: Khóa vĩnh viễn\n5. Báo cơ quan chức năng nếu cần",
      status: "Active",
      priority: "High",
      effectiveDate: "2024-01-15",
      lastUpdated: "2024-11-01",
      updatedBy: "Legal Team",
      violations: 12,
      complianceRate: 88,
    },
    {
      policyID: "POL006",
      title: "Quy định bảo mật dữ liệu",
      category: "Data Privacy",
      description:
        "Chính sách bảo vệ thông tin cá nhân của khách hàng và chủ xe",
      content:
        "Bảo mật dữ liệu:\n1. Mã hóa thông tin thanh toán\n2. Không chia sẻ dữ liệu với bên thứ 3\n3. Backup dữ liệu hàng ngày\n4. Xóa dữ liệu theo yêu cầu khách hàng\n5. Tuân thủ GDPR và luật bảo vệ dữ liệu VN",
      status: "Active",
      priority: "Critical",
      effectiveDate: "2024-01-01",
      lastUpdated: "2024-11-12",
      updatedBy: "IT Security",
      violations: 0,
      complianceRate: 100,
    },
  ]);

  const [showAddModal, setShowAddModal] = useState(false);
  const [showEditModal, setShowEditModal] = useState(false);
  const [showDetailModal, setShowDetailModal] = useState(false);
  const [selectedPolicy, setSelectedPolicy] = useState(null);
  const [searchTerm, setSearchTerm] = useState("");
  const [filterCategory, setFilterCategory] = useState("All");

  const [newPolicy, setNewPolicy] = useState({
    title: "",
    category: "",
    description: "",
    content: "",
    priority: "Medium",
    effectiveDate: "",
  });

  // Statistics
  const totalPolicies = policies.length;
  const activePolicies = policies.filter((p) => p.status === "Active").length;
  const criticalPolicies = policies.filter(
    (p) => p.priority === "Critical"
  ).length;
  const avgCompliance = (
    policies.reduce((sum, p) => sum + p.complianceRate, 0) / totalPolicies
  ).toFixed(1);

  // Handle Add Policy
  const handleAddPolicy = (e) => {
    e.preventDefault();
    const newPolicyData = {
      policyID: `POL${String(policies.length + 1).padStart(3, "0")}`,
      ...newPolicy,
      status: "Active",
      lastUpdated: new Date().toISOString().split("T")[0],
      updatedBy: "Admin",
      violations: 0,
      complianceRate: 100,
    };
    setPolicies([...policies, newPolicyData]);
    setShowAddModal(false);
    setNewPolicy({
      title: "",
      category: "",
      description: "",
      content: "",
      priority: "Medium",
      effectiveDate: "",
    });
  };

  // Handle Edit Policy
  const handleEditPolicy = (policy) => {
    setSelectedPolicy(policy);
    setNewPolicy({
      title: policy.title,
      category: policy.category,
      description: policy.description,
      content: policy.content,
      priority: policy.priority,
      effectiveDate: policy.effectiveDate,
    });
    setShowEditModal(true);
  };

  const handleUpdatePolicy = (e) => {
    e.preventDefault();
    setPolicies(
      policies.map((policy) =>
        policy.policyID === selectedPolicy.policyID
          ? {
              ...policy,
              ...newPolicy,
              lastUpdated: new Date().toISOString().split("T")[0],
            }
          : policy
      )
    );
    setShowEditModal(false);
    setSelectedPolicy(null);
  };

  // Handle View Detail
  const handleViewDetail = (policy) => {
    setSelectedPolicy(policy);
    setShowDetailModal(true);
  };

  // Handle Delete Policy
  const handleDeletePolicy = (policyID) => {
    if (window.confirm("Bạn có chắc muốn xóa chính sách này?")) {
      setPolicies(policies.filter((policy) => policy.policyID !== policyID));
    }
  };

  // Filter policies
  const filteredPolicies = policies.filter((policy) => {
    const matchSearch =
      policy.title.toLowerCase().includes(searchTerm.toLowerCase()) ||
      policy.description.toLowerCase().includes(searchTerm.toLowerCase()) ||
      policy.category.toLowerCase().includes(searchTerm.toLowerCase());

    const matchCategory =
      filterCategory === "All" || policy.category === filterCategory;

    return matchSearch && matchCategory;
  });

  const categories = [
    "All",
    "Insurance",
    "Maintenance",
    "Customer Verification",
    "Payment",
    "Violation",
    "Data Privacy",
    "Safety",
  ];

  return (
    <div className="p-6 bg-[#F5F9FA] min-h-screen">
      {/* Header */}
      <div className="mb-6">
        <h1 className="text-3xl font-bold text-[#2C3E50] mb-2">
          Quản lý chính sách tuân thủ
        </h1>
        <p className="text-[#7F8C8D]">
          Quản lý các chính sách và quy định tuân thủ của hệ thống
        </p>
      </div>

      {/* Statistics Cards */}
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-4 mb-6">
        <div className="bg-gradient-to-br from-blue-50 to-blue-100 rounded-xl p-5 shadow-md border border-blue-200">
          <div className="flex items-center justify-between">
            <div>
              <p className="text-blue-600 text-sm font-medium mb-1">
                Tổng chính sách
              </p>
              <p className="text-[#2C3E50] text-3xl font-bold">
                {totalPolicies}
              </p>
            </div>
            <div className="bg-blue-500 p-3 rounded-xl">
              <FileText className="w-8 h-8 text-white" />
            </div>
          </div>
        </div>

        <div className="bg-gradient-to-br from-green-50 to-green-100 rounded-xl p-5 shadow-md border border-green-200">
          <div className="flex items-center justify-between">
            <div>
              <p className="text-green-600 text-sm font-medium mb-1">
                Đang áp dụng
              </p>
              <p className="text-[#2C3E50] text-3xl font-bold">
                {activePolicies}
              </p>
            </div>
            <div className="bg-green-500 p-3 rounded-xl">
              <CheckCircle className="w-8 h-8 text-white" />
            </div>
          </div>
        </div>

        <div className="bg-gradient-to-br from-red-50 to-red-100 rounded-xl p-5 shadow-md border border-red-200">
          <div className="flex items-center justify-between">
            <div>
              <p className="text-red-600 text-sm font-medium mb-1">
                Mức độ cao
              </p>
              <p className="text-[#2C3E50] text-3xl font-bold">
                {criticalPolicies}
              </p>
            </div>
            <div className="bg-red-500 p-3 rounded-xl">
              <AlertTriangle className="w-8 h-8 text-white" />
            </div>
          </div>
        </div>

        <div className="bg-gradient-to-br from-purple-50 to-purple-100 rounded-xl p-5 shadow-md border border-purple-200">
          <div className="flex items-center justify-between">
            <div>
              <p className="text-purple-600 text-sm font-medium mb-1">
                Tuân thủ TB
              </p>
              <p className="text-[#2C3E50] text-3xl font-bold">
                {avgCompliance}%
              </p>
            </div>
            <div className="bg-purple-500 p-3 rounded-xl">
              <Shield className="w-8 h-8 text-white" />
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
                placeholder="Tìm kiếm chính sách..."
                value={searchTerm}
                onChange={(e) => setSearchTerm(e.target.value)}
                className="w-full pl-10 pr-4 py-2.5 border border-gray-200 rounded-lg focus:outline-none focus:ring-2 focus:ring-[#2E7D9A] focus:border-transparent"
              />
            </div>

            <select
              value={filterCategory}
              onChange={(e) => setFilterCategory(e.target.value)}
              className="px-4 py-2.5 border border-gray-200 rounded-lg focus:outline-none focus:ring-2 focus:ring-[#2E7D9A] bg-white"
            >
              {categories.map((cat) => (
                <option key={cat} value={cat}>
                  {cat === "All" ? "Tất cả danh mục" : cat}
                </option>
              ))}
            </select>
          </div>

          <button
            onClick={() => setShowAddModal(true)}
            className="bg-[#2E7D9A] text-white px-5 py-2.5 rounded-lg hover:bg-[#236a80] transition-all flex items-center gap-2 w-full lg:w-auto justify-center shadow-md hover:shadow-lg"
          >
            <PlusIcon className="w-5 h-5" />
            Thêm chính sách
          </button>
        </div>
      </div>

      {/* Policies Grid */}
      <div className="grid grid-cols-1 lg:grid-cols-2 xl:grid-cols-3 gap-4">
        {filteredPolicies.map((policy) => (
          <div
            key={policy.policyID}
            className="bg-white rounded-xl shadow-md hover:shadow-xl transition-all overflow-hidden border border-gray-100"
          >
            {/* Header */}
            <div
              className={`p-4 ${
                policy.priority === "Critical"
                  ? "bg-gradient-to-r from-red-500 to-red-600"
                  : policy.priority === "High"
                  ? "bg-gradient-to-r from-orange-500 to-orange-600"
                  : "bg-gradient-to-r from-blue-500 to-blue-600"
              } text-white`}
            >
              <div className="flex items-start justify-between mb-2">
                <div className="flex-1">
                  <h3 className="font-bold text-lg mb-1">{policy.title}</h3>
                  <p className="text-white/90 text-xs">{policy.policyID}</p>
                </div>
                <span
                  className={`px-2 py-1 rounded-full text-xs font-semibold ${
                    policy.priority === "Critical"
                      ? "bg-white text-red-600"
                      : policy.priority === "High"
                      ? "bg-white text-orange-600"
                      : "bg-white text-blue-600"
                  }`}
                >
                  {policy.priority}
                </span>
              </div>
              <div className="flex items-center gap-2">
                <Tag className="w-4 h-4" />
                <span className="text-sm">{policy.category}</span>
              </div>
            </div>

            {/* Body */}
            <div className="p-4">
              <p className="text-[#2C3E50] text-sm mb-4 line-clamp-2">
                {policy.description}
              </p>

              {/* Stats */}
              <div className="grid grid-cols-2 gap-3 mb-4">
                <div className="bg-green-50 p-3 rounded-lg">
                  <p className="text-green-600 text-xs font-medium mb-1">
                    Tuân thủ
                  </p>
                  <div className="flex items-center gap-2">
                    <div className="flex-1 bg-green-200 rounded-full h-2">
                      <div
                        className="bg-green-500 h-2 rounded-full"
                        style={{ width: `${policy.complianceRate}%` }}
                      />
                    </div>
                    <span className="text-[#2C3E50] text-sm font-bold">
                      {policy.complianceRate}%
                    </span>
                  </div>
                </div>

                <div className="bg-red-50 p-3 rounded-lg">
                  <p className="text-red-600 text-xs font-medium mb-1">
                    Vi phạm
                  </p>
                  <p className="text-[#2C3E50] text-xl font-bold">
                    {policy.violations}
                  </p>
                </div>
              </div>

              {/* Meta Info */}
              <div className="space-y-2 mb-4 text-xs">
                <div className="flex items-center gap-2 text-[#7F8C8D]">
                  <Calendar className="w-4 h-4" />
                  <span>Hiệu lực: {policy.effectiveDate}</span>
                </div>
                <div className="flex items-center gap-2 text-[#7F8C8D]">
                  <Clock className="w-4 h-4" />
                  <span>Cập nhật: {policy.lastUpdated}</span>
                </div>
                <div className="flex items-center gap-2 text-[#7F8C8D]">
                  <User className="w-4 h-4" />
                  <span>Bởi: {policy.updatedBy}</span>
                </div>
              </div>

              {/* Actions */}
              <div className="flex items-center gap-2">
                <button
                  onClick={() => handleViewDetail(policy)}
                  className="flex-1 bg-blue-50 text-blue-600 py-2 rounded-lg hover:bg-blue-100 transition-all flex items-center justify-center gap-2 text-sm font-semibold"
                >
                  <EyeIcon className="w-4 h-4" />
                  Xem
                </button>
                <button
                  onClick={() => handleEditPolicy(policy)}
                  className="flex-1 bg-green-50 text-green-600 py-2 rounded-lg hover:bg-green-100 transition-all flex items-center justify-center gap-2 text-sm font-semibold"
                >
                  <EditIcon className="w-4 h-4" />
                  Sửa
                </button>
                <button
                  onClick={() => handleDeletePolicy(policy.policyID)}
                  className="p-2 bg-red-50 text-red-600 rounded-lg hover:bg-red-100 transition-all"
                >
                  <TrashIcon className="w-4 h-4" />
                </button>
              </div>
            </div>
          </div>
        ))}
      </div>

      {/* Add Policy Modal */}
      {showAddModal && (
        <div className="fixed inset-0 bg-black/50 flex items-center justify-center z-50 p-4">
          <div className="bg-white rounded-2xl max-w-3xl w-full max-h-[90vh] overflow-y-auto">
            <div className="sticky top-0 bg-gradient-to-r from-[#2E7D9A] to-[#3498DB] text-white p-6 flex items-center justify-between rounded-t-2xl">
              <h2 className="text-2xl font-bold">Thêm chính sách mới</h2>
              <button
                onClick={() => setShowAddModal(false)}
                className="p-2 hover:bg-white/20 rounded-lg transition-all"
              >
                <XIcon className="w-6 h-6" />
              </button>
            </div>

            <form onSubmit={handleAddPolicy} className="p-6 space-y-4">
              <div>
                <label className="block text-[#2C3E50] font-semibold mb-2">
                  Tiêu đề <span className="text-red-500">*</span>
                </label>
                <input
                  type="text"
                  required
                  value={newPolicy.title}
                  onChange={(e) =>
                    setNewPolicy({ ...newPolicy, title: e.target.value })
                  }
                  className="w-full px-4 py-2.5 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-[#2E7D9A]"
                  placeholder="VD: Quy định bảo hiểm xe"
                />
              </div>

              <div className="grid grid-cols-2 gap-4">
                <div>
                  <label className="block text-[#2C3E50] font-semibold mb-2">
                    Danh mục <span className="text-red-500">*</span>
                  </label>
                  <select
                    required
                    value={newPolicy.category}
                    onChange={(e) =>
                      setNewPolicy({ ...newPolicy, category: e.target.value })
                    }
                    className="w-full px-4 py-2.5 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-[#2E7D9A]"
                  >
                    <option value="">Chọn danh mục</option>
                    <option value="Insurance">Insurance</option>
                    <option value="Maintenance">Maintenance</option>
                    <option value="Customer Verification">
                      Customer Verification
                    </option>
                    <option value="Payment">Payment</option>
                    <option value="Violation">Violation</option>
                    <option value="Data Privacy">Data Privacy</option>
                    <option value="Safety">Safety</option>
                  </select>
                </div>

                <div>
                  <label className="block text-[#2C3E50] font-semibold mb-2">
                    Mức độ ưu tiên <span className="text-red-500">*</span>
                  </label>
                  <select
                    required
                    value={newPolicy.priority}
                    onChange={(e) =>
                      setNewPolicy({ ...newPolicy, priority: e.target.value })
                    }
                    className="w-full px-4 py-2.5 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-[#2E7D9A]"
                  >
                    <option value="Low">Low</option>
                    <option value="Medium">Medium</option>
                    <option value="High">High</option>
                    <option value="Critical">Critical</option>
                  </select>
                </div>
              </div>

              <div>
                <label className="block text-[#2C3E50] font-semibold mb-2">
                  Mô tả ngắn <span className="text-red-500">*</span>
                </label>
                <textarea
                  required
                  rows="2"
                  value={newPolicy.description}
                  onChange={(e) =>
                    setNewPolicy({ ...newPolicy, description: e.target.value })
                  }
                  className="w-full px-4 py-2.5 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-[#2E7D9A]"
                  placeholder="Mô tả tóm tắt về chính sách..."
                />
              </div>

              <div>
                <label className="block text-[#2C3E50] font-semibold mb-2">
                  Nội dung chi tiết <span className="text-red-500">*</span>
                </label>
                <textarea
                  required
                  rows="8"
                  value={newPolicy.content}
                  onChange={(e) =>
                    setNewPolicy({ ...newPolicy, content: e.target.value })
                  }
                  className="w-full px-4 py-2.5 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-[#2E7D9A]"
                  placeholder="Nội dung đầy đủ của chính sách..."
                />
              </div>

              <div>
                <label className="block text-[#2C3E50] font-semibold mb-2">
                  Ngày có hiệu lực <span className="text-red-500">*</span>
                </label>
                <input
                  type="date"
                  required
                  value={newPolicy.effectiveDate}
                  onChange={(e) =>
                    setNewPolicy({
                      ...newPolicy,
                      effectiveDate: e.target.value,
                    })
                  }
                  className="w-full px-4 py-2.5 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-[#2E7D9A]"
                />
              </div>

              <div className="flex gap-3 pt-4">
                <button
                  type="submit"
                  className="flex-1 bg-[#2E7D9A] text-white py-3 rounded-lg font-semibold hover:bg-[#236a80] transition-all"
                >
                  Thêm chính sách
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

      {/* Edit & Detail Modals - Similar structure, omitted for brevity */}
      {/* You can add them following the same pattern as StaffManagementPage */}
    </div>
  );
};

export default CompliancePolicyPage;
