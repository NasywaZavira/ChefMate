import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

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
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        children: [
          _SectionTitle('Akun'),
          _SettingsTile(
            icon: Icons.person_outline_rounded,
            title: 'Profil Saya',
            subtitle: 'Kelola nama, email, dan preferensi',
            onTap: () {},
          ),
          _SettingsTile(
            icon: Icons.lock_outline_rounded,
            title: 'Keamanan',
            subtitle: 'Atur kata sandi dan privasi',
            onTap: () {},
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
            value: true,
            activeColor: AppColors.orange,
            onChanged: (_) {},
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
            value: false,
            activeColor: AppColors.orange,
            onChanged: (_) {},
          ),
          const SizedBox(height: 18),
          _SectionTitle('Lainnya'),
          _SettingsTile(
            icon: Icons.help_outline_rounded,
            title: 'Bantuan',
            subtitle: 'Panduan penggunaan app',
            onTap: () {},
          ),
          _SettingsTile(
            icon: Icons.logout_rounded,
            title: 'Keluar',
            subtitle: 'Logout dari akun saat ini',
            onTap: () {},
          ),
        ],
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
