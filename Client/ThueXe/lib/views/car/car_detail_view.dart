import 'package:flutter/material.dart';

class CarDetailView extends StatelessWidget {
  final dynamic car;

  CarDetailView({required this.car});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(car["nameCar"]),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Ảnh xe
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                car["imageUrls"] != null && car["imageUrls"].isNotEmpty
                    ? car["imageUrls"][0]
                    : "https://via.placeholder.com/350x200",
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 16),

            Text("Thông tin chi tiết",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            SizedBox(height: 12),

            _detail("Biển số", car["licensePlate"]),
            _detail("Năm sản xuất", "${car["modelYear"]}"),
            _detail("Số chỗ", "${car["seat"]}"),
            _detail("Loại xe", car["typeCar"]),
            _detail("Hộp số", car["transmission"]),
            _detail("Nhiên liệu", car["fuelType"]),
            _detail("Mức tiêu hao", "${car["fuelConsumption"]} L/100km"),
            _detail("Màu sắc", car["color"]),
            _detail("Tiền cọc", "${car["deposit"]} VNĐ"),
            _detail("Khu vực", car["location"]),
            _detail("Mô tả", car["description"] ?? "Không có mô tả"),
          ],
        ),
      ),
    );
  }

  Widget _detail(String title, String? value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8),
      child: Text(
        "$title: ${value ?? "N/A"}",
        style: TextStyle(fontSize: 16),
      ),
    );
  }
}
