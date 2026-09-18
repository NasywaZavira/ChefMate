import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class ShoppingListScreen extends StatelessWidget {
  const ShoppingListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bought = [
      {'name': 'Ayam fillet', 'qty': '250 g'},
      {'name': 'Kunyit', 'qty': '2 ruas'},
    ];
    final unbought = [
      {'name': 'Daun jeruk', 'qty': '3 lembar'},
      {'name': 'Santan kental', 'qty': '200 ml'},
      {'name': 'Kentang', 'qty': '3 buah'},
    ];

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Daftar belanja',
                style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 22)),
            const Icon(Icons.ios_share_rounded, size: 20, color: AppColors.muted),
          ],
        ),
        const SizedBox(height: 16),
        Text('Belum dibeli (${unbought.length})',
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.ink)),
        const SizedBox(height: 8),
        ...unbought.map((i) => _ShoppingRow(name: i['name']!, qty: i['qty']!, checked: false)),
        const SizedBox(height: 16),
        Text('Sudah dibeli (${bought.length})',
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.muted)),
        const SizedBox(height: 8),
        ...bought.map((i) => _ShoppingRow(name: i['name']!, qty: i['qty']!, checked: true)),
      ],
    );
  }
}

class _ShoppingRow extends StatelessWidget {
  const _ShoppingRow({required this.name, required this.qty, required this.checked});

  final String name;
  final String qty;
  final bool checked;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.line),
      ),
      child: Row(children: [
        Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            color: checked ? AppColors.green : Colors.transparent,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: checked ? AppColors.green : AppColors.line, width: 1.4),
          ),
          child: checked ? const Icon(Icons.check_rounded, size: 14, color: Colors.white) : null,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            name,
            style: TextStyle(
              fontSize: 13,
              color: checked ? AppColors.muted : AppColors.ink,
              decoration: checked ? TextDecoration.lineThrough : null,
            ),
          ),
        ),
        Text(qty, style: const TextStyle(fontSize: 12, color: AppColors.muted)),
      ]),
    );
  }
}
