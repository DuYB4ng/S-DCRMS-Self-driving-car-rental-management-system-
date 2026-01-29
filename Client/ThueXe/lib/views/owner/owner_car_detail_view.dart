import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/car.dart';
import '../../viewmodels/owner_car_viewmodel.dart';
import 'add_edit_car_view.dart';
import 'car_bookings_view.dart';
import 'car_calendar_view.dart';

class OwnerCarDetailView extends StatelessWidget {
  final Car car;

  const OwnerCarDetailView({
    super.key,
    required this.car,
  });

  String _imageUrl(BuildContext context) {
    if (car.imageUrls.isNotEmpty) {
      final img = car.imageUrls.first;
      if (img.startsWith('http')) return img;
      final baseUrl = context.read<OwnerCarViewModel>().baseUrl;
      return "${baseUrl.replaceAll('/api', '')}$img";
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.read<OwnerCarViewModel>();
    final imageUrl = _imageUrl(context);

    // Format money
    final price = car.pricePerDay != null 
        ? "${car.pricePerDay!.toInt().toString().replaceAll(RegExp(r'\B(?=(\d{3})+(?!\d))'), '.')} VNĐ" 
        : "N/A";
    final deposit = car.deposit != null 
        ? "${car.deposit!.toInt().toString().replaceAll(RegExp(r'\B(?=(\d{3})+(?!\d))'), '.')} VNĐ" 
        : "N/A";

    return Scaffold(
      appBar: AppBar(
        title: Text(car.nameCar),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // IMAGE
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: imageUrl.isNotEmpty
                  ? Image.network(
                      imageUrl,
                      height: 220,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        height: 220,
                        alignment: Alignment.center,
                        color: Colors.grey[200],
                        child: const Icon(Icons.car_rental, size: 60),
                      ),
                    )
                  : Container(
                      height: 220,
                      alignment: Alignment.center,
                      color: Colors.grey[200],
                      child: const Icon(Icons.car_rental, size: 60),
                    ),
            ),

            const SizedBox(height: 16),

            // NAME + STATUS
            Text(
              car.nameCar,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text("Biển số: ${car.licensePlate}"),
            const SizedBox(height: 4),
            Row(
              children: [
                const Text("Trạng thái: "),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: car.status == 'Available' ? Colors.green[100] : Colors.red[100],
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    car.status == 'Available' ? 'Sẵn sàng' : (car.status ?? 'N/A'),
                    style: TextStyle(
                      color: car.status == 'Available' ? Colors.green[900] : Colors.red[900],
                      fontWeight: FontWeight.bold
                    ),
                  ),
                ),
              ],
            ),

            const Divider(height: 32),

            // DETAILS
            const Text("Thông tin chi tiết", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            _info("Năm sản xuất", "${car.modelYear}"),
            _info("Số ghế", "${car.seat}"),
            _info("Loại xe", car.typeCar),
            _info("Hộp số", car.transmission ?? "N/A"),
            _info("Nhiên liệu", car.fuelType ?? "N/A"),
            _info("Tiêu thụ", "${car.fuelConsumption} L/100km"),
            _info("Màu sắc", car.color ?? "N/A"),
            _info("Vị trí", car.location),
            _info("Giá thuê/ngày", price),
            _info("Tiền cọc", deposit),

            const SizedBox(height: 16),
            const Text(
              "Mô tả",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Text(car.description.isEmpty ? "Không có mô tả" : car.description),

            const SizedBox(height: 30),
            
            // ACTION BUTTONS (4 Operations)
            const Text("Thao tác", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 2.5,
              children: [
                _actionButton(
                  context, 
                  icon: Icons.edit, 
                  label: "Chỉnh sửa", 
                  color: Colors.blue, 
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => AddEditCarView(car: car)),
                    );
                  }
                ),
                _actionButton(
                  context, 
                  icon: Icons.calendar_month, 
                  label: "Lịch xe", 
                  color: Colors.orange, 
                  onTap: () {
                    if (car.carId != null) {
                       Navigator.push(
                         context,
                         MaterialPageRoute(builder: (_) => CarCalendarView(carId: car.carId!, carName: car.nameCar)),
                       );
                    }
                  }
                ),
                _actionButton(
                  context, 
                  icon: Icons.list_alt, 
                  label: "Đơn đặt", 
                  color: Colors.teal, 
                  onTap: () {
                    if (car.carId != null) {
                       Navigator.push(
                         context,
                         MaterialPageRoute(builder: (_) => CarBookingsView(carId: car.carId!, carName: car.nameCar)),
                       );
                    }
                  }
                ),
                _actionButton(
                  context, 
                  icon: Icons.delete, 
                  label: "Xóa xe", 
                  color: Colors.red, 
                  onTap: () => _confirmDelete(context, vm)
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _info(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 140, child: Text(label, style: const TextStyle(color: Colors.grey))),
          Expanded(child: Text(value, style: const TextStyle(fontWeight: FontWeight.w500))),
        ],
      ),
    );
  }

  Widget _actionButton(BuildContext context, {required IconData icon, required String label, required Color color, required VoidCallback onTap}) {
    return ElevatedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, size: 20),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: color.withOpacity(0.1),
        foregroundColor: color,
        elevation: 0,
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(horizontal: 16)
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context, OwnerCarViewModel vm) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Xóa xe"),
        content: const Text("Bạn có chắc chắn muốn xóa xe này không?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Hủy"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Xóa", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm == true && car.carId != null) {
      await vm.deleteCar(car.carId!);
      if (context.mounted) Navigator.pop(context); // back detail
    }
  }
}
