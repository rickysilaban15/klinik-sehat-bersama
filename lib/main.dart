import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'services/supabase_service.dart';
import 'services/auth_service.dart';
import 'providers/settings_notifier.dart';
import 'utils/constants.dart';
import 'models/service_model.dart';
import 'pages/public/home_page.dart';
import 'pages/public/about_page.dart';
import 'pages/public/services_page.dart';
import 'pages/public/contact_page.dart';
import 'pages/public/reservation_page.dart';
import 'pages/public/services_detail.page.dart';
import 'pages/admin/login_page.dart';
import 'pages/admin/dashboard_page.dart';
import 'pages/admin/homepage_edit_page.dart';
import 'pages/admin/about_edit_page.dart';
import 'pages/admin/services_management_page.dart';
import 'pages/admin/contact_edit_page.dart';
import 'pages/admin/contact_messages_page.dart';
import 'pages/admin/settings_page.dart';
import 'pages/admin/help_page.dart';
import 'pages/admin/website_settings_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    await Supabase.initialize(
      url: 'https://mckajdfpmqontanzxinx.supabase.co',
      anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im1ja2FqZGZwbXFvbnRhbnp4aW54Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3Njc5Mzc4NTAsImV4cCI6MjA4MzUxMzg1MH0.rF_w6xr_CT0kQQrbZ1JrHvETIckyDqGIuAayUTrHeJc',
    );
    
    print('✅ Supabase initialized successfully');
    
    runApp(const MyApp());
  } catch (e) {
    print('❌ Error initializing app: $e');
    runApp(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error, size: 50, color: Colors.red),
                const SizedBox(height: 20),
                Text('Error Initializing App: $e', textAlign: TextAlign.center),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SupabaseService()),
        ChangeNotifierProvider(create: (_) => AuthService()),
        ChangeNotifierProvider(create: (_) => SettingsNotifier()), // ✅ TAMBAH INI
      ],
      child: MaterialApp(
        title: 'Klinik Sehat Bersama',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF00897B),
            brightness: Brightness.light,
            primary: const Color(0xFF00897B),
            secondary: const Color(0xFF26A69A),
            tertiary: const Color(0xFF4DB6AC),
          ),
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => const MainWrapper(),
          '/about': (context) => const AboutPage(),
          '/contact': (context) => const ContactPage(),
          '/admin/login': (context) => const LoginPage(),
          '/admin/dashboard': (context) => const DashboardPage(),
          '/admin/edit-homepage': (context) => const HomepageEditPage(),
          '/admin/edit-about': (context) => const AboutEditPage(),
          '/admin/manage-services': (context) => const ServicesManagementPage(),
          '/admin/contact-edit': (context) => const ContactEditPage(),
          '/admin/contact-messages': (context) => const ContactMessagesPage(),
          '/admin/settings': (context) => const SettingsPage(),
          '/admin/help': (context) => const HelpPage(),
          '/admin/website-settings': (context) => const WebsiteSettingsPage(),
        },
        onGenerateRoute: (settings) {
          switch (settings.name) {
            case '/services':
              return MaterialPageRoute(builder: (context) => const ServicesPage());
            case '/service-detail':
              final args = settings.arguments;
              if (args != null && args is Service) {
                return MaterialPageRoute(
                  builder: (context) => ServiceDetailPage(service: args),
                );
              }
              return MaterialPageRoute(builder: (context) => const ServicesPage());
            case '/reservation':
              final args = settings.arguments;
              if (args != null && args is Service) {
                return MaterialPageRoute(
                  builder: (context) => ReservationPage(service: args),
                );
              }
              return MaterialPageRoute(builder: (context) => const ReservationPage());
            default:
              return MaterialPageRoute(
                builder: (context) => Scaffold(
                  appBar: AppBar(title: const Text('404')),
                  body: const Center(child: Text('Page not found')),
                ),
              );
          }
        },
      ),
    );
  }
}

class MainWrapper extends StatefulWidget {
  const MainWrapper({super.key});

  @override
  State<MainWrapper> createState() => _MainWrapperState();
}

class _MainWrapperState extends State<MainWrapper> {
  bool _isLoading = true;
  String _loadingMessage = 'Memuat aplikasi...';

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    try {
      final supabaseService = Provider.of<SupabaseService>(context, listen: false);
      final settingsNotifier = Provider.of<SettingsNotifier>(context, listen: false);
      
      // Load website settings
      setState(() => _loadingMessage = 'Memuat pengaturan website...');
      await settingsNotifier.loadSettings(supabaseService);
      
      // Load services
      setState(() => _loadingMessage = 'Memuat layanan...');
      await supabaseService.fetchServices();
      
      setState(() => _isLoading = false);
    } catch (e) {
      print('Error initializing app: $e');
      setState(() {
        _isLoading = false;
        _loadingMessage = 'Error loading app';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(color: Color(0xFF00897B)),
              const SizedBox(height: 20),
              Text(
                _loadingMessage,
                style: const TextStyle(fontSize: 16, color: Color(0xFF37474F)),
              ),
            ],
          ),
        ),
      );
    }
    
    return const HomePage();
  }
}

// ============ DESKTOP NAVBAR ============
class DesktopNavbar extends StatelessWidget implements PreferredSizeWidget {
  const DesktopNavbar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(70);

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsNotifier>(
      builder: (context, settings, child) {
        return AppBar(
          backgroundColor: Colors.white,
          elevation: 2,
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
                        child: const Icon(
                          Icons.local_hospital,
                          color: Color(0xFF00897B),
                          size: 30,
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
                  child: const Icon(
                    Icons.local_hospital,
                    color: Color(0xFF00897B),
                    size: 30,
                  ),
                ),
              
              const SizedBox(width: 16),
              
              // Clinic Name
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    settings.clinicNamePrimary,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF00897B),
                    ),
                  ),
                  if (settings.clinicNameSecondary.isNotEmpty)
                    Text(
                      settings.clinicNameSecondary,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF37474F),
                      ),
                    ),
                ],
              ),
            ],
          ),
          actions: [
            _NavButton(label: 'Home', route: '/', icon: Icons.home),
            _NavButton(label: 'Tentang Kami', route: '/about', icon: Icons.info),
            _NavButton(label: 'Layanan', route: '/services', icon: Icons.medical_services),
            _NavButton(label: 'Kontak', route: '/contact', icon: Icons.contact_mail),
            const SizedBox(width: 20),
          ],
        );
      },
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
          color: Color(0xFF00897B),
        ),
      ),
    );
  }
}

// ============ MOBILE WRAPPER ============
class MobileWrapper extends StatefulWidget {
  const MobileWrapper({super.key});

  @override
  State<MobileWrapper> createState() => _MobileWrapperState();
}

class _MobileWrapperState extends State<MobileWrapper> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const HomePage(),
    const AboutPage(),
    const ServicesPage(),
    const ContactPage(),
  ];

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsNotifier>(
      builder: (context, settings, child) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 2,
            title: Row(
              children: [
                // Logo
                if (settings.logoUrl.isNotEmpty)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: Image.network(
                      settings.logoUrl,
                      height: 35,
                      width: 35,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(
                          Icons.local_hospital,
                          color: Color(0xFF00897B),
                          size: 28,
                        );
                      },
                    ),
                  )
                else
                  const Icon(
                    Icons.local_hospital,
                    color: Color(0xFF00897B),
                    size: 28,
                  ),
                
                const SizedBox(width: 8),
                
                // Clinic Name
                Expanded(
                  child: Text(
                    settings.clinicNamePrimary,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF00897B),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.calendar_today, color: Color(0xFF00897B)),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ReservationPage()),
                  );
                },
              ),
            ],
          ),
          body: _pages[_selectedIndex],
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _selectedIndex,
            type: BottomNavigationBarType.fixed,
            onTap: _onItemTapped,
            backgroundColor: Colors.white,
            selectedItemColor: const Color(0xFF00897B),
            unselectedItemColor: Colors.grey,
            selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500),
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
              BottomNavigationBarItem(icon: Icon(Icons.info), label: 'Tentang'),
              BottomNavigationBarItem(icon: Icon(Icons.medical_services), label: 'Layanan'),
              BottomNavigationBarItem(icon: Icon(Icons.contact_mail), label: 'Kontak'),
            ],
          ),
          drawer: Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                DrawerHeader(
                  decoration: const BoxDecoration(color: Color(0xFF00897B)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      if (settings.logoUrl.isNotEmpty)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            settings.logoUrl,
                            height: 50,
                            width: 50,
                            fit: BoxFit.contain,
                            color: Colors.white,
                            colorBlendMode: BlendMode.modulate,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(
                                Icons.local_hospital,
                                size: 50,
                                color: Colors.white,
                              );
                            },
                          ),
                        )
                      else
                        const Icon(Icons.local_hospital, size: 50, color: Colors.white),
                      
                      const SizedBox(height: 10),
                      
                      Text(
                        '${settings.clinicNamePrimary} ${settings.clinicNameSecondary}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        settings.clinicTagline,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white.withOpacity(0.9),
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.home),
                  title: const Text('Home'),
                  onTap: () {
                    _onItemTapped(0);
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.info),
                  title: const Text('Tentang Kami'),
                  onTap: () {
                    _onItemTapped(1);
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.medical_services),
                  title: const Text('Layanan'),
                  onTap: () {
                    _onItemTapped(2);
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.contact_mail),
                  title: const Text('Kontak'),
                  onTap: () {
                    _onItemTapped(3);
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.calendar_today),
                  title: const Text('Reservasi'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const ReservationPage()),
                    );
                  },
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.admin_panel_settings),
                  title: const Text('Admin Panel'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/admin/login');
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}