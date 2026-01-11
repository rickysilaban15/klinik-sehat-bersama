import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import '../../services/supabase_service.dart';
import '../../models/service_model.dart';
import './admin_layout.dart';

class ServicesManagementPage extends StatefulWidget {
  const ServicesManagementPage({super.key});

  @override
  State<ServicesManagementPage> createState() => _ServicesManagementPageState();
}

class _ServicesManagementPageState extends State<ServicesManagementPage> {
  final _formKey = GlobalKey<FormState>();
  late Service _editingService;
  bool _isEditing = false;
  bool _showForm = false;
  bool _isLoading = false;
  String? _selectedIcon;
  int _currentIconPage = 0;
  final int _iconsPerPage = 8;
  
  // Image upload
  XFile? _selectedImage;
  bool _isUploadingImage = false;

  // Available icons for services
  final List<Map<String, dynamic>> _availableIcons = [
    {'icon': 'medical_services', 'label': 'Medical Services', 'data': Icons.medical_services},
    {'icon': 'science', 'label': 'Laboratory', 'data': Icons.science},
    {'icon': 'vaccines', 'label': 'Vaccines', 'data': Icons.vaccines},
    {'icon': 'family_restroom', 'label': 'Family', 'data': Icons.family_restroom},
    {'icon': 'healing', 'label': 'Healing', 'data': Icons.healing},
    {'icon': 'accessible', 'label': 'Accessibility', 'data': Icons.accessible},
    {'icon': 'local_hospital', 'label': 'Hospital', 'data': Icons.local_hospital},
    {'icon': 'medication', 'label': 'Medication', 'data': Icons.medication},
    {'icon': 'monitor_heart', 'label': 'Heart Monitor', 'data': Icons.monitor_heart},
    {'icon': 'psychology', 'label': 'Psychology', 'data': Icons.psychology},
    {'icon': 'elderly', 'label': 'Elderly Care', 'data': Icons.elderly},
    {'icon': 'pregnant_woman', 'label': 'Pregnancy', 'data': Icons.pregnant_woman},
    {'icon': 'child_care', 'label': 'Child Care', 'data': Icons.child_care},
    {'icon': 'coronavirus', 'label': 'Coronavirus', 'data': Icons.coronavirus},
    {'icon': 'medical_information', 'label': 'Medical Info', 'data': Icons.medical_information},
    {'icon': 'local_pharmacy', 'label': 'Pharmacy', 'data': Icons.local_pharmacy},
    {'icon': 'favorite', 'label': 'Cardiology', 'data': Icons.favorite},
    {'icon': 'visibility', 'label': 'Ophthalmology', 'data': Icons.visibility},
    {'icon': 'hearing', 'label': 'ENT', 'data': Icons.hearing},
    {'icon': 'spa', 'label': 'Wellness', 'data': Icons.spa},
    {'icon': 'fitness_center', 'label': 'Physiotherapy', 'data': Icons.fitness_center},
    {'icon': 'water_drop', 'label': 'Dermatology', 'data': Icons.water_drop},
    {'icon': 'lunch_dining', 'label': 'Nutrition', 'data': Icons.lunch_dining},
    {'icon': 'nature_people', 'label': 'Rehabilitation', 'data': Icons.nature_people},
    {'icon': 'self_improvement', 'label': 'Mental Health', 'data': Icons.self_improvement},
    {'icon': 'sentiment_satisfied', 'label': 'Pediatrics', 'data': Icons.sentiment_satisfied},
    {'icon': 'sanitizer', 'label': 'Hygiene', 'data': Icons.sanitizer},
    {'icon': 'soap', 'label': 'Sanitation', 'data': Icons.soap},
    {'icon': 'thermostat', 'label': 'Thermometer', 'data': Icons.thermostat},
  ];

  @override
  void initState() {
    super.initState();
    _editingService = Service.empty();
    _selectedIcon = 'medical_services';

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadServices();
    });
  }

  int get _totalIconPages => (_availableIcons.length / _iconsPerPage).ceil();

  List<Map<String, dynamic>> get _currentPageIcons {
    final startIndex = _currentIconPage * _iconsPerPage;
    final endIndex = (startIndex + _iconsPerPage).clamp(0, _availableIcons.length);
    return _availableIcons.sublist(startIndex, endIndex);
  }

  Future<void> _loadServices() async {
    try {
      setState(() => _isLoading = true);
      final supabaseService = Provider.of<SupabaseService>(context, listen: false);
      await supabaseService.fetchServices();
    } catch (e) {
      print('Error loading services: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal memuat data layanan: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _pickImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1200,
        maxHeight: 1200,
        imageQuality: 85,
      );
      
      if (image != null) {
        setState(() => _selectedImage = image);
      }
    } catch (e) {
      print('Error picking image: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal memilih gambar: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _startAddService() {
    setState(() {
      _isEditing = false;
      _showForm = true;
      _editingService = Service.empty();
      _selectedIcon = 'medical_services';
      _currentIconPage = 0;
      _selectedImage = null;
      _formKey.currentState?.reset();
    });
  }

  void _startEditService(Service service) {
    setState(() {
      _isEditing = true;
      _showForm = true;
      _editingService = service.copyWith();
      _selectedIcon = service.icon;
      _currentIconPage = 0;
      _selectedImage = null;
    });
  }

  void _cancelForm() {
    setState(() {
      _showForm = false;
      _selectedImage = null;
      _formKey.currentState?.reset();
    });
  }

  Future<void> _saveService() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final supabaseService = Provider.of<SupabaseService>(context, listen: false);
      
      // Upload image if selected
      String? imageUrl = _editingService.imageUrl;
      if (_selectedImage != null) {
        setState(() => _isUploadingImage = true);
        
        final fileName = 'service_${DateTime.now().millisecondsSinceEpoch}.jpg';
        imageUrl = await supabaseService.uploadServiceImage(_selectedImage!, fileName);
        
        setState(() => _isUploadingImage = false);
      }

      final serviceToSave = _editingService.copyWith(
        icon: _selectedIcon!,
        imageUrl: imageUrl,
        updatedAt: DateTime.now(),
      );

      if (_isEditing) {
        await supabaseService.updateService(serviceToSave);
      } else {
        final services = supabaseService.services;
        final maxOrder = services.isEmpty ? 0 : services.map((s) => s.order).reduce((a, b) => a > b ? a : b);

        await supabaseService.createService(
          serviceToSave.copyWith(
            order: maxOrder + 1,
            createdAt: DateTime.now(),
          ),
        );
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              _isEditing ? '✅ Layanan berhasil diperbarui!' : '✅ Layanan berhasil ditambahkan!',
            ),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
          ),
        );
      }

      _cancelForm();
    } catch (e) {
      print('Error saving service: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ Gagal menyimpan: ${e.toString()}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _isUploadingImage = false;
        });
      }
    }
  }

  Future<void> _deleteService(String id, String name) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Konfirmasi Hapus'),
        content: Text('Apakah Anda yakin ingin menghapus layanan "$name"? Tindakan ini tidak dapat dibatalkan.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Hapus', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      setState(() => _isLoading = true);

      try {
        final supabaseService = Provider.of<SupabaseService>(context, listen: false);
        await supabaseService.deleteService(id);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('✅ Layanan berhasil dihapus!'),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 2),
            ),
          );
        }
      } catch (e) {
        print('Error deleting service: $e');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('❌ Gagal menghapus: ${e.toString()}'),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 3),
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    }
  }

  Future<void> _reorderServices(int oldIndex, int newIndex) async {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }

    try {
      final supabaseService = Provider.of<SupabaseService>(context, listen: false);
      final List<Service> services = List.from(supabaseService.services);

      if (oldIndex < 0 || oldIndex >= services.length || newIndex < 0 || newIndex >= services.length) {
        return;
      }

      final Service item = services.removeAt(oldIndex);
      services.insert(newIndex, item);

      final updatedServices = <Service>[];
      for (int i = 0; i < services.length; i++) {
        updatedServices.add(services[i].copyWith(order: i + 1));
      }

      await supabaseService.reorderServices(updatedServices);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ Urutan berhasil diperbarui'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      print('Error reordering services: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ Gagal mengubah urutan: ${e.toString()}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 2),
          ),
        );
        _loadServices();
      }
    }
  }

  Widget _buildServiceForm(bool isMobile) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(isMobile ? 16 : 20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      _isEditing ? '✏️ Edit Layanan' : '➕ Tambah Layanan Baru',
                      style: TextStyle(
                        fontSize: isMobile ? 16 : 18,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF2E7D32),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.grey),
                    onPressed: _cancelForm,
                    tooltip: 'Tutup',
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
              SizedBox(height: isMobile ? 16 : 20),

              // Image Upload Section
              Text(
                'Gambar Layanan',
                style: TextStyle(
                  fontSize: isMobile ? 13 : 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(height: 8),
              Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: _selectedImage != null
                    ? Stack(
                        fit: StackFit.expand,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              _selectedImage!.path,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  color: Colors.grey[200],
                                  child: const Center(
                                    child: Icon(Icons.broken_image, size: 50, color: Colors.grey),
                                  ),
                                );
                              },
                            ),
                          ),
                          Positioned(
                            top: 8,
                            right: 8,
                            child: IconButton(
                              icon: const Icon(Icons.close, color: Colors.white),
                              style: IconButton.styleFrom(backgroundColor: Colors.red),
                              onPressed: () => setState(() => _selectedImage = null),
                            ),
                          ),
                        ],
                      )
                    : _editingService.imageUrl != null && _editingService.imageUrl!.isNotEmpty
                        ? Stack(
                            fit: StackFit.expand,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.network(
                                  _editingService.imageUrl!,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      color: Colors.grey[200],
                                      child: const Center(
                                        child: Icon(Icons.broken_image, size: 50, color: Colors.grey),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              Positioned(
                                bottom: 8,
                                right: 8,
                                child: ElevatedButton.icon(
                                  onPressed: _pickImage,
                                  icon: const Icon(Icons.edit, size: 18),
                                  label: const Text('Ganti'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF2E7D32),
                                    foregroundColor: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          )
                        : InkWell(
                            onTap: _pickImage,
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.add_photo_alternate, size: 50, color: Colors.grey[400]),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Klik untuk upload gambar',
                                    style: TextStyle(color: Colors.grey[600], fontSize: 14),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'JPG, PNG, max 2MB',
                                    style: TextStyle(color: Colors.grey[500], fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                          ),
              ),
              const SizedBox(height: 20),

              // Service Name
              TextFormField(
                initialValue: _editingService.name,
                decoration: InputDecoration(
                  labelText: 'Nama Layanan *',
                  hintText: 'Contoh: Konsultasi Umum',
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.medical_services),
                  filled: true,
                  fillColor: Colors.grey[50],
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: isMobile ? 12 : 16,
                    vertical: isMobile ? 12 : 16,
                  ),
                ),
                style: TextStyle(fontSize: isMobile ? 14 : 16),
                maxLength: 100,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama layanan harus diisi';
                  }
                  if (value.length < 3) {
                    return 'Nama layanan minimal 3 karakter';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    _editingService = _editingService.copyWith(name: value.trim());
                  });
                },
              ),
              const SizedBox(height: 16),

              // Service Description
              TextFormField(
                initialValue: _editingService.description,
                decoration: InputDecoration(
                  labelText: 'Deskripsi Layanan *',
                  hintText: 'Deskripsikan layanan secara detail...',
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.description),
                  filled: true,
                  fillColor: Colors.grey[50],
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: isMobile ? 12 : 16,
                    vertical: isMobile ? 12 : 16,
                  ),
                ),
                style: TextStyle(fontSize: isMobile ? 14 : 16),
                maxLines: isMobile ? 3 : 4,
                maxLength: 500,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Deskripsi layanan harus diisi';
                  }
                  if (value.length < 10) {
                    return 'Deskripsi layanan minimal 10 karakter';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    _editingService = _editingService.copyWith(description: value.trim());
                  });
                },
              ),
              const SizedBox(height: 16),

              // Icon Selection
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Pilih Ikon:',
                    style: TextStyle(
                      fontSize: isMobile ? 13 : 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey,
                    ),
                  ),
                  Text(
                    'Hal ${_currentIconPage + 1}/$_totalIconPages',
                    style: TextStyle(
                      fontSize: isMobile ? 11 : 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    // Icons Grid
                    Padding(
                      padding: EdgeInsets.all(isMobile ? 8 : 12),
                      child: Wrap(
                        spacing: isMobile ? 6 : 8,
                        runSpacing: isMobile ? 6 : 8,
                        children: _currentPageIcons.map((iconData) {
                          final isSelected = _selectedIcon == iconData['icon'];
                          return InkWell(
                            onTap: () {
                              setState(() {
                                _selectedIcon = iconData['icon'] as String;
                              });
                            },
                            borderRadius: BorderRadius.circular(20),
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: isMobile ? 8 : 12,
                                vertical: isMobile ? 6 : 8,
                              ),
                              decoration: BoxDecoration(
                                color: isSelected ? const Color(0xFF2E7D32) : Colors.grey[100],
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: isSelected ? const Color(0xFF2E7D32) : Colors.grey.shade300,
                                  width: 1.5,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    iconData['data'] as IconData,
                                    size: isMobile ? 16 : 20,
                                    color: isSelected ? Colors.white : Colors.grey[700],
                                  ),
                                  if (!isMobile) ...[
                                    const SizedBox(width: 6),
                                    Text(
                                      iconData['label'] as String,
                                      style: TextStyle(
                                        color: isSelected ? Colors.white : Colors.grey[700],
                                        fontSize: 12,
                                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    // Pagination Controls
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(8),
                          bottomRight: Radius.circular(8),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: Icon(Icons.chevron_left, size: isMobile ? 20 : 24),
                            onPressed: _currentIconPage > 0
                                ? () => setState(() => _currentIconPage--)
                                : null,
                            tooltip: 'Sebelumnya',
                          ),
                          const SizedBox(width: 8),
                          Row(
                            children: List.generate(_totalIconPages, (index) {
                              return GestureDetector(
                                onTap: () => setState(() => _currentIconPage = index),
                                child: Container(
                                  margin: const EdgeInsets.symmetric(horizontal: 3),
                                  width: isMobile ? 6 : 8,
                                  height: isMobile ? 6 : 8,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: _currentIconPage == index
                                        ? const Color(0xFF2E7D32)
                                        : Colors.grey[300],
                                  ),
                                ),
                              );
                            }),
                          ),
                          const SizedBox(width: 8),
                          IconButton(
                            icon: Icon(Icons.chevron_right, size: isMobile ? 20 : 24),
                            onPressed: _currentIconPage < _totalIconPages - 1
                                ? () => setState(() => _currentIconPage++)
                                : null,
                            tooltip: 'Berikutnya',
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: isMobile ? 16 : 24),

              // Action Buttons
              if (isMobile) ...[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ElevatedButton.icon(
                      onPressed: (_isLoading || _isUploadingImage) ? null : _saveService,
                      icon: (_isLoading || _isUploadingImage)
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                            )
                          : Icon(_isEditing ? Icons.save : Icons.add, size: 18),
                      label: Text(
                        _isUploadingImage 
                            ? 'Uploading...' 
                            : _isEditing 
                                ? 'Simpan' 
                                : 'Tambah'
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2E7D32),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                    const SizedBox(height: 8),
                    OutlinedButton.icon(
                      onPressed: _cancelForm,
                      icon: const Icon(Icons.cancel, size: 18),
                      label: const Text('Batal'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.grey[700],
                        side: BorderSide(color: Colors.grey[300]!),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ],
                ),
              ] else ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    OutlinedButton.icon(
                      onPressed: _cancelForm,
                      icon: const Icon(Icons.cancel, size: 18),
                      label: const Text('Batal'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.grey[700],
                        side: BorderSide(color: Colors.grey[300]!),
                      ),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton.icon(
                      onPressed: (_isLoading || _isUploadingImage) ? null : _saveService,
                      icon: (_isLoading || _isUploadingImage)
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                            )
                          : Icon(_isEditing ? Icons.save : Icons.add, size: 18),
                      label: Text(
                        _isUploadingImage
                            ? 'Uploading...'
                            : _isEditing
                                ? 'Simpan'
                                : 'Tambah Layanan'
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2E7D32),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildServiceList(bool isMobile) {
    return Consumer<SupabaseService>(
      builder: (context, supabaseService, child) {
        final services = supabaseService.services;

        if (supabaseService.isLoading && services.isEmpty) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(32),
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (services.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                children: [
                  Icon(Icons.medical_services_outlined, size: isMobile ? 60 : 80, color: Colors.grey[300]),
                  SizedBox(height: isMobile ? 12 : 16),
                  Text('Belum ada layanan', style: TextStyle(fontSize: isMobile ? 16 : 18, color: Colors.grey)),
                  SizedBox(height: isMobile ? 6 : 8),
                  Text('Tambahkan layanan pertama Anda', style: TextStyle(fontSize: isMobile ? 13 : 14, color: Colors.grey)),
                ],
              ),
            ),
          );
        }

        return ReorderableListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: services.length,
          itemBuilder: (context, index) {
            final service = services[index];
            return Card(
              key: Key(service.id),
              margin: EdgeInsets.only(bottom: isMobile ? 8 : 10),
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: BorderSide(color: Colors.grey[200]!, width: 1),
              ),
              child: ListTile(
                contentPadding: EdgeInsets.all(isMobile ? 10 : 12),
                leading: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Service Image
                    if (service.imageUrl != null && service.imageUrl!.isNotEmpty)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          service.imageUrl!,
                          width: isMobile ? 50 : 60,
                          height: isMobile ? 50 : 60,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              width: isMobile ? 50 : 60,
                              height: isMobile ? 50 : 60,
                              decoration: BoxDecoration(
                                color: const Color(0xFFE8F5E9),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(service.iconData, color: const Color(0xFF2E7D32), size: isMobile ? 24 : 30),
                            );
                          },
                        ),
                      )
                    else
                      Container(
                        width: isMobile ? 50 : 60,
                        height: isMobile ? 50 : 60,
                        decoration: BoxDecoration(
                          color: const Color(0xFFE8F5E9),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(service.iconData, color: const Color(0xFF2E7D32), size: isMobile ? 24 : 30),
                      ),
                  ],
                ),
                title: Text(
                  service.name,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: isMobile ? 14 : 16,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 4),
                    Text(
                      service.description,
                      maxLines: isMobile ? 1 : 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: isMobile ? 12 : 13, color: Colors.grey),
                    ),
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 6,
                      runSpacing: 4,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                          decoration: BoxDecoration(
                            color: Colors.blue[50],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.sort, size: isMobile ? 10 : 12, color: Colors.blue),
                              const SizedBox(width: 3),
                              Text(
                                'Urutan ${service.order}',
                                style: TextStyle(
                                  fontSize: isMobile ? 10 : 11,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (service.imageUrl != null && service.imageUrl!.isNotEmpty)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                            decoration: BoxDecoration(
                              color: Colors.green[50],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.image, size: isMobile ? 10 : 12, color: Colors.green),
                                const SizedBox(width: 3),
                                Text(
                                  'Ada Gambar',
                                  style: TextStyle(
                                    fontSize: isMobile ? 10 : 11,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
                trailing: isMobile
                    ? PopupMenuButton(
                        icon: const Icon(Icons.more_vert, size: 20),
                        itemBuilder: (context) => [
                          PopupMenuItem(
                            child: Row(
                              children: [
                                Icon(Icons.edit, size: 16, color: Colors.blue[600]),
                                const SizedBox(width: 8),
                                const Text('Edit'),
                              ],
                            ),
                            onTap: () => Future.delayed(Duration.zero, () => _startEditService(service)),
                          ),
                          PopupMenuItem(
                            child: Row(
                              children: [
                                Icon(Icons.delete, size: 16, color: Colors.red[600]),
                                const SizedBox(width: 8),
                                const Text('Hapus'),
                              ],
                            ),
                            onTap: () => Future.delayed(Duration.zero, () => _deleteService(service.id, service.name)),
                          ),
                        ],
                      )
                    : Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, size: 18),
                            color: Colors.blue[600],
                            onPressed: () => _startEditService(service),
                            tooltip: 'Edit',
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, size: 18),
                            color: Colors.red[600],
                            onPressed: () => _deleteService(service.id, service.name),
                            tooltip: 'Hapus',
                          ),
                          const SizedBox(width: 4),
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.drag_handle, size: 16, color: Colors.grey),
                          ),
                        ],
                      ),
              ),
            );
          },
          onReorder: _reorderServices,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768;

    return AdminLayout(
      pageTitle: 'Kelola Layanan',
      useDrawerForMobile: false,
      child: _isLoading && !_showForm
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Memuat...'),
                ],
              ),
            )
          : SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(isMobile ? 12 : 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header Section
                    Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: Padding(
                        padding: EdgeInsets.all(isMobile ? 16 : 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (isMobile) ...[
                              Text(
                                'Kelola Layanan Klinik',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFF2E7D32),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Atur semua layanan yang ditawarkan klinik',
                                style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                              ),
                              const SizedBox(height: 12),
                              if (!_showForm)
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton.icon(
                                    onPressed: _startAddService,
                                    icon: const Icon(Icons.add, size: 18),
                                    label: const Text('Tambah Layanan'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF2E7D32),
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(vertical: 12),
                                    ),
                                  ),
                                ),
                            ] else ...[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Kelola Layanan Klinik',
                                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                                fontWeight: FontWeight.w700,
                                                color: const Color(0xFF2E7D32),
                                              ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          'Atur semua layanan yang ditawarkan klinik',
                                          style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                                        ),
                                      ],
                                    ),
                                  ),
                                  if (!_showForm)
                                    ElevatedButton.icon(
                                      onPressed: _startAddService,
                                      icon: const Icon(Icons.add, size: 18),
                                      label: const Text('Tambah Layanan Baru'),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(0xFF2E7D32),
                                        foregroundColor: Colors.white,
                                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                                      ),
                                    ),
                                ],
                              ),
                            ],
                            const SizedBox(height: 16),
                            Consumer<SupabaseService>(
                              builder: (context, supabaseService, child) {
                                if (isMobile) {
                                  return Column(
                                    children: [
                                      _buildStatCard(
                                        icon: Icons.medical_services,
                                        value: supabaseService.services.length.toString(),
                                        label: 'Total Layanan',
                                        color: Colors.blue,
                                        isMobile: true,
                                      ),
                                      const SizedBox(height: 8),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: _buildStatCard(
                                              icon: Icons.sort,
                                              value: 'Drag',
                                              label: 'Atur Urutan',
                                              color: Colors.green,
                                              isMobile: true,
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Expanded(
                                            child: _buildStatCard(
                                              icon: Icons.info,
                                              value: 'Live',
                                              label: 'Status',
                                              color: Colors.orange,
                                              isMobile: true,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  );
                                } else {
                                  return Wrap(
                                    spacing: 12,
                                    runSpacing: 12,
                                    children: [
                                      _buildStatCard(
                                        icon: Icons.medical_services,
                                        value: supabaseService.services.length.toString(),
                                        label: 'Total Layanan',
                                        color: Colors.blue,
                                        isMobile: false,
                                      ),
                                      _buildStatCard(
                                        icon: Icons.sort,
                                        value: 'Drag & Drop',
                                        label: 'Atur Urutan',
                                        color: Colors.green,
                                        isMobile: false,
                                      ),
                                      _buildStatCard(
                                        icon: Icons.info,
                                        value: 'Live',
                                        label: 'Status',
                                        color: Colors.orange,
                                        isMobile: false,
                                      ),
                                    ],
                                  );
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Form or List Section
                    if (_showForm) _buildServiceForm(isMobile),

                    if (!_showForm)
                      Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        child: Padding(
                          padding: EdgeInsets.all(isMobile ? 12 : 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (isMobile) ...[
                                const Text(
                                  '📋 Daftar Layanan',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF2E7D32),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Geser untuk mengubah urutan',
                                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                                ),
                              ] else ...[
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      '📋 Daftar Layanan',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xFF2E7D32),
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Icon(Icons.swap_vert, size: 16, color: Colors.grey[600]),
                                        const SizedBox(width: 4),
                                        Text(
                                          'Drag untuk mengurutkan',
                                          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Geser kiri/kanan untuk mengubah urutan tampilan di halaman publik',
                                  style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                                ),
                              ],
                              const SizedBox(height: 16),
                              _buildServiceList(isMobile),
                            ],
                          ),
                        ),
                      ),

                    const SizedBox(height: 16),

                    // Quick Actions Card
                    if (!isMobile)
                      Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Row(
                                children: [
                                  Icon(Icons.lightbulb, size: 20, color: Colors.orange),
                                  SizedBox(width: 8),
                                  Text(
                                    'Tips Pengelolaan',
                                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '• Urutan layanan mempengaruhi tampilan di halaman utama\n'
                                '• Pastikan deskripsi jelas dan informatif\n'
                                '• Upload gambar berkualitas untuk setiap layanan\n'
                                '• Gunakan ikon yang sesuai dengan jenis layanan',
                                style: TextStyle(fontSize: 12, color: Colors.grey[600], height: 1.5),
                              ),
                              const SizedBox(height: 12),
                              OutlinedButton.icon(
                                onPressed: () {
                                  Navigator.pushNamed(context, '/services');
                                },
                                icon: const Icon(Icons.visibility, size: 16),
                                label: const Text('Lihat di Halaman Publik'),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: const Color(0xFF2E7D32),
                                  side: const BorderSide(color: Color(0xFF2E7D32)),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String value,
    required String label,
    required Color color,
    required bool isMobile,
  }) {
    return Container(
      width: isMobile ? double.infinity : null,
      constraints: BoxConstraints(minWidth: isMobile ? 0 : 100),
      padding: EdgeInsets.all(isMobile ? 10 : 12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        mainAxisSize: isMobile ? MainAxisSize.max : MainAxisSize.min,
        children: [
          Icon(icon, size: isMobile ? 20 : 16, color: color),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: TextStyle(
                    fontSize: isMobile ? 16 : 18,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: isMobile ? 10 : 11,
                    color: color.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}