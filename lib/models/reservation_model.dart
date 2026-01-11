class Reservation {
  final String? id;
  final String serviceId;
  final String serviceName;
  final String customerName;
  final String customerEmail;
  final String customerPhone;
  final DateTime reservationDate;
  final String reservationTime;
  final String? notes;
  final String status; // pending, confirmed, cancelled
  final DateTime createdAt;

  Reservation({
    this.id,
    required this.serviceId,
    required this.serviceName,
    required this.customerName,
    required this.customerEmail,
    required this.customerPhone,
    required this.reservationDate,
    required this.reservationTime,
    this.notes,
    this.status = 'pending',
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory Reservation.fromJson(Map<String, dynamic> json) {
    return Reservation(
      id: json['id']?.toString(),
      serviceId: json['service_id']?.toString() ?? '',
      serviceName: json['service_name']?.toString() ?? '',
      customerName: json['customer_name']?.toString() ?? '',
      customerEmail: json['customer_email']?.toString() ?? '',
      customerPhone: json['customer_phone']?.toString() ?? '',
      reservationDate: DateTime.parse(json['reservation_date']?.toString() ?? DateTime.now().toString()),
      reservationTime: json['reservation_time']?.toString() ?? '',
      notes: json['notes']?.toString(),
      status: json['status']?.toString() ?? 'pending',
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at'].toString())
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'service_id': serviceId,
      'service_name': serviceName,
      'customer_name': customerName,
      'customer_email': customerEmail,
      'customer_phone': customerPhone,
      'reservation_date': reservationDate.toIso8601String().split('T')[0],
      'reservation_time': reservationTime,
      'notes': notes,
      'status': status,
      'created_at': createdAt.toIso8601String(),
    };
  }

  Map<String, dynamic> toInsert() {
    return {
      'service_id': serviceId,
      'service_name': serviceName,
      'customer_name': customerName,
      'customer_email': customerEmail,
      'customer_phone': customerPhone,
      'reservation_date': reservationDate.toIso8601String().split('T')[0],
      'reservation_time': reservationTime,
      'notes': notes,
      'status': status,
    };
  }

  // TAMBAHKAN method copyWith di sini
  Reservation copyWith({
    String? id,
    String? serviceId,
    String? serviceName,
    String? customerName,
    String? customerEmail,
    String? customerPhone,
    DateTime? reservationDate,
    String? reservationTime,
    String? notes,
    String? status,
    DateTime? createdAt,
  }) {
    return Reservation(
      id: id ?? this.id,
      serviceId: serviceId ?? this.serviceId,
      serviceName: serviceName ?? this.serviceName,
      customerName: customerName ?? this.customerName,
      customerEmail: customerEmail ?? this.customerEmail,
      customerPhone: customerPhone ?? this.customerPhone,
      reservationDate: reservationDate ?? this.reservationDate,
      reservationTime: reservationTime ?? this.reservationTime,
      notes: notes ?? this.notes,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}