import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../utils/constants.dart';

class Footer extends StatelessWidget {
  const Footer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF37474F), // Slate grey
            Color(0xFF263238), // Dark slate
          ],
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Main Footer Content
            LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth < 768) {
                  return _buildMobileFooter(context);
                } else {
                  return _buildDesktopFooter(context);
                }
              },
            ),
            
            const SizedBox(height: 30),
            Container(
              height: 1,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.transparent,
                    Colors.white.withOpacity(0.3),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            
            // Copyright - Dynamic
            Text(
              '© ${DateTime.now().year} ${AppConstants.clinicNamePrimary} ${AppConstants.clinicNameSecondary}. All rights reserved.',
              style: TextStyle(
                color: Colors.white.withOpacity(0.6),
                fontSize: 13,
                letterSpacing: 0.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 5),
            Text(
              AppConstants.clinicTagline,
              style: TextStyle(
                color: const Color(0xFF00897B).withOpacity(0.8),
                fontSize: 12,
                fontStyle: FontStyle.italic,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDesktopFooter(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Logo & Description
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Logo Container dengan gambar dari database atau assets
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF00897B).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color(0xFF00897B).withOpacity(0.3),
                    width: 1.5,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Logo Image - Dynamic
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: _buildLogo(56, 56),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppConstants.clinicNamePrimary,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                        Text(
                          AppConstants.clinicNameSecondary,
                          style: const TextStyle(
                            color: Color(0xFF00897B),
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Text(
                AppConstants.clinicDescription,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 14,
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 25),
              // Social Media - Dynamic
              Row(
                children: [
                  if (AppConstants.facebookUrl.isNotEmpty)
                    _SocialIcon(
                      icon: Icons.facebook,
                      onTap: () => _launchUrl(AppConstants.facebookUrl),
                    ),
                  if (AppConstants.facebookUrl.isNotEmpty)
                    const SizedBox(width: 12),
                  if (AppConstants.instagramUrl.isNotEmpty)
                    _SocialIcon(
                      icon: Icons.camera_alt,
                      onTap: () => _launchUrl(AppConstants.instagramUrl),
                    ),
                  if (AppConstants.instagramUrl.isNotEmpty)
                    const SizedBox(width: 12),
                  if (AppConstants.twitterUrl.isNotEmpty)
                    _SocialIcon(
                      icon: Icons.tag,
                      onTap: () => _launchUrl(AppConstants.twitterUrl),
                    ),
                  if (AppConstants.twitterUrl.isNotEmpty)
                    const SizedBox(width: 12),
                  _SocialIcon(
                    icon: Icons.mail_outline,
                    onTap: () => _launchEmail(),
                  ),
                  const SizedBox(width: 12),
                  _SocialIcon(
                    icon: Icons.phone_outlined,
                    onTap: () => _launchPhone(),
                  ),
                  const SizedBox(width: 12),
                  _SocialIcon(
                    icon: Icons.location_on_outlined,
                    onTap: () => _launchMaps(),
                  ),
                ],
              ),
            ],
          ),
        ),
        
        const SizedBox(width: 60),
        
        // Quick Links
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Container(
                    width: 4,
                    height: 24,
                    decoration: BoxDecoration(
                      color: const Color(0xFF00897B),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    'Tautan Cepat',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _FooterLink(text: 'Beranda', route: '/', icon: Icons.home_outlined),
              _FooterLink(text: 'Tentang Kami', route: '/about', icon: Icons.info_outline),
              _FooterLink(text: 'Layanan', route: '/services', icon: Icons.medical_services_outlined),
              _FooterLink(text: 'Kontak', route: '/contact', icon: Icons.contact_mail_outlined),
              const SizedBox(height: 10),
              Container(
                height: 1,
                width: 80,
                color: Colors.white.withOpacity(0.2),
              ),
              const SizedBox(height: 10),
              _FooterLink(text: 'Admin Login', route: '/admin/login', icon: Icons.admin_panel_settings_outlined),
            ],
          ),
        ),
        
        const SizedBox(width: 60),
        
        // Contact Info - Dynamic
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Container(
                    width: 4,
                    height: 24,
                    decoration: BoxDecoration(
                      color: const Color(0xFF00897B),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    'Hubungi Kami',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _ContactInfo(
                icon: Icons.location_on_outlined,
                text: AppConstants.contactAddress,
                onTap: () => _launchMaps(),
              ),
              const SizedBox(height: 15),
              _ContactInfo(
                icon: Icons.phone_outlined,
                text: AppConstants.contactPhone,
                onTap: () => _launchPhone(),
              ),
              const SizedBox(height: 15),
              _ContactInfo(
                icon: Icons.mail_outline,
                text: AppConstants.contactEmail,
                onTap: () => _launchEmail(),
              ),
              const SizedBox(height: 15),
              Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: const Color(0xFF00897B).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: const Color(0xFF00897B).withOpacity(0.3),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.access_time,
                          color: Color(0xFF00897B),
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Jam Operasional',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      AppConstants.operatingHours,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 4),
                    if (AppConstants.emergencyAvailable)
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFF5252).withOpacity(0.2),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text(
                              'Emergency 24 Jam',
                              style: TextStyle(
                                color: Color(0xFFFF5252),
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMobileFooter(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Logo & Description
        Center(
          child: Column(
            children: [
              // Logo Container dengan gambar dari database atau assets
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF00897B).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color(0xFF00897B).withOpacity(0.3),
                    width: 1.5,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Logo Image - Dynamic
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: _buildLogo(48, 48),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppConstants.clinicNamePrimary,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                        Text(
                          AppConstants.clinicNameSecondary,
                          style: const TextStyle(
                            color: Color(0xFF00897B),
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Text(
                AppConstants.clinicDescription,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 14,
                  height: 1.6,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 25),
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 12,
                runSpacing: 12,
                children: [
                  if (AppConstants.facebookUrl.isNotEmpty)
                    _SocialIcon(
                      icon: Icons.facebook,
                      onTap: () => _launchUrl(AppConstants.facebookUrl),
                    ),
                  if (AppConstants.instagramUrl.isNotEmpty)
                    _SocialIcon(
                      icon: Icons.camera_alt,
                      onTap: () => _launchUrl(AppConstants.instagramUrl),
                    ),
                  if (AppConstants.twitterUrl.isNotEmpty)
                    _SocialIcon(
                      icon: Icons.tag,
                      onTap: () => _launchUrl(AppConstants.twitterUrl),
                    ),
                  _SocialIcon(
                    icon: Icons.mail_outline,
                    onTap: () => _launchEmail(),
                  ),
                  _SocialIcon(
                    icon: Icons.phone_outlined,
                    onTap: () => _launchPhone(),
                  ),
                  _SocialIcon(
                    icon: Icons.location_on_outlined,
                    onTap: () => _launchMaps(),
                  ),
                ],
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 30),
        Container(
          height: 1,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.transparent,
                Colors.white.withOpacity(0.3),
                Colors.transparent,
              ],
            ),
          ),
        ),
        const SizedBox(height: 25),
        
        // Quick Links - Mobile
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 3,
                  height: 20,
                  decoration: BoxDecoration(
                    color: const Color(0xFF00897B),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: 8),
                const Text(
                  'Tautan Cepat',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            _FooterLink(text: 'Admin Login', route: '/admin/login', icon: Icons.admin_panel_settings_outlined),
          ],
        ),
        
        const SizedBox(height: 30),
        Container(
          height: 1,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.transparent,
                Colors.white.withOpacity(0.3),
                Colors.transparent,
              ],
            ),
          ),
        ),
        const SizedBox(height: 25),
        
        // Contact Info - Mobile - Dynamic
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 3,
                  height: 20,
                  decoration: BoxDecoration(
                    color: const Color(0xFF00897B),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: 8),
                const Text(
                  'Hubungi Kami',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            _ContactInfo(
              icon: Icons.location_on_outlined,
              text: AppConstants.contactAddress,
              onTap: () => _launchMaps(),
            ),
            const SizedBox(height: 12),
            _ContactInfo(
              icon: Icons.phone_outlined,
              text: AppConstants.contactPhone,
              onTap: () => _launchPhone(),
            ),
            const SizedBox(height: 12),
            _ContactInfo(
              icon: Icons.mail_outline,
              text: AppConstants.contactEmail,
              onTap: () => _launchEmail(),
            ),
            const SizedBox(height: 15),
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: const Color(0xFF00897B).withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: const Color(0xFF00897B).withOpacity(0.3),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.access_time,
                        color: Color(0xFF00897B),
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Jam Operasional',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    AppConstants.operatingHours,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 6),
                  if (AppConstants.emergencyAvailable)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFF5252).withOpacity(0.2),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        'Emergency 24 Jam',
                        style: TextStyle(
                          color: Color(0xFFFF5252),
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLogo(double width, double height) {
    if (AppConstants.logoUrl.isNotEmpty) {
      return Image.network(
        AppConstants.logoUrl,
        width: width,
        height: height,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return _buildFallbackLogo(width, height);
        },
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return _buildFallbackLogo(width, height);
        },
      );
    }
    return _buildFallbackLogo(width, height);
  }

  Widget _buildFallbackLogo(double width, double height) {
    return Image.asset(
      'assets/images/logo.jpeg',
      width: width,
      height: height,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: const Color(0xFF00897B),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Icon(
            Icons.local_hospital,
            color: Colors.white,
            size: width * 0.6,
          ),
        );
      },
    );
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  Future<void> _launchEmail() async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: AppConstants.contactEmail,
    );
    if (await canLaunchUrl(emailLaunchUri)) {
      await launchUrl(emailLaunchUri);
    }
  }

  Future<void> _launchPhone() async {
    final Uri phoneLaunchUri = Uri(
      scheme: 'tel',
      path: AppConstants.contactPhone,
    );
    if (await canLaunchUrl(phoneLaunchUri)) {
      await launchUrl(phoneLaunchUri);
    }
  }

  Future<void> _launchMaps() async {
    String mapsUrl;
    
    if (AppConstants.mapsUrl.isNotEmpty) {
      mapsUrl = AppConstants.mapsUrl;
    } else {
      mapsUrl = 'https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(AppConstants.contactAddress)}';
    }
    
    final Uri mapsLaunchUri = Uri.parse(mapsUrl);
    if (await canLaunchUrl(mapsLaunchUri)) {
      await launchUrl(mapsLaunchUri);
    }
  }
}

class _FooterLink extends StatelessWidget {
  final String text;
  final String route;
  final IconData icon;

  const _FooterLink({
    required this.text,
    required this.route,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, route);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Icon(
              icon,
              color: const Color(0xFF00897B),
              size: 16,
            ),
            const SizedBox(width: 10),
            Text(
              text,
              style: TextStyle(
                color: Colors.white.withOpacity(0.8),
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ContactInfo extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback? onTap;

  const _ContactInfo({
    required this.icon,
    required this.text,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: const Color(0xFF00897B).withOpacity(0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Icon(
                icon,
                color: const Color(0xFF00897B),
                size: 16,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 13,
                  height: 1.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SocialIcon extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _SocialIcon({
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: const Color(0xFF00897B).withOpacity(0.15),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: const Color(0xFF00897B).withOpacity(0.3),
            width: 1.5,
          ),
        ),
        child: Icon(
          icon,
          color: const Color(0xFF00897B),
          size: 20,
        ),
      ),
    );
  }
}