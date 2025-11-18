import React, { useState } from "react";
import {
  PlusIcon,
  SearchIcon,
  FilterIcon,
  EditIcon,
  TrashIcon,
  EyeIcon,
  XIcon,
} from "lucide-react";

const CarManagementPage = () => {
  const [searchTerm, setSearchTerm] = useState("");
  const [filterStatus, setFilterStatus] = useState("Tất cả");
  const [showAddModal, setShowAddModal] = useState(false);
  const [showEditModal, setShowEditModal] = useState(false);
  const [showDetailModal, setShowDetailModal] = useState(false);
  const [selectedCar, setSelectedCar] = useState(null);
  const [carsList, setCarsList] = useState([
    {
      id: "CAR001",
      name: "Toyota Vios 2020",
      brand: "Toyota",
      type: "Sedan",
      licensePlate: "51A-12345",
      year: 2020,
      price: 500000,
      transmission: "Tự động",
      seats: 5,
      fuel: "Xăng",
      color: "Trắng",
      status: "Sẵn sàng",
      rating: 4.8,
      trips: 156,
      image: "image/toyota-vios.png",
    },
    {
      id: "CAR002",
      name: "Mazda 3 2018",
      brand: "Mazda",
      type: "Sedan",
      licensePlate: "51B-67890",
      year: 2018,
      price: 450000,
      transmission: "Tự động",
      seats: 5,
      fuel: "Xăng",
      color: "Đỏ",
      status: "Đang thuê",
      rating: 4.6,
      trips: 132,
      image: "image/mazda-3.png",
    },
    {
      id: "CAR003",
      name: "VinFast VF6 2023",
      brand: "VinFast",
      type: "SUV",
      licensePlate: "51C-11111",
      year: 2023,
      price: 900000,
      transmission: "Tự động",
      seats: 7,
      fuel: "Điện",
      color: "Xanh",
      status: "Sẵn sàng",
      rating: 4.9,
      trips: 45,
      image: "image/vinfast-vf6.png",
    },
    {
      id: "CAR004",
      name: "Honda City 2019",
      brand: "Honda",
      type: "Sedan",
      licensePlate: "51D-22222",
      year: 2019,
      price: 550000,
      transmission: "Tự động",
      seats: 5,
      fuel: "Xăng",
      color: "Đen",
      status: "Bảo trì",
      rating: 4.7,
      trips: 98,
      image: "image/honda_city.png",
    },
    {
      id: "CAR005",
      name: "VinFast VF6 2023",
      brand: "VinFast",
      type: "SUV",
      licensePlate: "51E-33333",
      year: 2023,
      price: 1200000,
      transmission: "Tự động",
      seats: 7,
      fuel: "Điện",
      color: "Bạc",
      status: "Sẵn sàng",
      rating: 5.0,
      trips: 23,
      image: "image/vinfast-vf6.png",
    },
  ]);

  const [newCar, setNewCar] = useState({
    name: "",
    brand: "",
    type: "Sedan",
    licensePlate: "",
    year: new Date().getFullYear(),
    price: "",
    transmission: "Tự động",
    seats: 5,
    fuel: "Xăng",
    color: "",
    status: "Sẵn sàng",
    image: "image/default-car.png",
  });

  const handleAddCar = (e) => {
    e.preventDefault();
    const carId = `CAR${String(carsList.length + 1).padStart(3, "0")}`;
    const carToAdd = {
      ...newCar,
      id: carId,
      rating: 0,
      trips: 0,
      price: parseInt(newCar.price),
    };
    setCarsList([...carsList, carToAdd]);
    setShowAddModal(false);
    setNewCar({
      name: "",
      brand: "",
      type: "Sedan",
      licensePlate: "",
      year: new Date().getFullYear(),
      price: "",
      transmission: "Tự động",
      seats: 5,
      fuel: "Xăng",
      color: "",
      status: "Sẵn sàng",
      image: "image/default-car.png",
    });
  };

  const handleInputChange = (e) => {
    const { name, value } = e.target;
    setNewCar((prev) => ({
      ...prev,
      [name]: value,
    }));
  };

  const handleEditCar = (car) => {
    setSelectedCar(car);
    setNewCar({
      name: car.name,
      brand: car.brand,
      type: car.type,
      licensePlate: car.licensePlate,
      year: car.year,
      price: car.price,
      transmission: car.transmission,
      seats: car.seats,
      fuel: car.fuel,
      color: car.color,
      status: car.status,
      image: car.image,
    });
    setShowEditModal(true);
  };

  const handleUpdateCar = (e) => {
    e.preventDefault();
    const updatedCars = carsList.map((car) =>
      car.id === selectedCar.id
        ? {
            ...car,
            ...newCar,
            price: parseInt(newCar.price),
          }
        : car
    );
    setCarsList(updatedCars);
    setShowEditModal(false);
    setSelectedCar(null);
    setNewCar({
      name: "",
      brand: "",
      type: "Sedan",
      licensePlate: "",
      year: new Date().getFullYear(),
      price: "",
      transmission: "Tự động",
      seats: 5,
      fuel: "Xăng",
      color: "",
      status: "Sẵn sàng",
      image: "image/default-car.png",
    });
  };

  const handleViewDetail = (car) => {
    setSelectedCar(car);
    setShowDetailModal(true);
  };

  const handleDeleteCar = (carId) => {
    if (window.confirm("Bạn có chắc chắn muốn xóa xe này?")) {
      setCarsList(carsList.filter((car) => car.id !== carId));
    }
  };

  const stats = [
    { label: "Tổng số xe", value: carsList.length, color: "text-primary" },
    {
      label: "Sẵn sàng",
      value: carsList.filter((c) => c.status === "Sẵn sàng").length,
      color: "text-success",
    },
    {
      label: "Đang thuê",
      value: carsList.filter((c) => c.status === "Đang thuê").length,
      color: "text-warning",
    },
    {
      label: "Bảo trì",
      value: carsList.filter((c) => c.status === "Bảo trì").length,
      color: "text-danger",
    },
  ];

  const getStatusColor = (status) => {
    switch (status) {
      case "Sẵn sàng":
        return "bg-success text-white";
      case "Đang thuê":
        return "bg-warning text-white";
      case "Bảo trì":
        return "bg-danger text-white";
      default:
        return "bg-gray-500 text-white";
    }
  };

  const filteredCars = carsList.filter((car) => {
    const matchSearch =
      car.name.toLowerCase().includes(searchTerm.toLowerCase()) ||
      car.licensePlate.toLowerCase().includes(searchTerm.toLowerCase());
    const matchFilter =
      filterStatus === "Tất cả" || car.status === filterStatus;
    return matchSearch && matchFilter;
  });

  return (
    <div className="p-6 bg-secondary min-h-screen">
      {/* Header */}
      <div className="flex flex-col md:flex-row md:items-center md:justify-between mb-6">
        <h1 className="text-3xl font-bold text-textPrimary mb-4 md:mb-0">
          Quản lý xe
        </h1>
        <button
          onClick={() => setShowAddModal(true)}
          className="bg-[#2E7D9A] text-white px-6 py-3 rounded-lg hover:opacity-90 transition flex items-center gap-2 font-medium shadow-md"
        >
          <PlusIcon className="w-5 h-5" />
          Thêm xe mới
        </button>
      </div>

      {/* Stats */}
      <div className="grid grid-cols-2 md:grid-cols-4 gap-4 mb-6">
        {stats.map((stat, index) => (
          <div key={index} className="bg-white rounded-lg p-4 shadow-md">
            <p className="text-textSecondary text-sm mb-1">{stat.label}</p>
            <p className={`text-2xl font-bold ${stat.color}`}>{stat.value}</p>
          </div>
        ))}
      </div>

      {/* Search and Filter */}
      <div className="bg-white rounded-lg p-4 mb-6 shadow-md">
        <div className="flex flex-col md:flex-row gap-4">
          <div className="flex-1 relative">
            <SearchIcon className="absolute left-3 top-1/2 transform -translate-y-1/2 text-textSecondary w-5 h-5" />
            <input
              type="text"
              placeholder="Tìm kiếm theo tên hoặc biển số..."
              value={searchTerm}
              onChange={(e) => setSearchTerm(e.target.value)}
              className="w-full pl-10 pr-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-primary"
            />
          </div>
          <div className="flex items-center gap-2">
            <FilterIcon className="text-textSecondary w-5 h-5" />
            <select
              value={filterStatus}
              onChange={(e) => setFilterStatus(e.target.value)}
              className="px-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-primary"
            >
              <option>Tất cả</option>
              <option>Sẵn sàng</option>
              <option>Đang thuê</option>
              <option>Bảo trì</option>
            </select>
          </div>
        </div>
      </div>

      {/* Cars Grid */}
      <div className="grid md:grid-cols-2 lg:grid-cols-3 gap-6">
        {filteredCars.map((car) => (
          <div
            key={car.id}
            className="bg-white rounded-xl shadow-md overflow-hidden hover:shadow-lg transition"
          >
            {/* Image */}
            <div className="relative h-48 bg-gray-200">
              <img
                src={car.image}
                alt={car.name}
                className="w-full h-full object-cover"
              />
              <div
                className={`absolute top-3 right-3 px-3 py-1 rounded-full text-xs font-bold ${getStatusColor(
                  car.status
                )}`}
              >
                {car.status}
              </div>
            </div>

            {/* Content */}
            <div className="p-4">
              <h3 className="text-lg font-bold text-textPrimary mb-2">
                {car.name}
              </h3>

              <div className="space-y-2 mb-4">
                <div className="flex items-center text-sm text-textSecondary">
                  <span className="w-24">Biển số:</span>
                  <span className="font-medium text-textPrimary">
                    {car.licensePlate}
                  </span>
                </div>
                <div className="flex items-center text-sm text-textSecondary">
                  <span className="w-24">Loại xe:</span>
                  <span className="font-medium text-textPrimary">
                    {car.type}
                  </span>
                </div>
                <div className="flex items-center text-sm text-textSecondary">
                  <span className="w-24">Số chỗ:</span>
                  <span className="font-medium text-textPrimary">
                    {car.seats} chỗ
                  </span>
                </div>
                <div className="flex items-center text-sm text-textSecondary">
                  <span className="w-24">Nhiên liệu:</span>
                  <span className="font-medium text-textPrimary">
                    {car.fuel}
                  </span>
                </div>
              </div>

              {/* Stats */}
              <div className="flex items-center justify-between mb-4 pb-4 border-b border-gray-200">
                <div className="text-center">
                  <div className="flex items-center gap-1">
                    <span className="text-yellow-500">⭐</span>
                    <span className="font-bold text-textPrimary">
                      {car.rating}
                    </span>
                  </div>
                  <p className="text-xs text-textSecondary">Đánh giá</p>
                </div>
                <div className="text-center">
                  <p className="font-bold text-textPrimary">{car.trips}</p>
                  <p className="text-xs text-textSecondary">Chuyến đi</p>
                </div>
              </div>

              {/* Price and Actions */}
              <div className="flex items-center justify-between">
                <div>
                  <p className="text-2xl font-bold text-primary">
                    {car.price.toLocaleString()}đ
                  </p>
                  <p className="text-xs text-textSecondary">/ ngày</p>
                </div>
                <div className="flex gap-2">
                  <button
                    onClick={() => handleViewDetail(car)}
                    className="p-2 text-[#2E7D9A] hover:bg-blue-50 rounded-lg transition"
                    title="Xem chi tiết"
                  >
                    <EyeIcon className="w-5 h-5" />
                  </button>
                  <button
                    onClick={() => handleEditCar(car)}
                    className="p-2 text-purple-600 hover:bg-purple-50 rounded-lg transition"
                    title="Chỉnh sửa"
                  >
                    <EditIcon className="w-5 h-5" />
                  </button>
                  <button
                    onClick={() => handleDeleteCar(car.id)}
                    className="p-2 text-red-600 hover:bg-red-50 rounded-lg transition"
                    title="Xóa xe"
                  >
                    <TrashIcon className="w-5 h-5" />
                  </button>
                </div>
              </div>
            </div>
          </div>
        ))}
      </div>

      {/* Empty State */}
      {filteredCars.length === 0 && (
        <div className="text-center py-12">
          <div className="text-6xl mb-4">🚗</div>
          <p className="text-textSecondary">Không tìm thấy xe nào</p>
        </div>
      )}

      {/* Add Car Modal */}
      {showAddModal && (
        <div className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50 p-4">
          <div className="bg-white rounded-xl shadow-2xl max-w-3xl w-full max-h-[90vh] overflow-y-auto">
            {/* Modal Header */}
            <div className="flex items-center justify-between p-6 border-b border-gray-200 sticky top-0 bg-white">
              <h2 className="text-2xl font-bold text-textPrimary">
                Thêm xe mới
              </h2>
              <button
                onClick={() => setShowAddModal(false)}
                className="p-2 hover:bg-gray-100 rounded-lg transition"
              >
                <XIcon className="w-6 h-6 text-textSecondary" />
              </button>
            </div>

            {/* Modal Body */}
            <form onSubmit={handleAddCar} className="p-6">
              <div className="grid md:grid-cols-2 gap-6">
                {/* Tên xe */}
                <div>
                  <label className="block text-sm font-medium text-textPrimary mb-2">
                    Tên xe <span className="text-red-500">*</span>
                  </label>
                  <input
                    type="text"
                    name="name"
                    value={newCar.name}
                    onChange={handleInputChange}
                    placeholder="VD: Toyota Vios 2020"
                    required
                    className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-primary"
                  />
                </div>

                {/* Hãng xe */}
                <div>
                  <label className="block text-sm font-medium text-textPrimary mb-2">
                    Hãng xe <span className="text-red-500">*</span>
                  </label>
                  <input
                    type="text"
                    name="brand"
                    value={newCar.brand}
                    onChange={handleInputChange}
                    placeholder="VD: Toyota"
                    required
                    className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-primary"
                  />
                </div>

                {/* Loại xe */}
                <div>
                  <label className="block text-sm font-medium text-textPrimary mb-2">
                    Loại xe <span className="text-red-500">*</span>
                  </label>
                  <select
                    name="type"
                    value={newCar.type}
                    onChange={handleInputChange}
                    className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-primary"
                  >
                    <option value="Sedan">Sedan</option>
                    <option value="SUV">SUV</option>
                    <option value="Hatchback">Hatchback</option>
                    <option value="MPV">MPV</option>
                    <option value="Bán tải">Bán tải</option>
                  </select>
                </div>

                {/* Biển số */}
                <div>
                  <label className="block text-sm font-medium text-textPrimary mb-2">
                    Biển số xe <span className="text-red-500">*</span>
                  </label>
                  <input
                    type="text"
                    name="licensePlate"
                    value={newCar.licensePlate}
                    onChange={handleInputChange}
                    placeholder="VD: 51A-12345"
                    required
                    className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-primary"
                  />
                </div>

                {/* Năm sản xuất */}
                <div>
                  <label className="block text-sm font-medium text-textPrimary mb-2">
                    Năm sản xuất <span className="text-red-500">*</span>
                  </label>
                  <input
                    type="number"
                    name="year"
                    value={newCar.year}
                    onChange={handleInputChange}
                    min="2000"
                    max={new Date().getFullYear() + 1}
                    required
                    className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-primary"
                  />
                </div>

                {/* Giá thuê */}
                <div>
                  <label className="block text-sm font-medium text-textPrimary mb-2">
                    Giá thuê (VNĐ/ngày) <span className="text-red-500">*</span>
                  </label>
                  <input
                    type="number"
                    name="price"
                    value={newCar.price}
                    onChange={handleInputChange}
                    placeholder="VD: 500000"
                    min="0"
                    required
                    className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-primary"
                  />
                </div>

                {/* Hộp số */}
                <div>
                  <label className="block text-sm font-medium text-textPrimary mb-2">
                    Hộp số <span className="text-red-500">*</span>
                  </label>
                  <select
                    name="transmission"
                    value={newCar.transmission}
                    onChange={handleInputChange}
                    className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-primary"
                  >
                    <option value="Tự động">Tự động</option>
                    <option value="Số sàn">Số sàn</option>
                  </select>
                </div>

                {/* Số chỗ ngồi */}
                <div>
                  <label className="block text-sm font-medium text-textPrimary mb-2">
                    Số chỗ ngồi <span className="text-red-500">*</span>
                  </label>
                  <select
                    name="seats"
                    value={newCar.seats}
                    onChange={handleInputChange}
                    className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-primary"
                  >
                    <option value={4}>4 chỗ</option>
                    <option value={5}>5 chỗ</option>
                    <option value={7}>7 chỗ</option>
                    <option value={9}>9 chỗ</option>
                  </select>
                </div>

                {/* Nhiên liệu */}
                <div>
                  <label className="block text-sm font-medium text-textPrimary mb-2">
                    Nhiên liệu <span className="text-red-500">*</span>
                  </label>
                  <select
                    name="fuel"
                    value={newCar.fuel}
                    onChange={handleInputChange}
                    className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-primary"
                  >
                    <option value="Xăng">Xăng</option>
                    <option value="Dầu Diesel">Dầu Diesel</option>
                    <option value="Điện">Điện</option>
                    <option value="Hybrid">Hybrid</option>
                  </select>
                </div>

                {/* Màu sắc */}
                <div>
                  <label className="block text-sm font-medium text-textPrimary mb-2">
                    Màu sắc <span className="text-red-500">*</span>
                  </label>
                  <input
                    type="text"
                    name="color"
                    value={newCar.color}
                    onChange={handleInputChange}
                    placeholder="VD: Trắng"
                    required
                    className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-primary"
                  />
                </div>

                {/* Trạng thái */}
                <div>
                  <label className="block text-sm font-medium text-textPrimary mb-2">
                    Trạng thái <span className="text-red-500">*</span>
                  </label>
                  <select
                    name="status"
                    value={newCar.status}
                    onChange={handleInputChange}
                    className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-primary"
                  >
                    <option value="Sẵn sàng">Sẵn sàng</option>
                    <option value="Đang thuê">Đang thuê</option>
                    <option value="Bảo trì">Bảo trì</option>
                  </select>
                </div>

                {/* URL hình ảnh */}
                <div className="md:col-span-2">
                  <label className="block text-sm font-medium text-textPrimary mb-2">
                    URL hình ảnh
                  </label>
                  <input
                    type="text"
                    name="image"
                    value={newCar.image}
                    onChange={handleInputChange}
                    placeholder="VD: image/car.png"
                    className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-primary"
                  />
                </div>
              </div>

              {/* Modal Footer */}
              <div className="flex gap-4 mt-8">
                <button
                  type="button"
                  onClick={() => setShowAddModal(false)}
                  className="flex-1 px-6 py-3 border border-gray-300 text-textSecondary rounded-lg hover:bg-gray-50 transition font-medium"
                >
                  Hủy
                </button>
                <button
                  type="submit"
                  className="flex-1 px-6 py-3 bg-[#2E7D9A] text-white rounded-lg hover:opacity-90 transition font-medium shadow-md"
                >
                  Thêm xe
                </button>
              </div>
            </form>
          </div>
        </div>
      )}

      {/* Edit Car Modal */}
      {showEditModal && selectedCar && (
        <div className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50 p-4">
          <div className="bg-white rounded-xl shadow-2xl max-w-3xl w-full max-h-[90vh] overflow-y-auto">
            {/* Modal Header */}
            <div className="flex items-center justify-between p-6 border-b border-gray-200 sticky top-0 bg-white">
              <h2 className="text-2xl font-bold text-textPrimary">
                Chỉnh sửa xe: {selectedCar.name}
              </h2>
              <button
                onClick={() => {
                  setShowEditModal(false);
                  setSelectedCar(null);
                }}
                className="p-2 hover:bg-gray-100 rounded-lg transition"
              >
                <XIcon className="w-6 h-6 text-textSecondary" />
              </button>
            </div>

            {/* Modal Body */}
            <form onSubmit={handleUpdateCar} className="p-6">
              <div className="grid md:grid-cols-2 gap-6">
                {/* Tên xe */}
                <div>
                  <label className="block text-sm font-medium text-textPrimary mb-2">
                    Tên xe <span className="text-red-500">*</span>
                  </label>
                  <input
                    type="text"
                    name="name"
                    value={newCar.name}
                    onChange={handleInputChange}
                    placeholder="VD: Toyota Vios 2020"
                    required
                    className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-primary"
                  />
                </div>

                {/* Hãng xe */}
                <div>
                  <label className="block text-sm font-medium text-textPrimary mb-2">
                    Hãng xe <span className="text-red-500">*</span>
                  </label>
                  <input
                    type="text"
                    name="brand"
                    value={newCar.brand}
                    onChange={handleInputChange}
                    placeholder="VD: Toyota"
                    required
                    className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-primary"
                  />
                </div>

                {/* Loại xe */}
                <div>
                  <label className="block text-sm font-medium text-textPrimary mb-2">
                    Loại xe <span className="text-red-500">*</span>
                  </label>
                  <select
                    name="type"
                    value={newCar.type}
                    onChange={handleInputChange}
                    className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-primary"
                  >
                    <option value="Sedan">Sedan</option>
                    <option value="SUV">SUV</option>
                    <option value="Hatchback">Hatchback</option>
                    <option value="MPV">MPV</option>
                    <option value="Bán tải">Bán tải</option>
                  </select>
                </div>

                {/* Biển số */}
                <div>
                  <label className="block text-sm font-medium text-textPrimary mb-2">
                    Biển số xe <span className="text-red-500">*</span>
                  </label>
                  <input
                    type="text"
                    name="licensePlate"
                    value={newCar.licensePlate}
                    onChange={handleInputChange}
                    placeholder="VD: 51A-12345"
                    required
                    className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-primary"
                  />
                </div>

                {/* Năm sản xuất */}
                <div>
                  <label className="block text-sm font-medium text-textPrimary mb-2">
                    Năm sản xuất <span className="text-red-500">*</span>
                  </label>
                  <input
                    type="number"
                    name="year"
                    value={newCar.year}
                    onChange={handleInputChange}
                    min="2000"
                    max={new Date().getFullYear() + 1}
                    required
                    className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-primary"
                  />
                </div>

                {/* Giá thuê */}
                <div>
                  <label className="block text-sm font-medium text-textPrimary mb-2">
                    Giá thuê (VNĐ/ngày) <span className="text-red-500">*</span>
                  </label>
                  <input
                    type="number"
                    name="price"
                    value={newCar.price}
                    onChange={handleInputChange}
                    placeholder="VD: 500000"
                    min="0"
                    required
                    className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-primary"
                  />
                </div>

                {/* Hộp số */}
                <div>
                  <label className="block text-sm font-medium text-textPrimary mb-2">
                    Hộp số <span className="text-red-500">*</span>
                  </label>
                  <select
                    name="transmission"
                    value={newCar.transmission}
                    onChange={handleInputChange}
                    className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-primary"
                  >
                    <option value="Tự động">Tự động</option>
                    <option value="Số sàn">Số sàn</option>
                  </select>
                </div>

                {/* Số chỗ ngồi */}
                <div>
                  <label className="block text-sm font-medium text-textPrimary mb-2">
                    Số chỗ ngồi <span className="text-red-500">*</span>
                  </label>
                  <select
                    name="seats"
                    value={newCar.seats}
                    onChange={handleInputChange}
                    className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-primary"
                  >
                    <option value={4}>4 chỗ</option>
                    <option value={5}>5 chỗ</option>
                    <option value={7}>7 chỗ</option>
                    <option value={9}>9 chỗ</option>
                  </select>
                </div>

                {/* Nhiên liệu */}
                <div>
                  <label className="block text-sm font-medium text-textPrimary mb-2">
                    Nhiên liệu <span className="text-red-500">*</span>
                  </label>
                  <select
                    name="fuel"
                    value={newCar.fuel}
                    onChange={handleInputChange}
                    className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-primary"
                  >
                    <option value="Xăng">Xăng</option>
                    <option value="Dầu Diesel">Dầu Diesel</option>
                    <option value="Điện">Điện</option>
                    <option value="Hybrid">Hybrid</option>
                  </select>
                </div>

                {/* Màu sắc */}
                <div>
                  <label className="block text-sm font-medium text-textPrimary mb-2">
                    Màu sắc <span className="text-red-500">*</span>
                  </label>
                  <input
                    type="text"
                    name="color"
                    value={newCar.color}
                    onChange={handleInputChange}
                    placeholder="VD: Trắng"
                    required
                    className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-primary"
                  />
                </div>

                {/* Trạng thái */}
                <div>
                  <label className="block text-sm font-medium text-textPrimary mb-2">
                    Trạng thái <span className="text-red-500">*</span>
                  </label>
                  <select
                    name="status"
                    value={newCar.status}
                    onChange={handleInputChange}
                    className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-primary"
                  >
                    <option value="Sẵn sàng">Sẵn sàng</option>
                    <option value="Đang thuê">Đang thuê</option>
                    <option value="Bảo trì">Bảo trì</option>
                  </select>
                </div>

                {/* URL hình ảnh */}
                <div className="md:col-span-2">
                  <label className="block text-sm font-medium text-textPrimary mb-2">
                    URL hình ảnh
                  </label>
                  <input
                    type="text"
                    name="image"
                    value={newCar.image}
                    onChange={handleInputChange}
                    placeholder="VD: image/car.png"
                    className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-primary"
                  />
                </div>
              </div>

              {/* Modal Footer */}
              <div className="flex gap-4 mt-8">
                <button
                  type="button"
                  onClick={() => {
                    setShowEditModal(false);
                    setSelectedCar(null);
                  }}
                  className="flex-1 px-6 py-3 border border-gray-300 text-textSecondary rounded-lg hover:bg-gray-50 transition font-medium"
                >
                  Hủy
                </button>
                <button
                  type="submit"
                  className="flex-1 px-6 py-3 bg-purple-600 text-white rounded-lg hover:opacity-90 transition font-medium shadow-md"
                >
                  Cập nhật
                </button>
              </div>
            </form>
          </div>
        </div>
      )}

      {/* Detail Car Modal */}
      {showDetailModal && selectedCar && (
        <div className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50 p-4">
          <div className="bg-white rounded-xl shadow-2xl max-w-4xl w-full max-h-[90vh] overflow-y-auto">
            {/* Modal Header */}
            <div className="flex items-center justify-between p-6 border-b border-gray-200 sticky top-0 bg-white">
              <h2 className="text-2xl font-bold text-textPrimary">
                Chi tiết xe
              </h2>
              <button
                onClick={() => {
                  setShowDetailModal(false);
                  setSelectedCar(null);
                }}
                className="p-2 hover:bg-gray-100 rounded-lg transition"
              >
                <XIcon className="w-6 h-6 text-textSecondary" />
              </button>
            </div>

            {/* Modal Body */}
            <div className="p-6">
              {/* Car Image */}
              <div className="relative h-64 bg-gray-200 rounded-xl overflow-hidden mb-6">
                <img
                  src={selectedCar.image}
                  alt={selectedCar.name}
                  className="w-full h-full object-cover"
                />
                <div
                  className={`absolute top-4 right-4 px-4 py-2 rounded-full text-sm font-bold ${getStatusColor(
                    selectedCar.status
                  )}`}
                >
                  {selectedCar.status}
                </div>
              </div>

              {/* Car Info */}
              <div className="grid md:grid-cols-2 gap-6 mb-6">
                <div>
                  <h3 className="text-2xl font-bold text-textPrimary mb-4">
                    {selectedCar.name}
                  </h3>

                  <div className="space-y-3">
                    <div className="flex items-center justify-between py-3 border-b border-gray-200">
                      <span className="text-textSecondary font-medium">
                        ID xe:
                      </span>
                      <span className="text-textPrimary font-bold">
                        {selectedCar.id}
                      </span>
                    </div>
                    <div className="flex items-center justify-between py-3 border-b border-gray-200">
                      <span className="text-textSecondary font-medium">
                        Hãng xe:
                      </span>
                      <span className="text-textPrimary font-bold">
                        {selectedCar.brand}
                      </span>
                    </div>
                    <div className="flex items-center justify-between py-3 border-b border-gray-200">
                      <span className="text-textSecondary font-medium">
                        Loại xe:
                      </span>
                      <span className="text-textPrimary font-bold">
                        {selectedCar.type}
                      </span>
                    </div>
                    <div className="flex items-center justify-between py-3 border-b border-gray-200">
                      <span className="text-textSecondary font-medium">
                        Biển số:
                      </span>
                      <span className="text-primary font-bold text-lg">
                        {selectedCar.licensePlate}
                      </span>
                    </div>
                    <div className="flex items-center justify-between py-3 border-b border-gray-200">
                      <span className="text-textSecondary font-medium">
                        Năm sản xuất:
                      </span>
                      <span className="text-textPrimary font-bold">
                        {selectedCar.year}
                      </span>
                    </div>
                    <div className="flex items-center justify-between py-3 border-b border-gray-200">
                      <span className="text-textSecondary font-medium">
                        Màu sắc:
                      </span>
                      <span className="text-textPrimary font-bold">
                        {selectedCar.color}
                      </span>
                    </div>
                  </div>
                </div>

                <div>
                  <div className="bg-gradient-to-br from-[#2E7D9A] to-[#1a4d5e] text-white rounded-xl p-6 mb-6">
                    <p className="text-sm opacity-90 mb-2">Giá thuê</p>
                    <p className="text-4xl font-bold">
                      {selectedCar.price.toLocaleString()}đ
                    </p>
                    <p className="text-sm opacity-90 mt-1">/ ngày</p>
                  </div>

                  <div className="space-y-3">
                    <div className="flex items-center justify-between py-3 border-b border-gray-200">
                      <span className="text-textSecondary font-medium">
                        Hộp số:
                      </span>
                      <span className="text-textPrimary font-bold">
                        {selectedCar.transmission}
                      </span>
                    </div>
                    <div className="flex items-center justify-between py-3 border-b border-gray-200">
                      <span className="text-textSecondary font-medium">
                        Số chỗ ngồi:
                      </span>
                      <span className="text-textPrimary font-bold">
                        {selectedCar.seats} chỗ
                      </span>
                    </div>
                    <div className="flex items-center justify-between py-3 border-b border-gray-200">
                      <span className="text-textSecondary font-medium">
                        Nhiên liệu:
                      </span>
                      <span className="text-textPrimary font-bold">
                        {selectedCar.fuel}
                      </span>
                    </div>
                    <div className="flex items-center justify-between py-3 border-b border-gray-200">
                      <span className="text-textSecondary font-medium">
                        Đánh giá:
                      </span>
                      <span className="text-yellow-500 font-bold text-lg">
                        ⭐ {selectedCar.rating}
                      </span>
                    </div>
                    <div className="flex items-center justify-between py-3 border-b border-gray-200">
                      <span className="text-textSecondary font-medium">
                        Số chuyến đi:
                      </span>
                      <span className="text-textPrimary font-bold">
                        {selectedCar.trips} chuyến
                      </span>
                    </div>
                  </div>
                </div>
              </div>

              {/* Statistics Section */}
              <div className="bg-secondary rounded-xl p-6">
                <h4 className="text-lg font-bold text-textPrimary mb-4">
                  Thống kê
                </h4>
                <div className="grid grid-cols-3 gap-4">
                  <div className="text-center p-4 bg-white rounded-lg">
                    <p className="text-2xl font-bold text-success">
                      {selectedCar.trips}
                    </p>
                    <p className="text-xs text-textSecondary mt-1">Chuyến đi</p>
                  </div>
                  <div className="text-center p-4 bg-white rounded-lg">
                    <p className="text-2xl font-bold text-warning">
                      ⭐ {selectedCar.rating}
                    </p>
                    <p className="text-xs text-textSecondary mt-1">Đánh giá</p>
                  </div>
                  <div className="text-center p-4 bg-white rounded-lg">
                    <p className="text-2xl font-bold text-primary">
                      {(selectedCar.price * selectedCar.trips).toLocaleString()}
                      đ
                    </p>
                    <p className="text-xs text-textSecondary mt-1">
                      Tổng doanh thu
                    </p>
                  </div>
                </div>
              </div>

              {/* Action Buttons */}
              <div className="flex gap-4 mt-6">
                <button
                  onClick={() => {
                    setShowDetailModal(false);
                    handleEditCar(selectedCar);
                  }}
                  className="flex-1 px-6 py-3 bg-purple-600 text-white rounded-lg hover:opacity-90 transition font-medium shadow-md flex items-center justify-center gap-2"
                >
                  <EditIcon className="w-5 h-5" />
                  Chỉnh sửa
                </button>
                <button
                  onClick={() => {
                    setShowDetailModal(false);
                    handleDeleteCar(selectedCar.id);
                  }}
                  className="flex-1 px-6 py-3 bg-red-600 text-white rounded-lg hover:opacity-90 transition font-medium shadow-md flex items-center justify-center gap-2"
                >
                  <TrashIcon className="w-5 h-5" />
                  Xóa xe
                </button>
              </div>
            </div>
          </div>
        </div>
      )}
    </div>
  );
};

export default CarManagementPage;
