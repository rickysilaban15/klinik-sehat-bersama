// lib/pages/admin/admin_navbar.dart
import 'package:flutter/material.dart';

class AdminNavbar extends StatelessWidget {
  final String currentRoute;

  const AdminNavbar({
    super.key,
    required this.currentRoute,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      color: Colors.grey[50],
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.medical_services,
                          color: Theme.of(context).colorScheme.primary,
                          size: 32,
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          'Klinik Sehat',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2E7D32),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Admin Panel',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Menu Items
              _buildNavItem(
                context,
                icon: Icons.dashboard,
                label: 'Dashboard',
                route: '/admin/dashboard',
                isActive: currentRoute == '/admin/dashboard',
              ),
              _buildNavItem(
  context,
  icon: Icons.settings_applications,
  label: 'Website Settings',
  route: '/admin/website-settings',
  isActive: currentRoute == '/admin/website-settings',
),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.only(left: 16, bottom: 8),
                child: Text(
                  'KONTEN WEBSITE',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[600],
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              
              _buildNavItem(
                context,
                icon: Icons.home,
                label: 'Edit Homepage',
                route: '/admin/edit-homepage',
                isActive: currentRoute == '/admin/edit-homepage',
              ),
              _buildNavItem(
                context,
                icon: Icons.info,
                label: 'Edit About',
                route: '/admin/edit-about',
                isActive: currentRoute == '/admin/edit-about',
              ),
              _buildNavItem(
                context,
                icon: Icons.medical_services,
                label: 'Kelola Layanan',
                route: '/admin/manage-services',
                isActive: currentRoute == '/admin/manage-services',
              ),
              _buildNavItem(
                context,
                icon: Icons.contact_mail,
                label: 'Edit Kontak',
                route: '/admin/contact-edit',
                isActive: currentRoute == '/admin/contact-edit',
              ),
              
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.only(left: 16, bottom: 8),
                child: Text(
                  'PESAN & NOTIFIKASI',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[600],
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              
              _buildNavItem(
                context,
                icon: Icons.inbox,
                label: 'Pesan Masuk',
                route: '/admin/contact-messages',
                isActive: currentRoute == '/admin/contact-messages',
                showBadge: true, // Optional: untuk menampilkan badge unread
              ),
              
              const SizedBox(height: 24),
              const Divider(),
              const SizedBox(height: 8),
              _buildNavItem(
                context,
                icon: Icons.settings,
                label: 'Pengaturan',
                route: '/admin/settings',
                isActive: currentRoute == '/admin/settings',
              ),
              _buildNavItem(
                context,
                icon: Icons.help,
                label: 'Bantuan',
                route: '/admin/help',
                isActive: currentRoute == '/admin/help',
              ),
              const SizedBox(height: 20), // Extra padding di bawah
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String route,
    required bool isActive,
    bool showBadge = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: isActive
            ? Theme.of(context).colorScheme.primary.withOpacity(0.1)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        border: isActive
            ? Border.all(
                color: Theme.of(context).colorScheme.primary,
                width: 1,
              )
            : null,
      ),
      child: ListTile(
        leading: Stack(
          clipBehavior: Clip.none,
          children: [
            Icon(
              icon,
              color: isActive
                  ? Theme.of(context).colorScheme.primary
                  : Colors.grey[600],
            ),
            // Badge untuk notifikasi (optional)
            if (showBadge)
              Positioned(
                right: -8,
                top: -4,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 16,
                    minHeight: 16,
                  ),
                  child: const Text(
                    '',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
          ],
        ),
        title: Text(
          label,
          style: TextStyle(
            fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
            color: isActive
                ? Theme.of(context).colorScheme.primary
                : Colors.grey[700],
          ),
        ),
        onTap: () {
          if (!isActive) {
            Navigator.pushNamed(context, route);
          }
        },
        contentPadding: const EdgeInsets.symmetric(horizontal: 12),
        dense: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}