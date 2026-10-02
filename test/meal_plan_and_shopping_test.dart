import 'package:chefmate/data/recipe_data.dart';
import 'package:chefmate/screens/meal_plan_form_screen.dart';
import 'package:chefmate/screens/shopping_list_screen.dart';
import 'package:chefmate/state/app_state.dart';
import 'package:chefmate/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Skenario awal untuk "Matriks uji wajib sebelum UTS". Setiap test diberi
/// label [area] sesuai kategori di matriks: CRUD, Validasi, Data & state,
/// Navigasi, Async simulasi, Tampilan. Masih perlu ditambah sampai
void main() {
  Widget wrap(Widget child) => MaterialApp(theme: AppTheme.light, home: Scaffold(body: child));

  group('Meal Plan Form', () {
    testWidgets('[Validasi] tombol Simpan menampilkan error saat resep belum dipilih', (tester) async {
      await tester.pumpWidget(wrap(const MealPlanFormScreen(date: '2026-09-20')));

      await tester.tap(find.widgetWithText(ElevatedButton, 'Simpan'));
      await tester.pump();

      expect(find.text('Pilih resep terlebih dahulu.'), findsOneWidget);
    });

    testWidgets('[Async simulasi] indikator loading muncul lalu hilang setelah simpan berhasil', (tester) async {
      await tester.pumpWidget(wrap(const MealPlanFormScreen(date: '2026-09-20')));

      // Pilih resep pertama dari dropdown.
      await tester.tap(find.byType(DropdownButton<String>));
      await tester.pumpAndSettle();
      await tester.tap(find.text(dummyRecipes.first.title).last);
      await tester.pump();

      final before = appState.mealPlan.length;
      await tester.tap(find.widgetWithText(ElevatedButton, 'Simpan'));
      await tester.pump(); // frame pertama: loading mulai

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      await tester.pump(const Duration(milliseconds: 800)); // lewati delay simulasi
      await tester.pumpAndSettle();

      expect(appState.mealPlan.length, before + 1);
    });

    testWidgets('[Async simulasi] skenario gagal menampilkan pesan error dan tombol Coba lagi', (tester) async {
      await tester.pumpWidget(wrap(const MealPlanFormScreen(date: '2026-09-21')));

      await tester.tap(find.byType(DropdownButton<String>));
      await tester.pumpAndSettle();
      await tester.tap(find.text(dummyRecipes.first.title).last);
      await tester.pump();

      await tester.tap(find.text('Simulasikan gagal (untuk demo/uji)'));
      await tester.pump();

      await tester.tap(find.widgetWithText(ElevatedButton, 'Simpan'));
      await tester.pump(const Duration(milliseconds: 800));
      await tester.pumpAndSettle();

      expect(find.text('Coba lagi'), findsOneWidget);
    });

    testWidgets('[CRUD][Data & state] dialog konfirmasi hapus muncul dan membatalkannya tidak mengubah data', (tester) async {
      final entry = appState.addMealPlan(
        date: '2026-09-22',
        mealType: 'Sarapan',
        recipeId: dummyRecipes.first.id,
      );
      final before = appState.mealPlan.length;

      await tester.pumpWidget(wrap(MealPlanFormScreen(date: entry.date, existingEntry: entry)));

      await tester.tap(find.widgetWithText(OutlinedButton, 'Hapus Rencana'));
      await tester.pumpAndSettle();

      expect(find.text('Hapus rencana makan?'), findsOneWidget);

      await tester.tap(find.text('Batal'));
      await tester.pumpAndSettle();

      expect(appState.mealPlan.length, before); // data tidak berubah setelah dibatalkan
    });
  });

  group('Shopping List', () {
    testWidgets('[Tampilan][Data & state] empty state "Semua bahan sudah dibeli" tampil saat semua tercentang', (tester) async {
      for (final item in List.of(appState.shoppingItems)) {
        appState.deleteShoppingItem(item.id);
      }
      appState.addShoppingItem(name: 'Garam', amount: '1 sdt');
      final onlyItem = appState.shoppingItems.first;
      appState.toggleShoppingItem(onlyItem.id);

      await tester.pumpWidget(wrap(const ShoppingListScreen()));
      await tester.pump();

      expect(find.text('Semua bahan sudah dibeli.'), findsOneWidget);
    });

    testWidgets('[Validasi] form tambah item menampilkan error spesifik per field', (tester) async {
      await tester.pumpWidget(wrap(const ShoppingListScreen()));

      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      await tester.tap(find.widgetWithText(ElevatedButton, 'Simpan'));
      await tester.pump();

      expect(find.text('Nama bahan wajib diisi.'), findsOneWidget);
      expect(find.text('Jumlah wajib diisi.'), findsOneWidget);
    });
  });

}