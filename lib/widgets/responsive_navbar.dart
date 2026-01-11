import 'package:flutter/material.dart';
import '../utils/responsive_helper.dart';
import '../utils/constants.dart';

class ResponsiveNavbar extends StatelessWidget implements PreferredSizeWidget {
  const ResponsiveNavbar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(70); // TAMBAHKAN INI

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);
    
    return isMobile 
        ? const MobileNavbar()
        : const DesktopNavbar();
  }
}

class MobileNavbar extends StatefulWidget {
  const MobileNavbar({super.key});


  @override
  State<MobileNavbar> createState() => _MobileNavbarState();
}

class _MobileNavbarState extends State<MobileNavbar> {
  int _selectedIndex = 0;

  final List<NavItem> _navItems = [
    NavItem(icon: Icons.home, label: 'Home', route: '/'),
    NavItem(icon: Icons.info, label: 'Tentang', route: '/about'),
    NavItem(icon: Icons.medical_services, label: 'Layanan', route: '/services'),
    NavItem(icon: Icons.contact_mail, label: 'Kontak', route: '/contact'),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if (_navItems[index].route == '/') {
      Navigator.pushNamedAndRemoveUntil(
        context, 
        '/', 
        (route) => false
      );
    } else {
      Navigator.pushNamed(
        context, 
        _navItems[index].route
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 2,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: const Color(0xFF00897B).withOpacity(0.3),
                width: 1,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: _buildLogo(40, 40),
            ),
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              AppConstants.clinicNamePrimary,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF37474F),
                height: 1.2,
              ),
            ),
            Text(
              AppConstants.clinicNameSecondary,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Color(0xFF00897B),
                height: 1,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.menu,
              color: Color(0xFF37474F),
            ),
            onPressed: () {
              _showMobileMenu(context);
            },
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF00897B),
        unselectedItemColor: const Color(0xFF616161),
        onTap: _onItemTapped,
        items: _navItems.map((item) {
          return BottomNavigationBarItem(
            icon: Icon(item.icon),
            label: item.label,
          );
        }).toList(),
      ),
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
    );
  }

  void _showMobileMenu(BuildContext context) {
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
            ..._navItems.map((item) => ListTile(
              leading: Icon(
                item.icon,
                color: const Color(0xFF00897B),
              ),
              title: Text(
                item.label,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                if (item.route == '/') {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/',
                    (route) => false,
                  );
                } else {
                  Navigator.pushNamed(context, item.route);
                }
              },
            )),
            const Divider(height: 30),
            ListTile(
              leading: const Icon(
                Icons.admin_panel_settings,
                color: Color(0xFF37474F),
              ),
              title: const Text(
                'Admin Login',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/admin/login');
              },
            ),
          ],
        ),
      ),
    );
  }
}

class DesktopNavbar extends StatelessWidget implements PreferredSizeWidget {
  const DesktopNavbar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(70);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 2,
      toolbarHeight: 70,
      title: Row(
        children: [
          // Logo dengan styling yang konsisten dengan footer
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: const Color(0xFF00897B).withOpacity(0.3),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF00897B).withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: _buildLogo(48, 48),
            ),
          ),
          const SizedBox(width: 12),
          // Brand Name - Dynamic
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                AppConstants.clinicNamePrimary,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF37474F),
                  height: 1.2,
                ),
              ),
              Text(
                AppConstants.clinicNameSecondary,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF00897B),
                  height: 1,
                ),
              ),
            ],
          ),
        ],
      ),
      centerTitle: false,
      actions: [
        _NavButton(
          label: 'Home',
          route: '/',
          icon: Icons.home_outlined,
        ),
        _NavButton(
          label: 'Tentang Kami',
          route: '/about',
          icon: Icons.info_outline,
        ),
        _NavButton(
          label: 'Layanan',
          route: '/services',
          icon: Icons.medical_services_outlined,
        ),
        _NavButton(
          label: 'Kontak',
          route: '/contact',
          icon: Icons.contact_mail_outlined,
        ),
        const SizedBox(width: 10),
        Container(
          margin: const EdgeInsets.symmetric(vertical: 15),
          child: VerticalDivider(
            color: Colors.grey[300],
            thickness: 1,
            width: 20,
          ),
        ),
        const SizedBox(width: 10),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 15),
          child: ElevatedButton.icon(
            onPressed: () {
              Navigator.pushNamed(context, '/admin/login');
            },
            icon: const Icon(Icons.admin_panel_settings_outlined, size: 18),
            label: const Text(
              'Admin',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF00897B),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              elevation: 0,
            ),
          ),
        ),
        const SizedBox(width: 20),
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
    );
  }
}

class _NavButton extends StatefulWidget {
  final String label;
  final String route;
  final IconData icon;

  const _NavButton({
    required this.label,
    required this.route,
    required this.icon,
  });

  @override
  State<_NavButton> createState() => _NavButtonState();
}

class _NavButtonState extends State<_NavButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: TextButton.icon(
        onPressed: () {
          if (widget.route == '/') {
            Navigator.pushNamedAndRemoveUntil(
              context,
              '/',
              (route) => false,
            );
          } else {
            Navigator.pushNamed(
              context,
              widget.route,
            );
          }
        },
        icon: Icon(
          widget.icon,
          size: 18,
          color: _isHovered ? const Color(0xFF00897B) : const Color(0xFF616161),
        ),
        label: Text(
          widget.label,
          style: TextStyle(
            fontSize: 15,
            fontWeight: _isHovered ? FontWeight.w600 : FontWeight.w500,
            color: _isHovered ? const Color(0xFF00897B) : const Color(0xFF37474F),
          ),
        ),
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          backgroundColor: _isHovered
              ? const Color(0xFF00897B).withOpacity(0.1)
              : Colors.transparent,
        ),
      ),
    );
  }
}

class NavItem {
  final IconData icon;
  final String label;
  final String route;

  NavItem({
    required this.icon,
    required this.label,
    required this.route,
  });
}