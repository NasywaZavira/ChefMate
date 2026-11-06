import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

import '../state/app_state.dart';
import '../theme/app_theme.dart';
import 'settings_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late final _nameController = TextEditingController(text: appState.userName);
  late final _emailController = TextEditingController(text: appState.userEmail);
  late final _budgetController = TextEditingController(
    text: appState.dailyBudget,
  );

  late String _diet = appState.dietPreference;
  late bool _spicy = appState.likesSpicy;
  Uint8List? _profileImageBytes;
  bool _saved = false;
  String? _nameError;
  String? _emailError;

  static const diets = ['Halal', 'Vegetarian', 'Vegan', 'Tanpa pantangan'];

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _budgetController.dispose();
    super.dispose();
  }

  void _save() {
    final email = _emailController.text.trim();
    final validEmail = RegExp(r'^[\w.+-]+@[\w-]+\.[\w.-]+$').hasMatch(email);

    if (_nameController.text.trim().isEmpty) {
      setState(() {
        _nameError = 'Nama tidak boleh kosong.';
        _emailError = null;
        _saved = false;
      });
      return;
    }

    if (!validEmail) {
      setState(() {
        _nameError = null;
        _emailError = 'Format email tidak valid.';
        _saved = false;
      });
      return;
    }

    appState.updateProfile(
      name: _nameController.text.trim(),
      email: email,
      diet: _diet,
      budget: _budgetController.text.trim(),
      spicy: _spicy,
    );

    setState(() {
      _nameError = null;
      _emailError = null;
      _saved = true;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Preferensi berhasil disimpan.')),
    );
  }

  Future<void> _changeProfilePicture() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;

      final imageBytes = await image.readAsBytes();
      if (!mounted) return;
      setState(() => _profileImageBytes = imageBytes);
    } on PlatformException catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            error.message ?? 'Foto profil tidak dapat dipilih. Coba lagi.',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
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
          const SizedBox(height: 20),
          Center(
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  key: const Key('profile-picture'),
                  width: 144,
                  height: 144,
                  decoration: const BoxDecoration(
                    color: AppColors.orangeLight,
                    shape: BoxShape.circle,
                  ),
                  child: ClipOval(
                    child: _profileImageBytes == null
                        ? Image.asset(
                            'assets/images/profile.jpg',
                            fit: BoxFit.cover,
                          )
                        : Image.memory(_profileImageBytes!, fit: BoxFit.cover),
                  ),
                ),
                Positioned(
                  right: -2,
                  bottom: 4,
                  child: Material(
                    color: AppColors.orange,
                    shape: const CircleBorder(),
                    child: IconButton(
                      key: const Key('change-profile-picture'),
                      tooltip: 'Ubah foto profil',
                      onPressed: _changeProfilePicture,
                      icon: const Icon(
                        Icons.camera_alt_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          _FieldLabel('Nama'),
          TextField(
            controller: _nameController,
            decoration: InputDecoration(errorText: _nameError),
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
