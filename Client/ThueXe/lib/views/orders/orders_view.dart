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
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6,
                  ),
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
        child: Text(
          status,
          style: TextStyle(color: Colors.blue),
        ),
      ),
    );
  }
}
