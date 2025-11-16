import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/order_detail_viewmodel.dart';

class OrderDetailView extends StatelessWidget {
  final String orderId;

  OrderDetailView({required this.orderId});

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<OrderDetailViewModel>(context);

    // Load data khi mở màn hình
    WidgetsBinding.instance.addPostFrameCallback((_) {
      vm.loadOrder(orderId);
    });

    return Scaffold(
      appBar: AppBar(
        title: Text("Chi tiết đơn hàng"),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),

      body: vm.isLoading
          ? Center(child: CircularProgressIndicator())
          : vm.errorMessage != null
          ? Center(child: Text(vm.errorMessage!))
          : _buildDetail(context, vm.orderData!),
    );
  }

  Widget _buildDetail(BuildContext context, Map<String, dynamic> order) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(order["carName"],
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),

          SizedBox(height: 10),

          _infoRow("Mã đơn hàng", order["orderId"]),
          _infoRow("Ngày nhận xe", order["pickupDate"]),
          _infoRow("Ngày trả xe", order["returnDate"]),
          _infoRow("Trạng thái", order["status"]),

          SizedBox(height: 20),

          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent,
              minimumSize: Size(double.infinity, 48),
            ),
            child: Text("Liên hệ hỗ trợ"),
          )
        ],
      ),
    );
  }

  Widget _infoRow(String label, dynamic value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.black54)),
          Text(value.toString(),
              style: TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
