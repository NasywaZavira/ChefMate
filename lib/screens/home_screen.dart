import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import 'chatbot_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const mealTypes = [
      {'label': 'Sarapan', 'icon': Icons.egg_alt_rounded},
      {'label': 'Makan Siang', 'icon': Icons.ramen_dining_rounded},
      {'label': 'Makan Malam', 'icon': Icons.dinner_dining_rounded},
      {'label': 'Camilan', 'icon': Icons.icecream_rounded},
    ];

    const categories = ['Semua', 'Cepat dan Mudah', 'Vegan', 'Tanpa Gluten'];

    const recipes = [
      {'title': 'Nasi Goreng Spesial', 'subtitle': '20 menit \u00b7 Mudah'},
      {'title': 'Ayam Teriyaki', 'subtitle': '35 menit \u00b7 Sedang'},
      {'title': 'Sushi Roll', 'subtitle': '45 menit \u00b7 Sedang'},
      {'title': 'Tumis Kangkung', 'subtitle': '15 menit \u00b7 Mudah'},
    ];

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      children: [
        Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: const BoxDecoration(color: AppColors.orangeLight, shape: BoxShape.circle),
              // TODO: ganti dengan foto profil pengguna, mis. Image.asset('assets/avatar.jpg')
              child: const Icon(Icons.person_rounded, color: AppColors.orange, size: 26),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Hallo,',
                    style: TextStyle(fontSize: 13, color: AppColors.orange, fontWeight: FontWeight.w600)),
                Text('Jane Doe',
                    style: Theme.of(context)
                        .textTheme
                        .headlineMedium
                        ?.copyWith(fontSize: 17, color: AppColors.orange)),
              ],
            ),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          height: 46,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(color: AppColors.orangeLight, borderRadius: BorderRadius.circular(14)),
          child: const Row(children: [
            Icon(Icons.search_rounded, size: 18, color: AppColors.orange),
            SizedBox(width: 8),
            Text('Cari resep, bahan, atau makanan',
                style: TextStyle(fontSize: 12.5, color: AppColors.muted)),
          ]),
        ),
        const SizedBox(height: 22),
        Text('Rencana Menu Hari Ini',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontSize: 16, color: AppColors.orange)),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: mealTypes
              .map((m) => _MealTypeAvatar(label: m['label'] as String, icon: m['icon'] as IconData))
              .toList(),
        ),
        const SizedBox(height: 18),
        _AssistantBanner(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ChatbotScreen()));
          },
        ),
        const SizedBox(height: 22),
        Text('Kategori',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontSize: 16, color: AppColors.orange)),
        const SizedBox(height: 10),
        SizedBox(
          height: 34,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (context, i) {
              final active = i == 0;
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: active ? AppColors.orange : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: active ? AppColors.orange : AppColors.line),
                ),
                child: Text(categories[i],
                    style: TextStyle(fontSize: 12, color: active ? Colors.white : AppColors.ink)),
              );
            },
          ),
        ),
        const SizedBox(height: 16),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 0.8,
          children: recipes
              .map((r) => _RecipeCard(title: r['title']!, subtitle: r['subtitle']!))
              .toList(),
        ),
      ],
    );
  }
}

/// Placeholder foto bulat untuk tiap jenis makan.
/// Ganti isi Container dengan `Image.asset(...)` atau `Image.network(...)`
/// begitu ada aset foto, lalu bungkus dengan ClipOval seperti biasa.
class _MealTypeAvatar extends StatelessWidget {
  const _MealTypeAvatar({required this.label, required this.icon});
  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: AppColors.line,
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.orangeLight, width: 2),
          ),
          child: Icon(Icons.image_outlined, color: AppColors.muted, size: 20),
        ),
        const SizedBox(height: 6),
        Text(label, style: const TextStyle(fontSize: 10.5, color: AppColors.ink)),
      ],
    );
  }
}

/// Banner AI assistant, kini widget mandiri di atas grid resep (bukan kartu grid).
class _AssistantBanner extends StatelessWidget {
  const _AssistantBanner({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(color: AppColors.orange, borderRadius: BorderRadius.circular(16)),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
              child: const Icon(Icons.smart_toy_rounded, color: AppColors.orange, size: 19),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Text('ChefMate AI Assistant',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white)),
            ),
            const Icon(Icons.chevron_right_rounded, color: Colors.white),
          ],
        ),
      ),
    );
  }
}

/// Kartu resep. Bagian atas ("image placeholder") adalah tempat menaruh foto:
/// ganti Container di dalamnya dengan Image.asset(...) / Image.network(...)
/// dan biarkan ClipRRect di luarnya supaya sudut tetap membulat.
class _RecipeCard extends StatelessWidget {
  const _RecipeCard({required this.title, required this.subtitle});
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.line),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Stack(
              fit: StackFit.expand,
              children: [
                // --- image placeholder: ganti dengan Image.asset/Image.network ---
                Container(
                  color: AppColors.line,
                  child: Icon(Icons.image_outlined, color: AppColors.muted, size: 28),
                ),
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    width: 24,
                    height: 24,
                    decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                    child: const Icon(Icons.thumb_up_rounded, size: 13, color: AppColors.orange),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.ink)),
                const SizedBox(height: 2),
                Text(subtitle, style: const TextStyle(fontSize: 11, color: AppColors.muted)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}