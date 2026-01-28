import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/owner_car_viewmodel.dart';
import 'add_edit_car_view.dart';
import 'car_calendar_view.dart';
import 'owner_car_detail_view.dart';
import '../profile/profile_view.dart';
import 'car_bookings_view.dart';

class OwnerHomeView extends StatefulWidget {
  const OwnerHomeView({super.key});

  @override
  State<OwnerHomeView> createState() => _OwnerHomeViewState();
}

class _OwnerHomeViewState extends State<OwnerHomeView> {
  @override
  void initState() {
    super.initState();
    // Load cars when view initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<OwnerCarViewModel>().loadCars();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Danh sách xe"),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<OwnerCarViewModel>().loadCars();
            },
          ),
        ],
      ),
      body: Consumer<OwnerCarViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (viewModel.errorMessage != null) {
            return Center(child: Text("Lỗi: ${viewModel.errorMessage}"));
          }

          if (viewModel.cars.isEmpty) {
            return const Center(child: Text("Bạn chưa có xe nào."));
          }

          return ListView.builder(
            itemCount: viewModel.cars.length,
            itemBuilder: (context, index) {
              final car = viewModel.cars[index];
              return Card(
                elevation: 3,
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                child: InkWell(
                  onTap: () {
                    // Navigate to Detail View
                    if (car.carId != null) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => OwnerCarDetailView(car: car),
                          ),
                        );
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Left: Image
                        SizedBox(
                          width: 100,
                          height: 100,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: car.imageUrls.isNotEmpty
                                ? Image.network(
                                    car.imageUrls.first.startsWith("http") 
                                        ? car.imageUrls.first 
                                        : "${viewModel.baseUrl.replaceAll('/api', '')}${car.imageUrls.first}",
                                    fit: BoxFit.cover,
                                    errorBuilder: (ctx, err, stack) => Container(
                                      color: Colors.grey[200],
                                      child: const Icon(Icons.car_rental, size: 40),
                                    ),
                                  )
                                : Container(
                                    color: Colors.grey[200],
                                    child: const Icon(Icons.car_rental, size: 40),
                                  ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        // Right: Info
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                car.nameCar,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  const Icon(Icons.confirmation_number_outlined, size: 16, color: Colors.grey),
                                  const SizedBox(width: 4),
                                  Text(
                                    car.licensePlate,
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  const Icon(Icons.location_on_outlined, size: 16, color: Colors.grey),
                                  const SizedBox(width: 4),
                                  Expanded(
                                    child: Text(
                                      car.location,
                                      style: const TextStyle(fontSize: 14),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              // Status badge
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: car.status == 'Available' ? Colors.green[100] : Colors.red[100],
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  car.status == 'Available' ? 'Sẵn sàng' : car.status ?? 'N/A',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: car.status == 'Available' ? Colors.green[900] : Colors.red[900],
                                    fontWeight: FontWeight.w500
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0, 
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          if (index == 0) return; // Home

          if (index == 1) {
             // Profile
             Navigator.push(
               context,
               MaterialPageRoute(
                 builder: (_) => ProfileView(
                   onMenuTap: (i) {
                     Navigator.pop(context); 
                   },
                 ),
               ),
             );
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Trang chủ",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Tài khoản",
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddEditCarView(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
