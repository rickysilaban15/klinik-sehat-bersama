class AppConstants {
  // Cache untuk settings
  static Map<String, String> _cache = {};
  static DateTime? _lastFetch;
  static const Duration _cacheDuration = Duration(minutes: 5);

  // Default values (fallback)
  static const String defaultClinicNamePrimary = 'Klinik Sehat';
  static const String defaultClinicNameSecondary = 'Bersama';
  static const String defaultTagline = 'Melayani dengan Hati, Menyembuhkan dengan Profesional';
  static const String defaultDescription = 'Kami berkomitmen memberikan pelayanan kesehatan terbaik dengan fasilitas modern dan tim medis profesional untuk kesehatan keluarga Anda.';
  static const String defaultContactAddress = 'Jl. Sehat No. 123, Kota Sejahtera';
  static const String defaultContactPhone = '+62 812 3456 7890';
  static const String defaultContactEmail = 'info@kliniksehatbersama.com';
  static const String defaultContactWhatsapp = '081234567890';
  static const String defaultOperatingHours = 'Senin - Minggu: 08:00 - 21:00';
  static const String defaultFacebookUrl = 'https://facebook.com/kliniksehatbersama';
  
  // App info
  static const String appName = 'Klinik Sehat Bersama';
  static const String appVersion = '1.0.0';
  
  // Admin credentials
  static const String adminEmail = 'admin@klinik.com';
  
  // Storage keys
  static const String authTokenKey = 'auth_token';
  static const String userEmailKey = 'user_email';
  
  // Validation messages
  static const String requiredField = 'Field ini wajib diisi';
  static const String invalidEmail = 'Email tidak valid';
  static const String minPasswordLength = 'Password minimal 6 karakter';

  // Load settings dengan cache
  static Future<void> loadSettings(dynamic supabaseService) async {
    final now = DateTime.now();
    
    if (_lastFetch != null && 
        now.difference(_lastFetch!) < _cacheDuration && 
        _cache.isNotEmpty) {
      return;
    }

    try {
      _cache = await supabaseService.getAllSettings();
      _lastFetch = now;
    } catch (e) {
      print('Error loading settings: $e');
    }
  }

  // Force refresh settings
  static Future<void> refreshSettings(dynamic supabaseService) async {
    _lastFetch = null;
    await loadSettings(supabaseService);
  }

  // Getters dengan fallback ke defaults
  static String get clinicNamePrimary => 
      _cache['clinic_name_primary'] ?? defaultClinicNamePrimary;
  
  static String get clinicNameSecondary => 
      _cache['clinic_name_secondary'] ?? defaultClinicNameSecondary;
  
  static String get clinicTagline => 
      _cache['clinic_tagline'] ?? defaultTagline;
  
  static String get clinicDescription => 
      _cache['clinic_description'] ?? defaultDescription;
  
  static String get contactAddress => 
      _cache['contact_address'] ?? defaultContactAddress;
  
  static String get contactPhone => 
      _cache['contact_phone'] ?? defaultContactPhone;
  
  static String get contactEmail => 
      _cache['contact_email'] ?? defaultContactEmail;
  
  static String get contactWhatsapp => 
      _cache['contact_whatsapp'] ?? defaultContactWhatsapp;
  
  static String get operatingHours => 
      _cache['operating_hours'] ?? defaultOperatingHours;
  
  static bool get emergencyAvailable => 
      _cache['emergency_available'] == 'true';
  
  static String get logoUrl => 
      _cache['logo_url'] ?? '';
  
  static String get facebookUrl => 
      _cache['facebook_url'] ?? defaultFacebookUrl;
  
  static String get instagramUrl => 
      _cache['instagram_url'] ?? '';
  
  static String get twitterUrl => 
      _cache['twitter_url'] ?? '';
  
  static String get mapsUrl => 
      _cache['maps_url'] ?? '';

  // Clear cache
  static void clearCache() {
    _cache.clear();
    _lastFetch = null;
  }
}