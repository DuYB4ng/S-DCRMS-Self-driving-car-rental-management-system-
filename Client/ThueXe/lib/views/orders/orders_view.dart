import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/orders_viewmodel.dart';
import 'order_detail_view.dart';

class OrdersView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<OrdersViewModel>(context);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      vm.loadOrders();
    });

    return Scaffold(
      appBar: AppBar(
        title: Text("Lịch sử đơn hàng"),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),

      body: vm.isLoading
          ? Center(child: CircularProgressIndicator())
          : vm.errorMessage != null
          ? Center(child: Text(vm.errorMessage!))
          : vm.orders.isEmpty
          ? Center(child: Text("Chưa có đơn hàng"))
          : ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: vm.orders.length,
              itemBuilder: (context, index) {
                final vm = Provider.of<OrdersViewModel>(context, listen: false);
                final order = vm.orders[index];

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
                    padding: EdgeInsets.all(16),
                    margin: EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(color: Colors.black12, blurRadius: 6),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Đơn #${order["bookingID"]}",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 6),
                        Text("Nhận xe: ${order["startDate"]}"),
                        Text("Trả xe: ${order["endDate"]}"),
                        SizedBox(height: 6),
                        _statusTag(order["status"]),
                        const SizedBox(height: 8),
                        _buildActionButton(context, vm, order),
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
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.blue),
        ),
        child: Text(status, style: TextStyle(color: Colors.blue)),
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

    // Tên field checkIn/checkOut trong JSON:
    // C# property CheckIn -> JSON: "checkIn" (camelCase)
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
