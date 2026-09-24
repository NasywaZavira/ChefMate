import 'package:flutter/material.dart';

import '../data/recipe_data.dart';
import '../models/meal_plan_entry.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';
import 'meal_plan_form_screen.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  int _selectedDate = 10;
  static const _month = '2026-09';

  String get _selectedDateKey => '$_month-${_selectedDate.toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context) {
    const weekDays = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];
    final daysWithPlan = appState.mealPlan.map((e) => int.parse(e.date.split('-').last)).toSet();
    final todaysMeals = appState.mealsForDate(_selectedDateKey);

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      children: [
        Text('Calendar', style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 22)),
        const SizedBox(height: 4),
        const Text('September 2026', style: TextStyle(fontSize: 13, color: AppColors.muted)),
        const SizedBox(height: 14),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.line),
          ),
          child: Column(
            children: [
              Row(
                children: weekDays
                    .map((d) => Expanded(
                          child: Center(
                            child: Text(d,
                                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.muted)),
                          ),
                        ))
                    .toList(),
              ),
              const SizedBox(height: 8),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 30,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 7,
                  mainAxisSpacing: 4,
                  crossAxisSpacing: 4,
                ),
                itemBuilder: (context, i) {
                  final date = i + 1;
                  final selected = date == _selectedDate;
                  final hasPlan = daysWithPlan.contains(date);
                  return InkWell(
                    borderRadius: BorderRadius.circular(10),
                    onTap: () => setState(() => _selectedDate = date),
                    child: Container(
                      decoration: BoxDecoration(
                        color: selected ? AppColors.orange : Colors.transparent,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('$date',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                                color: selected ? Colors.white : AppColors.ink,
                              )),
                          const SizedBox(height: 2),
                          Container(
                            width: 4,
                            height: 4,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: hasPlan ? (selected ? Colors.white : AppColors.orange) : Colors.transparent,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Text('Rencana $_selectedDate September',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontSize: 15)),
        const SizedBox(height: 10),
        if (todaysMeals.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Text('Belum ada rencana di tanggal ini.',
                style: const TextStyle(fontSize: 13, color: AppColors.muted)),
          )
        else
          ...todaysMeals.map((entry) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: _PlannedMealRow(
                  entry: entry,
                  onTap: () async {
                    await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => MealPlanFormScreen(date: _selectedDateKey, existingEntry: entry),
                      ),
                    );
                    setState(() {});
                  },
                ),
              )),
        const SizedBox(height: 4),
        InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () async {
            await Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => MealPlanFormScreen(date: _selectedDateKey)),
            );
            setState(() {});
          },
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.line, width: 1.4),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Center(
              child: Text('+ Tambah rencana makan', style: TextStyle(fontSize: 13, color: AppColors.muted)),
            ),
          ),
        ),
      ],
    );
  }
}

class _PlannedMealRow extends StatelessWidget {
  const _PlannedMealRow({required this.entry, required this.onTap});

  final MealPlanEntry entry;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final recipe = dummyRecipes.firstWhere(
      (r) => r.id == entry.recipeId,
      orElse: () => dummyRecipes.first,
    );

    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.line),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(color: AppColors.orangeLight, borderRadius: BorderRadius.circular(10)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(entry.mealType,
                      style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.orange)),
                  const SizedBox(height: 2),
                  Text(recipe.title,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500)),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: AppColors.muted),
          ],
        ),
      ),
    );
  }
}