import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/owner_car_viewmodel.dart';
import 'add_edit_car_view.dart';

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
        title: const Text("My Cars"),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<OwnerCarViewModel>().loadCars();
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.blueAccent),
            onPressed: () async {
              // Sign out
              await context.read<OwnerCarViewModel>().signOut();
              if (context.mounted) {
                 Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
              }
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
            return Center(child: Text("Error: ${viewModel.errorMessage}"));
          }

          if (viewModel.cars.isEmpty) {
            return const Center(child: Text("You have no cars listed."));
          }

          return ListView.builder(
            itemCount: viewModel.cars.length,
            itemBuilder: (context, index) {
              final car = viewModel.cars[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: ListTile(
                  leading: car.imageUrls.isNotEmpty
                      ? Image.network(
                          car.imageUrls.first.startsWith("http") 
                              ? car.imageUrls.first 
                              : "${viewModel.baseUrl.replaceAll('/api', '')}${car.imageUrls.first}",
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                          errorBuilder: (ctx, err, stack) => const Icon(Icons.car_rental),
                        )
                      : const Icon(Icons.car_rental, size: 50),
                  title: Text(car.nameCar),
                  subtitle: Text("${car.licensePlate} - ${car.status}"),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AddEditCarView(car: car),
                            ),
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () async {
                          final confirm = await showDialog<bool>(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text("Delete Car"),
                              content: const Text("Are you sure you want to delete this car?"),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context, false),
                                  child: const Text("Cancel"),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.pop(context, true),
                                  child: const Text("Delete"),
                                ),
                              ],
                            ),
                          );

                          if (confirm == true && car.carId != null) {
                            await context.read<OwnerCarViewModel>().deleteCar(car.carId!);
                          }
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
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
