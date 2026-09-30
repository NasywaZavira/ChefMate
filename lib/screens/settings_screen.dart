import 'package:flutter/material.dart';

import '../state/app_state.dart';
import '../theme/app_theme.dart';
import 'landing_page.dart';
import 'profile_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  void _showInfoDialog(String title, String message) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.cream,
        title: Text(title),
        content: Text(message, style: const TextStyle(fontSize: 13, color: AppColors.ink)),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Tutup')),
        ],
      ),
    );
  }

  Future<void> _confirmLogout() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.cream,
        title: const Text('Keluar'),
        content: const Text('Yakin ingin keluar dari akun ini?',
            style: TextStyle(fontSize: 13, color: AppColors.ink)),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('Batal')),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Keluar', style: TextStyle(color: AppColors.red)),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const LandingPage()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        backgroundColor: AppColors.cream,
        foregroundColor: AppColors.ink,
        elevation: 0,
        title: const Text('Pengaturan'),
      ),
      body: AnimatedBuilder(
        animation: appState,
        builder: (context, _) => ListView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          children: [
            _SectionTitle('Akun'),
            _SettingsTile(
              icon: Icons.person_outline_rounded,
              title: 'Profil Saya',
              subtitle: 'Kelola nama, email, dan preferensi',
              onTap: () => Navigator.of(context)
                  .push(MaterialPageRoute(builder: (_) => const ProfileScreen())),
            ),
            _SettingsTile(
              icon: Icons.lock_outline_rounded,
              title: 'Keamanan',
              subtitle: 'Atur kata sandi dan privasi',
              onTap: () => _showInfoDialog(
                'Keamanan',
                'Pengaturan kata sandi dan privasi belum tersedia di versi ini.',
              ),
            ),
            const SizedBox(height: 18),
            _SectionTitle('Notifikasi'),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text(
                'Pengingat resep',
                style: TextStyle(fontSize: 14, color: AppColors.ink),
              ),
              subtitle: const Text(
                'Dapatkan reminder harian',
                style: TextStyle(fontSize: 12, color: AppColors.muted),
              ),
              value: appState.notifyReminder,
              activeThumbColor: AppColors.orange,
              onChanged: (v) => appState.setNotifyReminder(v),
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text(
                'Promo dan update',
                style: TextStyle(fontSize: 14, color: AppColors.ink),
              ),
              subtitle: const Text(
                'Info produk terbaru',
                style: TextStyle(fontSize: 12, color: AppColors.muted),
              ),
              value: appState.notifyPromo,
              activeThumbColor: AppColors.orange,
              onChanged: (v) => appState.setNotifyPromo(v),
            ),
            const SizedBox(height: 18),
            _SectionTitle('Lainnya'),
            _SettingsTile(
              icon: Icons.help_outline_rounded,
              title: 'Bantuan',
              subtitle: 'Panduan penggunaan app',
              onTap: () => _showInfoDialog(
                'Bantuan',
                'Jelajahi resep di Beranda, susun rencana makan di Kalender, '
                    'lalu kelola bahan yang perlu dibeli di Daftar Belanja. '
                    'Bingung soal bahan? Tanya ChefMate AI Assistant.',
              ),
            ),
            _SettingsTile(
              icon: Icons.logout_rounded,
              title: 'Keluar',
              subtitle: 'Logout dari akun saat ini',
              onTap: _confirmLogout,
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.2,
          color: AppColors.muted,
        ),
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.line),
      ),
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: const BoxDecoration(
            color: AppColors.orangeLight,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: AppColors.orange, size: 20),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.ink,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(fontSize: 12, color: AppColors.muted),
        ),
        trailing: const Icon(
          Icons.chevron_right_rounded,
          color: AppColors.muted,
        ),
        onTap: onTap,
      ),
    );
  }
}