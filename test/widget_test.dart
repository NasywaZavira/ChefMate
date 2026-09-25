import 'package:chefmate/screens/profile_screen.dart';
import 'package:chefmate/screens/settings_screen.dart';
import 'package:chefmate/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets(
    'profile screen shows settings button and opens settings screen',
    (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light,
          home: const Scaffold(body: ProfileScreen()),
        ),
      );

      expect(find.byType(OutlinedButton), findsWidgets);

      await tester.tap(find.byType(OutlinedButton).last);
      await tester.pumpAndSettle();

      expect(find.byType(SettingsScreen), findsOneWidget);
      expect(find.text('Akun'), findsOneWidget);
    },
  );
}
