import 'package:flutter/material.dart';

class ContactModel {
  final String id;
  final String heroTitle;
  final String heroSubtitle;
  final String heroIcon;
  
  // Contact Info Section
  final String contactInfoTitle;
  final String addressTitle;
  final String addressContent;
  final String phoneTitle;
  final String phoneContent;
  final String emailTitle;
  final String emailContent;
  
  // Contact Form Section
  final String formTitle;
  final String formNameLabel;
  final String formEmailLabel;
  final String formMessageLabel;
  final String formButtonText;
  final String formSuccessTitle;
  final String formSuccessMessage;
  
  // Operating Hours Section
  final String operatingHoursTitle;
  final Map<String, String> operatingHours; // day: time
  
  // Map Section
  final String mapTitle;
  final String mapButtonText;
  final String mapsUrl;
  
  final DateTime? updatedAt;

  ContactModel({
    required this.id,
    required this.heroTitle,
    required this.heroSubtitle,
    required this.heroIcon,
    required this.contactInfoTitle,
    required this.addressTitle,
    required this.addressContent,
    required this.phoneTitle,
    required this.phoneContent,
    required this.emailTitle,
    required this.emailContent,
    required this.formTitle,
    required this.formNameLabel,
    required this.formEmailLabel,
    required this.formMessageLabel,
    required this.formButtonText,
    required this.formSuccessTitle,
    required this.formSuccessMessage,
    required this.operatingHoursTitle,
    required this.operatingHours,
    required this.mapTitle,
    required this.mapButtonText,
    required this.mapsUrl,
    this.updatedAt,
  });

  factory ContactModel.fromJson(Map<String, dynamic> json) {
    return ContactModel(
      id: json['id']?.toString() ?? '',
      heroTitle: json['hero_title'] ?? 'Hubungi Kami',
      heroSubtitle: json['hero_subtitle'] ?? 'Kami siap melayani dan menjawab pertanyaan Anda',
      heroIcon: json['hero_icon'] ?? 'contact_mail',
      contactInfoTitle: json['contact_info_title'] ?? 'Informasi Kontak',
      addressTitle: json['address_title'] ?? 'Alamat',
      addressContent: json['address_content'] ?? '',
      phoneTitle: json['phone_title'] ?? 'Telepon',
      phoneContent: json['phone_content'] ?? '',
      emailTitle: json['email_title'] ?? 'Email',
      emailContent: json['email_content'] ?? '',
      formTitle: json['form_title'] ?? 'Kirim Pesan',
      formNameLabel: json['form_name_label'] ?? 'Nama Lengkap',
      formEmailLabel: json['form_email_label'] ?? 'Email',
      formMessageLabel: json['form_message_label'] ?? 'Pesan',
      formButtonText: json['form_button_text'] ?? 'Kirim Pesan',
      formSuccessTitle: json['form_success_title'] ?? 'Pesan Terkirim',
      formSuccessMessage: json['form_success_message'] ?? 'Terima kasih atas pesan Anda. Kami akan membalas segera.',
      operatingHoursTitle: json['operating_hours_title'] ?? 'Jam Operasional',
      operatingHours: json['operating_hours'] != null 
          ? Map<String, String>.from(json['operating_hours'])
          : {
              'Senin - Jumat': '08:00 - 21:00',
              'Sabtu': '08:00 - 18:00',
              'Minggu': '09:00 - 15:00',
              'Emergency': '24 Jam',
            },
      mapTitle: json['map_title'] ?? 'Lokasi Klinik',
      mapButtonText: json['map_button_text'] ?? 'Buka di Google Maps',
      mapsUrl: json['maps_url'] ?? '',
      updatedAt: json['updated_at'] != null 
          ? DateTime.parse(json['updated_at']) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'hero_title': heroTitle,
      'hero_subtitle': heroSubtitle,
      'hero_icon': heroIcon,
      'contact_info_title': contactInfoTitle,
      'address_title': addressTitle,
      'address_content': addressContent,
      'phone_title': phoneTitle,
      'phone_content': phoneContent,
      'email_title': emailTitle,
      'email_content': emailContent,
      'form_title': formTitle,
      'form_name_label': formNameLabel,
      'form_email_label': formEmailLabel,
      'form_message_label': formMessageLabel,
      'form_button_text': formButtonText,
      'form_success_title': formSuccessTitle,
      'form_success_message': formSuccessMessage,
      'operating_hours_title': operatingHoursTitle,
      'operating_hours': operatingHours,
      'map_title': mapTitle,
      'map_button_text': mapButtonText,
      'maps_url': mapsUrl,
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  ContactModel copyWith({
    String? id,
    String? heroTitle,
    String? heroSubtitle,
    String? heroIcon,
    String? contactInfoTitle,
    String? addressTitle,
    String? addressContent,
    String? phoneTitle,
    String? phoneContent,
    String? emailTitle,
    String? emailContent,
    String? formTitle,
    String? formNameLabel,
    String? formEmailLabel,
    String? formMessageLabel,
    String? formButtonText,
    String? formSuccessTitle,
    String? formSuccessMessage,
    String? operatingHoursTitle,
    Map<String, String>? operatingHours,
    String? mapTitle,
    String? mapButtonText,
    String? mapsUrl,
    DateTime? updatedAt,
  }) {
    return ContactModel(
      id: id ?? this.id,
      heroTitle: heroTitle ?? this.heroTitle,
      heroSubtitle: heroSubtitle ?? this.heroSubtitle,
      heroIcon: heroIcon ?? this.heroIcon,
      contactInfoTitle: contactInfoTitle ?? this.contactInfoTitle,
      addressTitle: addressTitle ?? this.addressTitle,
      addressContent: addressContent ?? this.addressContent,
      phoneTitle: phoneTitle ?? this.phoneTitle,
      phoneContent: phoneContent ?? this.phoneContent,
      emailTitle: emailTitle ?? this.emailTitle,
      emailContent: emailContent ?? this.emailContent,
      formTitle: formTitle ?? this.formTitle,
      formNameLabel: formNameLabel ?? this.formNameLabel,
      formEmailLabel: formEmailLabel ?? this.formEmailLabel,
      formMessageLabel: formMessageLabel ?? this.formMessageLabel,
      formButtonText: formButtonText ?? this.formButtonText,
      formSuccessTitle: formSuccessTitle ?? this.formSuccessTitle,
      formSuccessMessage: formSuccessMessage ?? this.formSuccessMessage,
      operatingHoursTitle: operatingHoursTitle ?? this.operatingHoursTitle,
      operatingHours: operatingHours ?? this.operatingHours,
      mapTitle: mapTitle ?? this.mapTitle,
      mapButtonText: mapButtonText ?? this.mapButtonText,
      mapsUrl: mapsUrl ?? this.mapsUrl,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // Helper method to get icon data
  IconData get heroIconData {
    switch (heroIcon.toLowerCase()) {
      case 'contact_mail':
        return Icons.contact_mail;
      case 'email':
        return Icons.email;
      case 'phone':
        return Icons.phone;
      case 'location_on':
        return Icons.location_on;
      default:
        return Icons.contact_mail;
    }
  }
}

// Model untuk menyimpan pesan dari contact form
class ContactMessage {
  final String id;
  final String name;
  final String email;
  final String message;
  final DateTime createdAt;
  final bool isRead;

  ContactMessage({
    required this.id,
    required this.name,
    required this.email,
    required this.message,
    required this.createdAt,
    this.isRead = false,
  });

  factory ContactMessage.fromJson(Map<String, dynamic> json) {
    return ContactMessage(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      message: json['message'] ?? '',
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
      isRead: json['is_read'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'message': message,
      'created_at': createdAt.toIso8601String(),
      'is_read': isRead,
    };
  }

  ContactMessage copyWith({
    String? id,
    String? name,
    String? email,
    String? message,
    DateTime? createdAt,
    bool? isRead,
  }) {
    return ContactMessage(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      message: message ?? this.message,
      createdAt: createdAt ?? this.createdAt,
      isRead: isRead ?? this.isRead,
    );
  }
}