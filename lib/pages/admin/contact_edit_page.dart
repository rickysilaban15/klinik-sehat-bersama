import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/supabase_service.dart';
import 'admin_layout.dart';

class ContactEditPage extends StatefulWidget {
  const ContactEditPage({super.key});

  @override
  State<ContactEditPage> createState() => _ContactEditPageState();
}

class _ContactEditPageState extends State<ContactEditPage> {
  final _formKey = GlobalKey<FormState>();
  
  // Hero Section Controllers
  final _heroTitleController = TextEditingController();
  final _heroSubtitleController = TextEditingController();
  
  // Contact Info Controllers
  final _contactInfoTitleController = TextEditingController();
  final _addressTitleController = TextEditingController();
  final _addressContentController = TextEditingController();
  final _phoneTitleController = TextEditingController();
  final _phoneContentController = TextEditingController();
  final _emailTitleController = TextEditingController();
  final _emailContentController = TextEditingController();
  
  // Form Section Controllers
  final _formTitleController = TextEditingController();
  final _formNameLabelController = TextEditingController();
  final _formEmailLabelController = TextEditingController();
  final _formMessageLabelController = TextEditingController();
  final _formButtonTextController = TextEditingController();
  final _formSuccessTitleController = TextEditingController();
  final _formSuccessMessageController = TextEditingController();
  
  // Operating Hours Controllers
  final _operatingHoursTitleController = TextEditingController();
  final Map<String, TextEditingController> _operatingHoursControllers = {
    'Senin - Jumat': TextEditingController(),
    'Sabtu': TextEditingController(),
    'Minggu': TextEditingController(),
    'Emergency': TextEditingController(),
  };
  
  // Map Section Controllers
  final _mapTitleController = TextEditingController();
  final _mapButtonTextController = TextEditingController();
  final _mapsUrlController = TextEditingController();

  bool _isLoading = false;
  bool _hasChanges = false;

  @override
  void initState() {
    super.initState();
    _loadContactData();
    _addChangeListeners();
  }

  void _addChangeListeners() {
    // Hero section
    _heroTitleController.addListener(_checkForChanges);
    _heroSubtitleController.addListener(_checkForChanges);
    
    // Contact info
    _contactInfoTitleController.addListener(_checkForChanges);
    _addressTitleController.addListener(_checkForChanges);
    _addressContentController.addListener(_checkForChanges);
    _phoneTitleController.addListener(_checkForChanges);
    _phoneContentController.addListener(_checkForChanges);
    _emailTitleController.addListener(_checkForChanges);
    _emailContentController.addListener(_checkForChanges);
    
    // Form section
    _formTitleController.addListener(_checkForChanges);
    _formNameLabelController.addListener(_checkForChanges);
    _formEmailLabelController.addListener(_checkForChanges);
    _formMessageLabelController.addListener(_checkForChanges);
    _formButtonTextController.addListener(_checkForChanges);
    _formSuccessTitleController.addListener(_checkForChanges);
    _formSuccessMessageController.addListener(_checkForChanges);
    
    // Operating hours
    _operatingHoursTitleController.addListener(_checkForChanges);
    _operatingHoursControllers.forEach((key, controller) {
      controller.addListener(_checkForChanges);
    });
    
    // Map section
    _mapTitleController.addListener(_checkForChanges);
    _mapButtonTextController.addListener(_checkForChanges);
    _mapsUrlController.addListener(_checkForChanges);
  }

  void _checkForChanges() {
    setState(() {
      _hasChanges = true;
    });
  }

  Future<void> _loadContactData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final supabaseService = Provider.of<SupabaseService>(context, listen: false);
      final data = await supabaseService.getContactPageData();
      
      if (data != null) {
        // Hero Section
        _heroTitleController.text = data['hero_title'] ?? 'Hubungi Kami';
        _heroSubtitleController.text = data['hero_subtitle'] ?? 'Kami siap melayani dan menjawab pertanyaan Anda';
        
        // Contact Info
        _contactInfoTitleController.text = data['contact_info_title'] ?? 'Informasi Kontak';
        _addressTitleController.text = data['address_title'] ?? 'Alamat';
        _addressContentController.text = data['address_content'] ?? 'Jl. Sehat No. 123, Kota Sejahtera';
        _phoneTitleController.text = data['phone_title'] ?? 'Telepon';
        _phoneContentController.text = data['phone_content'] ?? '+62 812-3456-7890';
        _emailTitleController.text = data['email_title'] ?? 'Email';
        _emailContentController.text = data['email_content'] ?? 'info@kliniksehat.com';
        
        // Form Section
        _formTitleController.text = data['form_title'] ?? 'Kirim Pesan';
        _formNameLabelController.text = data['form_name_label'] ?? 'Nama Lengkap';
        _formEmailLabelController.text = data['form_email_label'] ?? 'Email';
        _formMessageLabelController.text = data['form_message_label'] ?? 'Pesan';
        _formButtonTextController.text = data['form_button_text'] ?? 'Kirim Pesan';
        _formSuccessTitleController.text = data['form_success_title'] ?? 'Pesan Terkirim';
        _formSuccessMessageController.text = data['form_success_message'] ?? 'Terima kasih atas pesan Anda. Kami akan membalas segera.';
        
        // Operating Hours
        _operatingHoursTitleController.text = data['operating_hours_title'] ?? 'Jam Operasional';
        final operatingHours = data['operating_hours'] as Map<String, dynamic>? ?? {
          'Senin - Jumat': '08:00 - 21:00',
          'Sabtu': '08:00 - 18:00',
          'Minggu': '09:00 - 15:00',
          'Emergency': '24 Jam',
        };
        
        operatingHours.forEach((key, value) {
          if (_operatingHoursControllers.containsKey(key)) {
            _operatingHoursControllers[key]!.text = value.toString();
          }
        });
        
        // Map Section
        _mapTitleController.text = data['map_title'] ?? 'Lokasi Klinik';
        _mapButtonTextController.text = data['map_button_text'] ?? 'Buka di Google Maps';
        _mapsUrlController.text = data['maps_url'] ?? 'https://www.google.com/maps';
      }
    } catch (e) {
      print('Error loading contact data: $e');
    } finally {
      setState(() {
        _isLoading = false;
        _hasChanges = false;
      });
    }
  }

  Future<void> _saveContactData() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final supabaseService = Provider.of<SupabaseService>(context, listen: false);
      
      final operatingHours = <String, String>{};
      _operatingHoursControllers.forEach((key, controller) {
        if (controller.text.isNotEmpty) {
          operatingHours[key] = controller.text;
        }
      });
      
      final data = {
        // Hero Section
        'hero_title': _heroTitleController.text,
        'hero_subtitle': _heroSubtitleController.text,
        'hero_icon': 'contact_mail',
        
        // Contact Info
        'contact_info_title': _contactInfoTitleController.text,
        'address_title': _addressTitleController.text,
        'address_content': _addressContentController.text,
        'phone_title': _phoneTitleController.text,
        'phone_content': _phoneContentController.text,
        'email_title': _emailTitleController.text,
        'email_content': _emailContentController.text,
        
        // Form Section
        'form_title': _formTitleController.text,
        'form_name_label': _formNameLabelController.text,
        'form_email_label': _formEmailLabelController.text,
        'form_message_label': _formMessageLabelController.text,
        'form_button_text': _formButtonTextController.text,
        'form_success_title': _formSuccessTitleController.text,
        'form_success_message': _formSuccessMessageController.text,
        
        // Operating Hours
        'operating_hours_title': _operatingHoursTitleController.text,
        'operating_hours': operatingHours,
        
        // Map Section
        'map_title': _mapTitleController.text,
        'map_button_text': _mapButtonTextController.text,
        'maps_url': _mapsUrlController.text,
        
        'updated_at': DateTime.now().toIso8601String(),
      };

      await supabaseService.updateContactPageData(data);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Halaman Kontak berhasil diperbarui!'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
        
        setState(() {
          _hasChanges = false;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _resetForm() {
    _loadContactData();
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hintText,
    int maxLines = 1,
    bool isRequired = false,
    TextInputType? keyboardType,
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
        keyboardType: keyboardType,
        validator: isRequired ? (value) {
          if (value == null || value.isEmpty) {
            return '$label tidak boleh kosong';
          }
          return null;
        } : null,
      ),
    );
  }

  Widget _buildOperatingHoursField(String day) {
    return Card(
      elevation: 1,
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            SizedBox(
              width: 120,
              child: Text(
                day,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF37474F),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextFormField(
                controller: _operatingHoursControllers[day],
                decoration: const InputDecoration(
                  hintText: 'Contoh: 08:00 - 21:00',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Wajib diisi';
                  }
                  return null;
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _heroTitleController.dispose();
    _heroSubtitleController.dispose();
    _contactInfoTitleController.dispose();
    _addressTitleController.dispose();
    _addressContentController.dispose();
    _phoneTitleController.dispose();
    _phoneContentController.dispose();
    _emailTitleController.dispose();
    _emailContentController.dispose();
    _formTitleController.dispose();
    _formNameLabelController.dispose();
    _formEmailLabelController.dispose();
    _formMessageLabelController.dispose();
    _formButtonTextController.dispose();
    _formSuccessTitleController.dispose();
    _formSuccessMessageController.dispose();
    _operatingHoursTitleController.dispose();
    _operatingHoursControllers.forEach((key, controller) {
      controller.dispose();
    });
    _mapTitleController.dispose();
    _mapButtonTextController.dispose();
    _mapsUrlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;
    
    return AdminLayout(
      pageTitle: 'Edit Halaman Kontak',
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
                        // Header - Desktop only
                        if (!isMobile)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Edit Konten Halaman Kontak',
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
                                    onPressed: _hasChanges ? _saveContactData : null,
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
                        
                        // Mobile Header
                        if (isMobile)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: Text(
                              'Edit Konten Halaman Kontak',
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
                              controller: _heroTitleController,
                              label: 'Judul Hero',
                              hintText: 'Contoh: Hubungi Kami',
                              isRequired: true,
                            ),
                            _buildTextField(
                              controller: _heroSubtitleController,
                              label: 'Subtitle Hero',
                              hintText: 'Kami siap melayani dan menjawab pertanyaan Anda',
                              maxLines: 2,
                              isRequired: true,
                            ),
                          ],
                        ),

                        // Contact Info Section
                        _buildSectionCard(
                          title: 'Informasi Kontak',
                          icon: Icons.info,
                          iconColor: Colors.blue,
                          children: [
                            _buildTextField(
                              controller: _contactInfoTitleController,
                              label: 'Judul Section',
                              hintText: 'Informasi Kontak',
                              isRequired: true,
                            ),
                            const SizedBox(height: 16),
                            
                            // Address
                            Text(
                              'Alamat',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey[700],
                              ),
                            ),
                            const SizedBox(height: 8),
                            _buildTextField(
                              controller: _addressTitleController,
                              label: 'Label Alamat',
                              hintText: 'Alamat',
                              isRequired: true,
                            ),
                            _buildTextField(
                              controller: _addressContentController,
                              label: 'Isi Alamat',
                              hintText: 'Jl. Sehat No. 123, Kota Sejahtera',
                              maxLines: 2,
                              isRequired: true,
                            ),
                            const SizedBox(height: 16),
                            
                            // Phone
                            Text(
                              'Telepon',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey[700],
                              ),
                            ),
                            const SizedBox(height: 8),
                            _buildTextField(
                              controller: _phoneTitleController,
                              label: 'Label Telepon',
                              hintText: 'Telepon',
                              isRequired: true,
                            ),
                            _buildTextField(
                              controller: _phoneContentController,
                              label: 'Nomor Telepon',
                              hintText: '+62 812-3456-7890',
                              keyboardType: TextInputType.phone,
                              isRequired: true,
                            ),
                            const SizedBox(height: 16),
                            
                            // Email
                            Text(
                              'Email',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey[700],
                              ),
                            ),
                            const SizedBox(height: 8),
                            _buildTextField(
                              controller: _emailTitleController,
                              label: 'Label Email',
                              hintText: 'Email',
                              isRequired: true,
                            ),
                            _buildTextField(
                              controller: _emailContentController,
                              label: 'Alamat Email',
                              hintText: 'info@kliniksehat.com',
                              keyboardType: TextInputType.emailAddress,
                              isRequired: true,
                            ),
                          ],
                        ),

                        // Form Section
                        _buildSectionCard(
                          title: 'Section Form Kontak',
                          icon: Icons.contact_page,
                          iconColor: Colors.orange,
                          children: [
                            _buildTextField(
                              controller: _formTitleController,
                              label: 'Judul Form',
                              hintText: 'Kirim Pesan',
                              isRequired: true,
                            ),
                            _buildTextField(
                              controller: _formNameLabelController,
                              label: 'Label Nama',
                              hintText: 'Nama Lengkap',
                              isRequired: true,
                            ),
                            _buildTextField(
                              controller: _formEmailLabelController,
                              label: 'Label Email',
                              hintText: 'Email',
                              isRequired: true,
                            ),
                            _buildTextField(
                              controller: _formMessageLabelController,
                              label: 'Label Pesan',
                              hintText: 'Pesan',
                              isRequired: true,
                            ),
                            _buildTextField(
                              controller: _formButtonTextController,
                              label: 'Teks Tombol',
                              hintText: 'Kirim Pesan',
                              isRequired: true,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Pesan Sukses',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey[700],
                              ),
                            ),
                            const SizedBox(height: 8),
                            _buildTextField(
                              controller: _formSuccessTitleController,
                              label: 'Judul Pesan Sukses',
                              hintText: 'Pesan Terkirim',
                              isRequired: true,
                            ),
                            _buildTextField(
                              controller: _formSuccessMessageController,
                              label: 'Isi Pesan Sukses',
                              hintText: 'Terima kasih atas pesan Anda...',
                              maxLines: 2,
                              isRequired: true,
                            ),
                          ],
                        ),

                        // Operating Hours Section
                        _buildSectionCard(
                          title: 'Jam Operasional',
                          icon: Icons.access_time,
                          iconColor: Colors.purple,
                          children: [
                            _buildTextField(
                              controller: _operatingHoursTitleController,
                              label: 'Judul Section',
                              hintText: 'Jam Operasional',
                              isRequired: true,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Jadwal',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey[700],
                              ),
                            ),
                            const SizedBox(height: 12),
                            ..._operatingHoursControllers.keys.map(
                              (day) => _buildOperatingHoursField(day),
                            ),
                          ],
                        ),

                        // Map Section
                        _buildSectionCard(
                          title: 'Section Peta',
                          icon: Icons.map,
                          iconColor: Colors.red,
                          children: [
                            _buildTextField(
                              controller: _mapTitleController,
                              label: 'Judul Peta',
                              hintText: 'Lokasi Klinik',
                              isRequired: true,
                            ),
                            _buildTextField(
                              controller: _mapButtonTextController,
                              label: 'Teks Tombol Peta',
                              hintText: 'Buka di Google Maps',
                              isRequired: true,
                            ),
                            _buildTextField(
                              controller: _mapsUrlController,
                              label: 'URL Google Maps',
                              hintText: 'https://www.google.com/maps/...',
                              keyboardType: TextInputType.url,
                              isRequired: true,
                            ),
                          ],
                        ),

                        // Bottom padding for mobile FAB
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
                        Expanded(
                          flex: 2,
                          child: FloatingActionButton.extended(
                            onPressed: _isLoading ? null : _saveContactData,
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
                            label: Text(_isLoading ? 'Menyimpan...' : 'Simpan'),
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