import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../services/booking_service.dart';
import '../../services/payment_service.dart';
import '../../services/wallet_service.dart';
import '../wallet_screen.dart';
import 'package:dio/dio.dart';
import '../orders/order_detail_view.dart';

class BookingConfirmView extends StatefulWidget {
// ... (keep class definition)
// ...

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
  num walletBalance = 0;
  bool isWalletLoaded = false;

  // Lưu lại paymentId của giao dịch VNPay đang chờ
  int? _pendingPaymentId;

  // Cờ tránh check nhiều lần cùng lúc
  bool _isCheckingPayment = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    // Tính tổng tiền 1 lần ở đây
    // Tính tổng tiền 1 lần ở đây (Chỉ tính tiền thuê - Thế chấp là riêng)
    final pricePerDay = (widget.car["pricePerDay"] as num).toInt();
    // final deposit = (widget.car["deposit"] as num).toInt(); // Collateral, not included in Total Rental Price
    final days = widget.returnDate.difference(widget.receiveDate).inDays <= 0
        ? 1
        : widget.returnDate.difference(widget.receiveDate).inDays;

    totalPrice = pricePerDay * days;
    
    _loadWalletBalance();
  }

  Future<void> _loadWalletBalance() async {
     try {
       final walletService = WalletService();
       final res = await walletService.getBalance();
       if (res.data != null) {
          setState(() {
            walletBalance = res.data["balance"] ?? 0;
            isWalletLoaded = true;
          });
       }
     } catch (e) {
       print("Error loading wallet: $e");
     }
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
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight - 32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
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
                            _row("Nhận xe", widget.receiveDate.toString().substring(0, 16)),
                            _row("Trả xe", widget.returnDate.toString().substring(0, 16)),
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
                            _row("Thế chấp (sẽ hoàn lại)", "$deposit VNĐ"), 
                            const Divider(height: 25),
                            _row("Tổng tiền thuê", "$totalPrice VNĐ", isBold: true),
                            const SizedBox(height: 8),
                            Text(
                              "Cần thanh toán trước (Thế chấp): $deposit VNĐ",
                              style: const TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold),
                            ),
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
                            _radioRow("Ví của tôi (Số dư: ${walletBalance.toInt()}đ)", "Wallet"),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  if (selectedMethod == "Wallet") ...[
                     if (!isWalletLoaded)
                        const Center(child: CircularProgressIndicator())
                     else if (walletBalance < deposit) 
                       Column(
                         children: [
                            Text(
                              "Số dư không đủ để cọc ($deposit đ)",
                              style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 10),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                onPressed: () async {
                                   await Navigator.push(context, MaterialPageRoute(builder: (context) => const WalletScreen()));
                                   _loadWalletBalance();
                                }, 
                                icon: const Icon(Icons.add),
                                label: const Text("Nạp thêm tiền"),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.orange,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(vertical: 12)
                                ),
                              ),
                            )
                         ],
                       )
                     else
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () => handleConfirmBooking(context),
                            child: Text("Xác nhận & Cọc ngay ($deposit đ)"),
                            style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 12)),
                          ),
                        )
                  ] else 
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => handleConfirmBooking(context),
                        child: const Text("Xác nhận đặt xe"),
                        style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 12)),
                      ),
                    ),
                ],
              ),
            ),
          );
        }
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
        depositAmount: (widget.car["deposit"] as num).toInt(),
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

        _navigateToOrder(bookingId.toString());
        return;
      }

      // 3️⃣ Thanh toán Ví (Collateral)
      if (selectedMethod == "Wallet") {
         final deposit = (widget.car["deposit"] as num).toInt();
         
         if (walletBalance < deposit) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Số dư không đủ để cọc.")));
            return;
         }

         // Call Payment (Deposit) IMMEDIATELY
         await bookingService.payBooking(bookingId, true); // true = deposit

         if (!mounted) return;
         ScaffoldMessenger.of(context).showSnackBar(
           const SnackBar(
             content: Text("Đặt xe & Trừ cọc thành công!"),
           ),
         );

         _navigateToOrder(bookingId.toString());
         return;
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
  
  void _navigateToOrder(String bookingId) {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) => OrderDetailView(orderId: bookingId),
      ),
      (route) => route.isFirst,
    );
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
