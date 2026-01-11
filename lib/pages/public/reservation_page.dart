import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../models/service_model.dart';
import '../../models/reservation_model.dart';
import '../../services/supabase_service.dart';
import '../../widgets/footer.dart';

class ReservationPage extends StatefulWidget {
  final Service? service;

  const ReservationPage({
    super.key,
    this.service,
  });

  @override
  State<ReservationPage> createState() => _ReservationPageState();
}

class _ReservationPageState extends State<ReservationPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _notesController = TextEditingController();

  DateTime? _selectedDate;
  String? _selectedTime;
  bool _isSubmitting = false;
  Service? _selectedService;
  List<Service> _availableServices = [];

  final List<String> _availableTimes = [
    '08:00', '09:00', '10:00', '11:00',
    '13:00', '14:00', '15:00', '16:00',
    '17:00', '18:00', '19:00',
  ];

  @override
  void initState() {
    super.initState();
    _loadServices();
    if (widget.service != null) {
      _selectedService = widget.service;
    }
  }

  Future<void> _loadServices() async {
    try {
      final supabaseService = Provider.of<SupabaseService>(context, listen: false);
      if (supabaseService.services.isEmpty) {
        await supabaseService.fetchServices();
      }
      setState(() {
        _availableServices = supabaseService.services;
        if (_selectedService == null && _availableServices.isNotEmpty) {
          _selectedService = _availableServices.first;
        }
      });
    } catch (e) {
      print('Error loading services: $e');
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 90)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF2E7D32),
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _submitReservation() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedService == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mohon pilih layanan'), backgroundColor: Colors.red),
      );
      return;
    }
    if (_selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mohon pilih tanggal'), backgroundColor: Colors.red),
      );
      return;
    }
    if (_selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mohon pilih waktu'), backgroundColor: Colors.red),
      );
      return;
    }

    setState(() => _isSubmitting = true);
    
    try {
      final reservation = Reservation(
        serviceId: _selectedService!.id,
        serviceName: _selectedService!.name,
        customerName: _nameController.text.trim(),
        customerEmail: _emailController.text.trim(),
        customerPhone: _phoneController.text.trim(),
        reservationDate: _selectedDate!,
        reservationTime: _selectedTime!,
        notes: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
        status: 'pending',
      );

      final supabaseService = Provider.of<SupabaseService>(context, listen: false);
      await supabaseService.createReservation(reservation);

      if (mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            title: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.green[600], size: 32),
                const SizedBox(width: 10),
                const Text('Reservasi Berhasil!'),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Reservasi Anda telah berhasil dibuat.', style: TextStyle(fontSize: 16)),
                const SizedBox(height: 15),
                Text('Layanan: ${_selectedService!.name}', style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 5),
                Text('Tanggal: ${DateFormat('dd MMMM yyyy', 'id_ID').format(_selectedDate!)}'),
                Text('Waktu: $_selectedTime'),
                const SizedBox(height: 15),
                const Text('Kami akan menghubungi Anda untuk konfirmasi.', style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic)),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
                child: const Text('OK', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal: $e'), backgroundColor: Colors.red, duration: const Duration(seconds: 4)),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

@override
Widget build(BuildContext context) {
  final screenWidth = MediaQuery.of(context).size.width;
  final isMobile = screenWidth < 768;

  // Jika masih loading data layanan
  if (_availableServices.isEmpty) {
    return Scaffold(
      appBar: isMobile 
        ? AppBar(
            backgroundColor: Colors.white,
            elevation: 2,
            title: Row(
              children: [
                Icon(
                  Icons.medical_services,
                  color: Theme.of(context).colorScheme.primary,
                  size: 28,
                ),
                const SizedBox(width: 8),
                const Text(
                  'Reservasi',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2E7D32),
                  ),
                ),
              ],
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),
          )
        : _buildDesktopAppBar(context),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 20),
            Text('Memuat data layanan...'),
          ],
        ),
      ),
    );
  }

  return Scaffold(
    appBar: isMobile 
      ? AppBar(
          backgroundColor: Colors.white,
          elevation: 2,
          title: Row(
            children: [
              Icon(
                Icons.medical_services,
                color: Theme.of(context).colorScheme.primary,
                size: 28,
              ),
              const SizedBox(width: 8),
              const Text(
                'Buat Reservasi',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2E7D32),
                ),
              ),
            ],
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
        )
      : _buildDesktopAppBar(context),
    body: _buildReservationContent(isMobile),
  );
}

  Widget _buildReservationContent(bool isMobile) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Hero Section with Service Image
          widget.service != null && widget.service!.imageUrl != null && widget.service!.imageUrl!.isNotEmpty
              ? Container(
                  height: isMobile ? 250 : 300,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      // Service Image Background
                      Image.network(
                        widget.service!.imageUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  const Color(0xFF2E7D32),
                                  const Color(0xFF43A047),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                      
                      // Gradient Overlay
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.black.withOpacity(0.4),
                              Colors.black.withOpacity(0.7),
                            ],
                          ),
                        ),
                      ),
                      
                      // Content
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Icon
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(15),
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.3),
                                    width: 2,
                                  ),
                                ),
                                child: Icon(
                                  widget.service!.iconData,
                                  size: isMobile ? 40 : 50,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 16),
                              
                              // Title
                              Text(
                                'Buat Reservasi',
                                style: TextStyle(
                                  fontSize: isMobile ? 24 : 32,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  shadows: [
                                    Shadow(
                                      offset: const Offset(0, 2),
                                      blurRadius: 4,
                                      color: Colors.black.withOpacity(0.5),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 8),
                              
                              // Service Name
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  widget.service!.name,
                                  style: TextStyle(
                                    fontSize: isMobile ? 18 : 22,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : Container(
                  // Default Hero tanpa gambar
                  padding: EdgeInsets.symmetric(
                    horizontal: isMobile ? 20 : 40,
                    vertical: 40,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        const Color(0xFF2E7D32),
                        const Color(0xFF43A047),
                      ],
                    ),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.calendar_month,
                        size: isMobile ? 60 : 80,
                        color: Colors.white,
                      ),
                      const SizedBox(height: 15),
                      Text(
                        widget.service != null 
                            ? 'Buat Reservasi ${widget.service!.name}' 
                            : 'Buat Reservasi',
                        style: TextStyle(
                          fontSize: isMobile ? 28 : 36,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        widget.service != null 
                            ? widget.service!.name 
                            : 'Pilih layanan di bawah',
                        style: TextStyle(
                          fontSize: isMobile ? 18 : 22,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),

          // Form Section
          Padding(
            padding: EdgeInsets.symmetric(horizontal: isMobile ? 20 : 60, vertical: 40),
            child: Card(
              elevation: 5,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              child: Padding(
                padding: EdgeInsets.all(isMobile ? 20 : 40),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Informasi Pribadi', style: TextStyle(fontSize: isMobile ? 20 : 24, fontWeight: FontWeight.bold, color: const Color(0xFF2E7D32))),
                      const SizedBox(height: 25),

                      // Pilih Layanan (jika tidak ada service spesifik)
                      if (widget.service == null) ...[
                        DropdownButtonFormField<Service>(
                          value: _selectedService,
                          decoration: InputDecoration(
                            labelText: 'Pilih Layanan *',
                            prefixIcon: const Icon(Icons.medical_services),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(color: Color(0xFF2E7D32), width: 2),
                            ),
                          ),
                          items: _availableServices.map((service) => DropdownMenuItem(value: service, child: Text(service.name))).toList(),
                          onChanged: (value) => setState(() => _selectedService = value),
                          validator: (value) => value == null ? 'Pilih layanan terlebih dahulu' : null,
                        ),
                        const SizedBox(height: 20),
                      ],

                      // Nama Lengkap
                      TextFormField(
                        controller: _nameController,
                        decoration: _inputDecoration('Nama Lengkap *', Icons.person),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) return 'Nama lengkap harus diisi';
                          if (value.trim().length < 3) return 'Nama minimal 3 karakter';
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),

                      // Email
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: _inputDecoration('Email *', Icons.email),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) return 'Email harus diisi';
                          final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                          if (!emailRegex.hasMatch(value.trim())) return 'Format email tidak valid';
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),

                      // Nomor Telepon
                      TextFormField(
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        decoration: _inputDecoration('Nomor Telepon *', Icons.phone, hintText: '08xxxxxxxxxx'),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) return 'Nomor telepon harus diisi';
                          if (value.trim().length < 10) return 'Nomor telepon minimal 10 digit';
                          return null;
                        },
                      ),
                      const SizedBox(height: 30),

                      Text('Jadwal Reservasi', style: TextStyle(fontSize: isMobile ? 20 : 24, fontWeight: FontWeight.bold, color: const Color(0xFF2E7D32))),
                      const SizedBox(height: 25),

                      // Tanggal
                      InkWell(
                        onTap: () => _selectDate(context),
                        child: InputDecorator(
                          decoration: _inputDecoration('Tanggal Reservasi *', Icons.calendar_today).copyWith(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                          ),
                          child: Text(
                            _selectedDate == null ? 'Pilih tanggal' : DateFormat('dd MMMM yyyy', 'id_ID').format(_selectedDate!),
                            style: TextStyle(color: _selectedDate == null ? Colors.grey[600] : Colors.black),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Waktu
                      DropdownButtonFormField<String>(
                        value: _selectedTime,
                        decoration: _inputDecoration('Waktu Reservasi *', Icons.access_time),
                        items: _availableTimes.map((time) => DropdownMenuItem(value: time, child: Text(time))).toList(),
                        onChanged: (value) => setState(() => _selectedTime = value),
                        validator: (value) => value == null ? 'Waktu reservasi harus dipilih' : null,
                      ),
                      const SizedBox(height: 30),

                      Text('Catatan Tambahan', style: TextStyle(fontSize: isMobile ? 20 : 24, fontWeight: FontWeight.bold, color: const Color(0xFF2E7D32))),
                      const SizedBox(height: 25),

                      TextFormField(
                        controller: _notesController,
                        maxLines: 4,
                        decoration: _inputDecoration('Catatan (Opsional)', Icons.note).copyWith(
                          hintText: 'Tambahkan catatan atau keluhan Anda...',
                          alignLabelWithHint: true,
                        ),
                      ),
                      const SizedBox(height: 40),

                      SizedBox(
                        width: double.infinity,
                        height: 55,
                        child: ElevatedButton(
                          onPressed: _isSubmitting ? null : _submitReservation,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF43A047),
                            foregroundColor: Colors.white,
                            elevation: 5,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            disabledBackgroundColor: Colors.grey[400],
                          ),
                          child: _isSubmitting
                              ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5))
                              : const Text('Kirim Reservasi', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        ),
                      ),
                      const SizedBox(height: 15),

                      SizedBox(
                        width: double.infinity,
                        child: TextButton(
                          onPressed: _isSubmitting ? null : () => Navigator.pop(context),
                          child: const Text('Batal', style: TextStyle(fontSize: 16)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Footer untuk SEMUA (desktop dan mobile)
          const Footer(),
        ],
      ),
    );
  }

  // Method untuk membuat AppBar desktop
  PreferredSizeWidget _buildDesktopAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 2,
      title: Row(
        children: [
          Icon(
            Icons.medical_services,
            color: Theme.of(context).colorScheme.primary,
            size: 32,
          ),
          const SizedBox(width: 10),
          const Text(
            'Klinik Sehat Bersama',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2E7D32),
            ),
          ),
        ],
      ),
      centerTitle: false,
      actions: [
        _NavButton(
          label: 'Home',
          route: '/',
          icon: Icons.home,
        ),
        _NavButton(
          label: 'Tentang Kami',
          route: '/about',
          icon: Icons.info,
        ),
        _NavButton(
          label: 'Layanan',
          route: '/services',
          icon: Icons.medical_services,
        ),
        _NavButton(
          label: 'Kontak',
          route: '/contact',
          icon: Icons.contact_mail,
        ),
        const SizedBox(width: 20),
      ],
    );
  }

  InputDecoration _inputDecoration(String label, IconData icon, {String? hintText}) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFF2E7D32), width: 2),
      ),
      hintText: hintText,
    );
  }
}

// Kelas untuk tombol navigasi di AppBar desktop
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
      icon: Icon(icon, size: 18, color: Theme.of(context).colorScheme.primary),
      label: Text(
        label,
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}