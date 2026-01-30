import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'smart_checkin_view.dart';
import 'smart_checkout_view.dart';
import '../../viewmodels/order_detail_viewmodel.dart';
import '../../viewmodels/orders_viewmodel.dart';
import '../../services/review_service.dart';
import '../../services/booking_service.dart';
import 'package:dio/dio.dart';
import '../../services/wallet_service.dart';
import '../wallet_screen.dart';

class OrderDetailView extends StatefulWidget {
  final String orderId;
  final bool isOwnerView;

  const OrderDetailView({super.key, required this.orderId, this.isOwnerView = false});

  @override
  State<OrderDetailView> createState() => _OrderDetailViewState();
}

class _OrderDetailViewState extends State<OrderDetailView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
       // Load data ONCE when init
       Provider.of<OrderDetailViewModel>(context, listen: false).loadOrder(widget.orderId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<OrderDetailViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Chi tiết đơn hàng"),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: vm.isLoading
          ? const Center(child: CircularProgressIndicator())
          : vm.errorMessage != null
          ? Center(child: Text(vm.errorMessage!))
          : _buildDetail(
              context,
              vm.orderData!,
              vm.carData, // 👈 lấy thêm carData từ ViewModel
            ),
    );
  }

  /// Build chi tiết đơn hàng + thông tin xe
  Widget _buildDetail(
    BuildContext context,
    Map<String, dynamic> order,
    Map<String, dynamic>? car,
  ) {
    // Format ngày tạo hóa đơn
    final rawCreatedAt = order["createdAt"];
    final createdAt = _parseDateTime(rawCreatedAt);
    final createdAtText = createdAt != null
        ? DateFormat("dd/MM/yyyy HH:mm").format(createdAt)
        : "—";

    // Format ngày nhận / trả xe
    final rawStartDate = order["startDate"];
    final rawEndDate = order["endDate"];

    final startDate = _parseDateTime(rawStartDate);
    final endDate = _parseDateTime(rawEndDate);

    final startDateText = startDate != null
        ? DateFormat("dd/MM/yyyy HH:mm").format(startDate)
        : (rawStartDate?.toString() ?? "—");

    final endDateText = endDate != null
        ? DateFormat("dd/MM/yyyy HH:mm").format(endDate)
        : (rawEndDate?.toString() ?? "—");

    // Format tiền tệ
    final currencyFormat = NumberFormat.currency(locale: "vi_VN", symbol: "₫");

    // Tổng tiền (nếu API có trả totalPrice)
    final totalPrice = order["totalPrice"];
    final totalPriceText = totalPrice != null
        ? currencyFormat.format(totalPrice)
        : "—";

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "ĐƠN #${order["bookingID"]}",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // Thông tin chung của đơn
            _info("Mã đơn", "#${order["bookingID"]}"),
            _info("Ngày tạo hóa đơn", createdAtText),
            _info("Ngày nhận xe", startDateText),
            _info("Ngày trả xe", endDateText),
            _info("Trạng thái đơn", "${order["status"] ?? "—"}"),
            _info("Tổng tiền", totalPriceText),
            
            if (order["depositAmount"] != null && order["depositAmount"] > 0)
               _info("Tiền cọc", currencyFormat.format(order["depositAmount"])),

            if (order["cancellationFee"] != null && order["cancellationFee"] > 0)
               _info("Phí hủy chuyến", currencyFormat.format(order["cancellationFee"])),

            if (order["refundAmount"] != null && order["refundAmount"] > 0)
               _info("Số tiền hoàn lại", currencyFormat.format(order["refundAmount"])),

            const SizedBox(height: 24),

            // Nếu có thông tin xe thì hiển thị block "Thông tin xe"
            if (car != null) ...[
              const Divider(),
              const SizedBox(height: 8),
              const Text(
                "Thông tin xe",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _info("Tên xe", car["nameCar"]?.toString() ?? "—"),
                    _info("Biển số", car["licensePlate"]?.toString() ?? "—"),
                    _info(
                      "Số chỗ",
                      car["seat"] != null ? "${car["seat"]} chỗ" : "—",
                    ),
                    _info("Loại xe", car["typeCar"]?.toString() ?? "—"),
                    _info(
                      "Truyền động",
                      car["transmission"]?.toString() ?? "—",
                    ),
                    _info("Nhiên liệu", car["fuelType"]?.toString() ?? "—"),
                    _info("Màu sắc", car["color"]?.toString() ?? "—"),
                    _info(
                      "Địa điểm nhận xe",
                      car["location"]?.toString() ?? "—",
                    ),
                    _info(
                      "Giá / ngày",
                      car["pricePerDay"] != null
                          ? currencyFormat.format(car["pricePerDay"])
                          : "—",
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],


            
            // ===== ACTION BUTTONS SECTION =====
            if (car != null) ...[
                // OWNER ACTIONS
                if (widget.isOwnerView) ...[
                   if (order["status"] == "ReturnRequested" || order["status"] == "InProgress")
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.check_circle),
                          label: const Text("Xác nhận Trả xe & Thanh toán"),
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
                          onPressed: () async {
                             // Confirm Return
                             final confirm = await showDialog<bool>(
                               context: context,
                               builder: (ctx) => AlertDialog(
                                 title: const Text("Xác nhận"),
                                 content: const Text("Bạn đã nhận xe và thanh toán đầy đủ (nếu Tiền mặt)?\nHệ thống sẽ trừ hoa hồng 10% từ ví của bạn."),
                                 actions: [
                                   TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text("Hủy")),
                                   TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text("Đồng ý")),
                                 ],
                               )
                             );
                             
                             if (confirm == true) {
                                try {
                                  final bookingService = BookingService();
                                  await bookingService.confirmReturn(order["bookingID"]);
                                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Đã xác nhận thành công!")));
                                  Provider.of<OrderDetailViewModel>(context, listen: false).loadOrder(order["bookingID"].toString());
                                } catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Lỗi: $e")));
                                }
                             }
                          },
                        ),
                      ),
                ] 
                // CUSTOMER ACTIONS
                else ...[
                     // 1️⃣ Cancel Booking (Hủy chuyến)
                    if (order["status"] == "Pending" || order["status"] == "Approved" || order["status"] == "Paid")
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          icon: const Icon(Icons.cancel, color: Colors.red),
                          label: const Text("Hủy chuyến", style: TextStyle(color: Colors.red)),
                          style: OutlinedButton.styleFrom(side: const BorderSide(color: Colors.red)),
                          onPressed: () async {
                             final confirm = await showDialog<bool>(
                               context: context,
                               builder: (ctx) => AlertDialog(
                                 title: const Text("Hủy chuyến"),
                                 content: const Text("Bạn có chắc chắn muốn hủy chuyến? Phí hủy có thể áp dụng theo chính sách."),
                                 actions: [
                                   TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text("Không")),
                                   TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text("Hủy chuyến")),
                                 ],
                               )
                             );
                             
                             if (confirm == true) {
                                try {
                                  final bookingService = BookingService();
                                  final res = await bookingService.cancelBooking(order["bookingID"]);
                                  final data = res.data; // may contain fee info
                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("${data['message'] ?? 'Đã hủy chuyến thành công'}")));
                                  Provider.of<OrderDetailViewModel>(context, listen: false).loadOrder(order["bookingID"].toString());
                                } catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Lỗi: $e")));
                                }
                             }
                          },
                        ),
                      ),
                      const SizedBox(height: 10),

                    // 2️⃣ Smart Check-in (Nhận xe)
                    if ((order["status"] == "Paid" || order["status"] == "Approved" || order["status"] == "Pending") && !(order["checkIn"] ?? false))
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.camera_alt),
                          onPressed: () {
                             final startTime = _parseDateTime(order["startDate"]);
                             if (startTime != null) {
                                // Allow check-in 30 mins before
                                final checkInTime = startTime.subtract(const Duration(minutes: 30)); 
                                if (DateTime.now().isBefore(checkInTime)) {
                                   ScaffoldMessenger.of(context).showSnackBar(
                                     const SnackBar(content: Text("Chưa đến giờ nhận xe! Vui lòng chờ đến gần giờ hẹn.")),
                                   );
                                   return;
                                }
                             }

                             Navigator.push(
                               context,
                               MaterialPageRoute(
                                 builder: (context) => SmartCheckInView(
                                   orderId: order["bookingID"].toString(),
                                   expectedLicensePlate: car["licensePlate"]?.toString() ?? "",
                                   onCheckInSuccess: () {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text("Check-in thành công!")),
                                      );
                                      // Trigger reload inside callback
                                      Provider.of<OrderDetailViewModel>(context, listen: false).loadOrder(order["bookingID"].toString());
                                   },
                                 ),
                               ),
                             ).then((_) {
                                // Reload again when returning from page to be sure
                                Provider.of<OrderDetailViewModel>(context, listen: false).loadOrder(order["bookingID"].toString());
                             });
                          },
                          label: const Text("Smart Check-in (Nhận xe)"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueAccent,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),

                     // 3️⃣ Check-out / Thanh toán (Trả xe)
                     if (order["status"] == "InProgress" && (order["checkIn"] ?? false)) ...[
                       // Nút Thanh Toán & Checkout (như yêu cầu)
                       // Bấm nút này sẽ thực hiện thanh toán phần còn lại và chuyển sang trạng thái chờ Owner xác nhận trả xe
                        SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.payment),
                          onPressed: () => _handlePayment(context, order["bookingID"], false), // false = Remaining Payment
                          label: const Text("Thanh toán & Trả xe"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                     ],
                     
                     // ⏳ Đang chờ xác nhận
                     if (order["status"] == "ReturnRequested")
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.orange[50], 
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.orange)
                          ),
                          child: const Column(
                            children: [
                               Icon(Icons.hourglass_bottom, color: Colors.orange, size: 30),
                               SizedBox(height: 8),
                               Text(
                                 "Đang chờ chủ xe xác nhận trả xe...",
                                 style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold),
                               ),
                            ],
                          ),
                        ),

                     // 4️⃣ Đánh giá (Review)
                     if (order["status"] == "Completed" && ((order["reviews"] as List?)?.isEmpty ?? true))
                       SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.star),
                          onPressed: () async {
                              final result = await showDialog<_ReviewDialogResult>(
                                context: context,
                                builder: (context) => const _ReviewDialog(),
                              );

                              if (result != null) {
                                 // Call Review API
                                 final reviewService = ReviewService();
                                 try {
                                   await reviewService.createReview(
                                     bookingId: order["bookingID"], 
                                     rating: result.rating, 
                                     comment: result.comment
                                   );
                                   ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Đánh giá thành công!")));
                                   Provider.of<OrderDetailViewModel>(context, listen: false).loadOrder(order["bookingID"].toString());
                                 } catch (e) {
                                   ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Lỗi: $e")));
                                 }
                              }
                          },
                          label: const Text("Đánh giá chuyến đi"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.amber,
                            foregroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                ],
            ],

            const SizedBox(height: 24),
            const Divider(),

            // PHẦN REVIEW (UI) - Hiển thị review nếu có
            if ((order["reviews"] as List?)?.isNotEmpty ?? false) ...[
                const Text(
                  "Đánh giá của bạn",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(color: Colors.amber[50], borderRadius: BorderRadius.circular(8)),
                  child: Column(
                     crossAxisAlignment: CrossAxisAlignment.start,
                     children: [
                        Row(children: [
                           const Icon(Icons.star, color: Colors.amber, size: 20),
                           Text(" ${order["reviews"][0]["rating"]}/5", style: const TextStyle(fontWeight: FontWeight.bold))
                        ]),
                        const SizedBox(height: 4),
                        Text("${order["reviews"][0]["comment"]}")
                     ],
                  ),
                )
            ] else ...[
                const Text(
                  "Đánh giá",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Bạn có thể đánh giá trải nghiệm chuyến đi của mình sau khi hoàn thành đơn hàng.",
                  style: TextStyle(color: Colors.black54),
                ),
            ],
          ],
        ),
      ),
    );
  }

  /// Helper parse DateTime từ String / DateTime / null
  DateTime? _parseDateTime(dynamic raw) {
    if (raw == null) return null;
    if (raw is DateTime) return raw;
    if (raw is String) {
      return DateTime.tryParse(raw);
    }
    return null;
  }

  Widget _info(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.black54)),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handlePayment(BuildContext context, int bookingId, bool isDeposit) async {
       final currencyFormat = NumberFormat.currency(locale: 'vi_VN', symbol: '₫');
       final vm = Provider.of<OrderDetailViewModel>(context, listen: false);
       final order = vm.orderData;
       if (order == null) return;

       // 1. Calculate Amounts
       num deposit = order["depositAmount"] ?? 0;
       num total = order["totalPrice"] ?? 0;

       // Fallback: If TotalPrice is 0 (missing/error), try to calculate from Car Price
       if (total <= 0 || (total < deposit && !isDeposit)) {
          final car = vm.carData;
          if (car != null && car["pricePerDay"] != null) {
             final start = _parseDateTime(order["startDate"]);
             final end = _parseDateTime(order["endDate"]);
             if (start != null && end != null) {
                 int days = end.difference(start).inDays;
                 if (days < 1) days = 1; // Min 1 day
                 num price = car["pricePerDay"];
                 total = days * price;
                 // Remove forced deposit calculation to trust API data
                 // if (deposit == 0) deposit = total * 0.3; 
             }
          }
       }

       num amountToPay = 0;
       if (isDeposit) {
           amountToPay = deposit;
       } else {
           amountToPay = total;
       }

       // 2. Fetch Wallet Balance
       final walletService = WalletService();
       num balance = 0;
       try {
           final res = await walletService.getBalance();
           balance = res.data["balance"] ?? 0;
       } catch (e) {
           ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Lỗi lấy số dư ví: $e")));
           return;
       }
       
       final fmt = NumberFormat.currency(locale: 'vi_VN', symbol: '₫');
       bool isEnough = balance >= amountToPay;
       if (amountToPay <= 0) isEnough = true;

       // 3. Show Detailed Dialog FIRST
       await showModalBottomSheet(
           context: context,
           isScrollControlled: true,
           shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
           builder: (context) {
               return Padding(
                   padding: const EdgeInsets.all(24.0),
                   child: Column(
                       mainAxisSize: MainAxisSize.min,
                       crossAxisAlignment: CrossAxisAlignment.start,
                       children: [
                           Text(isDeposit ? "Thanh toán Tiền cọc" : "Thanh toán & Trả xe", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                           const SizedBox(height: 16),
                           
                           _billRow("Tổng hóa đơn (Thuê xe)", fmt.format(total), isBold: true),
                           if (!isDeposit) _billRow("Tiền cọc (Đã cọc)", fmt.format(deposit), color: Colors.green),
                           
                           const Divider(height: 24),
                           _billRow("CẦN THANH TOÁN", fmt.format(amountToPay), isBold: true, color: Colors.orange[800]),
                           const SizedBox(height: 8),
                           
                           // Wallet Info
                           Container(
                               padding: const EdgeInsets.all(12),
                               decoration: BoxDecoration(
                                   color: isEnough ? Colors.green[50] : Colors.red[50], 
                                   borderRadius: BorderRadius.circular(8)
                               ),
                               child: Row(
                                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                   children: [
                                       const Text("Ví của bạn:"),
                                       Text(fmt.format(balance), style: TextStyle(fontWeight: FontWeight.bold, color: isEnough ? Colors.green : Colors.red)),
                                   ],
                               ),
                           ),
                           if (!isEnough)
                               Padding(
                                 padding: const EdgeInsets.only(top: 8.0),
                                 child: Text("Thiếu: ${fmt.format(amountToPay - balance)}", style: const TextStyle(color: Colors.red, fontStyle: FontStyle.italic)),
                               ),

                           const SizedBox(height: 24),
                           
                           // Action: PAY WALLET
                           SizedBox(
                               width: double.infinity,
                               child: ElevatedButton(
                                   style: ElevatedButton.styleFrom(
                                       padding: const EdgeInsets.symmetric(vertical: 14),
                                       backgroundColor: isEnough ? Colors.orange : Colors.blue,
                                       foregroundColor: Colors.white
                                   ),
                                   onPressed: () async {
                                       if (isEnough) {
                                           Navigator.pop(context);
                                           await _processPayment(context, bookingId, isDeposit, isCash: false);
                                       } else {
                                           Navigator.pop(context);
                                           await Navigator.push(context, MaterialPageRoute(builder: (_) => const WalletScreen()));
                                       }
                                   },
                                   child: Text(isEnough ? (isDeposit ? "Thanh toán Cọc (Ví)" : "Thanh toán & Trả xe (Ví)") : "Nạp tiền vào ví"),
                               ),
                           ),
                           
                           // Action: PAY CASH (Only for Checkout/Return)
                           if (!isDeposit) ...[
                               const SizedBox(height: 12),
                               SizedBox(
                                   width: double.infinity,
                                   child: OutlinedButton.icon(
                                       icon: const Icon(Icons.money),
                                       style: OutlinedButton.styleFrom(
                                           padding: const EdgeInsets.symmetric(vertical: 14),
                                           side: const BorderSide(color: Colors.green),
                                           foregroundColor: Colors.green
                                       ),
                                       onPressed: () async {
                                            Navigator.pop(context);
                                            await _processPayment(context, bookingId, isDeposit, isCash: true);
                                       },
                                       label: const Text("Thanh toán Trực tiếp (Tiền mặt)"),
                                   ),
                               ),
                               const Padding(
                                  padding: EdgeInsets.only(top: 8.0),
                                  child: Text(
                                    "* Bạn sẽ thanh toán trực tiếp cho chủ xe khi gặp mặt. Hệ thống chỉ ghi nhận yêu cầu trả xe.",
                                    style: TextStyle(fontSize: 12, color: Colors.black54, fontStyle: FontStyle.italic),
                                  ),
                               )
                           ]
                       ],
                   ),
               );
           }
       );
  }

  Widget _billRow(String label, String value, {bool isBold = false, Color? color}) {
      return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                  Text(label, style: TextStyle(fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
                  Text(value, style: TextStyle(fontWeight: isBold ? FontWeight.bold : FontWeight.normal, color: color)),
              ],
          ),
      );
  }

  Future<void> _processPayment(BuildContext context, int bookingId, bool isDeposit, {required bool isCash}) async {
         final bookingService = BookingService();
         
         final vm = Provider.of<OrderDetailViewModel>(context, listen: false);
         final order = vm.orderData;
         num deposit = order?["depositAmount"] ?? 0;
         num total = order?["totalPrice"] ?? 0;
         num amountToPay = isDeposit ? deposit : total;

         // Phase 1: Payment (Skip if Cash)
         if (!isCash && amountToPay > 0) {
            try {
              await bookingService.payBooking(bookingId, isDeposit);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Thanh toán thành công!")),
              );
            } catch (e) {
               String msg = e.toString();
               if (e is DioException) {
                  msg = e.response?.data?["Message"] ?? e.response?.data?["message"] ?? e.message ?? "Lỗi không xác định"; 
               }
               ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Lỗi thanh toán: $msg")));
               return; 
            }
         }

         // Phase 2: Checkout (Return Request)
         // Assuming if we paid, we want to checkout.
         // If Cash, we assume payment happens physically, so we just request return.
         if (!isDeposit) {
             try {
               await bookingService.requestCheckOut(bookingId);
               String successMsg = isCash 
                   ? "Đã gửi yêu cầu trả xe. Vui lòng thanh toán tiền mặt cho chủ xe." 
                   : "Đã gửi yêu cầu trả xe.";
               ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(successMsg)));
             } catch (e) {
                 String msg = e.toString();
                 if (e is DioException) {
                    msg = e.response?.data?["Message"] ?? e.response?.data?["message"] ?? e.message ?? "Lỗi không xác định"; 
                 }
                 ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Lỗi trả xe: $msg")));
             }
         }
         
         // Reload Layout
         if (context.mounted) {
             await Future.delayed(const Duration(milliseconds: 1000));
             if (context.mounted) {
                // Force reload
                final vm = Provider.of<OrderDetailViewModel>(context, listen: false);
                vm.loadOrder(bookingId.toString());
             }
         }
  }
} // End Class

class _ReviewDialogResult {
  final int rating;
  final String comment;
  _ReviewDialogResult(this.rating, this.comment);
}

class _ReviewDialog extends StatefulWidget {
  const _ReviewDialog();

  @override
  State<_ReviewDialog> createState() => _ReviewDialogState();
}

class _ReviewDialogState extends State<_ReviewDialog> {
  int _rating = 5;
  final TextEditingController _commentController = TextEditingController();

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Đánh giá chuyến thuê"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text("Chọn số sao:"),
          DropdownButton<int>(
            value: _rating,
            items: List.generate(5, (i) {
              final v = i + 1;
              return DropdownMenuItem(value: v, child: Text("$v sao"));
            }),
            onChanged: (v) {
              if (v != null) {
                setState(() {
                  _rating = v;
                });
              }
            },
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _commentController,
            maxLines: 3,
            decoration: const InputDecoration(
              labelText: "Nhận xét",
              border: OutlineInputBorder(),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Hủy"),
        ),
        ElevatedButton(
          onPressed: () {
            final comment = _commentController.text.trim();
            Navigator.pop(context, _ReviewDialogResult(_rating, comment));
          },
          child: const Text("Gửi"),
        ),
      ],
    );
  }
}
