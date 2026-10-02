import 'package:flutter/material.dart';

import '../data/app_repository.dart';
import '../data/recipe_data.dart';
import '../models/meal_plan_entry.dart';
// ignore: unused_import
import '../state/app_state.dart';
import '../theme/app_theme.dart';

class MealPlanFormScreen extends StatefulWidget {
  const MealPlanFormScreen({
    super.key,
    required this.date,
    this.initialMealType,
    this.existingEntry,
  });

  final String date;
  final String? initialMealType;
  final MealPlanEntry? existingEntry;

  @override
  State<MealPlanFormScreen> createState() => _MealPlanFormScreenState();
}

class _MealPlanFormScreenState extends State<MealPlanFormScreen> {
  static const mealTypes = ['Sarapan', 'Makan Siang', 'Makan Malam', 'Camilan'];

  // Label bagian form: teks gelap, ukuran kecil (sesuai desain awal).
  static const _labelStyle = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w500,
    color: AppColors.orange,
  );

  String? _selectedRecipeId;
  String _mealType = 'Sarapan';

  // Toggle "Simulasikan gagal" disembunyikan dari UI agar tampilan
  // sama dengan desain. Ubah ke true untuk menguji error state.
  final bool _simulateError = false;

  bool _saving = false;
  String? _submitError;

  @override
  void initState() {
    super.initState();
    _selectedRecipeId = widget.existingEntry?.recipeId;
    _mealType =
        widget.existingEntry?.mealType ?? widget.initialMealType ?? 'Sarapan';
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
        scrolledUnderElevation: 0,
        foregroundColor: AppColors.orange,
        // Panah kembali (bukan tombol close) seperti desain awal.
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          widget.existingEntry == null
              ? 'Tambah Rencana Makan'
              : 'Edit Rencana Makan',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w400,
            color: AppColors.orange,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          // ---- Tanggal ----
          const Text('Tanggal', style: _labelStyle),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.line),
            ),
            child: Text(
              widget.date,
              style: const TextStyle(fontSize: 13, color: AppColors.muted),
            ),
          ),
          const SizedBox(height: 18),

          // ---- Jenis Makan ----
          const Text('Jenis Makan', style: _labelStyle),
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
                    color: active ? Colors.white : AppColors.orange,
                  ),
                ),
                selected: active,
                selectedColor: AppColors.orange,
                backgroundColor: Colors.white,
                checkmarkColor: Colors.white,
                side: BorderSide(
                  color: active ? AppColors.orange : AppColors.line,
                ),
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

          // ---- Pilih Resep ----
          const Text('Pilih Resep', style: _labelStyle),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            initialValue: _selectedRecipeId,
            isExpanded: true,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              contentPadding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: AppColors.line),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: AppColors.orange),
              ),
              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: AppColors.line),
              ),
            ),
            hint: const Text(
              'Pilih resep...',
              style: TextStyle(fontSize: 13, color: AppColors.muted),
            ),
            style: const TextStyle(fontSize: 13, color: AppColors.orange),
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

          if (_submitError != null) ...[
            const SizedBox(height: 8),
            Text(
              _submitError!,
              style: const TextStyle(fontSize: 12, color: AppColors.red),
            ),
          ],
          const SizedBox(height: 20),

          // ---- Tombol ----
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