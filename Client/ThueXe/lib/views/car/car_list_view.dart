import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/car_list_viewmodel.dart';
import 'car_detail_view.dart';

class CarListView extends StatefulWidget {
  final String city;
  final DateTime receiveDate;
  final TimeOfDay receiveTime;
  final DateTime returnDate;
  final TimeOfDay returnTime;

  CarListView({
    required this.city,
    required this.receiveDate,
    required this.receiveTime,
    required this.returnDate,
    required this.returnTime,
  });

  @override
  _CarListViewState createState() => _CarListViewState();
}

class _CarListViewState extends State<CarListView> {
  bool loadedOnce = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!loadedOnce) {
      final vm = Provider.of<CarListViewModel>(context, listen: false);

      vm.searchCars(
        city: widget.city,
        receiveDate: widget.receiveDate,
        receiveTime: widget.receiveTime,
        returnDate: widget.returnDate,
        returnTime: widget.returnTime,
      );

      loadedOnce = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<CarListViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text("Kết quả tìm kiếm", style: TextStyle(color: Colors.black)),
        centerTitle: true,
        leading: BackButton(color: Colors.black),
      ),

      backgroundColor: Colors.grey[100],

      body: vm.isLoading
          ? Center(child: CircularProgressIndicator())
          : vm.errorMessage != null
          ? Center(child: Text(vm.errorMessage!))
          : vm.cars.isEmpty
          ? Center(child: Text("Không tìm thấy xe nào"))
          : ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: vm.cars.length,
        itemBuilder: (context, index) {
          final car = vm.cars[index];
          return GestureDetector(
            onTap: () {
              final receiveDateTime = DateTime(
                widget.receiveDate.year,
                widget.receiveDate.month,
                widget.receiveDate.day,
                widget.receiveTime.hour,
                widget.receiveTime.minute,
              );

              final returnDateTime = DateTime(
                widget.returnDate.year,
                widget.returnDate.month,
                widget.returnDate.day,
                widget.returnTime.hour,
                widget.returnTime.minute,
              );

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => CarDetailView(
                    car: car,
                    receiveDate: receiveDateTime,
                    returnDate: returnDateTime,
                  ),
                ),
              );
            },

            child: _carItem(car),
          );
        },
      ),
    );
  }

  /// ===============================
  ///  WIDGET ITEM XE (UI từng chiếc)
  /// ===============================
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
          // Ảnh xe
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(14)),
            child: Image.network(
              (car["imageUrls"] != null && car["imageUrls"].isNotEmpty)
                  ? car["imageUrls"][0]
                  : "https://via.placeholder.com/300x180",
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
                // Giá thuê
                Text(
                  "Chỉ từ ${car["pricePerDay"]} VNĐ/ngày",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.green.shade700,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 6),

                // Tên xe
                Text(
                  car["nameCar"] ?? "Không rõ tên",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),

                // Dòng thông tin 1
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _infoItem(Icons.people_alt, "${car["seat"]} chỗ"),
                    _infoItem(Icons.settings, car["transmission"] ?? "N/A"),
                  ],
                ),
                SizedBox(height: 8),

                // Dòng thông tin 2
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _infoItem(Icons.car_rental, car["typeCar"] ?? "Loại xe"),
                    _infoItem(Icons.location_on, car["location"] ?? "Không rõ"),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// ===============================
  ///  WIDGET NHỎ: ICON + TEXT
  /// ===============================
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
