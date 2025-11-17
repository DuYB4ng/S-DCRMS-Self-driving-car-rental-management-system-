import 'package:flutter/material.dart';
import '../../constants.dart';
import '../../models/car.dart';
import 'add_edit_car_screen.dart';

class CarManagementScreen extends StatefulWidget {
  const CarManagementScreen({super.key});

  @override
  State<CarManagementScreen> createState() => _CarManagementScreenState();
}

class _CarManagementScreenState extends State<CarManagementScreen> {
  String selectedFilter = 'Tất cả';
  String searchQuery = '';

  // Dữ liệu mẫu với hình ảnh
  List<Car> cars = [
    Car(
      id: '1',
      name: 'Toyota Vios 2020',
      brand: 'Toyota',
      model: 'Vios',
      type: 'Sedan',
      licensePlate: '30A-12345',
      year: 2020,
      pricePerDay: 500000,
      transmission: 'Số tự động',
      seats: 5,
      fuelType: 'Xăng',
      color: 'Trắng',
      imagePath: 'image/toyota-vios-2020.png',
      status: 'Sẵn sàng',
      rating: 4.8,
      totalTrips: 45,
    ),
    Car(
      id: '2',
      name: 'Mazda 3 2018',
      brand: 'Mazda',
      model: '3',
      type: 'Hatchback',
      licensePlate: '30B-67890',
      year: 2018,
      pricePerDay: 450000,
      transmission: 'Số tự động',
      seats: 5,
      fuelType: 'Xăng',
      color: 'Đỏ',
      imagePath: 'image/mazda-3-2018-7.png',
      status: 'Đang thuê',
      rating: 4.7,
      totalTrips: 38,
    ),
    Car(
      id: '3',
      name: 'VinFast VF6',
      brand: 'VinFast',
      model: 'VF6',
      type: 'SUV',
      licensePlate: '30C-11111',
      year: 2024,
      pricePerDay: 900000,
      transmission: 'Số tự động',
      seats: 5,
      fuelType: 'Điện',
      color: 'Xanh',
      imagePath: 'image/vinfastvf6-4.png',
      status: 'Sẵn sàng',
      rating: 4.9,
      totalTrips: 32,
    ),
    Car(
      id: '4',
      name: 'Honda Civic 2024',
      brand: 'Honda',
      model: 'Civic',
      type: 'Sedan',
      licensePlate: '30D-22222',
      year: 2024,
      pricePerDay: 700000,
      transmission: 'Số tự động',
      seats: 5,
      fuelType: 'Xăng',
      color: 'Đen',
      imagePath: 'image/1-1.png',
      status: 'Sẵn sàng',
      rating: 4.6,
      totalTrips: 28,
    ),
    Car(
      id: '5',
      name: 'VinFast VF9',
      brand: 'VinFast',
      model: 'VF9',
      type: 'SUV',
      licensePlate: '30E-33333',
      year: 2024,
      pricePerDay: 1500000,
      transmission: 'Số tự động',
      seats: 7,
      fuelType: 'Điện',
      color: 'Xanh',
      imagePath: 'image/Xanh-Noc-trang-min.png',
      status: 'Bảo trì',
      rating: 4.8,
      totalTrips: 20,
    ),
  ];

  List<Car> get filteredCars {
    return cars.where((car) {
      final matchesFilter =
          selectedFilter == 'Tất cả' || car.status == selectedFilter;
      final matchesSearch =
          car.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
          car.licensePlate.toLowerCase().contains(searchQuery.toLowerCase());
      return matchesFilter && matchesSearch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Quản lý xe',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list, color: Colors.white),
            onPressed: _showFilterDialog,
          ),
        ],
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          _buildFilterChips(),
          _buildStatsOverview(),
          Expanded(child: _buildCarList()),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addNewCar,
        backgroundColor: primaryColor,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Thêm xe', style: TextStyle(color: Colors.white)),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.all(defaultPadding),
      color: Colors.white,
      child: TextField(
        onChanged: (value) {
          setState(() {
            searchQuery = value;
          });
        },
        decoration: InputDecoration(
          hintText: 'Tìm kiếm xe theo tên, biển số...',
          prefixIcon: const Icon(Icons.search, color: textSecondaryColor),
          filled: true,
          fillColor: bgColor,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
        ),
      ),
    );
  }

  Widget _buildFilterChips() {
    final filters = ['Tất cả', 'Sẵn sàng', 'Đang thuê', 'Bảo trì'];

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: defaultPadding,
        vertical: 8,
      ),
      color: Colors.white,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: filters.map((filter) {
            final isSelected = filter == selectedFilter;
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: FilterChip(
                label: Text(filter),
                selected: isSelected,
                onSelected: (selected) {
                  setState(() {
                    selectedFilter = filter;
                  });
                },
                selectedColor: primaryColor,
                backgroundColor: Colors.grey[200],
                labelStyle: TextStyle(
                  color: isSelected ? Colors.white : textColor,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
                side: BorderSide(
                  color: isSelected ? primaryColor : Colors.grey[300]!,
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildStatsOverview() {
    final total = cars.length;
    final available = cars.where((c) => c.status == 'Sẵn sàng').length;
    final rented = cars.where((c) => c.status == 'Đang thuê').length;
    final maintenance = cars.where((c) => c.status == 'Bảo trì').length;

    return Container(
      padding: const EdgeInsets.all(defaultPadding),
      color: Colors.white,
      child: Row(
        children: [
          _buildStatItem('Tổng', total, primaryColor),
          _buildStatItem('Sẵn sàng', available, successColor),
          _buildStatItem('Đang thuê', rented, warningColor),
          _buildStatItem('Bảo trì', maintenance, dangerColor),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, int count, Color color) {
    return Expanded(
      child: Column(
        children: [
          Text(
            count.toString(),
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(fontSize: 12, color: textSecondaryColor),
          ),
        ],
      ),
    );
  }

  Widget _buildCarList() {
    if (filteredCars.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.directions_car_outlined,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'Không tìm thấy xe nào',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(defaultPadding),
      itemCount: filteredCars.length,
      itemBuilder: (context, index) {
        return _buildCarCard(filteredCars[index]);
      },
    );
  }

  Widget _buildCarCard(Car car) {
    Color statusColor;
    switch (car.status) {
      case 'Sẵn sàng':
        statusColor = successColor;
        break;
      case 'Đang thuê':
        statusColor = warningColor;
        break;
      case 'Bảo trì':
        statusColor = dangerColor;
        break;
      default:
        statusColor = textSecondaryColor;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: defaultPadding),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () => _viewCarDetail(car),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Hình ảnh xe
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: car.imagePath != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.asset(
                          car.imagePath!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(
                              Icons.directions_car,
                              size: 48,
                              color: Colors.grey[400],
                            );
                          },
                        ),
                      )
                    : Icon(
                        Icons.directions_car,
                        size: 48,
                        color: Colors.grey[400],
                      ),
              ),
              const SizedBox(width: 12),

              // Thông tin xe
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            car.name,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: textColor,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: statusColor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            car.status,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: statusColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${car.brand} ${car.model} - ${car.year}',
                      style: const TextStyle(
                        fontSize: 13,
                        color: textSecondaryColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.confirmation_number,
                          size: 14,
                          color: textSecondaryColor,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          car.licensePlate,
                          style: const TextStyle(
                            fontSize: 12,
                            color: textSecondaryColor,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Icon(Icons.star, size: 14, color: warningColor),
                        const SizedBox(width: 4),
                        Text(
                          '${car.rating}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: textSecondaryColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${car.pricePerDay.toStringAsFixed(0)}đ/ngày',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: primaryColor,
                          ),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, size: 20),
                              color: accentColor,
                              onPressed: () => _editCar(car),
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                            ),
                            const SizedBox(width: 8),
                            IconButton(
                              icon: const Icon(Icons.delete, size: 20),
                              color: dangerColor,
                              onPressed: () => _deleteCar(car),
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Lọc xe'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('Theo loại xe'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {},
              ),
              ListTile(
                title: const Text('Theo giá'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {},
              ),
              ListTile(
                title: const Text('Theo đánh giá'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {},
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Đóng'),
            ),
          ],
        );
      },
    );
  }

  void _addNewCar() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddEditCarScreen()),
    );

    if (result != null && result is Car) {
      setState(() {
        cars.add(result);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Đã thêm xe mới thành công!')),
      );
    }
  }

  void _editCar(Car car) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddEditCarScreen(car: car)),
    );

    if (result != null && result is Car) {
      setState(() {
        final index = cars.indexWhere((c) => c.id == car.id);
        if (index != -1) {
          cars[index] = result;
        }
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Đã cập nhật xe thành công!')),
      );
    }
  }

  void _deleteCar(Car car) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Xác nhận xóa'),
          content: Text('Bạn có chắc chắn muốn xóa xe ${car.name}?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Hủy'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  cars.removeWhere((c) => c.id == car.id);
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Đã xóa xe thành công!')),
                );
              },
              child: const Text('Xóa', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  void _viewCarDetail(Car car) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.7,
          maxChildSize: 0.9,
          minChildSize: 0.5,
          expand: false,
          builder: (context, scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              child: Padding(
                padding: const EdgeInsets.all(defaultPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Hình ảnh
                    if (car.imagePath != null)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.asset(
                          car.imagePath!,
                          width: double.infinity,
                          height: 200,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              width: double.infinity,
                              height: 200,
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                Icons.directions_car,
                                size: 80,
                                color: Colors.grey[400],
                              ),
                            );
                          },
                        ),
                      )
                    else
                      Container(
                        width: double.infinity,
                        height: 200,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.directions_car,
                          size: 80,
                          color: Colors.grey[400],
                        ),
                      ),

                    const SizedBox(height: 20),

                    // Thông tin chi tiết
                    Text(
                      car.name,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildDetailRow('Hãng xe', car.brand),
                    _buildDetailRow('Model', car.model),
                    _buildDetailRow('Loại xe', car.type),
                    _buildDetailRow('Biển số', car.licensePlate),
                    _buildDetailRow('Năm sản xuất', car.year.toString()),
                    _buildDetailRow('Số chỗ', '${car.seats} chỗ'),
                    _buildDetailRow('Hộp số', car.transmission),
                    _buildDetailRow('Nhiên liệu', car.fuelType),
                    _buildDetailRow('Màu sắc', car.color),
                    _buildDetailRow('Trạng thái', car.status),
                    _buildDetailRow('Đánh giá', '${car.rating} ⭐'),
                    _buildDetailRow('Số chuyến', '${car.totalTrips} chuyến'),
                    _buildDetailRow(
                      'Giá thuê',
                      '${car.pricePerDay.toStringAsFixed(0)}đ/ngày',
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(fontSize: 14, color: textSecondaryColor),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: textColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
