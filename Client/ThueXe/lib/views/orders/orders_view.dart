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

                        // ===== Nút Check-in / Check-out =====
                        _buildActionButton(context, vm, order),

                        // ===== Nút Đánh giá (sẽ chỉnh ở bước 2 để ẩn nếu đã review) =====
                        _buildReviewButton(context, vm, order),
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

  Widget _buildReviewButton(
    BuildContext context,
    OrdersViewModel vm,
    Map<String, dynamic> order,
  ) {
    final status = (order["status"] ?? "") as String;
    final bookingId = order["bookingID"] as int?;
    final checkOut = order["checkOut"] as bool? ?? false;

    // 🔹 Lấy list review từ order
    final List<dynamic> reviews = (order["reviews"] as List?) ?? [];
    final bool hasReview = reviews.isNotEmpty;

    // Chỉ show nút REVIEW khi:
    // - có bookingId
    // - status = Completed
    // - đã CheckOut = true
    // - CHƯA có review nào
    if (bookingId == null || status != "Completed" || !checkOut || hasReview) {
      return const SizedBox.shrink();
    }

    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        child: const Text("Đánh giá"),
        onPressed: () async {
          final result = await showDialog<_ReviewDialogResult>(
            context: context,
            builder: (context) => const _ReviewDialog(),
          );

          if (result == null) return;

          try {
            await _reviewService.createReview(
              bookingId: bookingId,
              rating: result.rating,
              comment: result.comment,
            );

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Gửi đánh giá thành công")),
            );

            // 🔹 Load lại list đơn để:
            // - lấy review vừa tạo
            // - ẩn luôn nút "Đánh giá"
            await vm.refreshOrders();
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Có lỗi khi gửi đánh giá")),
            );
          }
        },
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context,
    OrdersViewModel vm,
    Map<String, dynamic> order,
  ) {
    final status = (order["status"] ?? "") as String;
    final bookingId = order["bookingID"] as int?;

    final checkIn = order["checkIn"] as bool? ?? false;
    final checkOut = order["checkOut"] as bool? ?? false;

    if (bookingId == null) return const SizedBox.shrink();

    // 1️⃣ Đã thanh toán nhưng chưa check-in -> hiện nút Check-in
    if (status == "Paid" && !checkIn) {
      return Align(
        alignment: Alignment.centerRight,
        child: ElevatedButton(
          onPressed: () async {
            try {
              await vm.checkIn(bookingId);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Check-in thành công")),
              );
            } catch (e) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text("Check-in thất bại: $e")));
            }
          },
          child: const Text("Check-in"),
        ),
      );
    }

    // 2️⃣ Đang thuê (InProgress) & chưa check-out -> hiện nút Check-out
    if (status == "InProgress" && checkIn && !checkOut) {
      return Align(
        alignment: Alignment.centerRight,
        child: ElevatedButton(
          onPressed: () async {
            try {
              await vm.checkOut(bookingId);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Check-out thành công")),
              );
            } catch (e) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text("Check-out thất bại: $e")));
            }
          },
          child: const Text("Check-out"),
        ),
      );
    }

    // 3️⃣ Các trạng thái khác -> không hiện nút
    return const SizedBox.shrink();
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
