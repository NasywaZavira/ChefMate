import 'package:flutter/material.dart';

import '../models/recipe.dart';
import '../theme/app_theme.dart';
import 'chatbot_screen.dart';

class RecipeDetailScreen extends StatefulWidget {
  const RecipeDetailScreen({super.key, required this.recipe});

  final Recipe recipe;

  @override
  State<RecipeDetailScreen> createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends State<RecipeDetailScreen> {
  late int _servings = widget.recipe.servings;

  @override
  Widget build(BuildContext context) {
    final recipe = widget.recipe;
    final scale = _servings / recipe.servings;

    return Scaffold(
      backgroundColor: AppColors.cream,
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          Stack(
            children: [
              //  image placeholder: ganti dengan Image.asset/Image.network 
              Container(
                height: 220,
                width: double.infinity,
                color: AppColors.orangeLight,
                child: const Icon(Icons.image_outlined, color: AppColors.orange, size: 40),
              ),
              Positioned(
                top: 44,
                left: 16,
                child: _RoundIconButton(
                  icon: Icons.arrow_back_rounded,
                  onTap: () => Navigator.of(context).pop(),
                ),
              ),
              const Positioned(
                top: 44,
                right: 16,
                child: _RoundIconButton(icon: Icons.bookmark_border_rounded),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(recipe.title,
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 22)),
                const SizedBox(height: 10),
                Row(children: [
                  _InfoChip(icon: Icons.access_time_rounded, label: recipe.time),
                  const SizedBox(width: 10),
                  _InfoChip(icon: Icons.local_fire_department_rounded, label: recipe.difficulty),
                ]),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Porsi',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.ink)),
                    Row(children: [
                      _StepperButton(
                        icon: Icons.remove_rounded,
                        onTap: () {
                          if (_servings > 1) setState(() => _servings--);
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        child: Text('$_servings',
                            style: const TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.ink)),
                      ),
                      _StepperButton(icon: Icons.add_rounded, onTap: () => setState(() => _servings++)),
                    ]),
                  ],
                ),
                const SizedBox(height: 20),
                const Text('Bahan',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.ink)),
                const SizedBox(height: 10),
                ...recipe.ingredients.map((ing) => _IngredientRow(ingredient: ing, scale: scale)),
                const SizedBox(height: 20),
                const Text('Peralatan',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.ink)),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: recipe.equipment
                      .map((e) => Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: AppColors.line),
                            ),
                            child: Text(e, style: const TextStyle(fontSize: 12, color: AppColors.ink)),
                          ))
                      .toList(),
                ),
                const SizedBox(height: 20),
                const Text('Langkah',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.ink)),
                const SizedBox(height: 10),
                ...List.generate(
                  recipe.steps.length,
                  (i) => _StepRow(number: i + 1, text: recipe.steps[i]),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const ChatbotScreen()),
                      );
                    },
                    child: const Text('Bingung? Tanya ChatBot'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Mengambil angka di depan takaran ("2 siung" -> 2) dan mengalikannya
/// dengan faktor skala porsi, lalu menyusun ulang teksnya (FR-11).
String _scaledAmount(String amount, double scale) {
  final match = RegExp(r'^([\d.,]+)\s*(.*)$').firstMatch(amount.trim());
  if (match == null) return amount;
  final value = double.tryParse(match.group(1)!.replaceAll(',', '.'));
  if (value == null) return amount;
  final rest = match.group(2) ?? '';
  final scaled = value * scale;
  final formatted =
      scaled == scaled.roundToDouble() ? scaled.toStringAsFixed(0) : scaled.toStringAsFixed(1);
  return '$formatted $rest'.trim();
}

class _IngredientRow extends StatelessWidget {
  const _IngredientRow({required this.ingredient, required this.scale});

  final Ingredient ingredient;
  final double scale;

  @override
  Widget build(BuildContext context) {
    final missing = !ingredient.available;
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: missing ? const Color(0xFFFBEAE6) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: missing ? AppColors.red : AppColors.line),
      ),
      child: Row(children: [
        Icon(missing ? Icons.close_rounded : Icons.check_rounded,
            size: 16, color: missing ? AppColors.red : AppColors.green),
        const SizedBox(width: 10),
        Expanded(
          child: Text(ingredient.name,
              style: TextStyle(fontSize: 13, color: missing ? AppColors.red : AppColors.ink)),
        ),
        Text(_scaledAmount(ingredient.amount, scale),
            style: TextStyle(fontSize: 12, color: missing ? AppColors.red : AppColors.muted)),
      ]),
    );
  }
}

class _StepRow extends StatelessWidget {
  const _StepRow({required this.number, required this.text});

  final int number;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 22,
            height: 22,
            alignment: Alignment.center,
            decoration: const BoxDecoration(color: AppColors.orange, shape: BoxShape.circle),
            child: Text('$number',
                style: const TextStyle(fontSize: 11, color: Colors.white, fontWeight: FontWeight.w600)),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(text, style: const TextStyle(fontSize: 13, color: AppColors.ink, height: 1.4)),
          ),
        ],
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.line),
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(icon, size: 14, color: AppColors.muted),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontSize: 12, color: AppColors.muted)),
      ]),
    );
  }
}

class _RoundIconButton extends StatelessWidget {
  const _RoundIconButton({required this.icon, this.onTap});

  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      customBorder: const CircleBorder(),
      child: Container(
        width: 36,
        height: 36,
        decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
        child: Icon(icon, size: 18, color: AppColors.ink),
      ),
    );
  }
}

class _StepperButton extends StatelessWidget {
  const _StepperButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      customBorder: const CircleBorder(),
      child: Container(
        width: 28,
        height: 28,
        decoration: const BoxDecoration(color: AppColors.orangeLight, shape: BoxShape.circle),
        child: Icon(icon, size: 16, color: AppColors.orange),
      ),
    );
  }
}