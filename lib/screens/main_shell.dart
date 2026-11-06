import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import 'calendar_screen.dart';
import 'home_screen.dart';
import 'profile_screen.dart';
import 'shopping_list_screen.dart';
import '../widgets/main_navigation_bar.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _index = 0;

  void _goToCalendar() => setState(() => _index = 1);

  @override
  Widget build(BuildContext context) {
    final screens = [
      HomeScreen(onNavigateToCalendar: _goToCalendar),
      const CalendarScreen(),
      const ShoppingListScreen(),
      const ProfileScreen(),
    ];

    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SafeArea(
        child: IndexedStack(index: _index, children: screens),
      ),
      bottomNavigationBar: MainNavigationBar(
        currentIndex: _index,
        onTap: (i) => setState(() => _index = i),
      ),
    );
  }
}
