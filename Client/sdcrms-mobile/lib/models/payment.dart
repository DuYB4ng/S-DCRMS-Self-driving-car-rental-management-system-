class Payment {
  final String id;
  final String bookingId;
  final String customerName;
  final double amount;
  final String method; // momo, vnpay, zalopay, bank_transfer, cash
  final String status; // pending, processing, completed, failed, refunded
  final DateTime createdAt;
  final DateTime? completedAt;
  final String? transactionId;
  final String? notes;

  Payment({
    required this.id,
    required this.bookingId,
    required this.customerName,
    required this.amount,
    required this.method,
    required this.status,
    required this.createdAt,
    this.completedAt,
    this.transactionId,
    this.notes,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'bookingId': bookingId,
      'customerName': customerName,
      'amount': amount,
      'method': method,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
      'completedAt': completedAt?.toIso8601String(),
      'transactionId': transactionId,
      'notes': notes,
    };
  }

  factory Payment.fromJson(Map<String, dynamic> json) {
    return Payment(
      id: json['id'],
      bookingId: json['bookingId'],
      customerName: json['customerName'],
      amount: json['amount'].toDouble(),
      method: json['method'],
      status: json['status'],
      createdAt: DateTime.parse(json['createdAt']),
      completedAt: json['completedAt'] != null
          ? DateTime.parse(json['completedAt'])
          : null,
      transactionId: json['transactionId'],
      notes: json['notes'],
    );
  }

  Payment copyWith({
    String? id,
    String? bookingId,
    String? customerName,
    double? amount,
    String? method,
    String? status,
    DateTime? createdAt,
    DateTime? completedAt,
    String? transactionId,
    String? notes,
  }) {
    return Payment(
      id: id ?? this.id,
      bookingId: bookingId ?? this.bookingId,
      customerName: customerName ?? this.customerName,
      amount: amount ?? this.amount,
      method: method ?? this.method,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      completedAt: completedAt ?? this.completedAt,
      transactionId: transactionId ?? this.transactionId,
      notes: notes ?? this.notes,
    );
  }
}
