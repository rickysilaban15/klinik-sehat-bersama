import 'package:flutter/foundation.dart';

class SettingsNotifier extends ChangeNotifier {
  Map<String, String> _settings = {};
  DateTime? _lastFetch;
  static const Duration _cacheDuration = Duration(minutes: 5);

  // Default values
  static const String defaultClinicNamePrimary = 'Klinik Sehat';
  static const String defaultClinicNameSecondary = 'Bersama';
  static const String defaultTagline = 'Melayani dengan Hati, Menyembuhkan dengan Profesional';
  static const String defaultDescription = 'Kami berkomitmen memberikan pelayanan kesehatan terbaik dengan fasilitas modern dan tim medis profesional untuk kesehatan keluarga Anda.';

  // Getters
  String get clinicNamePrimary => _settings['clinic_name_primary'] ?? defaultClinicNamePrimary;
  String get clinicNameSecondary => _settings['clinic_name_secondary'] ?? defaultClinicNameSecondary;
  String get clinicTagline => _settings['clinic_tagline'] ?? defaultTagline;
  String get clinicDescription => _settings['clinic_description'] ?? defaultDescription;
  String get contactAddress => _settings['contact_address'] ?? '';
  String get contactPhone => _settings['contact_phone'] ?? '';
  String get contactEmail => _settings['contact_email'] ?? '';
  String get contactWhatsapp => _settings['contact_whatsapp'] ?? '';
  String get operatingHours => _settings['operating_hours'] ?? '';
  bool get emergencyAvailable => _settings['emergency_available'] == 'true';
  String get logoUrl => _settings['logo_url'] ?? '';
  String get facebookUrl => _settings['facebook_url'] ?? '';
  String get instagramUrl => _settings['instagram_url'] ?? '';
  String get twitterUrl => _settings['twitter_url'] ?? '';
  String get mapsUrl => _settings['maps_url'] ?? '';

  // Load settings
  Future<void> loadSettings(dynamic supabaseService) async {
    final now = DateTime.now();
    
    if (_lastFetch != null && 
        now.difference(_lastFetch!) < _cacheDuration && 
        _settings.isNotEmpty) {
      return;
    }

    try {
      _settings = await supabaseService.getAllSettings();
      _lastFetch = now;
      notifyListeners();
    } catch (e) {
      print('Error loading settings: $e');
    }
  }

  // Force refresh
  Future<void> refreshSettings(dynamic supabaseService) async {
    _lastFetch = null;
    await loadSettings(supabaseService);
  }

  // Clear cache
  void clearCache() {
    _settings.clear();
    _lastFetch = null;
    notifyListeners();
  }
}