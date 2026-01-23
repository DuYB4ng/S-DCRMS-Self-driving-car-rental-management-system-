import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'smart_checkin_view.dart';
import 'smart_checkout_view.dart';
import '../../viewmodels/order_detail_viewmodel.dart';
import '../../viewmodels/orders_viewmodel.dart';
import '../../services/review_service.dart';

class OrderDetailView extends StatelessWidget {
  final String orderId;

  const OrderDetailView({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<OrderDetailViewModel>(context);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (vm.orderData == null && !vm.isLoading) {
        vm.loadOrder(orderId);
      }
    });

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
                // 1️⃣ Smart Check-in (Nhận xe)
                // Điều kiện: Status = 'Paid' / 'Approved' / 'Pending' (Demo) và chưa Check-in
                if ((order["status"] == "Paid" || order["status"] == "Approved" || order["status"] == "Pending") && !(order["checkIn"] ?? false))
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.camera_alt),
                      onPressed: () {
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
                                  // Reload
                                  Provider.of<OrderDetailViewModel>(context, listen: false).loadOrder(order["bookingID"].toString());
                               },
                             ),
                           ),
                         );
                      },
                      label: const Text("Smart Check-in (Nhận xe)"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),

                 // 2️⃣ Check-out (Trả xe)
                 // Điều kiện: Status = 'InProgress' (Đang thuê) và đã Check-in và chưa Check-out
                 if (order["status"] == "InProgress" && (order["checkIn"] ?? false) && !(order["checkOut"] ?? false))
                   SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.exit_to_app),
                      onPressed: () {
                         // Navigate to Smart Check-out
                         Navigator.push(
                           context,
                           MaterialPageRoute(
                             builder: (context) => SmartCheckOutView(
                               orderId: order["bookingID"].toString(),
                               expectedLicensePlate: car["licensePlate"]?.toString() ?? "",
                               onCheckOutSuccess: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text("Trả xe thành công!")),
                                  );
                                  // Reload
                                  Provider.of<OrderDetailViewModel>(context, listen: false).loadOrder(order["bookingID"].toString());
                               },
                             ),
                           ),
                         );
                      },
                      label: const Text("Smart Check-out (Trả xe)"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),

                 // 3️⃣ Đánh giá (Review)
                 // Điều kiện: Status = 'Completed' và chưa đánh giá
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
}

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
