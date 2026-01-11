// lib/pages/admin/admin_mobile_navbar.dart
import 'package:flutter/material.dart';

class AdminMobileNavbar extends StatelessWidget {
  final String currentRoute;

  const AdminMobileNavbar({
    super.key,
    required this.currentRoute,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.white,
      selectedItemColor: Theme.of(context).colorScheme.primary,
      unselectedItemColor: Colors.grey[600],
      selectedFontSize: 11,
      unselectedFontSize: 10,
      currentIndex: _getCurrentIndex(currentRoute),
      onTap: (index) => _onItemTapped(context, index),
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.dashboard, size: 22),
          label: 'Dashboard',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.edit, size: 22),
          label: 'Konten',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.medical_services, size: 22),
          label: 'Layanan',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.inbox, size: 22),
          label: 'Pesan',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.more_horiz, size: 22),
          label: 'Lainnya',
        ),
      ],
    );
  }

  int _getCurrentIndex(String route) {
    switch (route) {
      case '/admin/dashboard':
        return 0;
      case '/admin/edit-homepage':
      case '/admin/edit-about':
      case '/admin/contact-edit':
        return 1;
      case '/admin/manage-services':
        return 2;
      case '/admin/contact-messages':
        return 3;
      case '/admin/settings':
      case '/admin/help':
        return 4;
      default:
        return 0;
    }
  }

  void _onItemTapped(BuildContext context, int index) {
    switch (index) {
      case 0:
        if (currentRoute != '/admin/dashboard') {
          Navigator.pushNamed(context, '/admin/dashboard');
        }
        break;
      case 1:
        // Tampilkan bottom sheet untuk pilihan konten
        _showContentOptions(context);
        break;
      case 2:
        if (currentRoute != '/admin/manage-services') {
          Navigator.pushNamed(context, '/admin/manage-services');
        }
        break;
      case 3:
        if (currentRoute != '/admin/contact-messages') {
          Navigator.pushNamed(context, '/admin/contact-messages');
        }
        break;
      case 4:
        // Tampilkan bottom sheet untuk menu lainnya
        _showMoreOptions(context);
        break;
    }
  }

  void _showContentOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Edit Konten Website',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Edit Homepage'),
              onTap: () {
                Navigator.pop(context);
                if (currentRoute != '/admin/edit-homepage') {
                  Navigator.pushNamed(context, '/admin/edit-homepage');
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.info),
              title: const Text('Edit About Page'),
              onTap: () {
                Navigator.pop(context);
                if (currentRoute != '/admin/edit-about') {
                  Navigator.pushNamed(context, '/admin/edit-about');
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.contact_mail),
              title: const Text('Edit Kontak'),
              onTap: () {
                Navigator.pop(context);
                if (currentRoute != '/admin/contact-edit') {
                  Navigator.pushNamed(context, '/admin/contact-edit');
                }
              },
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  void _showMoreOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Menu Lainnya',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.settings_applications),
              title: const Text('Website Settings'),
              onTap: () {
                Navigator.pop(context);
                if (currentRoute != '/admin/website-settings') {
                  Navigator.pushNamed(context, '/admin/website-settings');
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Pengaturan'),
              onTap: () {
                Navigator.pop(context);
                if (currentRoute != '/admin/settings') {
                  Navigator.pushNamed(context, '/admin/settings');
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.help),
              title: const Text('Bantuan'),
              onTap: () {
                Navigator.pop(context);
                if (currentRoute != '/admin/help') {
                  Navigator.pushNamed(context, '/admin/help');
                }
              },
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
