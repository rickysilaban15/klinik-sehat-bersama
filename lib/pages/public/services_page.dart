import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/supabase_service.dart';
import '../../widgets/loading_widget.dart';
import '../../widgets/footer.dart';
import 'services_detail.page.dart';

class ServicesPage extends StatefulWidget {
  const ServicesPage({super.key});

  @override
  State<ServicesPage> createState() => _ServicesPageState();
}

class _ServicesPageState extends State<ServicesPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadServices();
    });
  }

  Future<void> _loadServices() async {
    final supabaseService = Provider.of<SupabaseService>(context, listen: false);
    try {
      await supabaseService.fetchServices();
    } catch (e) {
      print('Error loading services: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final supabaseService = Provider.of<SupabaseService>(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768;
    final isTablet = screenWidth >= 768 && screenWidth < 1024;

    return Scaffold(
      appBar: isMobile ? _buildMobileAppBar(context) : _buildDesktopAppBar(context),
      drawer: isMobile ? _buildMobileDrawer(context) : null,
      body: _buildServicesContent(supabaseService, isMobile, isTablet, screenWidth),
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
              },
            ),
            _buildDrawerItem(
              context: context,
              icon: Icons.contact_mail,
              title: 'Kontak',
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/contact');
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

  Widget _buildServicesContent(SupabaseService service, bool isMobile, bool isTablet, double screenWidth) {
    if (service.isLoading) {
      return const LoadingWidget();
    }

    // Responsive padding
    final horizontalPadding = isMobile ? 20.0 : (isTablet ? 40.0 : 80.0);
    final verticalPadding = isMobile ? 50.0 : (isTablet ? 60.0 : 80.0);
    
    // Responsive font sizes
    final heroTitleSize = isMobile ? 32.0 : (isTablet ? 40.0 : 48.0);
    final heroSubtitleSize = isMobile ? 13.0 : (isTablet ? 16.0 : 20.0);
    final sectionTitleSize = isMobile ? 32.0 : (isTablet ? 36.0 : 42.0);
    final sectionSubtitleSize = isMobile ? 16.0 : 18.0;
    final badgeTextSize = isMobile ? 12.0 : 14.0;

    return SingleChildScrollView(
      child: Column(
        children: [
          // Hero Section
          SizedBox(
            height: isMobile ? 250 : (isTablet ? 320 : 400),
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.network(
                  'https://images.unsplash.com/photo-1584820927498-cfe5211fd8bf?ixlib=rb-4.0.3&auto=format&fit=crop&w=1600&q=80',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: const Color(0xFF37474F),
                    );
                  },
                ),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withOpacity(0.5),
                        Colors.black.withOpacity(0.7),
                      ],
                    ),
                  ),
                ),
                Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: EdgeInsets.all(isMobile ? 16 : (isTablet ? 18 : 20)),
                          decoration: BoxDecoration(
                            color: const Color(0xFF00897B).withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: const Color(0xFF00897B).withOpacity(0.5),
                              width: 2,
                            ),
                          ),
                          child: Icon(
                            Icons.medical_services,
                            size: isMobile ? 50 : (isTablet ? 60 : 70),
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'Layanan Kesehatan',
                          style: TextStyle(
                            fontSize: heroTitleSize,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 0.5,
                            shadows: [
                              Shadow(
                                offset: const Offset(0, 2),
                                blurRadius: 4,
                                color: Colors.black.withOpacity(0.3),
                              ),
                            ],
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 15),
                        Container(
                          constraints: BoxConstraints(maxWidth: screenWidth * 0.8),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Text(
                            'Berbagai layanan kesehatan untuk kebutuhan Anda',
                            style: TextStyle(
                              fontSize: heroSubtitleSize,
                              color: Colors.white,
                              letterSpacing: 0.3,
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Services List Section
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: horizontalPadding,
              vertical: verticalPadding,
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.white,
                  const Color(0xFFF5F5F5),
                ],
              ),
            ),
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 1400),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF00897B).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'LAYANAN KAMI',
                        style: TextStyle(
                          fontSize: badgeTextSize,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF00897B),
                          letterSpacing: 2,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Layanan Unggulan Kami',
                      style: TextStyle(
                        fontSize: sectionTitleSize,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF37474F),
                        letterSpacing: 0.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Kami menyediakan berbagai layanan kesehatan dengan standar tertinggi',
                      style: TextStyle(
                        fontSize: sectionSubtitleSize,
                        color: const Color(0xFF616161),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: isMobile ? 40 : 50),
                    
                    // Service Cards GridView
                    _buildServicesGrid(service, isMobile, isTablet, screenWidth),
                  ],
                ),
              ),
            ),
          ),

          // Facilities Section
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              horizontal: horizontalPadding,
              vertical: verticalPadding,
            ),
            color: Colors.white,
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 1400),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF00897B).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'FASILITAS',
                        style: TextStyle(
                          fontSize: badgeTextSize,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF00897B),
                          letterSpacing: 2,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Fasilitas Pendukung',
                      style: TextStyle(
                        fontSize: sectionTitleSize,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF37474F),
                        letterSpacing: 0.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: isMobile ? 40 : 50),
                    
                    // Facilities GridView
                    _buildFacilitiesGrid(isMobile, isTablet, screenWidth),
                  ],
                ),
              ),
            ),
          ),

          // Footer
          const Footer(),
        ],
      ),
    );
  }

  Widget _buildServicesGrid(SupabaseService service, bool isMobile, bool isTablet, double screenWidth) {
    final services = service.services;
    
    // Responsive grid configuration
    int crossAxisCount;
    double childAspectRatio;
    
    if (isMobile) {
      crossAxisCount = 1;
      childAspectRatio = 0.85;
    } else if (isTablet) {
      crossAxisCount = 2;
      childAspectRatio = 1.1;
    } else if (screenWidth < 1400) {
      crossAxisCount = 2;
      childAspectRatio = 1.3;
    } else {
      crossAxisCount = 3;
      childAspectRatio = 1.15;
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: isMobile ? 20 : 25,
        mainAxisSpacing: isMobile ? 20 : 25,
        childAspectRatio: childAspectRatio,
      ),
      itemCount: services.length,
      itemBuilder: (context, index) {
        final serviceItem = services[index];
        return _buildServiceCard(context, serviceItem, isMobile, isTablet);
      },
    );
  }

  Widget _buildFacilitiesGrid(bool isMobile, bool isTablet, double screenWidth) {
    // Responsive grid configuration
    int crossAxisCount;
    double childAspectRatio;
    
    if (isMobile) {
      crossAxisCount = 1;
      childAspectRatio = 4.0;
    } else if (isTablet) {
      crossAxisCount = 2;
      childAspectRatio = 3.0;
    } else {
      crossAxisCount = 3;
      childAspectRatio = 2.8;
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: isMobile ? 15 : 20,
        mainAxisSpacing: isMobile ? 15 : 20,
        childAspectRatio: childAspectRatio,
      ),
      itemCount: _facilities.length,
      itemBuilder: (context, index) {
        final facility = _facilities[index];
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: const Color(0xFF00897B).withOpacity(0.2),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF00897B).withOpacity(0.08),
                blurRadius: 15,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.all(isMobile ? 12 : (isTablet ? 16 : 20)),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(isMobile ? 8 : 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF00897B).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color(0xFF00897B).withOpacity(0.3),
                      width: 1.5,
                    ),
                  ),
                  child: Icon(
                    facility['icon'] as IconData,
                    size: isMobile ? 22 : (isTablet ? 28 : 32),
                    color: const Color(0xFF00897B),
                  ),
                ),
                SizedBox(width: isMobile ? 10 : 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        facility['title']!,
                        style: TextStyle(
                          fontSize: isMobile ? 14 : (isTablet ? 16 : 17),
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF37474F),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        facility['description']!,
                        style: TextStyle(
                          fontSize: isMobile ? 11 : (isTablet ? 13 : 14),
                          color: const Color(0xFF616161),
                          height: 1.4,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildServiceCard(BuildContext context, service, bool isMobile, bool isTablet) {
    final imageHeight = isMobile ? 180.0 : (isTablet ? 200.0 : 220.0);
    final iconSize = isMobile ? 20.0 : 24.0;
    final titleSize = isMobile ? 20.0 : (isTablet ? 21.0 : 22.0);
    final descriptionSize = isMobile ? 14.0 : 15.0;
    final buttonSize = isMobile ? 15.0 : 16.0;
    
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFF00897B).withOpacity(0.2),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF00897B).withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ServiceDetailPage(service: service),
            ),
          );
        },
        borderRadius: BorderRadius.circular(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Service Image
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              child: Stack(
                children: [
                  Image.network(
                    service.imageUrl != null && service.imageUrl!.isNotEmpty
                        ? service.imageUrl!
                        : 'https://images.unsplash.com/photo-1576091160399-112ba8d25d1d?w=800&q=80',
                    width: double.infinity,
                    height: imageHeight,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        width: double.infinity,
                        height: imageHeight,
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
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: double.infinity,
                        height: imageHeight,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              const Color(0xFF00897B).withOpacity(0.8),
                              const Color(0xFF00796B),
                            ],
                          ),
                        ),
                        child: Center(
                          child: Icon(
                            service.iconData,
                            size: 60,
                            color: Colors.white,
                          ),
                        ),
                      );
                    },
                  ),
                  // Icon badge di pojok kiri atas
                  Positioned(
                    top: 12,
                    left: 12,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Icon(
                        service.iconData,
                        size: iconSize,
                        color: const Color(0xFF00897B),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // Content
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(isMobile ? 16 : (isTablet ? 20 : 25)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      service.name,
                      style: TextStyle(
                        fontSize: titleSize,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF37474F),
                        letterSpacing: 0.3,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 12),
                    
                    // Description
                    Expanded(
                      child: Text(
                        service.description,
                        style: TextStyle(
                          fontSize: descriptionSize,
                          color: const Color(0xFF616161),
                          height: 1.6,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ServiceDetailPage(service: service),
                            ),
                          );
                        },
                        icon: const Icon(Icons.arrow_forward, size: 18),
                        label: Text(
                          'Selengkapnya',
                          style: TextStyle(
                            fontSize: buttonSize,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.3,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF00897B),
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(
                            vertical: isMobile ? 12 : 14,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  // Data fasilitas
  static final List<Map<String, dynamic>> _facilities = [
    {
      'title': 'Laboratorium Modern',
      'description': 'Pemeriksaan darah, urine, dan tes kesehatan lainnya dengan alat terkini',
      'icon': Icons.science_outlined,
    },
    {
      'title': 'Ruang Tunggu Nyaman',
      'description': 'Area tunggu yang luas dengan fasilitas lengkap dan nyaman',
      'icon': Icons.chair_outlined,
    },
    {
      'title': 'Apotek Lengkap',
      'description': 'Obat-obatan lengkap dengan apoteker berpengalaman',
      'icon': Icons.local_pharmacy_outlined,
    },
    {
      'title': 'Parkir Luas',
      'description': 'Area parkir yang luas dan aman untuk kendaraan pasien',
      'icon': Icons.local_parking_outlined,
    },
    {
      'title': 'WiFi Gratis',
      'description': 'Akses internet gratis selama menunggu konsultasi',
      'icon': Icons.wifi,
    },
    {
      'title': 'Musholla',
      'description': 'Tempat ibadah yang nyaman dan bersih',
      'icon': Icons.mosque_outlined,
    },
  ];
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