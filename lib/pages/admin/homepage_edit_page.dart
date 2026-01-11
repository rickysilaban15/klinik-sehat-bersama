import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/supabase_service.dart';
import 'admin_layout.dart';

class HomepageEditPage extends StatefulWidget {
  const HomepageEditPage({super.key});

  @override
  State<HomepageEditPage> createState() => _HomepageEditPageState();
}

class _HomepageEditPageState extends State<HomepageEditPage> {
  final _formKey = GlobalKey<FormState>();
  
  // Hero Section Controllers
  final _titleController = TextEditingController();
  final _subtitleController = TextEditingController();
  final _heroImageController = TextEditingController();
  final _heroButtonTextController = TextEditingController();
  
  // Why Choose Us Section Controllers
  final _whyChooseUsTitleController = TextEditingController();
  final _whyChooseUsSubtitleController = TextEditingController();
  final List<TextEditingController> _featureControllers = [];
  
  // Services Section Controllers
  final _servicesSectionTitleController = TextEditingController();
  final _servicesSectionSubtitleController = TextEditingController();
  
  // Testimonial Section Controllers
  final _testimonialTitleController = TextEditingController();
  final List<Map<String, TextEditingController>> _testimonialControllers = [];
  
  // CTA Section Controllers
  final _ctaTitleController = TextEditingController();
  final _ctaSubtitleController = TextEditingController();
  final _ctaButton1TextController = TextEditingController();
  final _ctaButton2TextController = TextEditingController();

  bool _isLoading = false;
  bool _hasChanges = false;

  @override
  void initState() {
    super.initState();
    
    // Initialize feature controllers for 6 features
    _initializeFeatureControllers(6);
    
    // Initialize testimonial controllers for 3 testimonials
    _initializeTestimonialControllers(3);
    
    _loadHomepageData();
    
    // Add listeners to track changes
    _addChangeListeners();
  }

  void _initializeFeatureControllers(int count) {
    for (int i = 0; i < count; i++) {
      _featureControllers.add(TextEditingController());
    }
  }

  void _initializeTestimonialControllers(int count) {
    for (int i = 0; i < count; i++) {
      _testimonialControllers.add({
        'name': TextEditingController(),
        'role': TextEditingController(),
        'text': TextEditingController(),
      });
    }
  }

  void _addChangeListeners() {
    // Hero section
    _titleController.addListener(_checkForChanges);
    _subtitleController.addListener(_checkForChanges);
    _heroImageController.addListener(_checkForChanges);
    _heroButtonTextController.addListener(_checkForChanges);
    
    // Why Choose Us section
    _whyChooseUsTitleController.addListener(_checkForChanges);
    _whyChooseUsSubtitleController.addListener(_checkForChanges);
    for (var controller in _featureControllers) {
      controller.addListener(_checkForChanges);
    }
    
    // Services section
    _servicesSectionTitleController.addListener(_checkForChanges);
    _servicesSectionSubtitleController.addListener(_checkForChanges);
    
    // Testimonial section
    _testimonialTitleController.addListener(_checkForChanges);
    for (var testimonial in _testimonialControllers) {
      testimonial['name']!.addListener(_checkForChanges);
      testimonial['role']!.addListener(_checkForChanges);
      testimonial['text']!.addListener(_checkForChanges);
    }
    
    // CTA section
    _ctaTitleController.addListener(_checkForChanges);
    _ctaSubtitleController.addListener(_checkForChanges);
    _ctaButton1TextController.addListener(_checkForChanges);
    _ctaButton2TextController.addListener(_checkForChanges);
  }

  void _checkForChanges() {
    setState(() {
      _hasChanges = true;
    });
  }

  Future<void> _loadHomepageData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final supabaseService = Provider.of<SupabaseService>(context, listen: false);
      final data = await supabaseService.getHomepageData();
      
      if (data != null) {
        // Hero Section
        _titleController.text = data['title'] ?? 'Klinik Sehat Bersama';
        _subtitleController.text = data['subtitle'] ?? 'Pelayanan Kesehatan Terbaik untuk Keluarga Anda';
        _heroImageController.text = data['hero_image'] ?? 'https://images.unsplash.com/photo-1519494026892-80bbd2d6fd0d';
        _heroButtonTextController.text = data['hero_button_text'] ?? 'Lihat Layanan Kami';
        
        // Why Choose Us Section
        _whyChooseUsTitleController.text = data['why_choose_us_title'] ?? 'Mengapa Memilih Kami?';
        _whyChooseUsSubtitleController.text = data['why_choose_us_subtitle'] ?? 'Kami memberikan pelayanan terbaik dengan standar tertinggi';
        
        final features = data['features'] as List<dynamic>? ?? [
          'Dokter Profesional',
          'Fasilitas Modern',
          'Pelayanan 24 Jam',
          'BPJS dan Asuransi',
          'Laboratorium Lengkap',
          'Apotek 24 Jam'
        ];
        
        for (int i = 0; i < features.length && i < _featureControllers.length; i++) {
          _featureControllers[i].text = features[i].toString();
        }
        
        // Services Section
        _servicesSectionTitleController.text = data['services_section_title'] ?? 'Layanan Unggulan';
        _servicesSectionSubtitleController.text = data['services_section_subtitle'] ?? 'Berbagai layanan kesehatan komprehensif untuk kebutuhan Anda';
        
        // Testimonial Section
        _testimonialTitleController.text = data['testimonial_title'] ?? 'Testimoni Pasien';
        
        final testimonials = data['testimonials'] as List<dynamic>? ?? [
          {
            'name': 'Budi Santoso',
            'role': 'Pasien',
            'text': 'Pelayanan yang sangat memuaskan, dokter ramah dan fasilitasnya lengkap. Sangat recommended!',
          },
          {
            'name': 'Siti Aminah',
            'role': 'Ibu Rumah Tangga',
            'text': 'Anak saya demam tinggi, ditangani dengan cepat dan tepat oleh dokter. Terima kasih Klinik Sehat Bersama.',
          },
          {
            'name': 'Ahmad Rizal',
            'role': 'Karyawan',
            'text': 'Medical check-up lengkap dengan harga terjangkau. Hasil pemeriksaan jelas dijelaskan oleh dokter.',
          },
        ];
        
        for (int i = 0; i < testimonials.length && i < _testimonialControllers.length; i++) {
          _testimonialControllers[i]['name']!.text = testimonials[i]['name'] ?? '';
          _testimonialControllers[i]['role']!.text = testimonials[i]['role'] ?? '';
          _testimonialControllers[i]['text']!.text = testimonials[i]['text'] ?? '';
        }
        
        // CTA Section
        _ctaTitleController.text = data['cta_title'] ?? 'Siap Melayani Kesehatan Anda';
        _ctaSubtitleController.text = data['cta_subtitle'] ?? 'Jadwalkan konsultasi dengan dokter kami sekarang juga';
        _ctaButton1TextController.text = data['cta_button1_text'] ?? 'Hubungi Kami';
        _ctaButton2TextController.text = data['cta_button2_text'] ?? 'Lihat Layanan';
      }
    } catch (e) {
      print('Error loading homepage data: $e');
    } finally {
      setState(() {
        _isLoading = false;
        _hasChanges = false;
      });
    }
  }

  Future<void> _saveHomepageData() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final supabaseService = Provider.of<SupabaseService>(context, listen: false);
      
      final features = _featureControllers
          .where((c) => c.text.isNotEmpty)
          .map((c) => c.text)
          .toList();
      
      final testimonials = _testimonialControllers
          .where((t) => t['name']!.text.isNotEmpty)
          .map((t) => {
                'name': t['name']!.text,
                'role': t['role']!.text,
                'text': t['text']!.text,
              })
          .toList();
      
      final data = {
        // Hero Section
        'title': _titleController.text,
        'subtitle': _subtitleController.text,
        'hero_image': _heroImageController.text,
        'hero_button_text': _heroButtonTextController.text,
        
        // Why Choose Us Section
        'why_choose_us_title': _whyChooseUsTitleController.text,
        'why_choose_us_subtitle': _whyChooseUsSubtitleController.text,
        'features': features,
        
        // Services Section
        'services_section_title': _servicesSectionTitleController.text,
        'services_section_subtitle': _servicesSectionSubtitleController.text,
        
        // Testimonial Section
        'testimonial_title': _testimonialTitleController.text,
        'testimonials': testimonials,
        
        // CTA Section
        'cta_title': _ctaTitleController.text,
        'cta_subtitle': _ctaSubtitleController.text,
        'cta_button1_text': _ctaButton1TextController.text,
        'cta_button2_text': _ctaButton2TextController.text,
        
        'updated_at': DateTime.now().toIso8601String(),
      };

      await supabaseService.updateHomepageData(data);
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Homepage berhasil diperbarui!'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
      
      setState(() {
        _hasChanges = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _resetForm() {
    _loadHomepageData();
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hintText,
    int maxLines = 1,
    bool isRequired = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          hintText: hintText,
          border: const OutlineInputBorder(),
          filled: true,
          fillColor: Colors.grey[50],
        ),
        maxLines: maxLines,
        validator: isRequired ? (value) {
          if (value == null || value.isEmpty) {
            return '$label tidak boleh kosong';
          }
          return null;
        } : null,
      ),
    );
  }

  Widget _buildFeatureField(int index) {
    return Card(
      elevation: 1,
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: const Color(0xFF00897B).withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Text(
                '${index + 1}',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF00897B),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextFormField(
                controller: _featureControllers[index],
                decoration: const InputDecoration(
                  labelText: 'Fitur',
                  hintText: 'Contoh: Dokter Profesional',
                  border: OutlineInputBorder(),
                ),
                maxLines: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTestimonialField(int index) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF00897B).withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    '${index + 1}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF00897B),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'Testimoni ${index + 1}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _testimonialControllers[index]['name']!,
              label: 'Nama',
              hintText: 'Nama pasien',
              isRequired: true,
            ),
            _buildTextField(
              controller: _testimonialControllers[index]['role']!,
              label: 'Peran/Status',
              hintText: 'Contoh: Pasien, Ibu Rumah Tangga',
              isRequired: true,
            ),
            _buildTextField(
              controller: _testimonialControllers[index]['text']!,
              label: 'Testimoni',
              hintText: 'Tulis testimoni...',
              maxLines: 3,
              isRequired: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePreview() {
    if (_heroImageController.text.isEmpty) {
      return Container(
        height: 150,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Center(
          child: Icon(Icons.image, size: 50, color: Colors.grey),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Preview Gambar:',
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            _heroImageController.text,
            height: 150,
            width: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                height: 150,
                color: Colors.grey[200],
                child: const Center(
                  child: Icon(Icons.broken_image, color: Colors.grey),
                ),
              );
            },
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Container(
                height: 150,
                color: Colors.grey[200],
                child: Center(
                  child: CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes!
                        : null,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _subtitleController.dispose();
    _heroImageController.dispose();
    _heroButtonTextController.dispose();
    _whyChooseUsTitleController.dispose();
    _whyChooseUsSubtitleController.dispose();
    _servicesSectionTitleController.dispose();
    _servicesSectionSubtitleController.dispose();
    _testimonialTitleController.dispose();
    _ctaTitleController.dispose();
    _ctaSubtitleController.dispose();
    _ctaButton1TextController.dispose();
    _ctaButton2TextController.dispose();
    
    for (var controller in _featureControllers) {
      controller.dispose();
    }
    
    for (var testimonial in _testimonialControllers) {
      testimonial['name']!.dispose();
      testimonial['role']!.dispose();
      testimonial['text']!.dispose();
    }
    
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;
    
    return AdminLayout(
      pageTitle: 'Edit Homepage',
      child: _isLoading && !_hasChanges
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header - Hide buttons on mobile, show on desktop
                        if (!isMobile)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Edit Konten Homepage',
                                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Row(
                                children: [
                                  if (_hasChanges)
                                    OutlinedButton.icon(
                                      onPressed: _resetForm,
                                      icon: const Icon(Icons.refresh, size: 18),
                                      label: const Text('Reset'),
                                    ),
                                  const SizedBox(width: 12),
                                  ElevatedButton.icon(
                                    onPressed: _hasChanges ? _saveHomepageData : null,
                                    icon: _isLoading
                                        ? const SizedBox(
                                            width: 20,
                                            height: 20,
                                            child: CircularProgressIndicator(strokeWidth: 2),
                                          )
                                        : const Icon(Icons.save, size: 20),
                                    label: const Text('Simpan'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF00897B),
                                      foregroundColor: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        if (!isMobile) const SizedBox(height: 32),
                        
                        // Mobile Header - Simple title only
                        if (isMobile)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: Text(
                              'Edit Konten Homepage',
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),

                    // Hero Section
                    _buildSectionCard(
                      title: 'Section Hero',
                      icon: Icons.flag,
                      iconColor: const Color(0xFF00897B),
                      children: [
                        _buildTextField(
                          controller: _titleController,
                          label: 'Judul Utama',
                          hintText: 'Contoh: Klinik Sehat Bersama',
                          isRequired: true,
                        ),
                        _buildTextField(
                          controller: _subtitleController,
                          label: 'Subtitle',
                          hintText: 'Pelayanan Kesehatan Terbaik untuk Keluarga Anda',
                          isRequired: true,
                        ),
                        _buildTextField(
                          controller: _heroImageController,
                          label: 'URL Gambar Hero',
                          hintText: 'https://images.unsplash.com/photo-xxx',
                        ),
                        const SizedBox(height: 16),
                        _buildImagePreview(),
                        const SizedBox(height: 16),
                        _buildTextField(
                          controller: _heroButtonTextController,
                          label: 'Teks Tombol',
                          hintText: 'Contoh: Lihat Layanan Kami',
                        ),
                      ],
                    ),

                    // Why Choose Us Section
                    _buildSectionCard(
                      title: 'Section "Mengapa Memilih Kami"',
                      icon: Icons.star,
                      iconColor: Colors.orange,
                      children: [
                        _buildTextField(
                          controller: _whyChooseUsTitleController,
                          label: 'Judul Section',
                          hintText: 'Mengapa Memilih Kami?',
                          isRequired: true,
                        ),
                        _buildTextField(
                          controller: _whyChooseUsSubtitleController,
                          label: 'Subtitle Section',
                          hintText: 'Kami memberikan pelayanan terbaik...',
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Fitur Utama (6 fitur)',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[700],
                          ),
                        ),
                        const SizedBox(height: 12),
                        ...List.generate(
                          _featureControllers.length,
                          (index) => _buildFeatureField(index),
                        ),
                      ],
                    ),

                    // Services Section
                    _buildSectionCard(
                      title: 'Section Layanan',
                      icon: Icons.medical_services,
                      iconColor: const Color(0xFF00897B),
                      children: [
                        _buildTextField(
                          controller: _servicesSectionTitleController,
                          label: 'Judul Section',
                          hintText: 'Layanan Unggulan',
                          isRequired: true,
                        ),
                        _buildTextField(
                          controller: _servicesSectionSubtitleController,
                          label: 'Subtitle Section',
                          hintText: 'Berbagai layanan kesehatan komprehensif...',
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.blue[50],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.info_outline, color: Colors.blue[700], size: 20),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Layanan ditampilkan dari data Services yang sudah dibuat',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.blue[700],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    // Testimonial Section
                    _buildSectionCard(
                      title: 'Section Testimoni',
                      icon: Icons.rate_review,
                      iconColor: Colors.purple,
                      children: [
                        _buildTextField(
                          controller: _testimonialTitleController,
                          label: 'Judul Section',
                          hintText: 'Testimoni Pasien',
                          isRequired: true,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Testimoni (3 testimoni)',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[700],
                          ),
                        ),
                        const SizedBox(height: 12),
                        ...List.generate(
                          _testimonialControllers.length,
                          (index) => _buildTestimonialField(index),
                        ),
                      ],
                    ),

                    // CTA Section
                    _buildSectionCard(
                      title: 'Section Call-to-Action',
                      icon: Icons.call_to_action,
                      iconColor: Colors.red,
                      children: [
                        _buildTextField(
                          controller: _ctaTitleController,
                          label: 'Judul CTA',
                          hintText: 'Siap Melayani Kesehatan Anda',
                          isRequired: true,
                        ),
                        _buildTextField(
                          controller: _ctaSubtitleController,
                          label: 'Subtitle CTA',
                          hintText: 'Jadwalkan konsultasi dengan dokter kami...',
                        ),
                        _buildTextField(
                          controller: _ctaButton1TextController,
                          label: 'Teks Tombol Pertama',
                          hintText: 'Hubungi Kami',
                        ),
                        _buildTextField(
                          controller: _ctaButton2TextController,
                          label: 'Teks Tombol Kedua',
                          hintText: 'Lihat Layanan',
                        ),
                      ],
                    ),

                    // Add bottom padding for mobile FAB
                    if (isMobile) const SizedBox(height: 80),
                    
                    if (!isMobile) const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
            
            // Floating Action Buttons for Mobile
            if (isMobile && _hasChanges)
              Positioned(
                bottom: 16,
                left: 16,
                right: 16,
                child: Row(
                  children: [
                    // Reset Button
                    Expanded(
                      child: FloatingActionButton.extended(
                        onPressed: _resetForm,
                        backgroundColor: Colors.grey[100],
                        foregroundColor: Colors.grey[800],
                        icon: const Icon(Icons.refresh),
                        label: const Text('Reset'),
                        heroTag: 'reset_btn',
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Save Button
                    Expanded(
                      flex: 2,
                      child: FloatingActionButton.extended(
                        onPressed: _isLoading ? null : _saveHomepageData,
                        backgroundColor: const Color(0xFF00897B),
                        foregroundColor: Colors.white,
                        icon: _isLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                ),
                              )
                            : const Icon(Icons.save),
                        label: Text(_isLoading ? 'Menyimpan...' : 'Simpan Perubahan'),
                        heroTag: 'save_btn',
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required Color iconColor,
    required List<Widget> children,
  }) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 24),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: iconColor),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ...children,
          ],
        ),
      ),
    );
  }
}