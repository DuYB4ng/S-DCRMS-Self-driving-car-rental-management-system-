import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/order_detail_viewmodel.dart';

class OrderDetailView extends StatelessWidget {
  final String orderId;

  OrderDetailView({required this.orderId});

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
        title: Text("Chi tiết đơn hàng"),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),

      body: vm.isLoading
          ? Center(child: CircularProgressIndicator())
          : vm.errorMessage != null
          ? Center(child: Text(vm.errorMessage!))
          : _buildDetail(vm.orderData!),
    );
  }

  Widget _buildDetail(Map<String, dynamic> order) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("ĐƠN #${order["bookingID"]}",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          SizedBox(height: 20),

          _info("Ngày nhận xe", order["startDate"]),
          _info("Ngày trả xe", order["endDate"]),
          _info("Trạng thái", order["status"]),
          _info("Check-in", order["checkIn"].toString()),
          _info("Check-out", order["checkOut"].toString()),

          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {},
            child: Text("Liên hệ hỗ trợ"),
          )
        ],
      ),
    );
  }

  Widget _info(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.black54)),
          Text(value, style: TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

