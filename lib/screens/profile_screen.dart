import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import 'settings_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _nameController = TextEditingController(text: 'Jane Doe');
  final _emailController = TextEditingController(text: 'JaneDoe@email.com');
  final _budgetController = TextEditingController(text: '50000');

  String _diet = 'Halal';
  bool _spicy = true;
  bool _saved = false;
  String? _emailError;

  static const diets = ['Halal', 'Vegetarian', 'Vegan', 'Tanpa pantangan'];

  void _save() {
    final email = _emailController.text.trim();
    final validEmail = RegExp(r'^[\w.+-]+@[\w-]+\.[\w.-]+$').hasMatch(email);

    if (_nameController.text.trim().isEmpty) {
      setState(() {
        _emailError = null;
        _saved = false;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Nama tidak boleh kosong.')));
      return;
    }

    if (!validEmail) {
      setState(() {
        _emailError = 'Format email tidak valid.';
        _saved = false;
      });
      return;
    }

    setState(() {
      _emailError = null;
      _saved = true;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Preferensi berhasil disimpan.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        children: [
          Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: const BoxDecoration(
                  color: AppColors.orangeLight,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.person_rounded,
                  color: AppColors.orange,
                  size: 28,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Profil & Preferensi',
                      style: Theme.of(context).textTheme.headlineMedium
                          ?.copyWith(fontSize: 18),
                    ),
                    const SizedBox(height: 2),
                    const Text(
                      'Data ini dipakai chatbot & filter resep',
                      style: TextStyle(fontSize: 12, color: AppColors.muted),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          _FieldLabel('Nama'),
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(),
          ),
          const SizedBox(height: 16),

          _FieldLabel('Email'),
          TextField(
            controller: _emailController,
            decoration: InputDecoration(errorText: _emailError),
          ),
          const SizedBox(height: 16),

          _FieldLabel('Preferensi Diet'),
          const SizedBox(height: 6),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: diets.map((d) {
              final active = d == _diet;
              return ChoiceChip(
                label: Text(d),
                selected: active,
                onSelected: (_) => setState(() => _diet = d),
                selectedColor: AppColors.green,
                backgroundColor: Colors.white,
                labelStyle: TextStyle(
                  fontSize: 12,
                  color: active ? Colors.white : AppColors.ink,
                ),
                side: BorderSide(
                  color: active ? AppColors.green : AppColors.line,
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),

          _FieldLabel('Anggaran belanja per hari (Rp)'),
          TextField(
            controller: _budgetController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(),
          ),
          const SizedBox(height: 16),

          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text(
              'Suka masakan pedas',
              style: TextStyle(fontSize: 13, color: AppColors.ink),
            ),
            value: _spicy,
            activeThumbColor: AppColors.orange,
            onChanged: (v) => setState(() => _spicy = v),
          ),
          const SizedBox(height: 12),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _save,
              child: const Text('Simpan Preferensi'),
            ),
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const SettingsScreen()),
                );
              },
              icon: const Icon(Icons.settings_outlined),
              label: const Text('Pengaturan'),
            ),
          ),
          if (_saved) ...[
            const SizedBox(height: 10),
            const Row(
              children: [
                Icon(
                  Icons.check_circle_rounded,
                  size: 16,
                  color: AppColors.green,
                ),
                SizedBox(width: 6),
                Text(
                  'Tersimpan',
                  style: TextStyle(fontSize: 12, color: AppColors.green),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: AppColors.ink,
        ),
      ),
    );
  }
}
