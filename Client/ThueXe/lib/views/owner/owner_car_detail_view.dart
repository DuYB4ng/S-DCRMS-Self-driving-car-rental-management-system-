import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/car.dart';
import '../../viewmodels/owner_car_viewmodel.dart';
import 'car_calendar_view.dart';

class OwnerCarDetailView extends StatelessWidget {
  final Car car;
  final String baseUrl;

  const OwnerCarDetailView({
    super.key,
    required this.car,
    required this.baseUrl,
  });

  String _imageUrl() {
    if (car.imageUrls.isNotEmpty) {
      final img = car.imageUrls.first;
      if (img.startsWith('http')) return img;
      return "${baseUrl.replaceAll('/api', '')}$img";
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.read<OwnerCarViewModel>();
    final imageUrl = _imageUrl();

    return Scaffold(
      appBar: AppBar(
        title: Text(car.nameCar),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () => _confirmDelete(context, vm),
          ),
        ],
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
                        child: const Icon(Icons.car_rental, size: 60),
                      ),
                    )
                  : Container(
                      height: 220,
                      alignment: Alignment.center,
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
            Text("Trạng thái: ${car.status}"),
            Text("Hoạt động: ${car.isActive ? "Có" : "Không"}"),

            const Divider(height: 32),

            // DETAILS
            _info("Năm sản xuất", car.modelYear.toString()),
            _info("Số ghế", car.seat.toString()),
            _info("Loại xe", car.typeCar),
            _info("Hộp số", car.transmission),
            _info("Nhiên liệu", car.fuelType),
            _info("Tiêu thụ", "${car.fuelConsumption} L/100km"),
            _info("Màu", car.color),
            _info("Vị trí", car.location),
            _info("Giá/ngày", "${car.pricePerDay ?? 0}"),
            _info("Tiền cọc", "${car.deposit ?? 0}"),

            const SizedBox(height: 16),
            const Text(
              "Mô tả",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Text(car.description),

            const SizedBox(height: 24),

            // CALENDAR
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.calendar_month),
                label: const Text("Lịch đặt xe"),
                onPressed: () {
                  if (car.carId == null) return;
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => CarCalendarView(
                        carId: car.carId!,
                        carName: car.nameCar,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _info(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(width: 140, child: Text(label)),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context, OwnerCarViewModel vm) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Delete Car"),
        content: const Text("Are you sure you want to delete this car?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Delete"),
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
