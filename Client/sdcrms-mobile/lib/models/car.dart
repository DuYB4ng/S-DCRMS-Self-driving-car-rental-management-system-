class Car {
  final String id;
  final String name;
  final String brand;
  final String model;
  final String type; // Sedan, SUV, Hatchback, Xe máy
  final String licensePlate;
  final int year;
  final double pricePerDay;
  final String transmission; // Số tự động, Số sàn
  final int seats;
  final String fuelType; // Xăng, Dầu, Điện
  final String color;
  final String? imagePath;
  final String status; // Sẵn sàng, Đang thuê, Bảo trì
  final double rating;
  final int totalTrips;

  Car({
    required this.id,
    required this.name,
    required this.brand,
    required this.model,
    required this.type,
    required this.licensePlate,
    required this.year,
    required this.pricePerDay,
    required this.transmission,
    required this.seats,
    required this.fuelType,
    required this.color,
    this.imagePath,
    this.status = 'Sẵn sàng',
    this.rating = 0.0,
    this.totalTrips = 0,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'brand': brand,
      'model': model,
      'type': type,
      'licensePlate': licensePlate,
      'year': year,
      'pricePerDay': pricePerDay,
      'transmission': transmission,
      'seats': seats,
      'fuelType': fuelType,
      'color': color,
      'imagePath': imagePath,
      'status': status,
      'rating': rating,
      'totalTrips': totalTrips,
    };
  }

  factory Car.fromJson(Map<String, dynamic> json) {
    return Car(
      id: json['id'],
      name: json['name'],
      brand: json['brand'],
      model: json['model'],
      type: json['type'],
      licensePlate: json['licensePlate'],
      year: json['year'],
      pricePerDay: json['pricePerDay'].toDouble(),
      transmission: json['transmission'],
      seats: json['seats'],
      fuelType: json['fuelType'],
      color: json['color'],
      imagePath: json['imagePath'],
      status: json['status'],
      rating: json['rating']?.toDouble() ?? 0.0,
      totalTrips: json['totalTrips'] ?? 0,
    );
  }

  Car copyWith({
    String? id,
    String? name,
    String? brand,
    String? model,
    String? type,
    String? licensePlate,
    int? year,
    double? pricePerDay,
    String? transmission,
    int? seats,
    String? fuelType,
    String? color,
    String? imagePath,
    String? status,
    double? rating,
    int? totalTrips,
  }) {
    return Car(
      id: id ?? this.id,
      name: name ?? this.name,
      brand: brand ?? this.brand,
      model: model ?? this.model,
      type: type ?? this.type,
      licensePlate: licensePlate ?? this.licensePlate,
      year: year ?? this.year,
      pricePerDay: pricePerDay ?? this.pricePerDay,
      transmission: transmission ?? this.transmission,
      seats: seats ?? this.seats,
      fuelType: fuelType ?? this.fuelType,
      color: color ?? this.color,
      imagePath: imagePath ?? this.imagePath,
      status: status ?? this.status,
      rating: rating ?? this.rating,
      totalTrips: totalTrips ?? this.totalTrips,
    );
  }
}
