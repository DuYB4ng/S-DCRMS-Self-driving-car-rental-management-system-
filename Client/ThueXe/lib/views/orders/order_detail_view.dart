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
          : _buildDetail(context, vm.orderData!),
    );
  }

  /// THÊM BuildContext để dùng SnackBar / Navigator nếu cần
  Widget _buildDetail(BuildContext context, Map<String, dynamic> order) {
    // Lấy createdAt từ API và parse về DateTime an toàn
    final rawCreatedAt = order["createdAt"];
    DateTime? createdAt;

    if (rawCreatedAt != null) {
      if (rawCreatedAt is String) {
        createdAt = DateTime.tryParse(rawCreatedAt);
      } else if (rawCreatedAt is DateTime) {
        createdAt = rawCreatedAt;
      }
    }

    final createdAtText = createdAt != null
        ? DateFormat("dd/MM/yyyy HH:mm").format(createdAt)
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

            _info("Mã đơn", "#${order["bookingID"]}"),
            _info("Ngày tạo hóa đơn", createdAtText),
            _info("Ngày nhận xe", "${order["startDate"]}"),
            _info("Ngày trả xe", "${order["endDate"]}"),
            _info("Trạng thái", "${order["status"]}"),

            const SizedBox(height: 24),

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
                      // Ở đây tạm thời chỉ show SnackBar.
                      // Nếu có màn Review riêng thì thay bằng Navigator.push(...)
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
