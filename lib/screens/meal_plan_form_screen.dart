import 'package:flutter/material.dart';

import '../data/recipe_data.dart';
import '../models/meal_plan_entry.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';

/// Form Tambah/Edit Rencana Makan.
/// - existingEntry == null  -> mode tambah (Create)
/// - existingEntry != null  -> mode edit (Update), tombol Hapus juga muncul (Delete)
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

  late String _mealType;
  late String? _recipeId;
  String? _error;

  @override
  void initState() {
    super.initState();
    _mealType = widget.existingEntry?.mealType ?? widget.initialMealType ?? mealTypes.first;
    _recipeId = widget.existingEntry?.recipeId;
  }

  bool get _isEditing => widget.existingEntry != null;

  void _save() {
    if (_recipeId == null) {
      setState(() => _error = 'Pilih resep terlebih dahulu.');
      return;
    }

    if (_isEditing) {
      appState.updateMealPlan(widget.existingEntry!.id, mealType: _mealType, recipeId: _recipeId);
    } else {
      appState.addMealPlan(date: widget.date, mealType: _mealType, recipeId: _recipeId!);
    }
    Navigator.of(context).pop();
  }

  void _delete() {
    appState.deleteMealPlan(widget.existingEntry!.id);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        backgroundColor: AppColors.cream,
        elevation: 0,
        foregroundColor: AppColors.ink,
        title: Text(_isEditing ? 'Edit Rencana Makan' : 'Tambah Rencana Makan'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        children: [
          Text('Tanggal', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.ink)),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.line),
            ),
            child: Text(widget.date, style: const TextStyle(fontSize: 13, color: AppColors.muted)),
          ),
          const SizedBox(height: 18),
          const Text('Jenis Makan', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.ink)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: mealTypes.map((m) {
              final active = m == _mealType;
              return ChoiceChip(
                label: Text(m),
                selected: active,
                onSelected: (_) => setState(() => _mealType = m),
                selectedColor: AppColors.orange,
                backgroundColor: Colors.white,
                labelStyle: TextStyle(fontSize: 12, color: active ? Colors.white : AppColors.ink),
                side: BorderSide(color: active ? AppColors.orange : AppColors.line),
              );
            }).toList(),
          ),
          const SizedBox(height: 18),
          const Text('Pilih Resep', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.ink)),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: _error != null ? AppColors.red : AppColors.line),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _recipeId,
                isExpanded: true,
                padding: const EdgeInsets.symmetric(horizontal: 14),
                hint: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Text('Pilih resep...', style: TextStyle(fontSize: 13, color: AppColors.muted)),
                ),
                items: dummyRecipes
                    .map((r) => DropdownMenuItem(
                          value: r.id,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Text(r.title, style: const TextStyle(fontSize: 13, color: AppColors.ink)),
                          ),
                        ))
                    .toList(),
                onChanged: (value) => setState(() {
                  _recipeId = value;
                  _error = null;
                }),
              ),
            ),
          ),
          if (_error != null) ...[
            const SizedBox(height: 6),
            Text(_error!, style: const TextStyle(fontSize: 12, color: AppColors.red)),
          ],
          const SizedBox(height: 28),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(onPressed: _save, child: Text(_isEditing ? 'Simpan Perubahan' : 'Simpan')),
          ),
          if (_isEditing) ...[
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: _delete,
                style: OutlinedButton.styleFrom(foregroundColor: AppColors.red, side: const BorderSide(color: AppColors.red)),
                child: const Text('Hapus Rencana'),
              ),
            ),
          ],
        ],
      ),
    );
  }
}