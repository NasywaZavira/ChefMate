import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import 'main_shell.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _HeroIllustration(),
              const SizedBox(height: 32),
              Text(
                'Masak hari ini,\ntanpa bingung menunya',
                style: textTheme.displayLarge,
              ),
              const SizedBox(height: 12),
              Text(
                'Rencanakan meal plan mingguan, temukan resep sesuai bahan '
                'yang kamu punya, dan biarkan daftar belanja tersusun sendiri.',
                style: textTheme.bodyLarge?.copyWith(color: AppColors.muted),
              ),
              const Spacer(),
              const _FeatureRow(
                icon: Icons.calendar_month_rounded,
                label: 'Kalender meal plan mingguan',
              ),
              const SizedBox(height: 10),
              const _FeatureRow(
                icon: Icons.forum_rounded,
                label: 'Chatbot untuk substitusi bahan',
              ),
              const SizedBox(height: 10),
              const _FeatureRow(
                icon: Icons.shopping_bag_rounded,
                label: 'Daftar belanja otomatis',
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const MainShell()),
                  );
                },
                child: const Text('Mulai'),
              ),
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const MainShell()),
                  );
                },
                child: const Text('Sudah punya akun? Masuk'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HeroIllustration extends StatelessWidget {
  const _HeroIllustration();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.orangeLight,
        borderRadius: BorderRadius.circular(24),
      ),
      child: const Center(
        child: Icon(
          Icons.ramen_dining_rounded,
          size: 72,
          color: AppColors.orange,
        ),
      ),
    );
  }
}

class _FeatureRow extends StatelessWidget {
  const _FeatureRow({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: AppColors.greenLight,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 18, color: AppColors.green),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: Theme.of(context)
                .textTheme
                .bodyLarge
                ?.copyWith(color: AppColors.ink),
          ),
        ),
      ],
    );
  }
}