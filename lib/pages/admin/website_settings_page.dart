import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../services/supabase_service.dart';
import '../../utils/constants.dart';
import 'admin_layout.dart';
import '../../providers/settings_notifier.dart';
class WebsiteSettingsPage extends StatefulWidget {
  const WebsiteSettingsPage({super.key});

  @override
  State<WebsiteSettingsPage> createState() => _WebsiteSettingsPageState();
}

class _WebsiteSettingsPageState extends State<WebsiteSettingsPage> {
  final _formKey = GlobalKey<FormState>();
  
  bool _isLoading = true;
  bool _isSaving = false;
  
  // Controllers
  final _clinicNamePrimaryController = TextEditingController();
  final _clinicNameSecondaryController = TextEditingController();
  final _clinicTaglineController = TextEditingController();
  final _clinicDescriptionController = TextEditingController();
  final _contactAddressController = TextEditingController();
  final _contactPhoneController = TextEditingController();
  final _contactEmailController = TextEditingController();
  final _contactWhatsappController = TextEditingController();
  final _operatingHoursController = TextEditingController();
  final _facebookUrlController = TextEditingController();
  final _instagramUrlController = TextEditingController();
  final _twitterUrlController = TextEditingController();
  final _mapsUrlController = TextEditingController();
  
  bool _emergencyAvailable = true;
  String _currentLogoUrl = '';
  XFile? _selectedLogo; // Changed from File to XFile
  
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadSettings());
  }

  Future<void> _loadSettings() async {
    setState(() => _isLoading = true);
    try {
      final supabaseService = Provider.of<SupabaseService>(context, listen: false);
      final settings = await supabaseService.getAllSettings();
      
      if (mounted) {
        setState(() {
          _clinicNamePrimaryController.text = settings['clinic_name_primary'] ?? '';
          _clinicNameSecondaryController.text = settings['clinic_name_secondary'] ?? '';
          _clinicTaglineController.text = settings['clinic_tagline'] ?? '';
          _clinicDescriptionController.text = settings['clinic_description'] ?? '';
          _contactAddressController.text = settings['contact_address'] ?? '';
          _contactPhoneController.text = settings['contact_phone'] ?? '';
          _contactEmailController.text = settings['contact_email'] ?? '';
          _contactWhatsappController.text = settings['contact_whatsapp'] ?? '';
          _operatingHoursController.text = settings['operating_hours'] ?? '';
          _facebookUrlController.text = settings['facebook_url'] ?? '';
          _instagramUrlController.text = settings['instagram_url'] ?? '';
          _twitterUrlController.text = settings['twitter_url'] ?? '';
          _mapsUrlController.text = settings['maps_url'] ?? '';
          _emergencyAvailable = settings['emergency_available'] == 'true';
          _currentLogoUrl = settings['logo_url'] ?? '';
        });
      }
    } catch (e) {
      _showSnackBar('Error loading settings: $e', isError: true);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _pickLogo() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 2048,
        maxHeight: 2048,
        imageQuality: 90,
      );
      
      if (image != null) {
        // Validate file extension
        final extension = image.name.toLowerCase().split('.').last;
        final allowedExtensions = ['png', 'jpg', 'jpeg', 'svg', 'gif', 'webp'];
        
        if (!allowedExtensions.contains(extension)) {
          _showSnackBar(
            'Format file tidak didukung. Gunakan: PNG, JPG, JPEG, SVG, GIF, atau WEBP',
            isError: true,
          );
          return;
        }
        
        // Validate file size (max 5MB)
        final bytes = await image.readAsBytes();
        final sizeInMB = bytes.length / (1024 * 1024);
        
        if (sizeInMB > 5) {
          _showSnackBar(
            'Ukuran file terlalu besar. Maksimal 5MB',
            isError: true,
          );
          return;
        }
        
        setState(() {
          _selectedLogo = image;
        });
        
        print('✅ Logo selected: ${image.name} (${sizeInMB.toStringAsFixed(2)} MB)');
      }
    } catch (e) {
      _showSnackBar('Error picking image: $e', isError: true);
    }
  }

Future<void> _saveSettings() async {
  if (!_formKey.currentState!.validate()) return;
  
  setState(() => _isSaving = true);
  
  try {
    final supabaseService = Provider.of<SupabaseService>(context, listen: false);
    final settingsNotifier = Provider.of<SettingsNotifier>(context, listen: false);
    
    // Upload logo if changed
    if (_selectedLogo != null) {
      if (_currentLogoUrl.isNotEmpty) {
        await supabaseService.deleteOldLogo(_currentLogoUrl);
      }
      
      final extension = _selectedLogo!.name.toLowerCase().split('.').last;
      final fileName = 'logo_${DateTime.now().millisecondsSinceEpoch}.$extension';
      
      final logoUrl = await supabaseService.uploadLogo(_selectedLogo!, fileName);
      _currentLogoUrl = logoUrl;
    }
    
    // Update all settings
    await supabaseService.updateMultipleSettings({
      'clinic_name_primary': _clinicNamePrimaryController.text,
      'clinic_name_secondary': _clinicNameSecondaryController.text,
      'clinic_tagline': _clinicTaglineController.text,
      'clinic_description': _clinicDescriptionController.text,
      'contact_address': _contactAddressController.text,
      'contact_phone': _contactPhoneController.text,
      'contact_email': _contactEmailController.text,
      'contact_whatsapp': _contactWhatsappController.text,
      'operating_hours': _operatingHoursController.text,
      'facebook_url': _facebookUrlController.text,
      'instagram_url': _instagramUrlController.text,
      'twitter_url': _twitterUrlController.text,
      'maps_url': _mapsUrlController.text,
      'emergency_available': _emergencyAvailable.toString(),
      'logo_url': _currentLogoUrl,
    });
    
    // ✅ REFRESH SETTINGS NOTIFIER (ini yang penting!)
    await settingsNotifier.refreshSettings(supabaseService);
    
    _showSnackBar('Settings saved successfully!');
    setState(() => _selectedLogo = null);
    
  } catch (e) {
    _showSnackBar('Error saving settings: $e', isError: true);
  } finally {
    setState(() => _isSaving = false);
  }
}

  void _showSnackBar(String message, {bool isError = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : const Color(0xFF00897B),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AdminLayout(
      pageTitle: 'Website Settings',
      child: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Save Button at top
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton.icon(
                          onPressed: _isSaving ? null : _saveSettings,
                          icon: _isSaving
                              ? const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                  ),
                                )
                              : const Icon(Icons.save),
                          label: Text(_isSaving ? 'Saving...' : 'Save Changes'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF00897B),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Logo & Branding
                    _buildSection(
                      title: 'Logo & Branding',
                      icon: Icons.image,
                      children: [
                        _buildLogoUpload(),
                        const SizedBox(height: 20),
                        _buildTextField(
                          controller: _clinicNamePrimaryController,
                          label: 'Clinic Name (Primary)',
                          hint: 'e.g., Klinik Sehat',
                          icon: Icons.business,
                        ),
                        const SizedBox(height: 16),
                        _buildTextField(
                          controller: _clinicNameSecondaryController,
                          label: 'Clinic Name (Secondary)',
                          hint: 'e.g., Bersama',
                          icon: Icons.business_outlined,
                        ),
                        const SizedBox(height: 16),
                        _buildTextField(
                          controller: _clinicTaglineController,
                          label: 'Tagline',
                          hint: 'Your clinic tagline',
                          icon: Icons.format_quote,
                          maxLines: 2,
                        ),
                        const SizedBox(height: 16),
                        _buildTextField(
                          controller: _clinicDescriptionController,
                          label: 'Description',
                          hint: 'Brief description of your clinic',
                          icon: Icons.description,
                          maxLines: 4,
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 32),
                    
                    // Contact Information
                    _buildSection(
                      title: 'Contact Information',
                      icon: Icons.contact_phone,
                      children: [
                        _buildTextField(
                          controller: _contactAddressController,
                          label: 'Address',
                          hint: 'Full clinic address',
                          icon: Icons.location_on,
                          maxLines: 3,
                        ),
                        const SizedBox(height: 16),
                        _buildTextField(
                          controller: _contactPhoneController,
                          label: 'Phone Number',
                          hint: '(021) 1234-5678',
                          icon: Icons.phone,
                        ),
                        const SizedBox(height: 16),
                        _buildTextField(
                          controller: _contactWhatsappController,
                          label: 'WhatsApp Number',
                          hint: '081234567890',
                          icon: Icons.chat,
                        ),
                        const SizedBox(height: 16),
                        _buildTextField(
                          controller: _contactEmailController,
                          label: 'Email',
                          hint: 'info@clinic.com',
                          icon: Icons.email,
                          keyboardType: TextInputType.emailAddress,
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 32),
                    
                    // Operating Hours
                    _buildSection(
                      title: 'Operating Hours',
                      icon: Icons.access_time,
                      children: [
                        _buildTextField(
                          controller: _operatingHoursController,
                          label: 'Operating Hours',
                          hint: 'e.g., Senin - Minggu: 08:00 - 21:00',
                          icon: Icons.schedule,
                        ),
                        const SizedBox(height: 16),
                        SwitchListTile(
                          title: const Text('24-Hour Emergency Service'),
                          subtitle: const Text('Enable emergency service badge'),
                          value: _emergencyAvailable,
                          onChanged: (value) {
                            setState(() => _emergencyAvailable = value);
                          },
                          activeColor: const Color(0xFF00897B),
                          contentPadding: EdgeInsets.zero,
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 32),
                    
                    // Social Media
                    _buildSection(
                      title: 'Social Media Links',
                      icon: Icons.share,
                      children: [
                        _buildTextField(
                          controller: _facebookUrlController,
                          label: 'Facebook URL',
                          hint: 'https://facebook.com/yourpage',
                          icon: Icons.facebook,
                        ),
                        const SizedBox(height: 16),
                        _buildTextField(
                          controller: _instagramUrlController,
                          label: 'Instagram URL',
                          hint: 'https://instagram.com/yourpage',
                          icon: Icons.camera_alt,
                        ),
                        const SizedBox(height: 16),
                        _buildTextField(
                          controller: _twitterUrlController,
                          label: 'Twitter/X URL',
                          hint: 'https://twitter.com/yourpage',
                          icon: Icons.tag,
                        ),
                        const SizedBox(height: 16),
                        _buildTextField(
                          controller: _mapsUrlController,
                          label: 'Google Maps URL',
                          hint: 'https://maps.google.com/...',
                          icon: Icons.map,
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildSection({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF00897B).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: const Color(0xFF00897B), size: 24),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF37474F),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          ...children,
        ],
      ),
    );
  }

  Widget _buildLogoUpload() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Logo',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF37474F),
          ),
        ),
        const SizedBox(height: 12),
        InkWell(
          onTap: _pickLogo,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              border: Border.all(
                color: const Color(0xFF00897B).withOpacity(0.3),
                width: 2,
              ),
              borderRadius: BorderRadius.circular(12),
              color: const Color(0xFF00897B).withOpacity(0.05),
            ),
            child: Column(
              children: [
                if (_selectedLogo != null)
                  FutureBuilder<Uint8List>(
                    future: _selectedLogo!.readAsBytes(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.memory(
                            snapshot.data!,
                            height: 120,
                            fit: BoxFit.contain,
                          ),
                        );
                      }
                      return const CircularProgressIndicator();
                    },
                  )
                else if (_currentLogoUrl.isNotEmpty)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      _currentLogoUrl,
                      height: 120,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(
                          Icons.image_not_supported,
                          size: 120,
                          color: Colors.grey,
                        );
                      },
                    ),
                  )
                else
                  const Icon(
                    Icons.add_photo_alternate,
                    size: 64,
                    color: Color(0xFF00897B),
                  ),
                const SizedBox(height: 16),
                Text(
                  _selectedLogo != null || _currentLogoUrl.isNotEmpty
                      ? 'Click to change logo'
                      : 'Click to upload logo',
                  style: TextStyle(
                    color: const Color(0xFF00897B).withOpacity(0.8),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Format: PNG, JPG, JPEG, SVG, GIF, WEBP • Max: 5MB',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
                if (_selectedLogo != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    _selectedLogo!.name,
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 11,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    int maxLines = 1,
    TextInputType? keyboardType,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, color: const Color(0xFF00897B)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF00897B), width: 2),
        ),
        filled: true,
        fillColor: Colors.grey[50],
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return AppConstants.requiredField;
        }
        return null;
      },
    );
  }

  @override
  void dispose() {
    _clinicNamePrimaryController.dispose();
    _clinicNameSecondaryController.dispose();
    _clinicTaglineController.dispose();
    _clinicDescriptionController.dispose();
    _contactAddressController.dispose();
    _contactPhoneController.dispose();
    _contactEmailController.dispose();
    _contactWhatsappController.dispose();
    _operatingHoursController.dispose();
    _facebookUrlController.dispose();
    _instagramUrlController.dispose();
    _twitterUrlController.dispose();
    _mapsUrlController.dispose();
    super.dispose();
  }
}