class Car {
  int? carId;
  String nameCar;
  String licensePlate;
  int modelYear;
  int seat;
  String typeCar;
  String transmission;
  String fuelType;
  double fuelConsumption;
  String color;
  decimal? pricePerDay; // Using double/num for simplicity in Dart unless decimal package used
  decimal? deposit;
  String location;
  bool isActive;
  String description;
  List<String> imageUrls;
  String status;

  Car({
    this.carId,
    required this.nameCar,
    required this.licensePlate,
    required this.modelYear,
    required this.seat,
    required this.typeCar,
    this.transmission = "Automatic",
    this.fuelType = "Gasoline",
    required this.fuelConsumption,
    required this.color,
    this.pricePerDay,
    this.deposit,
    required this.location,
    this.isActive = true,
    required this.description,
    this.imageUrls = const [],
    this.status = "Active",
  });

  factory Car.fromJson(Map<String, dynamic> json) {
    return Car(
      carId: json['carID'], // Note: case sensitive, check backend (CarID vs carID)
      nameCar: json['nameCar'] ?? '',
      licensePlate: json['licensePlate'] ?? '',
      modelYear: json['modelYear'] ?? 2024,
      seat: json['seat'] ?? 4,
      typeCar: json['typeCar'] ?? '',
      transmission: json['transmission'] ?? 'Automatic',
      fuelType: json['fuelType'] ?? 'Gasoline',
      fuelConsumption: (json['fuelConsumption'] ?? 0).toDouble(),
      color: json['color'] ?? '',
      pricePerDay: json['pricePerDay'] != null ? (json['pricePerDay'] as num).toDouble() : 0.0,
      deposit: json['deposit'] != null ? (json['deposit'] as num).toDouble() : 0.0,
      location: json['location'] ?? '',
      isActive: json['isActive'] ?? true,
      description: json['description'] ?? '',
      imageUrls: List<String>.from(json['imageUrls'] ?? []),
      status: json['status'] ?? 'Active',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (carId != null) 'carID': carId,
      'nameCar': nameCar,
      'licensePlate': licensePlate,
      'modelYear': modelYear,
      'seat': seat,
      'typeCar': typeCar,
      'transmission': transmission,
      'fuelType': fuelType,
      'fuelConsumption': fuelConsumption,
      'color': color,
      'pricePerDay': pricePerDay,
      'deposit': deposit,
      'location': location,
      'isActive': isActive,
      'description': description,
      'imageUrls': imageUrls,
      // Required by Server DTO for MySQL valid dates
      'RegistrationDate': DateTime.now().toIso8601String(),
      'InsuranceExpiryDate': DateTime.now().add(const Duration(days: 365)).toIso8601String(),
      'InspectionExpiryDate': DateTime.now().add(const Duration(days: 365)).toIso8601String(),
      'OwnershipType': 'Personal',
      'RegistrationPlace': 'VN',
      'Status': status,
    };
  }
}

// Helper to handle Decimal if needed, but double is usually fine for UI.
typedef decimal = double;
