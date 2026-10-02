import 'package:flutter/material.dart';

import '../data/app_repository.dart';
import '../data/recipe_data.dart';
import '../models/meal_plan_entry.dart';
// ignore: unused_import
import '../state/app_state.dart';
import '../theme/app_theme.dart';

class MealPlanFormScreen extends StatefulWidget {
  const MealPlanFormScreen({super.key, required this.date, this.existingEntry});

  final String date;
  final MealPlanEntry? existingEntry;

  @override
  State<MealPlanFormScreen> createState() => _MealPlanFormScreenState();
}

class _MealPlanFormScreenState extends State<MealPlanFormScreen> {
  static const mealTypes = ['Sarapan', 'Makan Siang', 'Makan Malam', 'Camilan'];

  // Gaya tulisan judul/label: orange.
  static const _labelStyle = TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.orange);

  String? _selectedRecipeId;
  String _mealType = 'Sarapan';
  bool _simulateError = false;
  bool _saving = false;
  String? _submitError;

  @override
  void initState() {
    super.initState();
    _selectedRecipeId = widget.existingEntry?.recipeId;
    _mealType = widget.existingEntry?.mealType ?? 'Sarapan';
  }

  Future<void> _submit() async {
    if (_selectedRecipeId == null) {
      setState(() {
        _submitError = 'Pilih resep terlebih dahulu.';
      });
      return;
    }

    if (_saving) return;

    setState(() {
      _saving = true;
      _submitError = null;
    });

    try {
      await appRepository.saveMealPlan(
        date: widget.date,
        mealType: _mealType,
        recipeId: _selectedRecipeId!,
        existingId: widget.existingEntry?.id,
        simulateError: _simulateError,
      );

      if (!mounted) return;
      Navigator.of(context).pop();
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _saving = false;
        _submitError = e.toString().replaceFirst('Exception: ', '');
      });
    }
  }

  Future<void> _confirmDelete() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.cream,
        title: const Text('Hapus rencana makan?'),
        content: const Text(
          'Apakah Anda yakin ingin menghapus rencana makan ini?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Hapus', style: TextStyle(color: AppColors.red)),
          ),
        ],
      ),
    );

    if (confirmed != true || widget.existingEntry == null) return;

    setState(() => _saving = true);
    try {
      await appRepository.deleteMealPlan(
        widget.existingEntry!.id,
        simulateError: _simulateError,
      );
      if (!mounted) return;
      Navigator.of(context).pop();
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _saving = false;
        _submitError = e.toString().replaceFirst('Exception: ', '');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final buttonText = _submitError != null ? 'Coba lagi' : 'Simpan';

    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        backgroundColor: AppColors.cream,
        elevation: 0,
        foregroundColor: AppColors.orange,
        title: Text(
          widget.existingEntry == null
              ? 'Tambah rencana makan'
              : 'Edit rencana makan',
          style: const TextStyle(color: AppColors.orange, fontWeight: FontWeight.w700),
        ),
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        children: [
          Text(
            'Rencana untuk ${widget.date}',
            style: Theme.of(context).textTheme.headlineMedium
                ?.copyWith(fontSize: 16, color: AppColors.orange),
          ),
          const SizedBox(height: 18),
          DropdownButtonFormField<String>(
            initialValue: _selectedRecipeId,
            decoration: const InputDecoration(
              labelText: 'Resep',
              labelStyle: TextStyle(color: AppColors.orange),
              floatingLabelStyle: TextStyle(color: AppColors.orange, fontWeight: FontWeight.w600),
              border: OutlineInputBorder(),
            ),
            hint: const Text('Pilih resep'),
            items: dummyRecipes
                .map(
                  (recipe) => DropdownMenuItem<String>(
                value: recipe.id,
                child: Text(recipe.title),
              ),
            )
                .toList(),
            onChanged: _saving
                ? null
                : (value) {
              setState(() {
                _selectedRecipeId = value;
                _submitError = null;
              });
            },
          ),
          if (_submitError != null && _selectedRecipeId == null) ...[
            const SizedBox(height: 8),
            Text(
              _submitError!,
              style: const TextStyle(fontSize: 12, color: AppColors.red),
            ),
          ],
          const SizedBox(height: 18),
          const Text('Jenis makanan', style: _labelStyle),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: mealTypes.map((mealType) {
              final active = _mealType == mealType;
              return ChoiceChip(
                label: Text(
                  mealType,
                  style: TextStyle(
                    fontSize: 12,
                    // Belum dipilih: abu-abu. Sudah dipilih: putih di atas orange.
                    color: active ? Colors.white : AppColors.muted,
                  ),
                ),
                selected: active,
                selectedColor: AppColors.orange,
                backgroundColor: Colors.white,
                checkmarkColor: Colors.white,
                side: BorderSide(color: active ? AppColors.orange : AppColors.line),
                onSelected: _saving
                    ? null
                    : (_) {
                  setState(() {
                    _mealType = mealType;
                  });
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 18),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            dense: true,
            title: const Text(
              'Simulasikan gagal (untuk demo/uji)',
              style: TextStyle(fontSize: 11, color: AppColors.muted),
            ),
            value: _simulateError,
            activeThumbColor: AppColors.orange,
            onChanged: _saving
                ? null
                : (v) {
              setState(() {
                _simulateError = v;
                _submitError = null;
              });
            },
          ),
          if (_submitError != null && _selectedRecipeId != null) ...[
            const SizedBox(height: 8),
            Text(
              _submitError!,
              style: const TextStyle(fontSize: 12, color: AppColors.red),
            ),
          ],
          const SizedBox(height: 20),
          Row(
            children: [
              if (widget.existingEntry != null)
                Expanded(
                  child: OutlinedButton(
                    onPressed: _saving ? null : _confirmDelete,
                    child: const Text('Hapus Rencana'),
                  ),
                ),
              if (widget.existingEntry != null) const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton(
                  onPressed: _saving ? null : _submit,
                  child: _saving
                      ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                      : Text(buttonText),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}