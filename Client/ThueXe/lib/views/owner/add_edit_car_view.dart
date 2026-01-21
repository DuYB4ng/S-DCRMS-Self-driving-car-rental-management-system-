import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../models/car.dart';
import '../../viewmodels/owner_car_viewmodel.dart';
import '../../services/api_service.dart'; // For BaseUrl helper if needed or just use relative path

class AddEditCarView extends StatefulWidget {
  final Car? car;
  const AddEditCarView({super.key, this.car});

  @override
  State<AddEditCarView> createState() => _AddEditCarViewState();
}

class _AddEditCarViewState extends State<AddEditCarView> {
  final _formKey = GlobalKey<FormState>();
  
  // Controllers
  late TextEditingController _nameController;
  late TextEditingController _licensePlateController;
  late TextEditingController _priceController;
  late TextEditingController _locationController;
  late TextEditingController _descController;
  
  // New Controllers
  late TextEditingController _modelYearController;
  late TextEditingController _seatController;
  late TextEditingController _fuelConsumptionController;
  late TextEditingController _colorController;
  late TextEditingController _depositController;

  // Dropdown values
  String _typeCar = "Sedan";
  String _transmission = "Automatic";
  String _fuelType = "Gasoline";

  final List<String> _typeCarOptions = ["Sedan", "SUV", "Truck", "Van", "Coupe", "Hatchback"];
  final List<String> _transmissionOptions = ["Automatic", "Manual"];
  final List<String> _fuelOptions = ["Gasoline", "Diesel", "Electric", "Hybrid"];
  
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    final car = widget.car;
    _nameController = TextEditingController(text: car?.nameCar ?? "");
    _licensePlateController = TextEditingController(text: car?.licensePlate ?? "");
    _priceController = TextEditingController(text: car?.pricePerDay?.toString() ?? "");
    _locationController = TextEditingController(text: car?.location ?? "");
    _descController = TextEditingController(text: car?.description ?? "");

    _modelYearController = TextEditingController(text: car?.modelYear.toString() ?? "2024");
    _seatController = TextEditingController(text: car?.seat.toString() ?? "4");
    _fuelConsumptionController = TextEditingController(text: car?.fuelConsumption.toString() ?? "8.0");
    _colorController = TextEditingController(text: car?.color ?? "");
    _depositController = TextEditingController(text: car?.deposit.toString() ?? "0.0");

    if (car != null) {
      if (_typeCarOptions.contains(car.typeCar)) _typeCar = car.typeCar;
      if (_transmissionOptions.contains(car.transmission)) _transmission = car.transmission!;
      if (_fuelOptions.contains(car.fuelType)) _fuelType = car.fuelType!;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _licensePlateController.dispose();
    _priceController.dispose();
    _locationController.dispose();
    _descController.dispose();
    _modelYearController.dispose();
    _seatController.dispose();
    _fuelConsumptionController.dispose();
    _colorController.dispose();
    _depositController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _saveCar() async {
    if (_formKey.currentState!.validate()) {
      final viewModel = context.read<OwnerCarViewModel>();
      
      // Upload image first if new one selected
      String? imageUrl;
      if (_imageFile != null) {
        imageUrl = await viewModel.uploadImage(_imageFile!);
        if (imageUrl == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Failed to upload image")),
          );
          return;
        }
      }

      // Prepare Car object
      final car = Car(
        carId: widget.car?.carId,
        nameCar: _nameController.text,
        licensePlate: _licensePlateController.text,
        pricePerDay: double.tryParse(_priceController.text) ?? 0.0,
        deposit: double.tryParse(_depositController.text) ?? 0.0,
        location: _locationController.text,
        description: _descController.text,
        
        // Detailed Infos
        modelYear: int.tryParse(_modelYearController.text) ?? 2024,
        seat: int.tryParse(_seatController.text) ?? 4,
        typeCar: _typeCar,
        transmission: _transmission,
        fuelType: _fuelType,
        fuelConsumption: double.tryParse(_fuelConsumptionController.text) ?? 0.0,
        color: _colorController.text,

        imageUrls: imageUrl != null 
            ? [imageUrl] // Use the returned path (e.g. /images/...)
            : (widget.car?.imageUrls ?? []),
      );

      bool success;
      if (widget.car == null) {
        success = await viewModel.addCar(car);
      } else {
        success = await viewModel.updateCar(car);
      }

      if (success) {
        if (mounted) Navigator.pop(context);
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(viewModel.errorMessage ?? "Operation failed")),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.car == null ? "Add Car" : "Edit Car"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Image Picker
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    border: Border.all(color: Colors.grey),
                  ),
                  child: _imageFile != null
                      ? Image.file(_imageFile!, fit: BoxFit.cover)
                      : (widget.car != null && widget.car!.imageUrls.isNotEmpty)
                          ? Image.network(
                              // Ensure full URL if stored as relative path
                              widget.car!.imageUrls.first.startsWith("http") 
                              ? widget.car!.imageUrls.first
                              : "${context.read<OwnerCarViewModel>().baseUrl.replaceAll('/api', '')}${widget.car!.imageUrls.first}",
                              fit: BoxFit.cover,
                              errorBuilder: (ctx, _, __) => const Icon(Icons.add_a_photo, size: 50),
                            )
                          : const Center(child: Icon(Icons.add_a_photo, size: 50)),
                ),
              ),
              const SizedBox(height: 16),
              
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: "Car Name"),
                validator: (val) => val!.isEmpty ? "Required" : null,
              ),
              TextFormField(
                controller: _licensePlateController,
                decoration: const InputDecoration(labelText: "License Plate"),
                validator: (val) => val!.isEmpty ? "Required" : null,
              ),
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(labelText: "Price Per Day (VND)"),
                keyboardType: TextInputType.number,
                validator: (val) => val!.isEmpty ? "Required" : null,
              ),
              TextFormField(
                controller: _depositController,
                decoration: const InputDecoration(labelText: "Deposit (VND)"),
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                controller: _locationController,
                decoration: const InputDecoration(labelText: "Location"),
                validator: (val) => val!.isEmpty ? "Required" : null,
              ),
              
              const SizedBox(height: 16),
              const Text("Vehicle Details", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              
              Row(
                children: [
                   Expanded(
                     child: TextFormField(
                        controller: _modelYearController,
                        decoration: const InputDecoration(labelText: "Model Year"),
                        keyboardType: TextInputType.number,
                     ),
                   ),
                   const SizedBox(width: 10),
                   Expanded(
                     child: TextFormField(
                        controller: _seatController,
                        decoration: const InputDecoration(labelText: "Seats"),
                        keyboardType: TextInputType.number,
                     ),
                   ),
                ],
              ),
              
              Row(
                children: [
                   Expanded(
                     child: DropdownButtonFormField<String>(
                        value: _typeCar,
                        decoration: const InputDecoration(labelText: "Type"),
                        items: _typeCarOptions.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                        onChanged: (val) => setState(() => _typeCar = val!),
                     ),
                   ),
                   const SizedBox(width: 10),
                   Expanded(
                     child: DropdownButtonFormField<String>(
                        value: _transmission,
                        decoration: const InputDecoration(labelText: "Transmission"),
                        items: _transmissionOptions.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                        onChanged: (val) => setState(() => _transmission = val!),
                     ),
                   ),
                ],
              ),

              Row(
                children: [
                   Expanded(
                     child: DropdownButtonFormField<String>(
                        value: _fuelType,
                        decoration: const InputDecoration(labelText: "Fuel Type"),
                        items: _fuelOptions.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                        onChanged: (val) => setState(() => _fuelType = val!),
                     ),
                   ),
                   const SizedBox(width: 10),
                   Expanded(
                     child: TextFormField(
                        controller: _fuelConsumptionController,
                        decoration: const InputDecoration(labelText: "Fuel (L/100km)"),
                        keyboardType: TextInputType.number,
                     ),
                   ),
                ],
              ),
              
              TextFormField(
                controller: _colorController,
                decoration: const InputDecoration(labelText: "Color"),
              ),

              const SizedBox(height: 16),
              TextFormField(
                controller: _descController,
                decoration: const InputDecoration(labelText: "Description", border: OutlineInputBorder()),
                maxLines: 3,
              ),
              const SizedBox(height: 20),
              
              Consumer<OwnerCarViewModel>(
                builder: (context, viewModel, child) {
                  return ElevatedButton(
                    onPressed: viewModel.isLoading ? null : _saveCar,
                    child: viewModel.isLoading 
                        ? const CircularProgressIndicator() 
                        : Text(widget.car == null ? "Create Car" : "Update Car"),
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
