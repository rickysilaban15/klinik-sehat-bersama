import 'package:flutter/material.dart';

class Service {
  final String id;
  String name;
  String description;
  String icon;
  String? imageUrl;
  int order;
  DateTime createdAt;
  DateTime updatedAt;

  Service({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    this.imageUrl,
    required this.order,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      icon: json['icon'] ?? 'medical_services',
      imageUrl: json['image_url'],
      order: json['order'] ?? 0,
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at']) 
          : DateTime.now(),
      updatedAt: json['updated_at'] != null 
          ? DateTime.parse(json['updated_at']) 
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'icon': icon,
      'image_url': imageUrl,
      'order': order,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  // Convert to JSON for insertion (without id)
  Map<String, dynamic> toInsert() {
    return {
      'name': name,
      'description': description,
      'icon': icon,
      'image_url': imageUrl,
      'order': order,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  // Convert to JSON for update (without created_at)
  Map<String, dynamic> toUpdate() {
    return {
      'name': name,
      'description': description,
      'icon': icon,
      'image_url': imageUrl,
      'order': order,
      'updated_at': DateTime.now().toIso8601String(),
    };
  }

  Service copyWith({
    String? id,
    String? name,
    String? description,
    String? icon,
    String? imageUrl,
    int? order,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Service(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      icon: icon ?? this.icon,
      imageUrl: imageUrl ?? this.imageUrl,
      order: order ?? this.order,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // Helper methods - PERBAIKI ICON YANG TERSEDIA
  IconData get iconData {
    switch (icon) {
      case 'medical_services':
        return Icons.medical_services;
      case 'science':
        return Icons.science;
      case 'vaccines':
        return Icons.vaccines;
      case 'family_restroom':
        return Icons.family_restroom;
      case 'healing':
        return Icons.healing;
      case 'accessible':
        return Icons.accessible;
      case 'local_hospital':
        return Icons.local_hospital;
      case 'medication':
        return Icons.medication;
      case 'monitor_heart':
        return Icons.monitor_heart;
      case 'psychology':
        return Icons.psychology;
      case 'elderly':
        return Icons.elderly;
      case 'pregnant_woman':
        return Icons.pregnant_woman;
      case 'child_care':
        return Icons.child_care;
      case 'coronavirus':
        return Icons.coronavirus;
      case 'medical_information':
        return Icons.medical_information;
      case 'local_pharmacy':
        return Icons.local_pharmacy;
      case 'favorite':
        return Icons.favorite;
      case 'visibility':
        return Icons.visibility;
      case 'hearing':
        return Icons.hearing;
      case 'spa':
        return Icons.spa;
      case 'fitness_center':
        return Icons.fitness_center;
      case 'water_drop':
        return Icons.water_drop;
      case 'lunch_dining':
        return Icons.lunch_dining;
      case 'nature_people':
        return Icons.nature_people;
      case 'self_improvement':
        return Icons.self_improvement;
      case 'sentiment_satisfied':
        return Icons.sentiment_satisfied;
      case 'sanitizer':
        return Icons.sanitizer;
      case 'soap':
        return Icons.soap;
      case 'thermostat':
        return Icons.thermostat;
      // Untuk "tooth" dan "brain" yang tidak ada di Icons, gunakan alternatif
      case 'tooth':
        return Icons.medical_services; // Alternatif untuk dentistry
      case 'brain':
        return Icons.psychology; // Alternatif untuk neurology
      default:
        return Icons.medical_services;
    }
  }

  // Get image URL or default placeholder
  String get displayImageUrl {
    if (imageUrl != null && imageUrl!.isNotEmpty) {
      return imageUrl!;
    }
    // Default placeholder image
    return 'https://images.unsplash.com/photo-1576091160399-112ba8d25d1d?w=800&q=80';
  }

  // Create empty service for forms
  static Service empty() {
    return Service(
      id: '',
      name: '',
      description: '',
      icon: 'medical_services',
      imageUrl: null,
      order: 0,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  // Check if service is empty (for validation)
  bool get isEmpty {
    return name.isEmpty || description.isEmpty;
  }

  // Validate service data
  List<String> validate() {
    final errors = <String>[];
    
    if (name.isEmpty) {
      errors.add('Nama layanan harus diisi');
    }
    
    if (description.isEmpty) {
      errors.add('Deskripsi layanan harus diisi');
    }
    
    if (name.length < 3) {
      errors.add('Nama layanan minimal 3 karakter');
    }
    
    if (description.length < 10) {
      errors.add('Deskripsi layanan minimal 10 karakter');
    }
    
    return errors;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Service &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          description == other.description &&
          icon == other.icon &&
          imageUrl == other.imageUrl &&
          order == other.order;

  @override
  int get hashCode =>
      id.hashCode ^
      name.hashCode ^
      description.hashCode ^
      icon.hashCode ^
      imageUrl.hashCode ^
      order.hashCode;

  @override
  String toString() {
    return 'Service(id: $id, name: $name, order: $order, hasImage: ${imageUrl != null})';
  }
}