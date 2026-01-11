import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../services/auth_service.dart';
import 'admin_navbar.dart';
import 'admin_mobile_navbar.dart';

class AdminLayout extends StatefulWidget {
  final Widget child;
  final String pageTitle;
  final bool useDrawerForMobile;
  final bool showHeaderCard;

  const AdminLayout({
    super.key,
    required this.child,
    required this.pageTitle,
    this.useDrawerForMobile = true,
    this.showHeaderCard = false,
  });

  @override
  State<AdminLayout> createState() => _AdminLayoutState();
}

class _AdminLayoutState extends State<AdminLayout> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768;
    final authService = Provider.of<AuthService>(context);

    // Check authentication
    if (!authService.isLoggedIn) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushNamedAndRemoveUntil(
          context, 
          '/admin/login', 
          (route) => false
        );
      });
      return const Center(child: CircularProgressIndicator());
    }

    // Dapatkan user dari Supabase auth
    final currentUser = Supabase.instance.client.auth.currentUser;
    final userEmail = currentUser?.email ?? 'Administrator';

    if (isMobile) {
      if (widget.useDrawerForMobile) {
        return Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            title: Text(widget.pageTitle),
            leading: IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                _scaffoldKey.currentState?.openDrawer();
              },
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.logout),
                onPressed: () {
                  authService.logout();
                  Navigator.pushNamedAndRemoveUntil(
                    context, 
                    '/admin/login', 
                    (route) => false
                  );
                },
                tooltip: 'Logout',
              ),
            ],
          ),
          drawer: _buildMobileDrawer(context, userEmail),
          body: widget.child, // HAPUS SingleChildScrollView di sini
        );
      } else {
        // Layout dengan bottom navigation
        return Scaffold(
          appBar: AppBar(
            title: Text(widget.pageTitle),
            actions: [
              IconButton(
                icon: const Icon(Icons.logout),
                onPressed: () {
                  authService.logout();
                  Navigator.pushNamedAndRemoveUntil(
                    context, 
                    '/admin/login', 
                    (route) => false
                  );
                },
                tooltip: 'Logout',
              ),
            ],
          ),
          body: widget.child, // HAPUS Column dan SingleChildScrollView di sini
          bottomNavigationBar: AdminMobileNavbar(
            currentRoute: ModalRoute.of(context)?.settings.name ?? '',
          ),
        );
      }
    } else {
      // Desktop Layout (tetap sama)
      return Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              Icon(
                Icons.admin_panel_settings,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(width: 12),
              Text(
                'Admin Panel - ${widget.pageTitle}',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const Spacer(),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                    context, 
                    '/', 
                    (route) => false
                  );
                },
                icon: const Icon(Icons.home, size: 16),
                label: const Text('Kembali ke Website'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[200],
                  foregroundColor: Colors.grey[800],
                  elevation: 0,
                ),
              ),
              const SizedBox(width: 16),
              ElevatedButton.icon(
                onPressed: () {
                  authService.logout();
                  Navigator.pushNamedAndRemoveUntil(
                    context, 
                    '/admin/login', 
                    (route) => false
                  );
                },
                icon: const Icon(Icons.logout, size: 16),
                label: const Text('Logout'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.errorContainer,
                  foregroundColor: Theme.of(context).colorScheme.onErrorContainer,
                ),
              ),
            ],
          ),
          backgroundColor: Colors.white,
          elevation: 2,
        ),
        body: Row(
          children: [
            AdminNavbar(
              currentRoute: ModalRoute.of(context)?.settings.name ?? '',
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: widget.child,
              ),
            ),
          ],
        ),
      );
    }
  }
  
  Widget _buildMobileHeaderCard(BuildContext context) {
    IconData icon;
    String title;
    String subtitle;
    
    final route = ModalRoute.of(context)?.settings.name ?? '';
    
    switch (route) {
      case '/admin/settings':
        icon = Icons.settings;
        title = 'Pengaturan Akun';
        subtitle = 'Kelola preferensi dan keamanan akun Anda';
        break;
      case '/admin/help':
        icon = Icons.help_outline;
        title = 'Pusat Bantuan';
        subtitle = 'Panduan penggunaan Admin Panel';
        break;
      default:
        icon = Icons.dashboard;
        title = 'Admin Panel';
        subtitle = 'Kelola konten website';
    }

    return Card(
      margin: const EdgeInsets.all(16),
      elevation: 0,
      color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(
              icon,
              size: 32,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 12,
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

  Widget _buildMobileDrawer(BuildContext context, String userEmail) {
    final currentRoute = ModalRoute.of(context)?.settings.name ?? '';
    final screenHeight = MediaQuery.of(context).size.height;
    
    return Drawer(
      width: 280,
      child: Column(
        children: [
          // Header dengan SafeArea
          Container(
            height: screenHeight * 0.25,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Theme.of(context).colorScheme.primary,
                  Theme.of(context).colorScheme.secondary,
                ],
              ),
            ),
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 28,
                      child: Icon(
                        Icons.admin_panel_settings,
                        size: 32,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Admin Panel',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      userEmail,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white.withOpacity(0.9),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Klinik Sehat Bersama',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Menu Items dengan scroll
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 12),
              children: [
                _buildDrawerItem(
                  context,
                  icon: Icons.dashboard,
                  title: 'Dashboard',
                  route: '/admin/dashboard',
                  currentRoute: currentRoute,
                ),
                
                const Padding(
                  padding: EdgeInsets.fromLTRB(28, 12, 16, 8),
                  child: Text(
                    'KONTEN WEBSITE',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                
                _buildDrawerItem(
                  context,
                  icon: Icons.home,
                  title: 'Edit Homepage',
                  route: '/admin/edit-homepage',
                  currentRoute: currentRoute,
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.info,
                  title: 'Edit About',
                  route: '/admin/edit-about',
                  currentRoute: currentRoute,
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.medical_services,
                  title: 'Kelola Layanan',
                  route: '/admin/manage-services',
                  currentRoute: currentRoute,
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.contact_mail,
                  title: 'Edit Kontak',
                  route: '/admin/contact-edit',
                  currentRoute: currentRoute,
                ),
                
                const Padding(
                  padding: EdgeInsets.fromLTRB(28, 12, 16, 8),
                  child: Text(
                    'PESAN & NOTIFIKASI',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                
                _buildDrawerItem(
                  context,
                  icon: Icons.inbox,
                  title: 'Pesan Masuk',
                  route: '/admin/contact-messages',
                  currentRoute: currentRoute,
                ),
                
                const Divider(thickness: 1, height: 24, indent: 16, endIndent: 16),
                
                _buildDrawerItem(
                  context,
                  icon: Icons.settings,
                  title: 'Pengaturan',
                  route: '/admin/settings',
                  currentRoute: currentRoute,
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.help,
                  title: 'Bantuan',
                  route: '/admin/help',
                  currentRoute: currentRoute,
                ),
                
                _buildDrawerItem(
  context,
  icon: Icons.settings_applications,
  title: 'Website Settings',
  route: '/admin/website-settings',
  currentRoute: currentRoute,
),
                
                const Divider(thickness: 1, height: 24, indent: 16, endIndent: 16),
                
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: ListTile(
                    leading: Icon(
                      Icons.home,
                      size: 20,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    title: const Text(
                      'Kembali ke Website',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamedAndRemoveUntil(
                        context, 
                        '/', 
                        (route) => false
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: ListTile(
                    leading: Icon(
                      Icons.logout,
                      size: 20,
                      color: Theme.of(context).colorScheme.error,
                    ),
                    title: Text(
                      'Logout',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      Provider.of<AuthService>(context, listen: false).logout();
                      Navigator.pushNamedAndRemoveUntil(
                        context, 
                        '/admin/login', 
                        (route) => false
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String route,
    required String currentRoute,
  }) {
    final isActive = currentRoute == route;
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
      child: ListTile(
        dense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
        leading: Icon(
          icon,
          size: 20,
          color: isActive 
            ? Theme.of(context).colorScheme.primary 
            : Colors.grey[700],
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 13,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
            color: isActive 
              ? Theme.of(context).colorScheme.primary 
              : Colors.grey[700],
          ),
        ),
        tileColor: isActive 
          ? Theme.of(context).colorScheme.primary.withOpacity(0.1)
          : Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        onTap: () {
          Navigator.pop(context);
          if (currentRoute != route) {
            Navigator.pushNamed(context, route);
          }
        },
      ),
    );
  }
}