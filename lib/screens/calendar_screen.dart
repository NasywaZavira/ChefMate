import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class CalendarScreen extends StatelessWidget {
  const CalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const weekDays = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];
    const selectedDate = 10;
    const daysWithPlan = {3, 5, 8, 9, 10, 15, 22};

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Calendar',
                style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 22)),
            Row(children: const [
              _ViewTab(label: 'Week', active: false),
              SizedBox(width: 6),
              _ViewTab(label: 'Month', active: true),
            ]),
          ],
        ),
        const SizedBox(height: 4),
        Text('September 2026',
            style: const TextStyle(fontSize: 13, color: AppColors.muted)),
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
                                style: const TextStyle(
                                    fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.muted)),
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
                  final selected = date == selectedDate;
                  final hasPlan = daysWithPlan.contains(date);
                  return Container(
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
                            color: hasPlan
                                ? (selected ? Colors.white : AppColors.orange)
                                : Colors.transparent,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Text('Rencana 10 September', style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontSize: 15)),
        const SizedBox(height: 10),
        const _PlannedMeal(mealType: 'Sarapan', title: 'Nasi goreng kampung'),
        const SizedBox(height: 8),
        const _PlannedMeal(mealType: 'Makan siang', title: 'Soto ayam bening'),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.line, width: 1.4),
            borderRadius: BorderRadius.circular(14),
          ),
          child: const Center(
            child: Text('+ Tambah makan malam',
                style: TextStyle(fontSize: 13, color: AppColors.muted)),
          ),
        ),
      ],
    );
  }
}

class _ViewTab extends StatelessWidget {
  const _ViewTab({required this.label, required this.active});
  final String label;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: active ? AppColors.orange : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: active ? AppColors.orange : AppColors.line),
      ),
      child: Text(label,
          style: TextStyle(fontSize: 11, color: active ? Colors.white : AppColors.muted)),
    );
  }
}

class _PlannedMeal extends StatelessWidget {
  const _PlannedMeal({required this.mealType, required this.title});
  final String mealType;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
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
            decoration:
                BoxDecoration(color: AppColors.orangeLight, borderRadius: BorderRadius.circular(10)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(mealType,
                    style: const TextStyle(
                        fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.orange)),
                const SizedBox(height: 2),
                Text(title,
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.copyWith(fontWeight: FontWeight.w500)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
