import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/car_list_viewmodel.dart';

class CarListView extends StatelessWidget {
  final String city;
  final DateTime receiveDate;
  final TimeOfDay receiveTime;
  final DateTime returnDate;
  final TimeOfDay returnTime;
  bool loadedOnce = false;

  CarListView({
    required this.city,
    required this.receiveDate,
    required this.receiveTime,
    required this.returnDate,
    required this.returnTime,
  });

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<CarListViewModel>(context);

    // API CALL SAU KHI MỞ MÀN HÌNH
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!vm.isLoading && vm.cars.isEmpty) {
        vm.searchCars(
          city: city,
          receiveDate: receiveDate,
          receiveTime: receiveTime,
          returnDate: returnDate,
          returnTime: returnTime,
        );
      }
    });

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text("Thuê xe", style: TextStyle(color: Colors.black)),
        centerTitle: true,
        leading: BackButton(color: Colors.black),
      ),

      backgroundColor: Colors.grey[100],

      body: vm.isLoading
          ? Center(child: CircularProgressIndicator())
          : vm.errorMessage != null
          ? Center(child: Text(vm.errorMessage!))
          : ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: vm.cars.length,
        itemBuilder: (context, index) {
          final car = vm.cars[index];

          return _carItem(car);
        },
      ),
    );
  }

  Widget _carItem(dynamic car) {
    return Container(
      margin: EdgeInsets.only(bottom: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, 3),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // IMAGE
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(14)),
            child: Image.network(
              car["imageUrl"],
              height: 180,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),

          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // PRICE
                Text(
                  "Chỉ từ ${car["price"]} VNĐ/ngày",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.green.shade700,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                SizedBox(height: 6),

                // NAME
                Text(
                  car["name"] ?? "Unknown",
                  style: TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),

                SizedBox(height: 8),

                // INFOS
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _infoItem(Icons.people_alt, "${car["seats"]} chỗ"),
                    _infoItem(Icons.speed, "${car["range"]} km"),
                  ],
                ),

                SizedBox(height: 8),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _infoItem(Icons.car_rental, car["type"]),
                    _infoItem(Icons.luggage, "${car["trunk"]}L"),
                  ],
                ),

                SizedBox(height: 10),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoItem(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.black54),
        SizedBox(width: 4),
        Text(text, style: TextStyle(color: Colors.black87)),
      ],
    );
  }
}
