import 'package:flutter/material.dart';

import '../../services/booking_service.dart';
import '../booking/booking_confirm_view.dart';
import '../../services/review_service.dart';

class CarDetailView extends StatelessWidget {
  final dynamic car;

  final DateTime receiveDate;
  final DateTime returnDate;

  const CarDetailView({super.key, 
    required this.car,
    required this.receiveDate,
    required this.returnDate,
  });

  Future<void> handleBooking(BuildContext context) async {
    try {
      final bookingService = BookingService();

      final price = car["pricePerDay"] ?? 0;

      final res = await bookingService.createBooking(
        carId: car["carID"],
        receiveDate: receiveDate,
        returnDate: returnDate,
        totalPrice: price,
      );

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Đặt xe thành công!")));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Đặt xe thất bại: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    // Service lấy review theo car
    final ReviewService reviewService = ReviewService();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          car["nameCar"] ?? "Chi tiết xe",
          style: const TextStyle(color: Colors.black),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// ======== ẢNH SLIDER =========
            _imageSlider(car["imageUrls"]),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// ======== TÊN XE ========
                  Text(
                    car["nameCar"] ?? "Không rõ tên",
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),

                  /// ======== GIÁ / NGÀY ========
                  Text(
                    "${car["pricePerDay"]} VNĐ / ngày",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.green.shade700,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),

                  /// ======== TIỀN CỌC ========
                  Text(
                    "Tiền cọc: ${car["deposit"]} VNĐ",
                    style: const TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                  const SizedBox(height: 16),

                  /// ======== THÔNG SỐ XE ========
                  Container(
                    padding: const EdgeInsets.all(16),
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Thông số xe",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),

                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            /// ======== CỘT TRÁI ========
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _specItem(
                                    Icons.confirmation_number,
                                    "Biển số",
                                    car["licensePlate"],
                                  ),
                                  _specItem(
                                    Icons.event,
                                    "Năm SX",
                                    "${car["modelYear"]}",
                                  ),
                                  _specItem(
                                    Icons.people_alt,
                                    "Số chỗ",
                                    "${car["seat"]}",
                                  ),
                                  _specItem(
                                    Icons.color_lens,
                                    "Màu sắc",
                                    car["color"],
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(width: 12),

                            /// ======== CỘT PHẢI ========
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _specItem(
                                    Icons.car_rental,
                                    "Loại xe",
                                    car["typeCar"],
                                  ),
                                  _specItem(
                                    Icons.settings,
                                    "Hộp số",
                                    car["transmission"],
                                  ),
                                  _specItem(
                                    Icons.local_gas_station,
                                    "Nhiên liệu",
                                    car["fuelType"],
                                  ),
                                  _specItem(
                                    Icons.speed,
                                    "Tiêu hao",
                                    "${car["fuelConsumption"]} L/100km",
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  /// ======== MÔ TẢ ========
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Mô tả",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          car["description"] ?? "Không có mô tả",
                          style: const TextStyle(fontSize: 16, height: 1.4),
                        ),
                      ],
                    ),
                  ),

                  /// ======== GIẤY TỜ & ĐĂNG KIỂM ========
                  Container(
                    padding: const EdgeInsets.all(16),
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Giấy tờ & Đăng kiểm",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        _infoRow(
                          "Ngày đăng ký",
                          car["registrationDate"]?.toString().substring(0, 10),
                        ),
                        _infoRow("Nơi đăng ký", car["registrationPlace"]),
                        _infoRow(
                          "Hạn bảo hiểm",
                          car["insuranceExpiryDate"]?.toString().substring(
                            0,
                            10,
                          ),
                        ),
                        _infoRow(
                          "Hạn đăng kiểm",
                          car["inspectionExpiryDate"]?.toString().substring(
                            0,
                            10,
                          ),
                        ),
                      ],
                    ),
                  ),

                  /// ======== ĐÁNH GIÁ ========
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Đánh giá",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        FutureBuilder(
                          future: reviewService.getReviewsByCar(
                            car["carID"] as int,
                          ),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }

                            if (snapshot.hasError) {
                              return Text(
                                "Lỗi tải đánh giá: ${snapshot.error}",
                              );
                            }

                            final res = snapshot.data;
                            if (res == null) {
                              return const Text("Không có dữ liệu đánh giá");
                            }

                            // res.data là danh sách review từ API
                            final List<dynamic> data =
                                (res.data as List<dynamic>? ?? []);

                            if (data.isEmpty) {
                              return const Text("Chưa có đánh giá cho xe này");
                            }

                            final avgRating =
                                data
                                    .map((e) => (e["rating"] as num).toDouble())
                                    .fold<double>(0, (sum, r) => sum + r) /
                                data.length;

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Trung bình: ${avgRating.toStringAsFixed(1)}⭐ (${data.length} đánh giá)",
                                ),
                                const SizedBox(height: 8),
                                ...data.map((r) {
                                  return ListTile(
                                    contentPadding: EdgeInsets.zero,
                                    title: Text("${r["rating"]}⭐"),
                                    subtitle: Text(r["comment"] ?? ""),
                                  );
                                }),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

      /// ======== NÚT ĐẶT XE ========
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        height: 80,
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => BookingConfirmView(
                  car: car,
                  receiveDate: receiveDate,
                  returnDate: returnDate,
                ),
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF226EA3),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Text(
            "Đặt xe ngay",
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
        ),
      ),
    );
  }

  /// ============ IMAGE SLIDER ============
  Widget _imageSlider(List<dynamic>? images) {
    if (images == null || images.isEmpty) {
      return Image.network(
        "https://via.placeholder.com/350x200",
        width: double.infinity,
        height: 220,
        fit: BoxFit.cover,
      );
    }

    return SizedBox(
      height: 220,
      child: PageView.builder(
        itemCount: images.length,
        itemBuilder: (context, index) {
          return Image.network(
            images[index],
            width: double.infinity,
            height: 220,
            fit: BoxFit.cover,
          );
        },
      ),
    );
  }

  /// ============ THÔNG TIN XE (ROW) ============
  Widget _infoRow(String title, String? value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16, color: Colors.black87),
          ),
          Text(
            value ?? "N/A",
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}

Widget _specItem(IconData icon, String title, String value) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: Row(
      children: [
        Icon(icon, size: 20, color: Colors.blueGrey),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(fontSize: 14, color: Colors.black54),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
