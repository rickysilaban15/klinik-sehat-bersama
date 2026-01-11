import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../services/supabase_service.dart';
import '../../models/contact_model.dart';
import '../../utils/constants.dart';
import '../../widgets/footer.dart';

class ContactPage extends StatefulWidget {
  const ContactPage({super.key});

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  ContactModel? _contactData;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadContactData();
  }

  Future<void> _loadContactData() async {
    try {
      final supabaseService = Provider.of<SupabaseService>(context, listen: false);
      final data = await supabaseService.getContactPageData();
      
      if (data != null) {
        setState(() {
          _contactData = ContactModel.fromJson(data);
          _isLoading = false;
        });
      } else {
        // Gunakan data default jika tidak ada di database
        setState(() {
          _contactData = ContactModel(
            id: '',
            heroTitle: 'Hubungi Kami',
            heroSubtitle: 'Kami siap melayani dan menjawab pertanyaan Anda',
            heroIcon: 'contact_mail',
            contactInfoTitle: 'Informasi Kontak',
            addressTitle: 'Alamat',
            addressContent: AppConstants.contactAddress,
            phoneTitle: 'Telepon',
            phoneContent: AppConstants.contactPhone,
            emailTitle: 'Email',
            emailContent: AppConstants.contactEmail,
            formTitle: 'Kirim Pesan',
            formNameLabel: 'Nama Lengkap',
            formEmailLabel: 'Email',
            formMessageLabel: 'Pesan',
            formButtonText: 'Kirim Pesan',
            formSuccessTitle: 'Pesan Terkirim',
            formSuccessMessage: 'Terima kasih atas pesan Anda. Kami akan membalas segera.',
            operatingHoursTitle: 'Jam Operasional',
            operatingHours: {
              'Senin - Jumat': '08:00 - 21:00',
              'Sabtu': '08:00 - 18:00',
              'Minggu': '09:00 - 15:00',
              'Emergency': '24 Jam',
            },
            mapTitle: 'Lokasi Klinik',
            mapButtonText: 'Buka di Google Maps',
            mapsUrl: 'https://www.google.com/maps',
          );
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error loading contact data: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768;
    final isTablet = screenWidth >= 768 && screenWidth < 1024;

    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: isMobile ? _buildMobileAppBar(context) : _buildDesktopAppBar(context),
      drawer: isMobile ? _buildMobileDrawer(context) : null,
      body: _buildContactContent(context, isMobile, isTablet),
    );
  }

  PreferredSizeWidget _buildMobileAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 2,
      leading: Builder(
        builder: (context) => IconButton(
          icon: const Icon(Icons.menu, color: Color(0xFF00897B)),
          onPressed: () {
            Scaffold.of(context).openDrawer();
          },
        ),
      ),
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.medical_services,
            color: const Color(0xFF00897B),
            size: 28,
          ),
          const SizedBox(width: 8),
          const Flexible(
            child: Text(
              'Klinik Sehat Bersama',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF37474F),
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileDrawer(BuildContext context) {
    return Drawer(
      child: Container(
        color: Colors.white,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF00897B),
                    Color(0xFF00796B),
                  ],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.local_hospital,
                      size: 40,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    'Klinik Sehat Bersama',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Kesehatan Anda, Prioritas Kami',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            _buildDrawerItem(
              context: context,
              icon: Icons.home,
              title: 'Home',
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
              },
            ),
            _buildDrawerItem(
              context: context,
              icon: Icons.info,
              title: 'Tentang Kami',
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/about');
              },
            ),
            _buildDrawerItem(
              context: context,
              icon: Icons.medical_services,
              title: 'Layanan',
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/services');
              },
            ),
            _buildDrawerItem(
              context: context,
              icon: Icons.contact_mail,
              title: 'Kontak',
              onTap: () {
                Navigator.pop(context);
              },
            ),
            const Divider(),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Version 1.0.0',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF00897B)),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Color(0xFF37474F),
        ),
      ),
      onTap: onTap,
      hoverColor: const Color(0xFF00897B).withOpacity(0.1),
    );
  }

  PreferredSizeWidget _buildDesktopAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 2,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Color(0xFF00897B)),
        onPressed: () => Navigator.pop(context),
      ),
      title: Row(
        children: [
          Icon(
            Icons.medical_services,
            color: const Color(0xFF00897B),
            size: 32,
          ),
          const SizedBox(width: 10),
          const Text(
            'Klinik Sehat Bersama',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF37474F),
            ),
          ),
        ],
      ),
      centerTitle: false,
      actions: [
        _NavButton(label: 'Home', route: '/', icon: Icons.home),
        _NavButton(label: 'Tentang Kami', route: '/about', icon: Icons.info),
        _NavButton(label: 'Layanan', route: '/services', icon: Icons.medical_services),
        _NavButton(label: 'Kontak', route: '/contact', icon: Icons.contact_mail),
        const SizedBox(width: 20),
      ],
    );
  }

  Widget _buildContactContent(BuildContext context, bool isMobile, bool isTablet) {
    if (_contactData == null) {
      return const Center(child: Text('Data tidak tersedia'));
    }

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Hero Section
            Container(
              padding: EdgeInsets.all(isMobile ? 30 : (isTablet ? 40 : 60)),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    const Color(0xFF00897B),
                    const Color(0xFF00796B),
                  ],
                ),
              ),
              child: Column(
                children: [
                  Icon(
                    _contactData!.heroIconData,
                    size: isMobile ? 60 : (isTablet ? 70 : 80),
                    color: Colors.white,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    _contactData!.heroTitle,
                    style: TextStyle(
                      fontSize: isMobile ? 36 : (isTablet ? 40 : 48),
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    _contactData!.heroSubtitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: isMobile ? 16 : (isTablet ? 18 : 20),
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),

            // Contact Info & Form
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: isMobile ? 20 : (isTablet ? 40 : 60),
                vertical: 60,
              ),
              child: Column(
                children: [
                  // Contact Info Cards
                  Text(
                    _contactData!.contactInfoTitle,
                    style: TextStyle(
                      fontSize: isMobile ? 28 : (isTablet ? 32 : 36),
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF00897B),
                    ),
                  ),
                  const SizedBox(height: 40),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: isMobile ? 1 : (isTablet ? 2 : 3),
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20,
                      childAspectRatio: isMobile ? 1.2 : (isTablet ? 1.5 : 1.3),
                    ),
                    itemCount: 3,
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return _ContactInfoCard(
                          icon: Icons.location_on,
                          title: _contactData!.addressTitle,
                          content: _contactData!.addressContent,
                          onTap: () => _launchMaps(),
                        );
                      } else if (index == 1) {
                        return _ContactInfoCard(
                          icon: Icons.phone,
                          title: _contactData!.phoneTitle,
                          content: _contactData!.phoneContent,
                          onTap: () => _launchPhone(),
                        );
                      } else {
                        return _ContactInfoCard(
                          icon: Icons.email,
                          title: _contactData!.emailTitle,
                          content: _contactData!.emailContent,
                          onTap: () => _launchEmail(),
                        );
                      }
                    },
                  ),
                  const SizedBox(height: 60),

                  // Contact Form
                  Text(
                    _contactData!.formTitle,
                    style: TextStyle(
                      fontSize: isMobile ? 28 : (isTablet ? 32 : 36),
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF00897B),
                    ),
                  ),
                  const SizedBox(height: 30),
                  ContactForm(contactData: _contactData!),
                  const SizedBox(height: 60),

                  // Operating Hours
                  Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(30),
                      child: Column(
                        children: [
                          Icon(
                            Icons.access_time,
                            size: 50,
                            color: const Color(0xFF00897B),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            _contactData!.operatingHoursTitle,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF00897B),
                            ),
                          ),
                          const SizedBox(height: 20),
                          ..._contactData!.operatingHours.entries.map((entry) {
                            final isLast = entry.key == _contactData!.operatingHours.keys.last;
                            return Column(
                              children: [
                                _TimeRow(
                                  day: entry.key,
                                  time: entry.value,
                                  isHighlight: entry.key.toLowerCase().contains('emergency'),
                                ),
                                if (!isLast) const Divider(),
                              ],
                            );
                          }).toList(),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Map Section
                  Container(
                    height: 400,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Stack(
                        children: [
                          Container(
                            color: Colors.grey.shade300,
                          ),
                          Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.map,
                                  size: 80,
                                  color: Colors.grey.shade500,
                                ),
                                const SizedBox(height: 20),
                                Text(
                                  _contactData!.mapTitle,
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey.shade700,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 20),
                                  child: Text(
                                    _contactData!.addressContent,
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey.shade600,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                const SizedBox(height: 20),
                                ElevatedButton.icon(
                                  onPressed: () => _launchMaps(),
                                  icon: const Icon(Icons.directions),
                                  label: Text(_contactData!.mapButtonText),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF00897B),
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 30,
                                      vertical: 15,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Footer
            const Footer(),
          ],
        ),
      ),
    );
  }

  Future<void> _launchEmail() async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: _contactData?.emailContent ?? AppConstants.contactEmail,
    );
    if (await canLaunchUrl(emailLaunchUri)) {
      await launchUrl(emailLaunchUri);
    }
  }

  Future<void> _launchPhone() async {
    final Uri phoneLaunchUri = Uri(
      scheme: 'tel',
      path: _contactData?.phoneContent ?? AppConstants.contactPhone,
    );
    if (await canLaunchUrl(phoneLaunchUri)) {
      await launchUrl(phoneLaunchUri);
    }
  }

  Future<void> _launchMaps() async {
    String mapsUrl = _contactData?.mapsUrl ?? '';
    
    if (mapsUrl.isEmpty || !mapsUrl.contains('google.com/maps')) {
      // Fallback to search if URL is empty or invalid
      final address = _contactData?.addressContent ?? AppConstants.contactAddress;
      mapsUrl = 'https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(address)}';
    }
    
    final Uri mapsLaunchUri = Uri.parse(mapsUrl);
    if (await canLaunchUrl(mapsLaunchUri)) {
      await launchUrl(mapsLaunchUri);
    }
  }
}

class _NavButton extends StatelessWidget {
  final String label;
  final String route;
  final IconData icon;

  const _NavButton({
    required this.label,
    required this.route,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: () {
        if (route == '/') {
          Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
        } else {
          Navigator.pushNamed(context, route);
        }
      },
      icon: Icon(icon, size: 18, color: const Color(0xFF00897B)),
      label: Text(
        label,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          color: Color(0xFF37474F),
        ),
      ),
    );
  }
}

class _TimeRow extends StatelessWidget {
  final String day;
  final String time;
  final bool isHighlight;

  const _TimeRow({
    required this.day,
    required this.time,
    this.isHighlight = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            day,
            style: TextStyle(
              fontSize: 16,
              fontWeight: isHighlight ? FontWeight.bold : FontWeight.normal,
              color: isHighlight ? const Color(0xFF00897B) : Colors.grey[700],
            ),
          ),
          Text(
            time,
            style: TextStyle(
              fontSize: 16,
              fontWeight: isHighlight ? FontWeight.bold : FontWeight.w600,
              color: isHighlight ? const Color(0xFF00897B) : Colors.grey[800],
            ),
          ),
        ],
      ),
    );
  }
}

class _ContactInfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String content;
  final VoidCallback onTap;

  const _ContactInfoCard({
    required this.icon,
    required this.title,
    required this.content,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(15),
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 50,
                color: const Color(0xFF00897B),
              ),
              const SizedBox(height: 20),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF00897B),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                content,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ContactForm extends StatefulWidget {
  final ContactModel contactData;
  
  const ContactForm({
    super.key,
    required this.contactData,
  });

  @override
  State<ContactForm> createState() => _ContactFormState();
}

class _ContactFormState extends State<ContactForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _messageController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _sendMessage() async {
    if (_formKey.currentState!.validate()) {
      FocusScope.of(context).unfocus();
      
      setState(() {
        _isSubmitting = true;
      });
      
      try {
        final supabaseService = Provider.of<SupabaseService>(context, listen: false);
        
        // Simpan pesan ke database
        await supabaseService.submitContactMessage(
          name: _nameController.text.trim(),
          email: _emailController.text.trim(),
          message: _messageController.text.trim(),
        );
        
        if (!mounted) return;
        
        // Show success dialog
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(widget.contactData.formSuccessTitle),
            content: Text(widget.contactData.formSuccessMessage),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _nameController.clear();
                  _emailController.clear();
                  _messageController.clear();
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      } catch (e) {
        if (!mounted) return;
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal mengirim pesan: $e'),
            backgroundColor: Colors.red,
          ),
        );
      } finally {
        if (mounted) {
          setState(() {
            _isSubmitting = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: widget.contactData.formNameLabel,
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.person, color: Color(0xFF00897B)),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF00897B), width: 2),
                  ),
                  labelStyle: const TextStyle(color: Color(0xFF37474F)),
                ),
                textInputAction: TextInputAction.next,
                enabled: !_isSubmitting,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return AppConstants.requiredField;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: widget.contactData.formEmailLabel,
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.email, color: Color(0xFF00897B)),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF00897B), width: 2),
                  ),
                  labelStyle: const TextStyle(color: Color(0xFF37474F)),
                ),
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                enabled: !_isSubmitting,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return AppConstants.requiredField;
                  }
                  if (!value.contains('@')) {
                    return AppConstants.invalidEmail;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _messageController,
                decoration: InputDecoration(
                  labelText: widget.contactData.formMessageLabel,
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.message, color: Color(0xFF00897B)),
                  alignLabelWithHint: true,
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF00897B), width: 2),
                  ),
                  labelStyle: const TextStyle(color: Color(0xFF37474F)),
                ),
                maxLines: 5,
                textInputAction: TextInputAction.done,
                enabled: !_isSubmitting,
                onFieldSubmitted: (_) => _sendMessage(),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return AppConstants.requiredField;
                  }
                  if (value.trim().length < 10) {
                    return 'Pesan minimal 10 karakter';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isSubmitting ? null : _sendMessage,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00897B),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: _isSubmitting
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : Text(
                          widget.contactData.formButtonText,
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}