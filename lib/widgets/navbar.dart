import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/settings_notifier.dart';

class CustomNavBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomNavBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(70);

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsNotifier>(
      builder: (context, settings, child) {
        return AppBar(
          backgroundColor: Colors.white,
          elevation: 1,
          toolbarHeight: 70,
          title: Row(
            children: [
              // Logo
              if (settings.logoUrl.isNotEmpty)
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    settings.logoUrl,
                    height: 50,
                    width: 50,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          color: const Color(0xFF00897B).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Image.asset(
  'assets/images/logo.jpeg',
  fit: BoxFit.cover,
  errorBuilder: (context, error, stackTrace) {
    return Icon(
      Icons.local_hospital,
      color: Color(0xFF00897B),
      size: 30,
    );
  },
),
                      );
                    },
                  ),
                )
              else
                Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    color: const Color(0xFF00897B).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Image.asset(
  'assets/images/logo.jpeg',
  fit: BoxFit.cover,
  errorBuilder: (context, error, stackTrace) {
    return Icon(
      Icons.local_hospital,
      color: Color(0xFF00897B),
      size: 30,
    );
  },
),
                ),
              
              const SizedBox(width: 16),
              
              // Clinic Name
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      settings.clinicNamePrimary,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF00897B),
                      ),
                    ),
                    if (settings.clinicNameSecondary.isNotEmpty)
                      Text(
                        settings.clinicNameSecondary,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF37474F),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            _buildNavItem(context, 'Home', Icons.home, '/'),
            _buildNavItem(context, 'Tentang Kami', Icons.info_outline, '/about'),
            _buildNavItem(context, 'Layanan', Icons.medical_services_outlined, '/services'),
            _buildNavItem(context, 'Kontak', Icons.contact_page_outlined, '/contact'),
            const SizedBox(width: 16),
          ],
        );
      },
    );
  }

  Widget _buildNavItem(BuildContext context, String title, IconData icon, String route) {
    final isActive = ModalRoute.of(context)?.settings.name == route;
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: TextButton.icon(
        onPressed: () => Navigator.pushNamed(context, route),
        icon: Icon(
          icon,
          size: 20,
          color: isActive ? const Color(0xFF00897B) : const Color(0xFF37474F),
        ),
        label: Text(
          title,
          style: TextStyle(
            color: isActive ? const Color(0xFF00897B) : const Color(0xFF37474F),
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        ),
      ),
    );
  }
}