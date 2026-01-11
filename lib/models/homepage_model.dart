class HomepageContent {
  final String id;
  
  // Hero Section
  String title;
  String subtitle;
  String heroImage;
  String heroButtonText;
  
  // Why Choose Us Section
  String whyChooseUsTitle;
  String whyChooseUsSubtitle;
  List<String> features;
  
  // Services Section
  String servicesSectionTitle;
  String servicesSectionSubtitle;
  
  // Testimonial Section
  String testimonialTitle;
  List<Map<String, String>> testimonials;
  
  // CTA Section
  String ctaTitle;
  String ctaSubtitle;
  String ctaButton1Text;
  String ctaButton2Text;
  
  DateTime updatedAt;

  HomepageContent({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.heroImage,
    required this.heroButtonText,
    required this.whyChooseUsTitle,
    required this.whyChooseUsSubtitle,
    required this.features,
    required this.servicesSectionTitle,
    required this.servicesSectionSubtitle,
    required this.testimonialTitle,
    required this.testimonials,
    required this.ctaTitle,
    required this.ctaSubtitle,
    required this.ctaButton1Text,
    required this.ctaButton2Text,
    required this.updatedAt,
  });

  factory HomepageContent.fromJson(Map<String, dynamic> json) {
    // Parse testimonials from JSONB
    List<Map<String, String>> parsedTestimonials = [];
    if (json['testimonials'] != null) {
      final testimonialsData = json['testimonials'] as List<dynamic>;
      parsedTestimonials = testimonialsData.map((t) {
        return {
          'name': t['name']?.toString() ?? '',
          'role': t['role']?.toString() ?? '',
          'text': t['text']?.toString() ?? '',
        };
      }).toList();
    }

    return HomepageContent(
      id: json['id'] ?? '',
      
      // Hero Section
      title: json['title'] ?? 'Klinik Sehat Bersama',
      subtitle: json['subtitle'] ?? 'Pelayanan Kesehatan Terbaik untuk Keluarga Anda',
      heroImage: json['hero_image'] ?? 'https://images.unsplash.com/photo-1519494026892-80bbd2d6fd0d',
      heroButtonText: json['hero_button_text'] ?? 'Lihat Layanan Kami',
      
      // Why Choose Us Section
      whyChooseUsTitle: json['why_choose_us_title'] ?? 'Mengapa Memilih Kami?',
      whyChooseUsSubtitle: json['why_choose_us_subtitle'] ?? 'Kami memberikan pelayanan terbaik dengan standar tertinggi',
      features: List<String>.from(json['features'] ?? []),
      
      // Services Section
      servicesSectionTitle: json['services_section_title'] ?? 'Layanan Unggulan',
      servicesSectionSubtitle: json['services_section_subtitle'] ?? 'Berbagai layanan kesehatan komprehensif untuk kebutuhan Anda',
      
      // Testimonial Section
      testimonialTitle: json['testimonial_title'] ?? 'Testimoni Pasien',
      testimonials: parsedTestimonials,
      
      // CTA Section
      ctaTitle: json['cta_title'] ?? 'Siap Melayani Kesehatan Anda',
      ctaSubtitle: json['cta_subtitle'] ?? 'Jadwalkan konsultasi dengan dokter kami sekarang juga',
      ctaButton1Text: json['cta_button1_text'] ?? 'Hubungi Kami',
      ctaButton2Text: json['cta_button2_text'] ?? 'Lihat Layanan',
      
      updatedAt: DateTime.parse(json['updated_at'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      
      // Hero Section
      'title': title,
      'subtitle': subtitle,
      'hero_image': heroImage,
      'hero_button_text': heroButtonText,
      
      // Why Choose Us Section
      'why_choose_us_title': whyChooseUsTitle,
      'why_choose_us_subtitle': whyChooseUsSubtitle,
      'features': features,
      
      // Services Section
      'services_section_title': servicesSectionTitle,
      'services_section_subtitle': servicesSectionSubtitle,
      
      // Testimonial Section
      'testimonial_title': testimonialTitle,
      'testimonials': testimonials,
      
      // CTA Section
      'cta_title': ctaTitle,
      'cta_subtitle': ctaSubtitle,
      'cta_button1_text': ctaButton1Text,
      'cta_button2_text': ctaButton2Text,
      
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  Map<String, dynamic> toInsert() {
    return {
      // Hero Section
      'title': title,
      'subtitle': subtitle,
      'hero_image': heroImage,
      'hero_button_text': heroButtonText,
      
      // Why Choose Us Section
      'why_choose_us_title': whyChooseUsTitle,
      'why_choose_us_subtitle': whyChooseUsSubtitle,
      'features': features,
      
      // Services Section
      'services_section_title': servicesSectionTitle,
      'services_section_subtitle': servicesSectionSubtitle,
      
      // Testimonial Section
      'testimonial_title': testimonialTitle,
      'testimonials': testimonials,
      
      // CTA Section
      'cta_title': ctaTitle,
      'cta_subtitle': ctaSubtitle,
      'cta_button1_text': ctaButton1Text,
      'cta_button2_text': ctaButton2Text,
    };
  }

  Map<String, dynamic> toUpdate() {
    return {
      // Hero Section
      'title': title,
      'subtitle': subtitle,
      'hero_image': heroImage,
      'hero_button_text': heroButtonText,
      
      // Why Choose Us Section
      'why_choose_us_title': whyChooseUsTitle,
      'why_choose_us_subtitle': whyChooseUsSubtitle,
      'features': features,
      
      // Services Section
      'services_section_title': servicesSectionTitle,
      'services_section_subtitle': servicesSectionSubtitle,
      
      // Testimonial Section
      'testimonial_title': testimonialTitle,
      'testimonials': testimonials,
      
      // CTA Section
      'cta_title': ctaTitle,
      'cta_subtitle': ctaSubtitle,
      'cta_button1_text': ctaButton1Text,
      'cta_button2_text': ctaButton2Text,
      
      'updated_at': DateTime.now().toIso8601String(),
    };
  }
}