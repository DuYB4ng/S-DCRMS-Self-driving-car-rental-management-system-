class Admin {
  final int? userId;
  final String email;
  final String firstName;
  final String lastName;
  final String phoneNumber;
  final String role;
  final String sex;
  final DateTime birthday;
  final DateTime joinDate;
  final String address;

  Admin({
    this.userId,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.role,
    required this.sex,
    required this.birthday,
    required this.joinDate,
    required this.address,
  });

  factory Admin.fromJson(Map<String, dynamic> json) {
    return Admin(
      userId: json['userID'],
      email: json['email'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      phoneNumber: json['phoneNumber'],
      role: json['role'],
      sex: json['sex'],
      birthday: DateTime.parse(json['birthday']),
      joinDate: DateTime.parse(json['joinDate']),
      address: json['address'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'phoneNumber': phoneNumber,
      'sex': sex,
      'birthday': birthday.toIso8601String(),
      'address': address,
    };
  }

  String get fullName => '$firstName $lastName';
}
