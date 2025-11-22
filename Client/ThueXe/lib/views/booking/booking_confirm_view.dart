import 'package:flutter/material.dart';
import '../../services/booking_service.dart';
import '../../services/payment_service.dart';
import 'package:url_launcher/url_launcher.dart';

class BookingConfirmView extends StatefulWidget {
  final dynamic car;
  final DateTime receiveDate;
  final DateTime returnDate;

  BookingConfirmView({
    required this.car,
    required this.receiveDate,
    required this.returnDate,
  });

  @override
  _BookingConfirmViewState createState() => _BookingConfirmViewState();
}

class _BookingConfirmViewState extends State<BookingConfirmView> {
  String selectedMethod = "Cash";          // Thanh toán mặc định
  int totalPrice = 0;

  @override
  void initState() {
    super.initState();

    final pricePerDay = (widget.car["pricePerDay"] as num).toInt();
    final deposit = (widget.car["deposit"] as num).toInt();

    final days = widget.returnDate.difference(widget.receiveDate).inDays <= 0
        ? 1
        : widget.returnDate.difference(widget.receiveDate).inDays;

    totalPrice = pricePerDay * days + deposit;
  }

  @override
  Widget build(BuildContext context) {
    final pricePerDay = (widget.car["pricePerDay"] as num).toInt();
    final deposit = (widget.car["deposit"] as num).toInt();

    final days = widget.returnDate.difference(widget.receiveDate).inDays <= 0
        ? 1
        : widget.returnDate.difference(widget.receiveDate).inDays;

    return Scaffold(
      appBar: AppBar(
        title: Text("Xác nhận đặt xe"),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),

      backgroundColor: Colors.grey[100],

      body: SingleChildScrollView(
        child: Column(
          children: [
            _box(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.car["nameCar"],
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  _row("Loại xe", widget.car["typeCar"]),
                  _row("Biển số", widget.car["licensePlate"]),
                  _row("Màu sắc", widget.car["color"]),
                ],
              ),
            ),

            _box(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Thời gian thuê",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  _row("Nhận xe", widget.receiveDate.toString().substring(0, 16)),
                  _row("Trả xe", widget.returnDate.toString().substring(0, 16)),
                  _row("Tổng số ngày", "$days ngày"),
                ],
              ),
            ),

            _box(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Chi phí",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  _row("Giá thuê / ngày", "$pricePerDay VNĐ"),
                  _row("Tiền cọc", "$deposit VNĐ"),
                  Divider(height: 25),
                  _row("Tổng thanh toán", "$totalPrice VNĐ", isBold: true),
                ],
              ),
            ),

            _box(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Phương thức thanh toán",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  SizedBox(height: 12),

                  RadioListTile(
                    title: Text("Thanh toán tiền mặt"),
                    value: "Cash",
                    groupValue: selectedMethod,
                    onChanged: (v) => setState(() => selectedMethod = v!),
                  ),

                  RadioListTile(
                    title: Text("Thanh toán VNPay"),
                    value: "VNPAY",
                    groupValue: selectedMethod,
                    onChanged: (v) => setState(() => selectedMethod = v!),
                  ),
                ],
              ),
            ),

            SizedBox(height: 100),
          ],
        ),
      ),

      bottomNavigationBar: Container(
        padding: EdgeInsets.all(16),
        height: 80,
        child: ElevatedButton(
          onPressed: () => handleConfirmBooking(context),
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF226EA3),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Text(
            "Xác nhận & Thanh toán",
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
        ),
      ),
    );
  }

  Widget _box({required Widget child}) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: child,
    );
  }

  Widget _row(String title, String value, {bool isBold = false}) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: TextStyle(fontSize: 16)),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> handleConfirmBooking(BuildContext context) async {
    try {
      final bookingService = BookingService();

      // 1️⃣ Tạo booking trước
      final bookingRes = await bookingService.createBooking(
        carId: widget.car["carID"],
        receiveDate: widget.receiveDate,
        returnDate: widget.returnDate,
        totalPrice: totalPrice,
      );

      final bookingId = bookingRes.data["bookingID"];
      final paymentService = PaymentService();

      // 2️⃣ Thanh toán tiền mặt
      if (selectedMethod == "Cash") {
        await paymentService.createCashPayment(
          bookingId: bookingId,
          amount: totalPrice,
        );

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Đặt xe & thanh toán tiền mặt thành công")),
        );

        Navigator.pop(context);
        return;
      }

      // 3️⃣ Thanh toán VNPay
      final vnPayRes = await paymentService.createVnPayPayment(
        bookingId: bookingId,
        amount: totalPrice,
      );

      final url = vnPayRes.data["paymentUrl"];

      if (!await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication)) {
        throw Exception("Không mở được VNPay");
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Lỗi thanh toán: $e")),
      );
    }
  }
}
