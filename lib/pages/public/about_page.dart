import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/supabase_service.dart';
import '../../widgets/footer.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  Widget _buildImage(String url, double height) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Image.network(
        url,
        height: height,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            height: height,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.image_not_supported, size: 50, color: Colors.grey[600]),
                const SizedBox(height: 10),
                Text(
                  'Gambar tidak dapat dimuat',
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
              ],
            ),
          );
        },
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            height: height,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                        loadingProgress.expectedTotalBytes!
                    : null,
                color: const Color(0xFF00897B),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768;

    return FutureBuilder<Map<String, dynamic>?>(
      future: Provider.of<SupabaseService>(context, listen: false).getAboutData(),
      builder: (context, snapshot) {
        final aboutData = snapshot.data;
        
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildLoadingScreen(context, isMobile);
        }

        // Extract all data with defaults
        final title = aboutData?['title'] ?? 'Tentang Kami';
        final subtitle = aboutData?['subtitle'] ?? 'Mengenal Lebih Dekat Klinik Sehat Bersama';
        final heroImage = aboutData?['hero_image'];
        
        final historyTitle = aboutData?['history_title'] ?? 'Sejarah Klinik';
        final historyImage = aboutData?['history_image'] ?? 'https://images.unsplash.com/photo-1582750433449-648ed127bb54';
        final historyContent1 = aboutData?['history_content_1'] ?? '';
        final historyContent2 = aboutData?['history_content_2'] ?? '';
        
        final missionTitle = aboutData?['mission_title'] ?? 'Misi Kami';
        final missionImage = aboutData?['mission_image'] ?? 'https://images.unsplash.com/photo-1579684385127-1ef15d508118';
        final missionContent = aboutData?['mission_content'] ?? '';
        final missionPoints = (aboutData?['mission_points'] as List<dynamic>?)?.cast<String>() ?? [];
        
        final visionTitle = aboutData?['vision_title'] ?? 'Visi Kami';
        final visionImage = aboutData?['vision_image'] ?? 'https://images.unsplash.com/photo-1559757148-5c350d0d3c56';
        final visionContent = aboutData?['vision_content'] ?? '';
        final visionPoints = (aboutData?['vision_points'] as List<dynamic>?)?.cast<String>() ?? [];
        
        final teamTitle = aboutData?['team_title'] ?? 'Tim Profesional Kami';
        final teamImage = aboutData?['team_image'] ?? 'https://images.unsplash.com/photo-1551601651-2a8555f1a136';
        final team = (aboutData?['team'] as List<dynamic>?) ?? [];

        return Scaffold(
          appBar: isMobile ? _buildMobileAppBar(context) : _buildDesktopAppBar(context),
          drawer: isMobile ? _buildMobileDrawer(context) : null,
          body: _buildAboutContent(
            context,
            isMobile,
            title: title,
            subtitle: subtitle,
            heroImage: heroImage,
            historyTitle: historyTitle,
            historyImage: historyImage,
            historyContent1: historyContent1,
            historyContent2: historyContent2,
            missionTitle: missionTitle,
            missionImage: missionImage,
            missionContent: missionContent,
            missionPoints: missionPoints,
            visionTitle: visionTitle,
            visionImage: visionImage,
            visionContent: visionContent,
            visionPoints: visionPoints,
            teamTitle: teamTitle,
            teamImage: teamImage,
            team: team,
          ),
        );
      },
    );
  }

  Widget _buildLoadingScreen(BuildContext context, bool isMobile) {
    return Scaffold(
      appBar: isMobile ? _buildMobileAppBar(context) : AppBar(
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
      ),
      drawer: isMobile ? _buildMobileDrawer(context) : null,
      body: const Center(child: CircularProgressIndicator()),
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

  Widget _buildAboutContent(
    BuildContext context,
    bool isMobile, {
    required String title,
    required String subtitle,
    String? heroImage,
    required String historyTitle,
    required String historyImage,
    required String historyContent1,
    required String historyContent2,
    required String missionTitle,
    required String missionImage,
    required String missionContent,
    required List<String> missionPoints,
    required String visionTitle,
    required String visionImage,
    required String visionContent,
    required List<String> visionPoints,
    required String teamTitle,
    required String teamImage,
    required List<dynamic> team,
  }) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Hero Section
          heroImage != null && heroImage.isNotEmpty
              ? Container(
                  height: isMobile ? 250 : 400,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.network(
                        heroImage,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return _buildDefaultHero(isMobile, title, subtitle);
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
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                title,
                                style: TextStyle(
                                  fontSize: isMobile ? 36 : 48,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 15),
                              Text(
                                subtitle,
                                style: TextStyle(
                                  fontSize: isMobile ? 16 : 20,
                                  color: Colors.white,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : _buildDefaultHero(isMobile, title, subtitle),

          // Main Content
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isMobile ? 20 : 40,
              vertical: 60,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // History Section
                Card(
                  elevation: 2,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.history,
                              color: Color(0xFF00897B),
                              size: 32,
                            ),
                            const SizedBox(width: 15),
                            Expanded(
                              child: Text(
                                historyTitle,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: isMobile ? 24 : 28,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF37474F),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        _buildImage(historyImage, 300),
                        const SizedBox(height: 25),
                        if (historyContent1.isNotEmpty)
                          Text(
                            historyContent1,
                            style: TextStyle(
                              fontSize: isMobile ? 15 : 16,
                              color: const Color(0xFF616161),
                              height: 1.6,
                            ),
                            textAlign: TextAlign.justify,
                          ),
                        if (historyContent1.isNotEmpty && historyContent2.isNotEmpty)
                          const SizedBox(height: 15),
                        if (historyContent2.isNotEmpty)
                          Text(
                            historyContent2,
                            style: TextStyle(
                              fontSize: isMobile ? 15 : 16,
                              color: const Color(0xFF616161),
                              height: 1.6,
                            ),
                            textAlign: TextAlign.justify,
                          ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 40),

                // Mission & Vision
                isMobile
                    ? Column(
                        children: [
                          _buildMissionCard(
                            isMobile,
                            missionTitle,
                            missionImage,
                            missionContent,
                            missionPoints,
                          ),
                          const SizedBox(height: 20),
                          _buildVisionCard(
                            isMobile,
                            visionTitle,
                            visionImage,
                            visionContent,
                            visionPoints,
                          ),
                        ],
                      )
                    : Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: _buildMissionCard(
                              isMobile,
                              missionTitle,
                              missionImage,
                              missionContent,
                              missionPoints,
                            ),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: _buildVisionCard(
                              isMobile,
                              visionTitle,
                              visionImage,
                              visionContent,
                              visionPoints,
                            ),
                          ),
                        ],
                      ),

                const SizedBox(height: 40),

                // Team Section
                Card(
                  elevation: 2,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.people,
                              color: Color(0xFF00897B),
                              size: 32,
                            ),
                            const SizedBox(width: 15),
                            Expanded(
                              child: Text(
                                teamTitle,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: isMobile ? 24 : 28,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF37474F),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        _buildImage(teamImage, 350),
                        const SizedBox(height: 30),
                        if (team.isNotEmpty)
                          isMobile
                              ? Column(
                                  children: team.map((member) {
                                    return Padding(
                                      padding: const EdgeInsets.only(bottom: 16),
                                      child: _buildTeamMemberMobile(member as Map<String, dynamic>),
                                    );
                                  }).toList(),
                                )
                              : GridView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: isMobile ? 2 : 3,
                                    crossAxisSpacing: 20,
                                    mainAxisSpacing: 20,
                                    childAspectRatio: isMobile ? 0.8 : 0.9,
                                  ),
                                  itemCount: team.length,
                                  itemBuilder: (context, index) {
                                    final member = team[index] as Map<String, dynamic>;
                                    return _buildTeamMemberCard(member);
                                  },
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
    );
  }

  Widget _buildDefaultHero(bool isMobile, String title, String subtitle) {
    return Container(
      height: isMobile ? 250 : 400,
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
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: isMobile ? 36 : 48,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 15),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: isMobile ? 16 : 20,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMissionCard(
    bool isMobile,
    String title,
    String image,
    String content,
    List<String> points,
  ) {
    return Card(
      elevation: 2,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.flag,
                  size: 32,
                  color: const Color(0xFF00897B),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: isMobile ? 22 : 24,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF37474F),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _buildImage(image, 200),
            const SizedBox(height: 20),
            if (content.isNotEmpty)
              Text(
                content,
                style: TextStyle(
                  fontSize: isMobile ? 14 : 15,
                  color: const Color(0xFF616161),
                  height: 1.6,
                ),
              ),
            if (points.isNotEmpty) ...[
              const SizedBox(height: 10),
              ...points.map((point) => _ListTileItem(text: point)).toList(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildVisionCard(
    bool isMobile,
    String title,
    String image,
    String content,
    List<String> points,
  ) {
    return Card(
      elevation: 2,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.visibility,
                  size: 32,
                  color: const Color(0xFF00897B),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: isMobile ? 22 : 24,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF37474F),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _buildImage(image, 200),
            const SizedBox(height: 20),
            if (content.isNotEmpty)
              Text(
                content,
                style: TextStyle(
                  fontSize: isMobile ? 14 : 15,
                  color: const Color(0xFF616161),
                  height: 1.6,
                ),
              ),
            if (points.isNotEmpty) ...[
              const SizedBox(height: 10),
              ...points.map((point) => _ListTileItem(text: point)).toList(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildTeamMemberCard(Map<String, dynamic> member) {
    final photoUrl = member['photo_url']?.toString();
    
    return Card(
      elevation: 2,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            photoUrl != null && photoUrl.isNotEmpty
                ? ClipOval(
                    child: Image.network(
                      photoUrl,
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return _buildDefaultAvatar();
                      },
                    ),
                  )
                : _buildDefaultAvatar(),
            const SizedBox(height: 10),
            Text(
              member['name']?.toString() ?? 'Nama tidak tersedia',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Color(0xFF37474F),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              member['position']?.toString() ?? 'Posisi tidak tersedia',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF616161),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              member['education']?.toString() ?? 'Pendidikan tidak tersedia',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 11,
                color: Color(0xFF757575),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTeamMemberMobile(Map<String, dynamic> member) {
    final photoUrl = member['photo_url']?.toString();

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            photoUrl != null && photoUrl.isNotEmpty
                ? ClipOval(
                    child: Image.network(
                      photoUrl,
                      width: 70,
                      height: 70,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => _buildDefaultAvatar(),
                    ),
                  )
                : _buildDefaultAvatar(),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    member['name']?.toString() ?? 'Nama tidak tersedia',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF37474F),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    member['position']?.toString() ?? 'Posisi tidak tersedia',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF616161),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    member['education']?.toString() ?? '',
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF757575),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDefaultAvatar() {
    return CircleAvatar(
      radius: 40,
      backgroundColor: const Color(0xFF00897B).withOpacity(0.1),
      child: Icon(
        Icons.person,
        size: 50,
        color: const Color(0xFF00897B),
      ),
    );
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

class _ListTileItem extends StatelessWidget {
  final String text;

  const _ListTileItem({
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.check_circle,
            color: const Color(0xFF00897B),
            size: 18,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 14,
                color: const Color(0xFF616161),
              ),
            ),
          ),
        ],
      ),
    );
  }
}