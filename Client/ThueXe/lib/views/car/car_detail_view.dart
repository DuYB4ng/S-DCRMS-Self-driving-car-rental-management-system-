import 'package:flutter/material.dart';

import '../../services/booking_service.dart';

class CarDetailView extends StatelessWidget {
  final dynamic car;

  CarDetailView({required this.car});
  Future<void> handleBooking(BuildContext context) async {
    try {
      final bookingService = BookingService();

      // TODO: Lấy ngày thuê thật từ HomeView → truyền qua arguments
      // Demo tạm thời (xử lý logic thật tùy bạn)
      final receiveDate = DateTime.now();
      final returnDate = DateTime.now().add(Duration(days: 1));
      final price = car["pricePerDay"] ?? 0;

      final res = await bookingService.createBooking(
        carId: car["carID"],
        receiveDate: receiveDate,
        returnDate: returnDate,
        totalPrice: price,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Đặt xe thành công!")),
      );

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Đặt xe thất bại: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          car["nameCar"] ?? "Chi tiết xe",
          style: TextStyle(color: Colors.black),
        ),
        iconTheme: IconThemeData(color: Colors.black),
      ),

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// ======== ẢNH SLIDER =========
            _imageSlider(car["imageUrls"]),

            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  /// ======== TÊN XE ========
                  Text(
                    car["nameCar"] ?? "Không rõ tên",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 6),

                  /// ======== GIÁ / NGÀY ========
                  Text(
                    "${car["pricePerDay"]} VNĐ / ngày",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.green.shade700,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),

                  /// ======== TIỀN CỌC ========
                  Text(
                    "Tiền cọc: ${car["deposit"]} VNĐ",
                    style: TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                  SizedBox(height: 16),


                  /// ======== THÔNG SỐ XE ========
                  Container(
                    padding: EdgeInsets.all(16),
                    margin: EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Thông số xe",
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 12),

                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            /// ======== CỘT TRÁI ========
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _specItem(Icons.confirmation_number, "Biển số", car["licensePlate"]),
                                  _specItem(Icons.event, "Năm SX", "${car["modelYear"]}"),
                                  _specItem(Icons.people_alt, "Số chỗ", "${car["seat"]}"),
                                  _specItem(Icons.color_lens, "Màu sắc", car["color"]),
                                ],
                              ),
                            ),

                            SizedBox(width: 12),

                            /// ======== CỘT PHẢI ========
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _specItem(Icons.car_rental, "Loại xe", car["typeCar"]),
                                  _specItem(Icons.settings, "Hộp số", car["transmission"]),
                                  _specItem(Icons.local_gas_station, "Nhiên liệu", car["fuelType"]),
                                  _specItem(Icons.speed, "Tiêu hao", "${car["fuelConsumption"]} L/100km"),
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
                    width: double.infinity,               // 🔥 FULL chiều ngang
                    padding: EdgeInsets.all(16),
                    margin: EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Mô tả",
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 8),

                        Text(
                          car["description"] ?? "Không có mô tả",
                          style: TextStyle(fontSize: 16, height: 1.4),
                        ),
                      ],
                    ),
                  ),





                  /// ======== GIẤY TỜ & ĐĂNG KIỂM ========
                  Container(
                    padding: EdgeInsets.all(16),
                    margin: EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Giấy tờ & Đăng kiểm",
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 12),

                        _infoRow("Ngày đăng ký",
                            car["registrationDate"]?.toString().substring(0, 10)),
                        _infoRow("Nơi đăng ký", car["registrationPlace"]),
                        _infoRow("Hạn bảo hiểm",
                            car["insuranceExpiryDate"]?.toString().substring(0, 10)),
                        _infoRow("Hạn đăng kiểm",
                            car["inspectionExpiryDate"]?.toString().substring(0, 10)),
                      ],
                    ),
                  ),

                ],
              ),
            ),
          ],
        ),
      ),

      /// ======== NÚT ĐẶT XE (CỐ ĐỊNH DƯỚI ĐÁY) ========
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(16),
        height: 80,
        child: ElevatedButton(
          onPressed: () async {
            await handleBooking(context);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF226EA3),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Text(
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
      padding: EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
              style: TextStyle(fontSize: 16, color: Colors.black87)),
          Text(value ?? "N/A",
              style:
              TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}
Widget _specItem(IconData icon, String title, String value) {
  return Padding(
    padding: EdgeInsets.only(bottom: 10),
    child: Row(
      children: [
        Icon(icon, size: 20, color: Colors.blueGrey),
        SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: TextStyle(fontSize: 14, color: Colors.black54)),
              Text(value,
                  style: TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ],
    ),
  );
}
