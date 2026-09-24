import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final preferences = ['Halal', 'Pedas sedang', 'Anggaran hemat', 'Masakan Nusantara'];

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      children: [
        Row(children: [
          Container(
            width: 56,
            height: 56,
            decoration: const BoxDecoration(color: AppColors.orangeLight, shape: BoxShape.circle),
            child: const Icon(Icons.person_rounded, color: AppColors.orange, size: 28),
          ),
          const SizedBox(width: 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Nasywa',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontSize: 18)),
              const SizedBox(height: 2),
              const Text('nasywa@email.com', style: TextStyle(fontSize: 12, color: AppColors.muted)),
            ],
          ),
        ]),
        const SizedBox(height: 24),
        const Text('Preferensi',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.ink)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: preferences
              .map((p) => Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration:
                        BoxDecoration(color: AppColors.greenLight, borderRadius: BorderRadius.circular(20)),
                    child: Text(p,
                        style: const TextStyle(
                            fontSize: 12, color: AppColors.green, fontWeight: FontWeight.w600)),
                  ))
              .toList(),
        ),
        const SizedBox(height: 24),
        const Text('Koleksi resep',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.ink)),
        const SizedBox(height: 8),
        const _CollectionRow(label: 'Resep praktis kerja', count: 6),
        const SizedBox(height: 8),
        const _CollectionRow(label: 'Resep date night', count: 3),
      ],
    );
  }
}

class _CollectionRow extends StatelessWidget {
  const _CollectionRow({required this.label, required this.count});

  final String label;
  final int count;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.line),
      ),
      child: Row(children: [
        const Icon(Icons.bookmark_rounded, size: 18, color: AppColors.orange),
        const SizedBox(width: 10),
        Expanded(child: Text(label, style: const TextStyle(fontSize: 13, color: AppColors.ink))),
        Text('$count resep', style: const TextStyle(fontSize: 12, color: AppColors.muted)),
      ]),
    );
  }
}
