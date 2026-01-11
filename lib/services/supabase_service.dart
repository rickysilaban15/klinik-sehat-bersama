import 'dart:io';
import 'package:flutter/material.dart';
import '../models/service_model.dart';
import '../models/reservation_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';

class SupabaseService with ChangeNotifier {
  final SupabaseClient _supabase = Supabase.instance.client;
  
  bool _isLoading = false;
  List<Service> _services = [];
  List<Reservation> _reservations = [];

  bool get isLoading => _isLoading;
  List<Service> get services => _services;
  List<Reservation> get reservations => _reservations;

  // ==================== SERVICES METHODS ====================

  Future<void> fetchServices() async {
    try {
      _isLoading = true;
      notifyListeners();

      final response = await _supabase
          .from('services')
          .select()
          .order('order', ascending: true);
      
      if (response == null) {
        throw Exception('Failed to fetch services: No response');
      }

      _services = (response as List)
          .map((item) => Service.fromJson(item))
          .toList();
      
      notifyListeners();
    } catch (e) {
      print('Error fetching services: $e');
      if (_services.isEmpty) {
        _services = _getDummyServices();
        notifyListeners();
      }
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<Service?> fetchServiceById(String id) async {
    try {
      final response = await _supabase
          .from('services')
          .select()
          .eq('id', id)
          .single();
      
      if (response == null) {
        print('Error fetching service: Service not found');
        return null;
      }

      return Service.fromJson(response);
    } catch (e) {
      print('Error fetching service by id: $e');
      return null;
    }
  }

  Future<void> createService(Service service) async {
    try {
      await _supabase
          .from('services')
          .insert(service.toInsert());

      await fetchServices();
      
      print('✅ Service created successfully');
    } catch (e) {
      print('Error creating service: $e');
      rethrow;
    }
  }

  Future<void> updateService(Service service) async {
    try {
      await _supabase
          .from('services')
          .update(service.toUpdate())
          .eq('id', service.id);

      await fetchServices();
      
      print('✅ Service updated successfully');
    } catch (e) {
      print('Error updating service: $e');
      rethrow;
    }
  }

  Future<void> deleteService(String id) async {
    try {
      await _supabase
          .from('services')
          .delete()
          .eq('id', id);

      // Remove from local list
      _services.removeWhere((service) => service.id == id);
      notifyListeners();
      
      print('✅ Service deleted successfully');
    } catch (e) {
      print('Error deleting service: $e');
      rethrow;
    }
  }

  Future<void> reorderServices(List<Service> newOrder) async {
    try {
      // Update each service's order
      for (int i = 0; i < newOrder.length; i++) {
        final service = newOrder[i].copyWith(order: i + 1);
        
        await _supabase
            .from('services')
            .update({'order': service.order})
            .eq('id', service.id);
      }

      // Update local list
      _services = newOrder;
      notifyListeners();
      
      print('✅ Services reordered successfully');
    } catch (e) {
      print('Error reordering services: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getServiceStats() async {
    try {
      final response = await _supabase
          .from('services')
          .select('id, name, created_at');
      
      if (response == null) {
        return {
          'total': 0,
          'recently_added': 0,
        };
      }

      final services = response as List;
      final now = DateTime.now();
      final oneWeekAgo = now.subtract(const Duration(days: 7));
      
      final recentlyAdded = services.where((service) {
        final createdAt = DateTime.parse(service['created_at']);
        return createdAt.isAfter(oneWeekAgo);
      }).length;

      return {
        'total': services.length,
        'recently_added': recentlyAdded,
      };
    } catch (e) {
      print('Error getting service stats: $e');
      return {
        'total': 0,
        'recently_added': 0,
      };
    }
  }

  // ==================== HOMEPAGE METHODS ====================

  Future<Map<String, dynamic>?> getHomepageData() async {
    try {
      final response = await _supabase
          .from('homepage')
          .select()
          .order('updated_at', ascending: false)
          .limit(1)
          .single();

      return response;
    } catch (e) {
      print('Exception getting homepage data: $e');
      return null;
    }
  }

  Future<void> updateHomepageData(Map<String, dynamic> data) async {
    try {
      final existingData = await getHomepageData();
      
      if (existingData != null) {
        await _supabase
            .from('homepage')
            .update(data)
            .eq('id', existingData['id']);
      } else {
        await _supabase
            .from('homepage')
            .insert(data);
      }
      
      notifyListeners();
    } catch (e) {
      print('Error updating homepage data: $e');
      rethrow;
    }
  }

  // ==================== ABOUT PAGE METHODS ====================

  Future<Map<String, dynamic>?> getAboutData() async {
    try {
      final response = await _supabase
          .from('about')
          .select()
          .order('updated_at', ascending: false)
          .limit(1);

      if (response == null || (response as List).isEmpty) {
        print('No about data found, returning defaults');
        return _getDefaultAboutData();
      }

      final data = (response as List).first as Map<String, dynamic>;
      return data;
    } catch (e) {
      print('Exception getting about data: $e');
      return _getDefaultAboutData();
    }
  }

  Map<String, dynamic> _getDefaultAboutData() {
    return {
      'title': 'Tentang Kami',
      'subtitle': 'Mengenal Lebih Dekat Klinik Sehat Bersama',
      'hero_image': null,
      'history_title': 'Sejarah Klinik',
      'history_image': 'https://images.unsplash.com/photo-1582750433449-648ed127bb54',
      'history_content_1': 'Klinik Sehat Bersama didirikan pada tahun 2010 oleh Dr. Budi Santoso dengan visi memberikan pelayanan kesehatan yang terjangkau dan berkualitas bagi seluruh masyarakat. Bermula dari klinik kecil dengan 2 dokter, kini kami telah berkembang menjadi klinik kesehatan terpadu dengan fasilitas modern.',
      'history_content_2': 'Dalam perjalanan lebih dari 10 tahun, kami telah melayani ribuan pasien dengan berbagai kebutuhan kesehatan. Komitmen kami terhadap kualitas pelayanan membuat kami terus berinovasi dan memperbarui fasilitas untuk memberikan yang terbaik bagi pasien.',
      'mission_title': 'Misi Kami',
      'mission_image': 'https://images.unsplash.com/photo-1579684385127-1ef15d508118',
      'mission_content': 'Menyediakan layanan kesehatan yang terjangkau, berkualitas, dan ramah bagi seluruh lapisan masyarakat dengan mengutamakan kepuasan pasien dan standar medis tertinggi.',
      'mission_points': [
        'Memberikan pelayanan kesehatan yang holistik',
        'Menggunakan teknologi medis terkini',
        'Menyediakan lingkungan yang nyaman dan aman',
        'Mengedukasi masyarakat tentang kesehatan'
      ],
      'vision_title': 'Visi Kami',
      'vision_image': 'https://images.unsplash.com/photo-1559757148-5c350d0d3c56',
      'vision_content': 'Menjadi klinik kesehatan terdepan dan terpercaya di wilayah ini yang dikenal karena pelayanan prima, teknologi modern, dan tim medis profesional.',
      'vision_points': [
        'Pusat rujukan kesehatan masyarakat',
        'Inovasi dalam pelayanan kesehatan',
        'Membangun kepercayaan masyarakat',
        'Berkontribusi pada kesehatan nasional'
      ],
      'team_title': 'Tim Profesional Kami',
      'team_image': 'https://images.unsplash.com/photo-1551601651-2a8555f1a136',
      'team': [
        {
          'name': 'Dr. Budi Santoso',
          'position': 'Dokter Umum',
          'education': 'Spesialis Penyakit Dalam',
          'photo_url': null
        },
        {
          'name': 'Dr. Siti Aminah',
          'position': 'Dokter Anak',
          'education': 'Spesialis Anak',
          'photo_url': null
        },
        {
          'name': 'Dr. Ahmad Rizal',
          'position': 'Dokter Gigi',
          'education': 'Spesialis Gigi',
          'photo_url': null
        },
        {
          'name': 'Nurul Hasanah, S.Kep',
          'position': 'Kepala Perawat',
          'education': 'S.Kep Ners',
          'photo_url': null
        },
        {
          'name': 'Rina Marlina, A.Md.AK',
          'position': 'Analis Lab',
          'education': 'D3 Analis Kesehatan',
          'photo_url': null
        },
        {
          'name': 'Dian Permatasari',
          'position': 'Administrasi',
          'education': 'S1 Administrasi',
          'photo_url': null
        },
      ],
    };
  }

  Future<void> updateAboutData(Map<String, dynamic> data) async {
    try {
      print('Starting updateAboutData with data: ${data.keys}');
      
      // Check if record exists
      final existingResponse = await _supabase
          .from('about')
          .select('id')
          .limit(1);
      
      print('Existing data check: ${existingResponse}');
      
      if (existingResponse != null && (existingResponse as List).isNotEmpty) {
        // Update existing record
        final existingId = (existingResponse as List).first['id'];
        print('Updating existing record with id: $existingId');
        
        await _supabase
            .from('about')
            .update(data)
            .eq('id', existingId)
            .select();
        
        print('✅ About data updated successfully');
      } else {
        // Insert new record
        print('Inserting new record');
        
        await _supabase
            .from('about')
            .insert(data)
            .select();
        
        print('✅ About data inserted successfully');
      }
      
      notifyListeners();
    } catch (e) {
      print('❌ Error updating about data: $e');
      print('Error type: ${e.runtimeType}');
      if (e is PostgrestException) {
        print('Postgrest error details: ${e.message}');
        print('Postgrest error code: ${e.code}');
        print('Postgrest error hint: ${e.hint}');
      }
      rethrow;
    }
  }

  // ==================== RESERVATION METHODS ====================

  Future<void> fetchReservations() async {
    try {
      _isLoading = true;
      notifyListeners();

      final response = await _supabase
          .from('reservations')
          .select()
          .order('created_at', ascending: false);
      
      if (response == null) {
        throw Exception('Failed to fetch reservations: No response');
      }

      _reservations = (response as List)
          .map((item) => Reservation.fromJson(item))
          .toList();
      
      notifyListeners();
    } catch (e) {
      print('Error fetching reservations: $e');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> createReservation(Reservation reservation) async {
    try {
      await _supabase
          .from('reservations')
          .insert(reservation.toInsert());
      
      print('Reservation created successfully');
      notifyListeners();
    } catch (e) {
      print('Error creating reservation: $e');
      rethrow;
    }
  }

  Future<List<Reservation>> fetchUpcomingReservations() async {
    try {
      final today = DateTime.now().toIso8601String().split('T')[0];
      
      final response = await _supabase
          .from('reservations')
          .select()
          .gte('reservation_date', today)
          .neq('status', 'cancelled')
          .order('reservation_date', ascending: true)
          .order('reservation_time', ascending: true);
      
      return (response as List)
          .map((item) => Reservation.fromJson(item))
          .toList();
    } catch (e) {
      print('Error fetching upcoming reservations: $e');
      rethrow;
    }
  }

  Future<List<Reservation>> fetchReservationsByEmail(String email) async {
    try {
      final response = await _supabase
          .from('reservations')
          .select()
          .eq('customer_email', email)
          .order('created_at', ascending: false);
      
      return (response as List)
          .map((item) => Reservation.fromJson(item))
          .toList();
    } catch (e) {
      print('Error fetching reservations by email: $e');
      rethrow;
    }
  }

  Future<void> updateReservationStatus(String id, String status) async {
    try {
      if (!['pending', 'confirmed', 'cancelled'].contains(status)) {
        throw Exception('Invalid status: $status');
      }

      await _supabase
          .from('reservations')
          .update({'status': status})
          .eq('id', id);
      
      // Update local list
      final index = _reservations.indexWhere((r) => r.id == id);
      if (index != -1) {
        _reservations[index] = _reservations[index].copyWith(status: status);
        notifyListeners();
      }
      
      print('Reservation status updated: $id -> $status');
    } catch (e) {
      print('Error updating reservation status: $e');
      rethrow;
    }
  }

  Future<void> deleteReservation(String id) async {
    try {
      await _supabase
          .from('reservations')
          .delete()
          .eq('id', id);
      
      // Remove from local list
      _reservations.removeWhere((r) => r.id == id);
      notifyListeners();
      
      print('Reservation deleted: $id');
    } catch (e) {
      print('Error deleting reservation: $e');
      rethrow;
    }
  }

  Future<bool> isTimeSlotAvailable({
    required DateTime date,
    required String time,
  }) async {
    try {
      final dateStr = date.toIso8601String().split('T')[0];
      
      final response = await _supabase
          .from('reservations')
          .select('id')
          .eq('reservation_date', dateStr)
          .eq('reservation_time', time)
          .neq('status', 'cancelled');
      
      return (response as List).isEmpty;
    } catch (e) {
      print('Error checking time slot availability: $e');
      return true;
    }
  }

  Future<List<String>> getAvailableTimeSlots(DateTime date) async {
    try {
      final allTimeSlots = [
        '08:00', '09:00', '10:00', '11:00',
        '13:00', '14:00', '15:00', '16:00',
        '17:00', '18:00', '19:00',
      ];

      final dateStr = date.toIso8601String().split('T')[0];
      
      final response = await _supabase
          .from('reservations')
          .select('reservation_time')
          .eq('reservation_date', dateStr)
          .neq('status', 'cancelled');
      
      final bookedSlots = (response as List)
          .map((item) => item['reservation_time'] as String)
          .toSet();
      
      return allTimeSlots
          .where((slot) => !bookedSlots.contains(slot))
          .toList();
    } catch (e) {
      print('Error getting available time slots: $e');
      return [
        '08:00', '09:00', '10:00', '11:00',
        '13:00', '14:00', '15:00', '16:00',
        '17:00', '18:00', '19:00',
      ];
    }
  }

  Future<Map<String, int>> getReservationStats() async {
    try {
      final today = DateTime.now().toIso8601String().split('T')[0];
      
      final response = await _supabase
          .from('reservations')
          .select('id, status, reservation_date');
      
      final all = response as List;
      
      return {
        'total': all.length,
        'pending': all.where((r) => r['status'] == 'pending').length,
        'confirmed': all.where((r) => r['status'] == 'confirmed').length,
        'cancelled': all.where((r) => r['status'] == 'cancelled').length,
        'upcoming': all.where((r) => 
          r['reservation_date'] >= today && 
          r['status'] != 'cancelled'
        ).length,
      };
    } catch (e) {
      print('Error getting reservation stats: $e');
      return {
        'total': 0,
        'pending': 0,
        'confirmed': 0,
        'cancelled': 0,
        'upcoming': 0,
      };
    }
  }

  // ==================== CONTACT PAGE METHODS ====================

  /// Get contact page data from database
  Future<Map<String, dynamic>?> getContactPageData() async {
    try {
      final response = await _supabase
          .from('contact_page')
          .select()
          .single();
      
      return response;
    } catch (e) {
      print('Error getting contact page data: $e');
      return null;
    }
  }

  Future<void> updateContactPageData(Map<String, dynamic> data) async {
    try {
      // Check if record exists
      final response = await _supabase
          .from('contact_page')
          .select('id');
      
      if (response != null && response.isNotEmpty) {
        // Update existing record
        final existingId = response[0]['id'];
        await _supabase
            .from('contact_page')
            .update(data)
            .eq('id', existingId);
      } else {
        // Insert new record
        await _supabase
            .from('contact_page')
            .insert(data);
      }
      
      notifyListeners();
    } catch (e) {
      print('Error updating contact page data: $e');
      throw Exception('Failed to update contact page: $e');
    }
  }

  /// Submit contact message from form
  Future<void> submitContactMessage({
    required String name,
    required String email,
    required String message,
  }) async {
    try {
      await _supabase.from('contact_messages').insert({
        'name': name,
        'email': email,
        'message': message,
        'is_read': false,
        'created_at': DateTime.now().toIso8601String(),
      });
      
      notifyListeners();
    } catch (e) {
      print('Error submitting contact message: $e');
      throw Exception('Failed to submit message: $e');
    }
  }

  /// Get contact messages (optional filter by read status)
  Future<List<Map<String, dynamic>>> getContactMessages({bool? isRead}) async {
    try {
      dynamic response;
      
      if (isRead != null) {
        // Query dengan filter
        response = await _supabase
            .from('contact_messages')
            .select()
            .eq('is_read', isRead)
            .order('created_at', ascending: false);
      } else {
        // Query tanpa filter (ambil semua)
        response = await _supabase
            .from('contact_messages')
            .select()
            .order('created_at', ascending: false);
      }
      
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('Error getting contact messages: $e');
      return [];
    }
  }

  /// Mark message as read
  Future<void> markMessageAsRead(String messageId) async {
    try {
      await _supabase
          .from('contact_messages')
          .update({'is_read': true})
          .eq('id', messageId);
      
      notifyListeners();
    } catch (e) {
      print('Error marking message as read: $e');
      throw Exception('Failed to mark message as read: $e');
    }
  }

  /// Delete contact message
  Future<void> deleteContactMessage(String messageId) async {
    try {
      await _supabase
          .from('contact_messages')
          .delete()
          .eq('id', messageId);
      
      notifyListeners();
    } catch (e) {
      print('Error deleting contact message: $e');
      throw Exception('Failed to delete message: $e');
    }
  }

  /// Get unread messages count
  Future<int> getUnreadMessagesCount() async {
    try {
      final response = await _supabase
          .from('contact_messages')
          .select()
          .eq('is_read', false);
      
      // Count dari list yang dikembalikan
      if (response is List) {
        return response.length;
      }
      
      return 0;
    } catch (e) {
      print('Error getting unread messages count: $e');
      return 0;
    }
  }

  // ==================== DASHBOARD METHODS ====================

  /// Get dashboard statistics
  Future<Map<String, dynamic>> getDashboardStats() async {
    try {
      // Get services count
      final servicesResponse = await _supabase
          .from('services')
          .select('id');
      final servicesCount = (servicesResponse as List).length;

      // Get contact messages stats
      final messagesResponse = await _supabase
          .from('contact_messages')
          .select('id, is_read');
      
      final allMessages = messagesResponse as List;
      final unreadMessages = allMessages.where((m) => m['is_read'] == false).length;

      // Get today's reservations
      final today = DateTime.now().toIso8601String().split('T')[0];
      
      final todayReservationsResponse = await _supabase
          .from('reservations')
          .select('id')
          .eq('reservation_date', today)
          .neq('status', 'cancelled');
      
      final todayReservations = (todayReservationsResponse as List).length;

      // Get pending reservations
      final pendingReservationsResponse = await _supabase
          .from('reservations')
          .select('id')
          .eq('status', 'pending');
      
      final pendingReservations = (pendingReservationsResponse as List).length;

      // Get upcoming reservations (from today onwards)
      final upcomingReservationsResponse = await _supabase
          .from('reservations')
          .select('id')
          .gte('reservation_date', today)
          .neq('status', 'cancelled');
      
      final upcomingReservations = (upcomingReservationsResponse as List).length;

      // Get total reservations
      final totalReservationsResponse = await _supabase
          .from('reservations')
          .select('id');
      
      final totalReservations = (totalReservationsResponse as List).length;

      return {
        'services_count': servicesCount,
        'contact_messages': allMessages.length,
        'unread_messages': unreadMessages,
        'today_reservations': todayReservations,
        'pending_reservations': pendingReservations,
        'upcoming_reservations': upcomingReservations,
        'total_reservations': totalReservations,
      };
    } catch (e) {
      print('Error getting dashboard stats: $e');
      return {
        'services_count': 0,
        'contact_messages': 0,
        'unread_messages': 0,
        'today_reservations': 0,
        'pending_reservations': 0,
        'upcoming_reservations': 0,
        'total_reservations': 0,
      };
    }
  }

  /// Get recent activity for dashboard
  Future<List<Map<String, dynamic>>> getRecentActivity({int limit = 10}) async {
    try {
      List<Map<String, dynamic>> activities = [];

      // Get recent messages (last 5)
      final recentMessages = await _supabase
          .from('contact_messages')
          .select('name, email, created_at, is_read')
          .order('created_at', ascending: false)
          .limit(5);

      for (var message in recentMessages as List) {
        activities.add({
          'type': 'message',
          'title': 'Pesan dari ${message['name']}',
          'subtitle': message['email'],
          'time': _formatTimeAgo(DateTime.parse(message['created_at'])),
          'is_new': message['is_read'] == false,
          'created_at': DateTime.parse(message['created_at']),
        });
      }

      // Get recent reservations (last 5)
      final recentReservations = await _supabase
          .from('reservations')
          .select('customer_name, service_name, reservation_date, reservation_time, status, created_at')
          .order('created_at', ascending: false)
          .limit(5);

      for (var reservation in recentReservations as List) {
        activities.add({
          'type': 'reservation',
          'title': 'Reservasi ${reservation['service_name']}',
          'subtitle': '${reservation['customer_name']} - ${reservation['reservation_date']} ${reservation['reservation_time']}',
          'time': _formatTimeAgo(DateTime.parse(reservation['created_at'])),
          'is_new': reservation['status'] == 'pending',
          'created_at': DateTime.parse(reservation['created_at']),
        });
      }

      // Sort by created_at descending
      activities.sort((a, b) => b['created_at'].compareTo(a['created_at']));

      // Return limited items
      return activities.take(limit).toList();
    } catch (e) {
      print('Error getting recent activity: $e');
      return [];
    }
  }

  /// Helper: Format time ago in Indonesian
  String _formatTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inSeconds < 60) {
      return 'Baru saja';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} menit yang lalu';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} jam yang lalu';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} hari yang lalu';
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return '$weeks minggu yang lalu';
    } else if (difference.inDays < 365) {
      final months = (difference.inDays / 30).floor();
      return '$months bulan yang lalu';
    } else {
      final years = (difference.inDays / 365).floor();
      return '$years tahun yang lalu';
    }
  }

  /// Get today's reservations detail
  Future<List<Map<String, dynamic>>> getTodayReservations() async {
    try {
      final today = DateTime.now().toIso8601String().split('T')[0];
      
      final response = await _supabase
          .from('reservations')
          .select('*')
          .eq('reservation_date', today)
          .neq('status', 'cancelled')
          .order('reservation_time', ascending: true);
      
      return List<Map<String, dynamic>>.from(response as List);
    } catch (e) {
      print('Error getting today reservations: $e');
      return [];
    }
  }

  /// Get pending reservations detail
  Future<List<Map<String, dynamic>>> getPendingReservations() async {
    try {
      final response = await _supabase
          .from('reservations')
          .select('*')
          .eq('status', 'pending')
          .order('reservation_date', ascending: true)
          .order('reservation_time', ascending: true);
      
      return List<Map<String, dynamic>>.from(response as List);
    } catch (e) {
      print('Error getting pending reservations: $e');
      return [];
    }
  }

  // ==================== WEBSITE SETTINGS METHODS ====================

  Future<Map<String, String>> getAllSettings() async {
    try {
      final response = await _supabase
          .from('website_settings')
          .select();
      
      if (response == null || (response as List).isEmpty) {
        print('No settings found in database');
        return {};
      }
      
      // Convert list of settings to map
      final Map<String, String> settings = {};
      for (var item in response as List) {
        settings[item['setting_key']] = item['setting_value']?.toString() ?? '';
      }
      
      print('✅ Loaded ${settings.length} settings');
      return settings;
    } catch (e) {
      print('Error getting all settings: $e');
      return {};
    }
  }

  /// Get single setting by key
  Future<String?> getSetting(String key) async {
    try {
      final response = await _supabase
          .from('website_settings')
          .select('setting_value')
          .eq('setting_key', key)
          .maybeSingle();
      
      if (response == null) {
        return null;
      }
      
      return response['setting_value']?.toString();
    } catch (e) {
      print('Error getting setting $key: $e');
      return null;
    }
  }

  /// Update multiple settings at once
  Future<void> updateMultipleSettings(Map<String, String> settings) async {
    try {
      print('Updating ${settings.length} settings...');
      
      for (var entry in settings.entries) {
        // Check if setting exists
        final existing = await _supabase
            .from('website_settings')
            .select('id')
            .eq('setting_key', entry.key)
            .maybeSingle();
        
        if (existing != null) {
          // Update existing setting
          await _supabase
              .from('website_settings')
              .update({
                'setting_value': entry.value,
              })
              .eq('setting_key', entry.key);
          
          print('  ✅ Updated: ${entry.key}');
        } else {
          // Insert new setting
          await _supabase
              .from('website_settings')
              .insert({
                'setting_key': entry.key,
                'setting_value': entry.value,
                'setting_type': 'text',
              });
          
          print('  ✅ Inserted: ${entry.key}');
        }
      }
      
      notifyListeners();
      print('✅ All settings updated successfully');
    } catch (e) {
      print('❌ Error updating settings: $e');
      if (e is PostgrestException) {
        print('Postgrest error: ${e.message}');
        print('Code: ${e.code}');
        print('Hint: ${e.hint}');
      }
      rethrow;
    }
  }

  /// Upload logo to Supabase Storage (supports PNG, JPG, JPEG, SVG, GIF, WEBP)
  Future<String> uploadLogo(XFile file, String fileName) async {
    try {
      print('Uploading logo: $fileName');
      
      // Read file as bytes
      final Uint8List bytes = await file.readAsBytes();
      
      // Get MIME type
      final String mimeType = file.mimeType ?? _getMimeTypeFromExtension(fileName);
      
      print('File size: ${bytes.length} bytes');
      print('MIME type: $mimeType');
      
      // Upload to Supabase Storage bucket 'logos'
      await _supabase.storage
          .from('logos')
          .uploadBinary(
            fileName,
            bytes,
            fileOptions: FileOptions(
              upsert: true,
              contentType: mimeType,
            ),
          );
      
      // Get public URL
      final publicUrl = _supabase.storage
          .from('logos')
          .getPublicUrl(fileName);
      
      print('✅ Logo uploaded successfully: $publicUrl');
      return publicUrl;
    } catch (e) {
      print('❌ Error uploading logo: $e');
      if (e is StorageException) {
        print('Storage error: ${e.message}');
        print('Status code: ${e.statusCode}');
      }
      rethrow;
    }
  }

  // ==================== SERVICE IMAGE UPLOAD ====================

  /// Upload service image to Supabase Storage
  Future<String> uploadServiceImage(XFile file, String fileName) async {
    try {
      print('Uploading service image: $fileName');
      
      // Read file as bytes
      final Uint8List bytes = await file.readAsBytes();
      
      // Get MIME type
      final String mimeType = file.mimeType ?? _getMimeTypeFromExtension(fileName);
      
      print('File size: ${bytes.length} bytes');
      print('MIME type: $mimeType');
      
      // Upload to Supabase Storage bucket 'service-images'
      await _supabase.storage
          .from('service-images')
          .uploadBinary(
            fileName,
            bytes,
            fileOptions: FileOptions(
              upsert: true,
              contentType: mimeType,
            ),
          );
      
      // Get public URL
      final publicUrl = _supabase.storage
          .from('service-images')
          .getPublicUrl(fileName);
      
      print('✅ Service image uploaded successfully: $publicUrl');
      return publicUrl;
    } catch (e) {
      print('❌ Error uploading service image: $e');
      if (e is StorageException) {
        print('Storage error: ${e.message}');
        print('Status code: ${e.statusCode}');
      }
      rethrow;
    }
  }

  /// Delete old service image from Supabase Storage
  Future<void> deleteOldServiceImage(String imageUrl) async {
    try {
      if (imageUrl.isEmpty) {
        print('No image URL provided, skipping delete');
        return;
      }
      
      // Extract filename from URL
      final uri = Uri.parse(imageUrl);
      final pathSegments = uri.pathSegments;
      
      if (pathSegments.isEmpty) {
        print('Invalid image URL, no path segments');
        return;
      }
      
      // Get the filename (last segment)
      final fileName = pathSegments.last;
      
      print('Deleting old service image: $fileName');
      
      // Delete from storage
      await _supabase.storage
          .from('service-images')
          .remove([fileName]);
      
      print('✅ Old service image deleted successfully');
    } catch (e) {
      print('⚠️ Error deleting old service image: $e');
      // Don't rethrow - deleting old image is not critical
    }
  }

  /// Get MIME type from file extension
  String _getMimeTypeFromExtension(String fileName) {
    final extension = fileName.toLowerCase().split('.').last;
    switch (extension) {
      case 'png':
        return 'image/png';
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      case 'svg':
        return 'image/svg+xml';
      case 'gif':
        return 'image/gif';
      case 'webp':
        return 'image/webp';
      default:
        return 'image/png'; // default fallback
    }
  }

  /// Delete old logo from Supabase Storage
  Future<void> deleteOldLogo(String logoUrl) async {
    try {
      if (logoUrl.isEmpty) {
        print('No logo URL provided, skipping delete');
        return;
      }
      
      // Extract filename from URL
      final uri = Uri.parse(logoUrl);
      final pathSegments = uri.pathSegments;
      
      if (pathSegments.isEmpty) {
        print('Invalid logo URL, no path segments');
        return;
      }
      
      // Get the filename (last segment)
      final fileName = pathSegments.last;
      
      print('Deleting old logo: $fileName');
      
      // Delete from storage
      await _supabase.storage
          .from('logos')
          .remove([fileName]);
      
      print('✅ Old logo deleted successfully');
    } catch (e) {
      print('⚠️ Error deleting old logo: $e');
      // Don't rethrow - deleting old logo is not critical
    }
  }

  /// Delete setting by key
  Future<void> deleteSetting(String key) async {
    try {
      await _supabase
          .from('website_settings')
          .delete()
          .eq('setting_key', key);
      
      notifyListeners();
      print('✅ Setting $key deleted successfully');
    } catch (e) {
      print('Error deleting setting $key: $e');
      rethrow;
    }
  }

  /// Get settings by type
  Future<Map<String, String>> getSettingsByType(String type) async {
    try {
      final response = await _supabase
          .from('website_settings')
          .select()
          .eq('setting_type', type);
      
      if (response == null || (response as List).isEmpty) {
        return {};
      }
      
      final Map<String, String> settings = {};
      for (var item in response as List) {
        settings[item['setting_key']] = item['setting_value']?.toString() ?? '';
      }
      
      return settings;
    } catch (e) {
      print('Error getting settings by type $type: $e');
      return {};
    }
  }

  // ==================== DUMMY DATA ====================

  List<Service> _getDummyServices() {
    return [
      Service(
        id: '1',
        name: 'Konsultasi Umum',
        description: 'Konsultasi kesehatan umum dengan dokter spesialis untuk diagnosis dan pengobatan berbagai penyakit.',
        icon: 'medical_services',
        order: 1,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      Service(
        id: '2',
        name: 'Pemeriksaan Lab',
        description: 'Pemeriksaan laboratorium lengkap dan akurat untuk diagnosis yang tepat.',
        icon: 'science',
        order: 2,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      Service(
        id: '3',
        name: 'Vaksinasi',
        description: 'Layanan vaksinasi untuk semua usia, termasuk vaksin COVID-19, influenza, dan lainnya.',
        icon: 'vaccines',
        order: 3,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      Service(
        id: '4',
        name: 'Kesehatan Ibu & Anak',
        description: 'Pelayanan kesehatan khusus untuk ibu hamil, bayi, dan anak-anak.',
        icon: 'family_restroom',
        order: 4,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      Service(
        id: '5',
        name: 'Medical Check-up',
        description: 'Pemeriksaan kesehatan menyeluruh untuk deteksi dini penyakit.',
        icon: 'healing',
        order: 5,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      Service(
        id: '6',
        name: 'Fisioterapi',
        description: 'Terapi fisik untuk pemulihan cedera dan peningkatan mobilitas.',
        icon: 'accessible',
        order: 6,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    ];
  }

  @override
  void dispose() {
    super.dispose();
  }
}