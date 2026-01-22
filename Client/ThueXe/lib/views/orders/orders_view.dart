import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../viewmodels/orders_viewmodel.dart';
import 'order_detail_view.dart';
import '../../services/review_service.dart';
import '../../services/payment_service.dart';

class OrdersView extends StatelessWidget {
  OrdersView({super.key});

  final ReviewService _reviewService = ReviewService();
  final PaymentService _paymentService = PaymentService();

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<OrdersViewModel>(context);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      vm.loadOrders();
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text("Lịch sử đơn hàng"),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: vm.isLoading
          ? const Center(child: CircularProgressIndicator())
          : vm.errorMessage != null
          ? Center(child: Text(vm.errorMessage!))
          : vm.orders.isEmpty
          ? const Center(child: Text("Chưa có đơn hàng"))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: vm.orders.length,
              itemBuilder: (context, index) {
                final order = vm.orders[index] as Map<String, dynamic>;

                // 🔹 Lấy danh sách review từ API (Booking có List<Review> Reviews)
                final List<dynamic> reviews =
                    (order["reviews"] as List?) ??
                    []; // nếu null thì dùng list rỗng
                final bool hasReview = reviews.isNotEmpty;
                final Map<String, dynamic>? firstReview = hasReview
                    ? reviews.first as Map<String, dynamic>
                    : null;

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => OrderDetailView(
                          orderId: order["bookingID"].toString(),
                        ),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: const [
                        BoxShadow(color: Colors.black12, blurRadius: 6),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ===== Thông tin đơn =====
                        Text(
                          "Đơn #${order["bookingID"]}",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text("Nhận xe: ${order["startDate"]}"),
                        Text("Trả xe: ${order["endDate"]}"),
                        const SizedBox(height: 6),
                        _statusTag(order["status"] ?? ""),
                        const SizedBox(height: 8),

                        // ===== Nếu đã có review -> hiện review trong card =====
                        if (hasReview) ...[
                          const Divider(),
                          const Text(
                            "Đánh giá của bạn",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(Icons.star, size: 16),
                              const SizedBox(width: 4),
                              Text("${firstReview?["rating"] ?? 0}/5"),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            firstReview?["comment"] ?? "",
                            style: const TextStyle(fontStyle: FontStyle.italic),
                          ),
                          const SizedBox(height: 8),
                        ],

                        // ===== Nút Thanh toán =====
                        _buildPayButton(context, order),

                        // ===== Nút Thanh toán (giữ lại nếu cần cho retry, nhưng User bảo xóa hết action ở đây, tuy nhiên thanh toán Pending có thể là ngoại lệ. tạm xóa nút hành động checkin/review) =====
                        _buildPayButton(context, order),
                        
                        // Nút xem chi tiết (Mặc định thẻ card đã bấm được, nhưng có thể thêm text "Xem chi tiết")
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => OrderDetailView(
                                    orderId: order["bookingID"].toString(),
                                  ),
                                ),
                              );
                            }, 
                            child: const Text("Xem chi tiết"),
                          )
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }

  Widget _statusTag(String status) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.blue),
        ),
        child: Text(status, style: const TextStyle(color: Colors.blue)),
      ),
    );
  }

  Widget _buildPayButton(BuildContext context, Map<String, dynamic> order) {
    final status = (order["status"] ?? "") as String;
    final bookingId = order["bookingID"] as int?;

    // Chỉ hiện nút khi đơn đang Pending (chưa thanh toán)
    if (bookingId == null || status != "Pending") {
      return const SizedBox.shrink();
    }

    return Align(
      alignment: Alignment.centerRight,
      child: ElevatedButton(
        onPressed: () async {
          try {
            // gọi API /payment/vnpay/retry/{bookingId}
            final url = await _paymentService.retryVnPay(bookingId);
            final uri = Uri.parse(url);

            final opened = await launchUrl(
              uri,
              mode: LaunchMode.externalApplication,
            );

            if (!opened) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Không mở được trang thanh toán")),
              );
            }
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Lỗi mở lại thanh toán: $e")),
            );
          }
        },
        child: const Text("Thanh toán"),
      ),
    );
  }

}
