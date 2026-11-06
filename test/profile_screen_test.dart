import 'package:chefmate/screens/profile_screen.dart';
import 'package:chefmate/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets(
    'profile title stays left and avatar is centered with camera action',
    (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light,
          home: const Scaffold(body: ProfileScreen()),
        ),
      );

      final title = find.text('Profil & Preferensi');
      final avatar = find.byKey(const Key('profile-picture'));
      final cameraButton = find.byKey(const Key('change-profile-picture'));
      final screenWidth =
          tester.view.physicalSize.width / tester.view.devicePixelRatio;

      expect(title, findsOneWidget);
      expect(avatar, findsOneWidget);
      expect(cameraButton, findsOneWidget);
      expect(tester.getTopLeft(title).dx, 20);
      expect(tester.getCenter(avatar).dx, closeTo(screenWidth / 2, 1));
    },
  );
}
