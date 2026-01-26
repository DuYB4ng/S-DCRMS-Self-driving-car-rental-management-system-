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
      appBar: AppBar(title: Text("Bookings: ${widget.carName}")),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _bookings.isEmpty
              ? const Center(child: Text("No bookings for this car."))
              : ListView.builder(
                  itemCount: _bookings.length,
                  itemBuilder: (context, index) {
                    final booking = _bookings[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      child: ListTile(
                        title: Text("Booking #${booking['bookingID']}"),
                        subtitle: Text("${booking['startDate']} - ${booking['endDate']}\nStatus: ${booking['status']}"),
                        trailing: const Icon(Icons.arrow_forward_ios),
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
                      ),
                    );
                  },
                ),
    );
  }
}
