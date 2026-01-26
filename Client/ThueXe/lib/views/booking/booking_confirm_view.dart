import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../services/booking_service.dart';
import '../../services/payment_service.dart';
import 'package:dio/dio.dart';

class BookingConfirmView extends StatefulWidget {
  final dynamic car;
  final DateTime receiveDate;
  final DateTime returnDate;

  const BookingConfirmView({
    super.key,
    required this.car,
    required this.receiveDate,
    required this.returnDate,
  });

  @override
  State<BookingConfirmView> createState() => _BookingConfirmViewState();
}

class _BookingConfirmViewState extends State<BookingConfirmView>
    with WidgetsBindingObserver {
  String selectedMethod = "Cash";
  int totalPrice = 0;

  // Lưu lại paymentId của giao dịch VNPay đang chờ
  int? _pendingPaymentId;

  // Cờ tránh check nhiều lần cùng lúc
  bool _isCheckingPayment = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    // Tính tổng tiền 1 lần ở đây
    final pricePerDay = (widget.car["pricePerDay"] as num).toInt();
    final deposit = (widget.car["deposit"] as num).toInt();
    final days = widget.returnDate.difference(widget.receiveDate).inDays <= 0
        ? 1
        : widget.returnDate.difference(widget.receiveDate).inDays;

    totalPrice = pricePerDay * days + deposit;
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    // App quay lại từ background (đi VNPay về)
    if (state == AppLifecycleState.resumed && _pendingPaymentId != null) {
      _checkPaymentStatus();
    }
  }

  @override
  Widget build(BuildContext context) {
    final car = widget.car;
    final carName = (car["carName"] ?? "").toString();
    final brandName = (car["brandName"] ?? "").toString();
    final pricePerDay = (car["pricePerDay"] as num).toInt();
    final deposit = (car["deposit"] as num).toInt();
    final days = widget.returnDate.difference(widget.receiveDate).inDays <= 0
        ? 1
        : widget.returnDate.difference(widget.receiveDate).inDays;

    return Scaffold(
      appBar: AppBar(title: const Text("Xác nhận đặt xe")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _box(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    carName.isEmpty ? "Xe" : carName,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (brandName.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(brandName, style: const TextStyle(fontSize: 16)),
                  ],
                  const SizedBox(height: 8),
                  _row("Nhận xe", widget.receiveDate.toString()),
                  _row("Trả xe", widget.returnDate.toString()),
                  _row("Số ngày thuê", "$days ngày"),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _box(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Chi phí",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  _row("Giá thuê / ngày", "$pricePerDay VNĐ"),
                  _row("Tiền cọc", "$deposit VNĐ"),
                  const Divider(height: 25),
                  _row("Tổng cộng", "$totalPrice VNĐ", isBold: true),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _box(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Phương thức thanh toán",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  _radioRow("Tiền mặt", "Cash"),
                  _radioRow("VNPay", "VNPAY"),
                ],
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => handleConfirmBooking(context),
                child: const Text("Xác nhận đặt xe"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==== UI helpers ====

  Widget _box({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: child,
    );
  }

  Widget _row(String title, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontSize: 16)),
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

  Widget _radioRow(String label, String value) {
    return Row(
      children: [
        Radio<String>(
          value: value,
          groupValue: selectedMethod,
          onChanged: (v) {
            if (v != null) {
              setState(() {
                selectedMethod = v;
              });
            }
          },
        ),
        Text(label),
      ],
    );
  }

  // ==== Logic đặt xe & thanh toán ====

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

        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Đặt xe & thanh toán tiền mặt thành công"),
          ),
        );

        Navigator.pop(context);
        return;
      }

      // 3️⃣ Thanh toán VNPay
      final deposit = (widget.car["deposit"] as num).toInt();
      final vnPayRes = await paymentService.createVnPayPayment(
        bookingId: bookingId,
        amount: deposit,
      );

      final paymentId =
          vnPayRes.data["paymentId"] ?? vnPayRes.data["paymentID"];
      final url = vnPayRes.data["paymentUrl"] as String;

      // Lưu lại paymentId để tí nữa check khi app resume
      setState(() {
        _pendingPaymentId = paymentId;
      });

      final uri = Uri.parse(url);
      final opened = await launchUrl(uri, mode: LaunchMode.externalApplication);
      if (!opened) {
        throw Exception("Không mở được VNPay");
      }
    } on DioException catch (e) {
      if (!mounted) return;

      final statusCode = e.response?.statusCode;
      final data = e.response?.data;
      String? backendMessage;

      if (data is Map && data["message"] != null) {
        backendMessage = data["message"].toString();
      }

      if (statusCode == 409) {
        // Lỗi trùng lịch / xe đang bảo trì (theo logic BE)
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              backendMessage ??
                  "Xe không khả dụng trong khoảng thời gian này (trùng lịch đặt hoặc đang bảo trì).",
            ),
          ),
        );
        return; // dừng, không chuyển sang bước thanh toán
      }

      // Các lỗi khác từ BE
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            backendMessage != null
                ? "Không thể đặt xe: $backendMessage"
                : "Có lỗi xảy ra khi đặt xe: ${e.message}",
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Có lỗi xảy ra khi thanh toán: $e")),
      );
    }
  }

  // ==== Check trạng thái payment khi app quay lại ====

  Future<void> _checkPaymentStatus() async {
    if (_isCheckingPayment || _pendingPaymentId == null) return;

    setState(() {
      _isCheckingPayment = true;
    });

    try {
      final paymentService = PaymentService();
      // GET /api/payment/{id}
      final res = await paymentService.getPaymentById(_pendingPaymentId!);

      // ví dụ BE trả: { "paymentID": 5, "status": "Completed", ... }
      final status = res.data["status"] as String?;

      if (!mounted) return;

      if (status == "Completed") {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Thanh toán VNPay thành công")),
        );
        Navigator.pop(context);
        _pendingPaymentId = null;
      } else if (status == "Failed") {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Thanh toán VNPay thất bại")),
        );
        _pendingPaymentId = null;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Thanh toán chưa hoàn tất (trạng thái: $status)"),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Lỗi kiểm tra thanh toán: $e")));
    } finally {
      if (mounted) {
        setState(() {
          _isCheckingPayment = false;
        });
      }
    }
  }
}
