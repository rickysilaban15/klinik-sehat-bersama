import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/supabase_service.dart';
import 'admin_layout.dart';

class AboutEditPage extends StatefulWidget {
  const AboutEditPage({super.key});

  @override
  State<AboutEditPage> createState() => _AboutEditPageState();
}

class _AboutEditPageState extends State<AboutEditPage> {
  final _formKey = GlobalKey<FormState>();
  
  // Hero Section Controllers
  final _titleController = TextEditingController();
  final _subtitleController = TextEditingController();
  final _heroImageController = TextEditingController();
  
  // History Section Controllers
  final _historyTitleController = TextEditingController();
  final _historyImageController = TextEditingController();
  final _historyContent1Controller = TextEditingController();
  final _historyContent2Controller = TextEditingController();
  
  // Mission Section Controllers
  final _missionTitleController = TextEditingController();
  final _missionImageController = TextEditingController();
  final _missionContentController = TextEditingController();
  final List<TextEditingController> _missionPointsControllers = [];
  
  // Vision Section Controllers
  final _visionTitleController = TextEditingController();
  final _visionImageController = TextEditingController();
  final _visionContentController = TextEditingController();
  final List<TextEditingController> _visionPointsControllers = [];
  
  // Team Section Controllers
  final _teamTitleController = TextEditingController();
  final _teamImageController = TextEditingController();
  final List<Map<String, TextEditingController>> _teamControllers = [];

  bool _isLoading = false;
  bool _hasChanges = false;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _loadAboutData();
    _addChangeListeners();
  }

  void _initializeControllers() {
    // Initialize with 4 mission points
    for (int i = 0; i < 4; i++) {
      _missionPointsControllers.add(TextEditingController());
    }
    
    // Initialize with 4 vision points
    for (int i = 0; i < 4; i++) {
      _visionPointsControllers.add(TextEditingController());
    }
    
    // Initialize with 6 team members
    for (int i = 0; i < 6; i++) {
      _teamControllers.add({
        'name': TextEditingController(),
        'position': TextEditingController(),
        'education': TextEditingController(),
        'photo': TextEditingController(),
      });
    }
  }

  void _addChangeListeners() {
    // Hero section
    _titleController.addListener(_checkForChanges);
    _subtitleController.addListener(_checkForChanges);
    _heroImageController.addListener(_checkForChanges);
    
    // History section
    _historyTitleController.addListener(_checkForChanges);
    _historyImageController.addListener(_checkForChanges);
    _historyContent1Controller.addListener(_checkForChanges);
    _historyContent2Controller.addListener(_checkForChanges);
    
    // Mission section
    _missionTitleController.addListener(_checkForChanges);
    _missionImageController.addListener(_checkForChanges);
    _missionContentController.addListener(_checkForChanges);
    for (var controller in _missionPointsControllers) {
      controller.addListener(_checkForChanges);
    }
    
    // Vision section
    _visionTitleController.addListener(_checkForChanges);
    _visionImageController.addListener(_checkForChanges);
    _visionContentController.addListener(_checkForChanges);
    for (var controller in _visionPointsControllers) {
      controller.addListener(_checkForChanges);
    }
    
    // Team section
    _teamTitleController.addListener(_checkForChanges);
    _teamImageController.addListener(_checkForChanges);
    for (var member in _teamControllers) {
      for (var controller in member.values) {
        controller.addListener(_checkForChanges);
      }
    }
  }

  void _checkForChanges() {
    setState(() {
      _hasChanges = true;
    });
  }

  Future<void> _loadAboutData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final supabaseService = Provider.of<SupabaseService>(context, listen: false);
      final data = await supabaseService.getAboutData();
      
      if (data != null) {
        // Hero section
        _titleController.text = data['title'] ?? 'Tentang Kami';
        _subtitleController.text = data['subtitle'] ?? 'Mengenal Lebih Dekat Klinik Sehat Bersama';
        _heroImageController.text = data['hero_image'] ?? '';
        
        // History section
        _historyTitleController.text = data['history_title'] ?? 'Sejarah Klinik';
        _historyImageController.text = data['history_image'] ?? 'https://images.unsplash.com/photo-1582750433449-648ed127bb54';
        _historyContent1Controller.text = data['history_content_1'] ?? '';
        _historyContent2Controller.text = data['history_content_2'] ?? '';
        
        // Mission section
        _missionTitleController.text = data['mission_title'] ?? 'Misi Kami';
        _missionImageController.text = data['mission_image'] ?? 'https://images.unsplash.com/photo-1579684385127-1ef15d508118';
        _missionContentController.text = data['mission_content'] ?? '';
        
        final missionPoints = data['mission_points'] as List<dynamic>?;
        if (missionPoints != null) {
          for (int i = 0; i < missionPoints.length && i < _missionPointsControllers.length; i++) {
            _missionPointsControllers[i].text = missionPoints[i].toString();
          }
        }
        
        // Vision section
        _visionTitleController.text = data['vision_title'] ?? 'Visi Kami';
        _visionImageController.text = data['vision_image'] ?? 'https://images.unsplash.com/photo-1559757148-5c350d0d3c56';
        _visionContentController.text = data['vision_content'] ?? '';
        
        final visionPoints = data['vision_points'] as List<dynamic>?;
        if (visionPoints != null) {
          for (int i = 0; i < visionPoints.length && i < _visionPointsControllers.length; i++) {
            _visionPointsControllers[i].text = visionPoints[i].toString();
          }
        }
        
        // Team section
        _teamTitleController.text = data['team_title'] ?? 'Tim Profesional Kami';
        _teamImageController.text = data['team_image'] ?? 'https://images.unsplash.com/photo-1551601651-2a8555f1a136';
        
        final teamData = data['team'] as List<dynamic>?;
        if (teamData != null && teamData.isNotEmpty) {
          for (int i = 0; i < teamData.length && i < _teamControllers.length; i++) {
            final member = teamData[i] as Map<String, dynamic>;
            _teamControllers[i]['name']!.text = member['name']?.toString() ?? '';
            _teamControllers[i]['position']!.text = member['position']?.toString() ?? '';
            _teamControllers[i]['education']!.text = member['education']?.toString() ?? '';
            _teamControllers[i]['photo']!.text = member['photo_url']?.toString() ?? '';
          }
        }
      } else {
        _setDefaultValues();
      }
    } catch (e) {
      print('Error loading about data: $e');
      _setDefaultValues();
    } finally {
      setState(() {
        _isLoading = false;
        _hasChanges = false;
      });
    }
  }

  void _setDefaultValues() {
    // Hero section defaults
    _titleController.text = 'Tentang Kami';
    _subtitleController.text = 'Mengenal Lebih Dekat Klinik Sehat Bersama';
    
    // History section defaults
    _historyTitleController.text = 'Sejarah Klinik';
    _historyImageController.text = 'https://images.unsplash.com/photo-1582750433449-648ed127bb54';
    _historyContent1Controller.text = 'Klinik Sehat Bersama didirikan pada tahun 2010 oleh Dr. Budi Santoso dengan visi memberikan pelayanan kesehatan yang terjangkau dan berkualitas bagi seluruh masyarakat.';
    _historyContent2Controller.text = 'Dalam perjalanan lebih dari 10 tahun, kami telah melayani ribuan pasien dengan berbagai kebutuhan kesehatan.';
    
    // Mission section defaults
    _missionTitleController.text = 'Misi Kami';
    _missionImageController.text = 'https://images.unsplash.com/photo-1579684385127-1ef15d508118';
    _missionContentController.text = 'Menyediakan layanan kesehatan yang terjangkau, berkualitas, dan ramah bagi seluruh lapisan masyarakat.';
    
    final defaultMissionPoints = [
      'Memberikan pelayanan kesehatan yang holistik',
      'Menggunakan teknologi medis terkini',
      'Menyediakan lingkungan yang nyaman dan aman',
      'Mengedukasi masyarakat tentang kesehatan'
    ];
    for (int i = 0; i < defaultMissionPoints.length; i++) {
      _missionPointsControllers[i].text = defaultMissionPoints[i];
    }
    
    // Vision section defaults
    _visionTitleController.text = 'Visi Kami';
    _visionImageController.text = 'https://images.unsplash.com/photo-1559757148-5c350d0d3c56';
    _visionContentController.text = 'Menjadi klinik kesehatan terdepan dan terpercaya di wilayah ini.';
    
    final defaultVisionPoints = [
      'Pusat rujukan kesehatan masyarakat',
      'Inovasi dalam pelayanan kesehatan',
      'Membangun kepercayaan masyarakat',
      'Berkontribusi pada kesehatan nasional'
    ];
    for (int i = 0; i < defaultVisionPoints.length; i++) {
      _visionPointsControllers[i].text = defaultVisionPoints[i];
    }
    
    // Team section defaults
    _teamTitleController.text = 'Tim Profesional Kami';
    _teamImageController.text = 'https://images.unsplash.com/photo-1551601651-2a8555f1a136';
    
    final defaultTeam = [
      {'name': 'Dr. Budi Santoso', 'position': 'Dokter Umum', 'education': 'Spesialis Penyakit Dalam'},
      {'name': 'Dr. Siti Aminah', 'position': 'Dokter Anak', 'education': 'Spesialis Anak'},
      {'name': 'Dr. Ahmad Rizal', 'position': 'Dokter Gigi', 'education': 'Spesialis Gigi'},
      {'name': 'Nurul Hasanah, S.Kep', 'position': 'Kepala Perawat', 'education': 'S.Kep Ners'},
      {'name': 'Rina Marlina, A.Md.AK', 'position': 'Analis Lab', 'education': 'D3 Analis Kesehatan'},
      {'name': 'Dian Permatasari', 'position': 'Administrasi', 'education': 'S1 Administrasi'},
    ];
    
    for (int i = 0; i < defaultTeam.length; i++) {
      _teamControllers[i]['name']!.text = defaultTeam[i]['name']!;
      _teamControllers[i]['position']!.text = defaultTeam[i]['position']!;
      _teamControllers[i]['education']!.text = defaultTeam[i]['education']!;
    }
  }

  Future<void> _saveAboutData() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final supabaseService = Provider.of<SupabaseService>(context, listen: false);
      
      // Collect mission points
      final missionPoints = _missionPointsControllers
          .map((c) => c.text.trim())
          .where((text) => text.isNotEmpty)
          .toList();
      
      // Collect vision points
      final visionPoints = _visionPointsControllers
          .map((c) => c.text.trim())
          .where((text) => text.isNotEmpty)
          .toList();
      
      // Collect team data
      final teamData = <Map<String, dynamic>>[];
      for (var member in _teamControllers) {
        final name = member['name']!.text.trim();
        final position = member['position']!.text.trim();
        final education = member['education']!.text.trim();
        final photo = member['photo']!.text.trim();
        
        if (name.isNotEmpty && position.isNotEmpty) {
          teamData.add({
            'name': name,
            'position': position,
            'education': education.isNotEmpty ? education : '',
            'photo_url': photo.isNotEmpty ? photo : null,
          });
        }
      }
      
      // Prepare data - ensure all required fields are present
      final aboutData = {
        'title': _titleController.text.trim(),
        'subtitle': _subtitleController.text.trim(),
        'hero_image': _heroImageController.text.trim().isNotEmpty ? _heroImageController.text.trim() : null,
        'history_title': _historyTitleController.text.trim(),
        'history_image': _historyImageController.text.trim(),
        'history_content_1': _historyContent1Controller.text.trim(),
        'history_content_2': _historyContent2Controller.text.trim(),
        'mission_title': _missionTitleController.text.trim(),
        'mission_image': _missionImageController.text.trim(),
        'mission_content': _missionContentController.text.trim(),
        'mission_points': missionPoints,
        'vision_title': _visionTitleController.text.trim(),
        'vision_image': _visionImageController.text.trim(),
        'vision_content': _visionContentController.text.trim(),
        'vision_points': visionPoints,
        'team_title': _teamTitleController.text.trim(),
        'team_image': _teamImageController.text.trim(),
        'team': teamData,
        'updated_at': DateTime.now().toIso8601String(),
      };

      print('Saving about data: ${aboutData.keys}');
      print('Team data count: ${teamData.length}');
      print('Mission points count: ${missionPoints.length}');
      print('Vision points count: ${visionPoints.length}');

      await supabaseService.updateAboutData(aboutData);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ Data halaman Tentang Kami berhasil diperbarui!'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
        
        setState(() {
          _hasChanges = false;
        });
      }
    } catch (e, stackTrace) {
      print('Error saving about data: $e');
      print('Stack trace: $stackTrace');
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error menyimpan data: ${e.toString()}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 5),
            action: SnackBarAction(
              label: 'Lihat Log',
              textColor: Colors.white,
              onPressed: () {
                print('Full error: $e');
                print('Stack: $stackTrace');
              },
            ),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _resetForm() {
    _loadAboutData();
  }

  void _addMissionPoint() {
    setState(() {
      final controller = TextEditingController();
      controller.addListener(_checkForChanges);
      _missionPointsControllers.add(controller);
    });
  }

  void _removeMissionPoint(int index) {
    if (_missionPointsControllers.length > 1) {
      setState(() {
        _missionPointsControllers[index].dispose();
        _missionPointsControllers.removeAt(index);
        _checkForChanges();
      });
    }
  }

  void _addVisionPoint() {
    setState(() {
      final controller = TextEditingController();
      controller.addListener(_checkForChanges);
      _visionPointsControllers.add(controller);
    });
  }

  void _removeVisionPoint(int index) {
    if (_visionPointsControllers.length > 1) {
      setState(() {
        _visionPointsControllers[index].dispose();
        _visionPointsControllers.removeAt(index);
        _checkForChanges();
      });
    }
  }

  void _addTeamMember() {
    setState(() {
      final member = {
        'name': TextEditingController(),
        'position': TextEditingController(),
        'education': TextEditingController(),
        'photo': TextEditingController(),
      };
      
      for (var controller in member.values) {
        controller.addListener(_checkForChanges);
      }
      
      _teamControllers.add(member);
    });
  }

  void _removeTeamMember(int index) {
    if (_teamControllers.length > 1) {
      setState(() {
        for (var controller in _teamControllers[index].values) {
          controller.dispose();
        }
        _teamControllers.removeAt(index);
        _checkForChanges();
      });
    }
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hintText,
    int maxLines = 1,
    bool isRequired = false,
    String? helperText,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          hintText: hintText,
          helperText: helperText,
          helperMaxLines: 2,
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

  @override
  void dispose() {
    _titleController.dispose();
    _subtitleController.dispose();
    _heroImageController.dispose();
    _historyTitleController.dispose();
    _historyImageController.dispose();
    _historyContent1Controller.dispose();
    _historyContent2Controller.dispose();
    _missionTitleController.dispose();
    _missionImageController.dispose();
    _missionContentController.dispose();
    _visionTitleController.dispose();
    _visionImageController.dispose();
    _visionContentController.dispose();
    _teamTitleController.dispose();
    _teamImageController.dispose();
    
    for (var controller in _missionPointsControllers) {
      controller.dispose();
    }
    for (var controller in _visionPointsControllers) {
      controller.dispose();
    }
    for (var member in _teamControllers) {
      for (var controller in member.values) {
        controller.dispose();
      }
    }
    
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;
    
    return AdminLayout(
      pageTitle: 'Edit Tentang Kami',
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
                        // Header
                        if (!isMobile) ...[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Edit Halaman Tentang Kami',
                                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Edit semua konten halaman Tentang Kami termasuk hero, gambar, dan semua teks',
                                      style: TextStyle(color: Colors.grey[600]),
                                    ),
                                  ],
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
                                  OutlinedButton.icon(
                                    onPressed: () {
                                      Navigator.pushNamed(context, '/about');
                                    },
                                    icon: const Icon(Icons.visibility, size: 18),
                                    label: const Text('Lihat Halaman'),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 32),
                        ],

                        if (isMobile) ...[
                          Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: Text(
                              'Edit Halaman Tentang Kami',
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],

                        // Hero Section
                        _buildSectionCard(
                          title: 'Hero Section',
                          icon: Icons.view_carousel,
                          iconColor: Colors.purple,
                          children: [
                            _buildTextField(
                              controller: _titleController,
                              label: 'Judul Utama',
                              hintText: 'Contoh: Tentang Kami',
                              isRequired: true,
                            ),
                            _buildTextField(
                              controller: _subtitleController,
                              label: 'Subjudul',
                              hintText: 'Contoh: Mengenal Lebih Dekat Klinik Sehat Bersama',
                              isRequired: true,
                            ),
                            _buildTextField(
                              controller: _heroImageController,
                              label: 'URL Gambar Hero (Opsional)',
                              hintText: 'https://example.com/image.jpg',
                              helperText: 'Biarkan kosong untuk menggunakan gradient default',
                            ),
                          ],
                        ),

                        // History Section
                        _buildSectionCard(
                          title: 'Sejarah Klinik',
                          icon: Icons.history,
                          iconColor: const Color(0xFF00897B),
                          children: [
                            _buildTextField(
                              controller: _historyTitleController,
                              label: 'Judul Sejarah',
                              hintText: 'Contoh: Sejarah Klinik',
                              isRequired: true,
                            ),
                            _buildTextField(
                              controller: _historyImageController,
                              label: 'URL Gambar Sejarah',
                              hintText: 'https://images.unsplash.com/...',
                              isRequired: true,
                              helperText: 'Gunakan URL gambar dari Unsplash atau sumber lain',
                            ),
                            _buildTextField(
                              controller: _historyContent1Controller,
                              label: 'Konten Paragraf 1',
                              hintText: 'Masukkan paragraf pertama sejarah klinik...',
                              maxLines: 4,
                              isRequired: true,
                            ),
                            _buildTextField(
                              controller: _historyContent2Controller,
                              label: 'Konten Paragraf 2',
                              hintText: 'Masukkan paragraf kedua sejarah klinik...',
                              maxLines: 4,
                              isRequired: true,
                            ),
                          ],
                        ),

                        // Mission Section
                        _buildSectionCard(
                          title: 'Misi Klinik',
                          icon: Icons.flag,
                          iconColor: Colors.blue,
                          children: [
                            _buildTextField(
                              controller: _missionTitleController,
                              label: 'Judul Misi',
                              hintText: 'Contoh: Misi Kami',
                              isRequired: true,
                            ),
                            _buildTextField(
                              controller: _missionImageController,
                              label: 'URL Gambar Misi',
                              hintText: 'https://images.unsplash.com/...',
                              isRequired: true,
                            ),
                            _buildTextField(
                              controller: _missionContentController,
                              label: 'Konten Misi',
                              hintText: 'Masukkan deskripsi misi klinik...',
                              maxLines: 4,
                              isRequired: true,
                            ),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Poin-poin Misi',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey[800],
                                  ),
                                ),
                                TextButton.icon(
                                  onPressed: _addMissionPoint,
                                  icon: const Icon(Icons.add, size: 18),
                                  label: const Text('Tambah Poin'),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            ..._missionPointsControllers.asMap().entries.map((entry) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: TextFormField(
                                        controller: entry.value,
                                        decoration: InputDecoration(
                                          labelText: 'Poin ${entry.key + 1}',
                                          hintText: 'Masukkan poin misi...',
                                          border: const OutlineInputBorder(),
                                          filled: true,
                                          fillColor: Colors.grey[50],
                                          prefixIcon: const Icon(Icons.check_circle_outline),
                                        ),
                                      ),
                                    ),
                                    if (_missionPointsControllers.length > 1)
                                      IconButton(
                                        icon: const Icon(Icons.delete, color: Colors.red),
                                        onPressed: () => _removeMissionPoint(entry.key),
                                      ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ],
                        ),

                        // Vision Section
                        _buildSectionCard(
                          title: 'Visi Klinik',
                          icon: Icons.visibility,
                          iconColor: Colors.orange,
                          children: [
                            _buildTextField(
                              controller: _visionTitleController,
                              label: 'Judul Visi',
                              hintText: 'Contoh: Visi Kami',
                              isRequired: true,
                            ),
                            _buildTextField(
                              controller: _visionImageController,
                              label: 'URL Gambar Visi',
                              hintText: 'https://images.unsplash.com/...',
                              isRequired: true,
                            ),
                            _buildTextField(
                              controller: _visionContentController,
                              label: 'Konten Visi',
                              hintText: 'Masukkan deskripsi visi klinik...',
                              maxLines: 4,
                              isRequired: true,
                            ),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Poin-poin Visi',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey[800],
                                  ),
                                ),
                                TextButton.icon(
                                  onPressed: _addVisionPoint,
                                  icon: const Icon(Icons.add, size: 18),
                                  label: const Text('Tambah Poin'),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            ..._visionPointsControllers.asMap().entries.map((entry) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: TextFormField(
                                        controller: entry.value,
                                        decoration: InputDecoration(
                                          labelText: 'Poin ${entry.key + 1}',
                                          hintText: 'Masukkan poin visi...',
                                          border: const OutlineInputBorder(),
                                          filled: true,
                                          fillColor: Colors.grey[50],
                                          prefixIcon: const Icon(Icons.check_circle_outline),
                                        ),
                                      ),
                                    ),
                                    if (_visionPointsControllers.length > 1)
                                      IconButton(
                                        icon: const Icon(Icons.delete, color: Colors.red),
                                        onPressed: () => _removeVisionPoint(entry.key),
                                      ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ],
                        ),

                        // Team Section
                        Card(
                          elevation: 2,
                          margin: const EdgeInsets.only(bottom: 24),
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Icon(Icons.people, color: Color(0xFF00897B)),
                                    const SizedBox(width: 12),
                                    const Text(
                                      'Tim Profesional',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                _buildTextField(
                                  controller: _teamTitleController,
                                  label: 'Judul Tim',
                                  hintText: 'Contoh: Tim Profesional Kami',
                                  isRequired: true,
                                ),
                                _buildTextField(
                                  controller: _teamImageController,
                                  label: 'URL Gambar Tim',
                                  hintText: 'https://images.unsplash.com/...',
                                  isRequired: true,
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Anggota Tim',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.grey[800],
                                      ),
                                    ),
                                    if (!isMobile)
                                      ElevatedButton.icon(
                                        onPressed: _addTeamMember,
                                        icon: const Icon(Icons.add, size: 18),
                                        label: const Text('Tambah Anggota'),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: const Color(0xFF00897B),
                                          foregroundColor: Colors.white,
                                        ),
                                      ),
                                  ],
                                ),
                                if (isMobile) ...[
                                  const SizedBox(height: 12),
                                  SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton.icon(
                                      onPressed: _addTeamMember,
                                      icon: const Icon(Icons.add, size: 18),
                                      label: const Text('Tambah Anggota'),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(0xFF00897B),
                                        foregroundColor: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                                const SizedBox(height: 20),
                                ..._teamControllers.asMap().entries.map((entry) {
                                  return _buildTeamMemberCard(entry.key);
                                }).toList(),
                              ],
                            ),
                          ),
                        ),

                        // Desktop Action Buttons
                        if (!isMobile)
                          Card(
                            elevation: 2,
                            margin: const EdgeInsets.only(bottom: 32),
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  OutlinedButton(
                                    onPressed: _resetForm,
                                    child: const Text('Reset'),
                                  ),
                                  const SizedBox(width: 16),
                                  ElevatedButton.icon(
                                    onPressed: _hasChanges ? _saveAboutData : null,
                                    icon: _isLoading
                                        ? const SizedBox(
                                            width: 20,
                                            height: 20,
                                            child: CircularProgressIndicator(strokeWidth: 2),
                                          )
                                        : const Icon(Icons.save, size: 20),
                                    label: const Text('Simpan Perubahan'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF00897B),
                                      foregroundColor: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        
                        // Add bottom padding for mobile FAB
                        if (isMobile) const SizedBox(height: 80),
                      ],
                    ),
                  ),
                ),
                
                // Mobile Floating Action Buttons
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
                            onPressed: _isLoading ? null : _saveAboutData,
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
            const SizedBox(height: 16),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildTeamMemberCard(int index) {
    return Card(
      elevation: 1,
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF00897B),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'Anggota Tim',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF00897B),
                      ),
                    ),
                  ],
                ),
                if (_teamControllers.length > 1)
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red, size: 20),
                    onPressed: () => _removeTeamMember(index),
                    tooltip: 'Hapus anggota',
                  ),
              ],
            ),
            const SizedBox(height: 12),
            _buildTextField(
              controller: _teamControllers[index]['name']!,
              label: 'Nama',
              hintText: 'Contoh: Dr. Budi Santoso',
              isRequired: true,
            ),
            _buildTextField(
              controller: _teamControllers[index]['position']!,
              label: 'Posisi',
              hintText: 'Contoh: Dokter Umum',
              isRequired: true,
            ),
            _buildTextField(
              controller: _teamControllers[index]['education']!,
              label: 'Pendidikan/Spesialisasi',
              hintText: 'Contoh: Spesialis Penyakit Dalam',
              isRequired: true,
            ),
            _buildTextField(
              controller: _teamControllers[index]['photo']!,
              label: 'URL Foto (Opsional)',
              hintText: 'https://example.com/photo.jpg',
              helperText: 'Biarkan kosong untuk menggunakan avatar default',
            ),
          ],
        ),
      ),
    );
  }
}