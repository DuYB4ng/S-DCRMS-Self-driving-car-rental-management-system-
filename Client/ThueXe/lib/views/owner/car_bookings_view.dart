import 'package:flutter/material.dart';
import '../../services/booking_service.dart';
import '../orders/order_detail_view.dart';

class CarBookingsView extends StatefulWidget {
  final int carId;
  final String carName;

  const CarBookingsView({super.key, required this.carId, required this.carName});

  @override
  State<CarBookingsView> createState() => _CarBookingsViewState();
}

class _CarBookingsViewState extends State<CarBookingsView> {
  final BookingService _bookingService = BookingService();
  List<dynamic> _bookings = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadBookings();
  }

  Future<void> _loadBookings() async {
    try {
      final res = await _bookingService.getBookingsByCarId(widget.carId);
      setState(() {
        _bookings = res.data ?? [];
        _isLoading = false;
      });
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Danh sách đơn: ${widget.carName}")),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _bookings.isEmpty
              ? const Center(child: Text("Chưa có đơn đặt nào cho xe này."))
              : ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: _bookings.length,
                  itemBuilder: (context, index) {
                    final booking = _bookings[index];
                    final status = booking['status'] ?? "Unknown";
                    
                    // Format Dates
                    String dateStr = "—";
                    if (booking['startDate'] != null && booking['endDate'] != null) {
                       try {
                         final start = DateTime.parse(booking['startDate']);
                         final end = DateTime.parse(booking['endDate']);
                         // Simple formatted date
                         dateStr = "${start.day}/${start.month} - ${end.day}/${end.month}/${end.year}";
                       } catch (_) {}
                    }

                    return GestureDetector(
                      onTap: () {
                         Navigator.push(
                           context,
                           MaterialPageRoute(
                             builder: (context) => OrderDetailView(
                               orderId: booking['bookingID'].toString(),
                               isOwnerView: true, 
                             ),
                           ),
                         ).then((_) => _loadBookings());
                      },
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                             BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))
                          ],
                          border: Border.all(color: Colors.grey.shade200)
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                             Row(
                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                               children: [
                                  Text(
                                    "Đơn #${booking['bookingID']}", 
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)
                                  ),
                                  _statusBadge(status),
                               ],
                             ),
                             const Divider(height: 24),
                             Row(
                               children: [
                                  const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                                  const SizedBox(width: 8),
                                  Text(dateStr, style: const TextStyle(color: Colors.black87)),
                               ],
                             ),
                             const SizedBox(height: 8),
                             Row(
                               children: [
                                  const Icon(Icons.monetization_on, size: 16, color: Colors.grey),
                                  const SizedBox(width: 8),
                                  // Simplified Total Price if available, else just 'Chi tiết'
                                  Text(
                                    booking['totalPrice'] != null 
                                      ? "${(booking['totalPrice'] as num).toInt().toString().replaceAll(RegExp(r'\B(?=(\d{3})+(?!\d))'), '.')} đ" 
                                      : "Xem chi tiết",
                                    style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.green),
                                  ),
                               ],
                             ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }

  Widget _statusBadge(String status) {
    Color bg = Colors.grey[200]!;
    Color text = Colors.black87;
    String label = status;

    switch (status) {
      case "Pending": bg = Colors.orange[100]!; text = Colors.orange[800]!; label = "Chờ duyệt"; break;
      case "Approved": bg = Colors.blue[100]!; text = Colors.blue[800]!; label = "Đã duyệt"; break;
      case "Paid": bg = Colors.indigo[100]!; text = Colors.indigo[800]!; label = "Đã thanh toán"; break;
      case "InProgress": bg = Colors.blue[50]!; text = Colors.blue[900]!; label = "Đang thuê"; break;
      case "ReturnRequested": bg = Colors.purple[100]!; text = Colors.purple[800]!; label = "Yêu cầu trả"; break;
      case "Completed": bg = Colors.green[100]!; text = Colors.green[800]!; label = "Hoàn thành"; break;
      case "Cancelled": bg = Colors.red[100]!; text = Colors.red[800]!; label = "Đã hủy"; break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(label, style: TextStyle(color: text, fontSize: 12, fontWeight: FontWeight.bold)),
    );
  }
}
