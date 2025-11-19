import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/home_viewmodel.dart';
import '../car/car_list_view.dart';

class HomeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<HomeViewModel>(context);

    return Scaffold(

      backgroundColor: Colors.white,

      body:Stack(
          children: [
// Background
            Positioned.fill(
              child: Transform.scale(
                scale: 1.8,        // phóng to 30%
                child: Image.asset(
                  "assets/images/background.png",
                  fit: BoxFit.cover,
                ),
              ),
            ),
// nội dung
            SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [

                // LOGO
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Center(
                    child: Image.asset(
                      "assets/images/logo - Copy.png",
                      height: 120,  // giảm 1 chút để nhìn gọn hơn
                    ),
                  ),
                ),


                // FORM
                Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16, top: 0, bottom: 16),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 15,
                          spreadRadius: 2,
                        )
                      ],
                    ),
                    padding: EdgeInsets.all(16),

                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Nơi nhận xe
                        Text("Nơi nhận xe",
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w600)),
                        SizedBox(height: 8),
                        DropdownButtonFormField<String>(
                          decoration: _inputDecoration(),
                          value: vm.selectedCity,
                          items: [
                            "Hồ Chí Minh",
                            "Hà Nội",
                            "Đà Nẵng"
                          ].map((value) {
                            return DropdownMenuItem(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (value) {
                            vm.setCity(value!);
                          },
                        ),

                        SizedBox(height: 20),

                        // Ngày nhận xe
                        Text("Ngày nhận xe",
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w600)),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: _dateSelector(
                                context,
                                label: _formatDate(vm.receiveDate),
                                icon: Icons.calendar_today,
                                onTap: () async {
                                  DateTime? picked = await showDatePicker(
                                    context: context,
                                    firstDate: DateTime.now(),
                                    lastDate: DateTime(2030),
                                    initialDate: vm.receiveDate,
                                  );
                                  if (picked != null) vm.setReceiveDate(picked);
                                },
                              ),
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: _dateSelector(
                                context,
                                label: vm.receiveTime.format(context),
                                icon: Icons.access_time,
                                onTap: () async {
                                  TimeOfDay? picked = await showTimePicker(
                                    context: context,
                                    initialTime: vm.receiveTime,
                                  );
                                  if (picked != null) vm.setReceiveTime(picked);
                                },
                              ),
                            )
                          ],
                        ),

                        SizedBox(height: 20),

                        // Ngày trả xe
                        Text("Ngày trả xe",
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w600)),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: _dateSelector(
                                context,
                                label: _formatDate(vm.returnDate),
                                icon: Icons.calendar_today,
                                onTap: () async {
                                  DateTime? picked = await showDatePicker(
                                    context: context,
                                    firstDate: vm.receiveDate,
                                    lastDate: DateTime(2030),
                                    initialDate: vm.returnDate,
                                  );
                                  if (picked != null) vm.setReturnDate(picked);
                                },
                              ),
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: _dateSelector(
                                context,
                                label: vm.returnTime.format(context),
                                icon: Icons.access_time,
                                onTap: () async {
                                  TimeOfDay? picked = await showTimePicker(
                                    context: context,
                                    initialTime: vm.returnTime,
                                  );
                                  if (picked != null) vm.setReturnTime(picked);
                                },
                              ),
                            )
                          ],
                        ),

                        SizedBox(height: 25),

                        // Button tìm kiếm
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => CarListView(
                                    city: vm.selectedCity,
                                    receiveDate: vm.receiveDate,
                                    receiveTime: vm.receiveTime,
                                    returnDate: vm.returnDate,
                                    returnTime: vm.returnTime,
                                  ),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF226EA3),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                            ),
                            child: Text(
                              "Tìm kiếm xe",
                              style:
                              TextStyle(color: Colors.white, fontSize: 16),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 10),

                // Image car bottom


                SizedBox(height: 20),
              ],
            ),
          ),
        ),
          ]
      ),

    );
  }

  // Date/time boxes
  Widget _dateSelector(BuildContext context,
      {required String label,
        required IconData icon,
        required Function onTap}) {
    return InkWell(
      onTap: () => onTap(),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        decoration: _boxDecoration(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: TextStyle(fontSize: 14)),
            Icon(icon, size: 20, color: Colors.grey[700]),
          ],
        ),
      ),
    );
  }

  // Helpers
  String _formatDate(DateTime date) =>
      "${date.day.toString().padLeft(2, "0")}/${date.month.toString().padLeft(2, "0")}/${date.year}";

  BoxDecoration _boxDecoration() {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: Colors.grey.shade300),
    );
  }

  InputDecoration _inputDecoration() {
    return InputDecoration(
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none),
      filled: true,
      fillColor: Colors.grey.shade100,
    );
  }


}
