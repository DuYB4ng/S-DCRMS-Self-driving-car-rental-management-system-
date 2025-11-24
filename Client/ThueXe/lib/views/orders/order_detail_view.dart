import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../viewmodels/order_detail_viewmodel.dart';

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

            // Hàng nút hành động
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      // TODO: gắn số điện thoại, chat, gì đó cho "Liên hệ hỗ trợ"
                    },
                    child: const Text("Liên hệ hỗ trợ"),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // TODO: chuyển qua màn đánh giá chuyến đi
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Mở màn hình đánh giá (TODO)"),
                        ),
                      );
                    },
                    child: const Text("Đánh giá chuyến đi"),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),
            const Divider(),

            // PHẦN REVIEW (UI)
            const Text(
              "Đánh giá",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              "Bạn có thể đánh giá trải nghiệm chuyến đi của mình để chúng tôi phục vụ tốt hơn.",
              style: TextStyle(color: Colors.black54),
            ),
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
