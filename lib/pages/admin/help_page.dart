// lib/pages/admin/help_page.dart
import 'package:flutter/material.dart';
import 'admin_layout.dart';

class HelpPage extends StatelessWidget {
  const HelpPage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768;

    return AdminLayout(
      pageTitle: 'Bantuan',
      useDrawerForMobile: false,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Card(
              elevation: 0,
              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              child: Padding(
                padding: EdgeInsets.all(isMobile ? 16 : 20),
                child: Row(
                  children: [
                    Icon(
                      Icons.help_outline,
                      size: isMobile ? 32 : 40,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Pusat Bantuan',
                            style: TextStyle(
                              fontSize: isMobile ? 20 : 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Panduan penggunaan Admin Panel',
                            style: TextStyle(
                              color: Colors.grey[700],
                              fontSize: isMobile ? 12 : 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Quick Actions
            const Text(
              'Aksi Cepat',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: isMobile ? 2 : 3,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: isMobile ? 1.3 : 1.5,
              children: [
                _buildQuickActionCard(
                  context,
                  icon: Icons.video_library,
                  title: 'Tutorial Video',
                  subtitle: 'Panduan video lengkap',
                  onTap: () {
                    _showInfoDialog(
                      context,
                      'Tutorial Video',
                      'Fitur tutorial video akan segera tersedia. Anda akan dapat mengakses panduan video lengkap tentang penggunaan admin panel.',
                    );
                  },
                ),
                _buildQuickActionCard(
                  context,
                  icon: Icons.article,
                  title: 'Dokumentasi',
                  subtitle: 'Baca dokumentasi',
                  onTap: () {
                    _showInfoDialog(
                      context,
                      'Dokumentasi',
                      'Dokumentasi lengkap sedang dalam pengembangan. Sementara waktu, Anda dapat menggunakan FAQ di bawah untuk panduan cepat.',
                    );
                  },
                ),
                _buildQuickActionCard(
                  context,
                  icon: Icons.contact_support,
                  title: 'Hubungi Support',
                  subtitle: 'Butuh bantuan?',
                  onTap: () {
                    _showContactSupportDialog(context);
                  },
                ),
              ],
            ),
            const SizedBox(height: 32),

            // FAQ Section
            const Text(
              'Pertanyaan Umum (FAQ)',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            _buildFAQSection(context),
            const SizedBox(height: 32),

            // Panduan Section
            const Text(
              'Panduan Fitur',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            _buildGuideSection(context),
            const SizedBox(height: 32),

            // Contact Info
            Card(
              child: Padding(
                padding: EdgeInsets.all(isMobile ? 16 : 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.contact_phone,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          'Butuh Bantuan Lebih Lanjut?',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildContactItem(
                      context,
                      icon: Icons.email,
                      label: 'Email',
                      value: 'support@kliniksehat.com',
                    ),
                    const SizedBox(height: 12),
                    _buildContactItem(
                      context,
                      icon: Icons.phone,
                      label: 'Telepon',
                      value: '+62 812-3456-7890',
                    ),
                    const SizedBox(height: 12),
                    _buildContactItem(
                      context,
                      icon: Icons.access_time,
                      label: 'Jam Operasional',
                      value: 'Senin - Jumat, 08:00 - 17:00 WIB',
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey[300]!),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 36,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFAQSection(BuildContext context) {
    final faqs = [
      {
        'question': 'Bagaimana cara mengubah konten homepage?',
        'answer':
            'Navigasi ke menu "Edit Homepage" di sidebar. Anda dapat mengubah judul, deskripsi, dan gambar hero section. Klik tombol "Simpan Perubahan" setelah selesai mengedit.',
      },
      {
        'question': 'Bagaimana cara menambah layanan baru?',
        'answer':
            'Buka menu "Kelola Layanan", kemudian klik tombol "+ Tambah Layanan Baru". Isi form dengan detail layanan dan klik simpan.',
      },
      {
        'question': 'Bagaimana cara melihat pesan dari pengunjung?',
        'answer':
            'Pesan dari form kontak dapat dilihat di menu "Pesan Masuk". Anda akan melihat notifikasi untuk pesan baru yang belum dibaca.',
      },
      {
        'question': 'Apakah perubahan langsung terlihat di website?',
        'answer':
            'Ya, semua perubahan yang disimpan akan langsung terlihat di website publik setelah Anda menekan tombol simpan.',
      },
      {
        'question': 'Bagaimana cara mengubah password?',
        'answer':
            'Buka menu "Pengaturan", lalu isi form "Ubah Password" dengan password lama dan password baru Anda. Pastikan password baru minimal 6 karakter.',
      },
      {
        'question': 'Bagaimana cara mengubah informasi kontak klinik?',
        'answer':
            'Buka menu "Edit Kontak", kemudian ubah alamat, nomor telepon, email, atau jam operasional sesuai kebutuhan. Jangan lupa klik simpan.',
      },
      {
        'question': 'Bagaimana cara menghapus layanan?',
        'answer':
            'Di halaman "Kelola Layanan", cari layanan yang ingin dihapus, lalu klik tombol hapus (ikon tempat sampah) di sebelah kanan. Konfirmasi penghapusan akan muncul.',
      },
      {
        'question': 'Apakah saya bisa mengupload gambar untuk layanan?',
        'answer':
            'Ya, saat menambah atau mengedit layanan, Anda dapat mengupload gambar dengan klik area upload atau drag & drop gambar ke area yang disediakan.',
      },
    ];

    return Column(
      children: faqs.map((faq) => _buildFAQItem(context, faq)).toList(),
    );
  }

  Widget _buildFAQItem(BuildContext context, Map<String, String> faq) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          title: Text(
            faq['question']!,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Text(
                faq['answer']!,
                style: TextStyle(
                  color: Colors.grey[700],
                  height: 1.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGuideSection(BuildContext context) {
    final guides = [
      {
        'icon': Icons.home,
        'title': 'Edit Homepage',
        'description': 'Cara mengedit dan mengatur tampilan halaman utama',
        'route': '/admin/edit-homepage',
      },
      {
        'icon': Icons.info,
        'title': 'Edit About',
        'description': 'Mengubah informasi tentang klinik',
        'route': '/admin/edit-about',
      },
      {
        'icon': Icons.medical_services,
        'title': 'Kelola Layanan',
        'description': 'Menambah, mengedit, dan menghapus layanan klinik',
        'route': '/admin/manage-services',
      },
      {
        'icon': Icons.contact_mail,
        'title': 'Edit Kontak',
        'description': 'Mengubah informasi kontak klinik',
        'route': '/admin/contact-edit',
      },
      {
        'icon': Icons.inbox,
        'title': 'Kelola Pesan',
        'description': 'Membaca dan merespon pesan dari pengunjung website',
        'route': '/admin/contact-messages',
      },
    ];

    return Column(
      children: guides
          .map((guide) => Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor:
                        Theme.of(context).colorScheme.primary.withOpacity(0.1),
                    child: Icon(
                      guide['icon'] as IconData,
                      color: Theme.of(context).colorScheme.primary,
                      size: 20,
                    ),
                  ),
                  title: Text(
                    guide['title'] as String,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text(
                    guide['description'] as String,
                    style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    Navigator.pushNamed(context, guide['route'] as String);
                  },
                ),
              ))
          .toList(),
    );
  }

  Widget _buildContactItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey[600]),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showContactSupportDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.contact_support, color: Colors.blue),
            SizedBox(width: 12),
            Text('Hubungi Support'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Pilih metode untuk menghubungi tim support kami:',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 16),
            _buildDialogContactItem(
              icon: Icons.email,
              iconColor: Colors.blue,
              title: 'Email',
              subtitle: 'support@kliniksehat.com',
              onTap: () {
                Navigator.pop(context);
                _showInfoDialog(
                  context,
                  'Email Support',
                  'Silakan kirim email Anda ke support@kliniksehat.com. Tim kami akan merespon dalam 1x24 jam.',
                );
              },
            ),
            const Divider(),
            _buildDialogContactItem(
              icon: Icons.phone,
              iconColor: Colors.green,
              title: 'WhatsApp',
              subtitle: '+62 812-3456-7890',
              onTap: () {
                Navigator.pop(context);
                _showInfoDialog(
                  context,
                  'WhatsApp Support',
                  'Hubungi kami melalui WhatsApp di nomor +62 812-3456-7890 untuk bantuan cepat.',
                );
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }

  Widget _buildDialogContactItem({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Icon(icon, color: iconColor, size: 24),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  void _showInfoDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}