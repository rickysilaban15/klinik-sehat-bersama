import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/supabase_service.dart';
import '../../widgets/loading_widget.dart';
import '../../widgets/footer.dart';
import 'dart:async';
import '../../widgets/responsive_navbar.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _servicesScrollController = ScrollController();
  final PageController _pageController = PageController();
  Timer? _autoScrollTimer;
  int _currentPage = 0;
  
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
      _startAutoScroll();
    });
  }

  @override
  void dispose() {
    _autoScrollTimer?.cancel();
    _servicesScrollController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _startAutoScroll() {
    _autoScrollTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (_pageController.hasClients) {
        final service = Provider.of<SupabaseService>(context, listen: false);
        if (service.services.isNotEmpty) {
          final nextPage = (_currentPage + 1) % service.services.length;
          _pageController.animateToPage(
            nextPage,
            duration: const Duration(milliseconds: 800),
            curve: Curves.easeInOut,
          );
        }
      }
    });
  }

  Future<void> _loadData() async {
    final service = Provider.of<SupabaseService>(context, listen: false);
    await service.fetchServices();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768;
    final isTablet = screenWidth >= 768 && screenWidth < 1024;

    return Scaffold(
      appBar: isMobile ? _buildMobileAppBar(context) : _buildDesktopAppBar(context),
      drawer: isMobile ? _buildMobileDrawer(context) : null,
      body: Consumer<SupabaseService>(
        builder: (context, service, child) {
          if (service.isLoading) {
            return const LoadingWidget();
          }
          return _buildHomeContent(context, isMobile, isTablet);
        },
      ),
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
          // LOGO IMAGE
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              'assets/images/logo.jpeg',
              width: 32,
              height: 32,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Icon(
                  Icons.medical_services,
                  color: const Color(0xFF00897B),
                  size: 28,
                );
              },
            ),
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
                  // LOGO IMAGE IN DRAWER
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset(
                        'assets/images/logo.jpeg',
                        width: 40,
                        height: 40,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(
                            Icons.local_hospital,
                            size: 40,
                            color: Colors.white,
                          );
                        },
                      ),
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
              icon: Icons.home,
              title: 'Home',
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
              },
            ),
            _buildDrawerItem(
              icon: Icons.info,
              title: 'Tentang Kami',
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/about');
              },
            ),
            _buildDrawerItem(
              icon: Icons.medical_services,
              title: 'Layanan',
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/services');
              },
            ),
            _buildDrawerItem(
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

  Widget _buildHomeContent(BuildContext context, bool isMobile, bool isTablet) {
    final service = Provider.of<SupabaseService>(context);
    final screenHeight = MediaQuery.of(context).size.height;

    return SingleChildScrollView(
      child: Column(
        children: [
          // Hero Section - FULLSCREEN untuk mobile
          Stack(
            children: [
              Container(
                height: isMobile ? screenHeight * 0.85 : (isTablet ? 550 : 600),
                width: double.infinity,
                child: _buildHeroImage(),
              ),
              Container(
                height: isMobile ? screenHeight * 0.85 : (isTablet ? 550 : 600),
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
              Container(
                height: isMobile ? screenHeight * 0.85 : (isTablet ? 550 : 600),
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: isMobile ? 20 : 40,
                    ),
                    child: FutureBuilder<Map<String, dynamic>?>(
                      future: Provider.of<SupabaseService>(context, listen: false).getHomepageData(),
                      builder: (context, snapshot) {
                        final homepageData = snapshot.data;
                        
                        final title = homepageData?['title'] ?? 'Klinik Sehat Bersama';
                        final subtitle = homepageData?['subtitle'] ?? 'Pelayanan Kesehatan Terbaik untuk Keluarga Anda';
                        
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // LOGO IN HERO SECTION
                            Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.3),
                                  width: 2,
                                ),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.asset(
                                  'assets/images/logo.jpeg',
                                  width: isMobile ? 60 : (isTablet ? 70 : 80),
                                  height: isMobile ? 60 : (isTablet ? 70 : 80),
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Icon(
                                      Icons.local_hospital,
                                      size: isMobile ? 60 : (isTablet ? 70 : 80),
                                      color: Colors.white,
                                    );
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(height: 30),
                            Text(
                              title,
                              style: TextStyle(
                                fontSize: isMobile ? 36 : (isTablet ? 44 : 52),
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
                            const SizedBox(height: 20),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Text(
                                subtitle,
                                style: TextStyle(
                                  fontSize: isMobile ? 16 : (isTablet ? 18 : 20),
                                  color: Colors.white,
                                  letterSpacing: 0.3,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            const SizedBox(height: 40),
                            ElevatedButton.icon(
                              onPressed: () {
                                Navigator.pushNamed(context, '/services');
                              },
                              icon: const Icon(Icons.arrow_forward, size: 20),
                              label: Text(
                                'Lihat Layanan Kami',
                                style: TextStyle(
                                  fontSize: isMobile ? 16 : 18,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.5,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF00897B),
                                foregroundColor: Colors.white,
                                padding: EdgeInsets.symmetric(
                                  horizontal: isMobile ? 30 : 40,
                                  vertical: isMobile ? 16 : 20,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                elevation: 8,
                                shadowColor: const Color(0xFF00897B).withOpacity(0.5),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),

          // Why Choose Us Section
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: isMobile ? 20 : (isTablet ? 40 : 80),
              vertical: isMobile ? 60 : 80,
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
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF00897B).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'KEUNGGULAN KAMI',
                    style: TextStyle(
                      fontSize: isMobile ? 12 : 14,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF00897B),
                      letterSpacing: 2,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Mengapa Memilih Kami?',
                  style: TextStyle(
                    fontSize: isMobile ? 32 : (isTablet ? 36 : 42),
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF37474F),
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 15),
                Text(
                  'Kami memberikan pelayanan terbaik dengan standar tertinggi',
                  style: TextStyle(
                    fontSize: isMobile ? 16 : 18,
                    color: const Color(0xFF616161),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 50),
                LayoutBuilder(
                  builder: (context, constraints) {
                    return FutureBuilder<Map<String, dynamic>?>(
                      future: Provider.of<SupabaseService>(context, listen: false).getHomepageData(),
                      builder: (context, snapshot) {
                        final homepageData = snapshot.data;
                        final features = homepageData?['features'] as List<dynamic>? ?? [
                          'Dokter Profesional',
                          'Fasilitas Modern',
                          'Pelayanan 24 Jam',
                          'BPJS dan Asuransi'
                        ];
                        
                        final featureData = features.map((feature) {
                          String title = feature.toString();
                          IconData icon = Icons.medical_services_outlined;
                          String description = 'Pelayanan terbaik untuk Anda';
                          
                          if (title.toLowerCase().contains('dokter')) {
                            icon = Icons.medical_services_outlined;
                            description = 'Tim dokter berpengalaman dan bersertifikasi dengan spesialisasi berbagai bidang kesehatan.';
                          } else if (title.toLowerCase().contains('fasilitas')) {
                            icon = Icons.health_and_safety_outlined;
                            description = 'Peralatan medis terkini dan ruangan yang nyaman untuk kenyamanan pasien.';
                          } else if (title.toLowerCase().contains('24 jam')) {
                            icon = Icons.access_time_filled;
                            description = 'Layanan emergency tersedia 24 jam untuk penanganan darurat kapan saja.';
                          } else if (title.toLowerCase().contains('bpjs') || title.toLowerCase().contains('asuransi')) {
                            icon = Icons.card_membership_outlined;
                            description = 'Melayani pembayaran dengan BPJS dan berbagai jenis asuransi kesehatan.';
                          }
                          
                          return {
                            'title': title,
                            'description': description,
                            'icon': icon,
                          };
                        }).toList();
                        
                        int crossAxisCount = isMobile ? 1 : (isTablet ? 2 : 4);
                        return GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: crossAxisCount,
                            crossAxisSpacing: 25,
                            mainAxisSpacing: 25,
                            childAspectRatio: isMobile ? 1.3 : (isTablet ? 1.1 : 1.0),
                          ),
                          itemCount: featureData.length,
                          itemBuilder: (context, index) {
                            final feature = featureData.elementAt(index);
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
                              child: Padding(
                                padding: EdgeInsets.all(isMobile ? 25 : 30),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(18),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF00897B).withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(15),
                                        border: Border.all(
                                          color: const Color(0xFF00897B).withOpacity(0.3),
                                          width: 2,
                                        ),
                                      ),
                                      child: Icon(
                                        feature['icon'] as IconData,
                                        size: isMobile ? 40 : 45,
                                        color: const Color(0xFF00897B),
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    Text(
                                      feature['title'] as String,
                                      style: TextStyle(
                                        fontSize: isMobile ? 18 : 20,
                                        fontWeight: FontWeight.bold,
                                        color: const Color(0xFF37474F),
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 12),
                                    Text(
                                      feature['description'] as String,
                                      style: TextStyle(
                                        fontSize: isMobile ? 13 : 14,
                                        color: const Color(0xFF616161),
                                        height: 1.6,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),

          // Spacer between sections
          Container(
            height: isMobile ? 60 : 80,
            color: const Color(0xFFF5F5F5),
          ),

          // Services Preview Section dengan PAGINATION
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: isMobile ? 20 : (isTablet ? 40 : 80),
              vertical: isMobile ? 60 : 80,
            ),
            color: Colors.white,
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
                      fontSize: isMobile ? 12 : 14,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF00897B),
                      letterSpacing: 2,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Layanan Unggulan',
                  style: TextStyle(
                    fontSize: isMobile ? 32 : (isTablet ? 36 : 42),
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF37474F),
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 15),
                Text(
                  'Berbagai layanan kesehatan komprehensif untuk kebutuhan Anda',
                  style: TextStyle(
                    fontSize: isMobile ? 16 : 18,
                    color: const Color(0xFF616161),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 50),
                service.services.isEmpty
                    ? Center(
                        child: Text(
                          'Belum ada layanan tersedia',
                          style: TextStyle(
                            fontSize: 16,
                            color: const Color(0xFF616161),
                          ),
                        ),
                      )
                    : Column(
                        children: [
                          SizedBox(
                            height: isMobile ? 380 : (isTablet ? 390 : 400),
                            child: PageView.builder(
                              controller: _pageController,
                              onPageChanged: (index) {
                                setState(() {
                                  _currentPage = index;
                                });
                              },
                              itemCount: service.services.length,
                              itemBuilder: (context, index) {
                                final serviceItem = service.services[index];
                                return Container(
                                  margin: EdgeInsets.symmetric(
                                    horizontal: isMobile ? 10 : 20,
                                  ),
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
                                  child: Padding(
                                    padding: EdgeInsets.all(isMobile ? 30 : 40),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: double.infinity,
                                          height: isMobile ? 120 : 150,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(12),
                                            image: serviceItem.imageUrl != null && serviceItem.imageUrl!.isNotEmpty
                                                ? DecorationImage(
                                                    image: NetworkImage(serviceItem.imageUrl!),
                                                    fit: BoxFit.cover,
                                                  )
                                                : null,
                                            color: serviceItem.imageUrl == null || serviceItem.imageUrl!.isEmpty
                                                ? const Color(0xFF00897B).withOpacity(0.1)
                                                : Colors.transparent,
                                          ),
                                          child: serviceItem.imageUrl == null || serviceItem.imageUrl!.isEmpty
                                              ? Center(
                                                  child: Icon(
                                                    serviceItem.iconData,
                                                    size: isMobile ? 45 : 50,
                                                    color: const Color(0xFF00897B),
                                                  ),
                                                )
                                              : null,
                                        ),
                                        const SizedBox(height: 25),
                                        Text(
                                          serviceItem.name,
                                          style: TextStyle(
                                            fontSize: isMobile ? 22 : 26,
                                            fontWeight: FontWeight.bold,
                                            color: const Color(0xFF37474F),
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 15),
                                        Expanded(
                                          child: Text(
                                            serviceItem.description,
                                            style: TextStyle(
                                              fontSize: isMobile ? 15 : 16,
                                              color: const Color(0xFF616161),
                                              height: 1.6,
                                            ),
                                            maxLines: 4,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        const SizedBox(height: 25),
                                        SizedBox(
                                          width: double.infinity,
                                          child: ElevatedButton.icon(
                                            onPressed: () {
                                              Navigator.pushNamed(
                                                context,
                                                '/service-detail',
                                                arguments: serviceItem,
                                              );
                                            },
                                            icon: const Icon(Icons.arrow_forward, size: 20),
                                            label: Text(
                                              'Selengkapnya',
                                              style: TextStyle(
                                                fontSize: isMobile ? 15 : 16,
                                              ),
                                            ),
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: const Color(0xFF00897B),
                                              foregroundColor: Colors.white,
                                              padding: EdgeInsets.symmetric(
                                                vertical: isMobile ? 16 : 18,
                                              ),
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(12),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 30),
                          // Pagination dots
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(
                              service.services.length,
                              (index) => AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                margin: const EdgeInsets.symmetric(horizontal: 4),
                                width: _currentPage == index ? 30 : 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  color: _currentPage == index
                                      ? const Color(0xFF00897B)
                                      : const Color(0xFF00897B).withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
              ],
            ),
          ),

          // Spacer between sections
          Container(
            height: isMobile ? 60 : 80,
            color: Colors.white,
          ),

          // Testimonial Section
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: isMobile ? 20 : (isTablet ? 40 : 80),
              vertical: isMobile ? 60 : 80,
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  const Color(0xFFF5F5F5),
                  Colors.white,
                ],
              ),
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF00897B).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'TESTIMONI',
                    style: TextStyle(
                      fontSize: isMobile ? 12 : 14,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF00897B),
                      letterSpacing: 2,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Apa Kata Pasien Kami',
                  style: TextStyle(
                    fontSize: isMobile ? 32 : (isTablet ? 36 : 42),
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF37474F),
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 50),
                LayoutBuilder(
                  builder: (context, constraints) {
                    int crossAxisCount = isMobile ? 1 : (isTablet ? 2 : 3);
                    return GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        crossAxisSpacing: 25,
                        mainAxisSpacing: 25,
                        childAspectRatio: isMobile ? 1.1 : (isTablet ? 1.2 : 1.4),
                      ),
                      itemCount: _testimonials.length,
                      itemBuilder: (context, index) {
                        final testimonial = _testimonials[index];
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
                          child: Padding(
                            padding: EdgeInsets.all(isMobile ? 25 : 28),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF00897B).withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(50),
                                        border: Border.all(
                                          color: const Color(0xFF00897B).withOpacity(0.3),
                                          width: 2,
                                        ),
                                      ),
                                      child: CircleAvatar(
                                        backgroundColor: Colors.transparent,
                                        radius: isMobile ? 22 : 26,
                                        child: Text(
                                          testimonial['name']![0],
                                          style: TextStyle(
                                            color: const Color(0xFF00897B),
                                            fontSize: isMobile ? 20 : 24,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 15),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            testimonial['name']!,
                                            style: TextStyle(
                                              fontSize: isMobile ? 16 : 17,
                                              fontWeight: FontWeight.bold,
                                              color: const Color(0xFF37474F),
                                            ),
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            testimonial['role']!,
                                            style: TextStyle(
                                              fontSize: isMobile ? 13 : 14,
                                              color: const Color(0xFF00897B),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Icon(
                                      Icons.format_quote,
                                      size: 30,
                                      color: const Color(0xFF00897B).withOpacity(0.3),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 20),
                                Expanded(
                                  child: Text(
                                    testimonial['text']!,
                                    style: TextStyle(
                                      fontSize: isMobile ? 14 : 15,
                                      color: const Color(0xFF616161),
                                      height: 1.6,
                                    ),
                                    maxLines: 5,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const SizedBox(height: 15),
                                Row(
                                  children: List.generate(5, (index) {
                                    return Icon(
                                      Icons.star,
                                      size: 16,
                                      color: const Color(0xFFFFC107),
                                    );
                                  }),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),

          // Spacer before CTA Section
          Container(
            height: isMobile ? 60 : 80,
            color: Colors.white,
          ),

          // CTA Section
          Container(
            width: double.infinity,
            margin: EdgeInsets.symmetric(
              horizontal: isMobile ? 20 : 40,
            ),
            padding: EdgeInsets.symmetric(
              vertical: isMobile ? 50 : 70,
              horizontal: isMobile ? 25 : 60,
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  const Color(0xFF37474F),
                  const Color(0xFF546E7A),
                ],
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF37474F).withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // LOGO IN CTA SECTION
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.3),
                      width: 2,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      'assets/images/logo.jpeg',
                      width: isMobile ? 50 : 60,
                      height: isMobile ? 50 : 60,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(
                          Icons.local_hospital,
                          size: isMobile ? 50 : 60,
                          color: Colors.white,
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                Text(
                  'Siap Melayani Kesehatan Anda',
                  style: TextStyle(
                    fontSize: isMobile ? 28 : (isTablet ? 36 : 42),
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 0.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 15),
                Text(
                  'Jadwalkan konsultasi dengan dokter kami sekarang juga',
                  style: TextStyle(
                    fontSize: isMobile ? 16 : 18,
                    color: Colors.white.withOpacity(0.9),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
                Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 20,
                  runSpacing: 15,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pushNamed(context, '/contact');
                      },
                      icon: const Icon(Icons.phone, size: 20),
                      label: Text(
                        'Hubungi Kami',
                        style: TextStyle(
                          fontSize: isMobile ? 15 : 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF00897B),
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(
                          horizontal: isMobile ? 30 : 40,
                          vertical: 18,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 8,
                        shadowColor: const Color(0xFF00897B).withOpacity(0.5),
                      ),
                    ),
                    OutlinedButton.icon(
                      onPressed: () {
                        Navigator.pushNamed(context, '/services');
                      },
                      icon: const Icon(Icons.arrow_forward, size: 20),
                      label: Text(
                        'Lihat Layanan',
                        style: TextStyle(
                          fontSize: isMobile ? 15 : 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.white, width: 2),
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(
                          horizontal: isMobile ? 30 : 40,
                          vertical: 18,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Spacer after CTA Section
          Container(
            height: isMobile ? 60 : 80,
            color: Colors.white,
          ),

          // Footer
          const Footer(),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildDesktopAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 2,
      title: Row(
        children: [
          // LOGO IMAGE IN DESKTOP
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              'assets/images/logo.jpeg',
              width: 36,
              height: 36,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Icon(
                  Icons.medical_services,
                  color: const Color(0xFF00897B),
                  size: 32,
                );
              },
            ),
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

  Widget _buildHeroImage() {
    return FutureBuilder<Map<String, dynamic>?>(
      future: Provider.of<SupabaseService>(context, listen: false).getHomepageData(),
      builder: (context, snapshot) {
        final homepageData = snapshot.data;
        final heroImage = homepageData?['hero_image'] ?? 'https://images.unsplash.com/photo-1519494026892-80bbd2d6fd0d';

        return Image.network(
          heroImage,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    const Color(0xFF37474F).withOpacity(0.8),
                    const Color(0xFF546E7A).withOpacity(0.9),
                  ],
                ),
              ),
            );
          },
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) {
              return ColorFiltered(
                colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.3),
                  BlendMode.darken,
                ),
                child: child,
              );
            }
            return Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    const Color(0xFF37474F).withOpacity(0.8),
                    const Color(0xFF546E7A).withOpacity(0.9),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  final List<Map<String, String>> _testimonials = [
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