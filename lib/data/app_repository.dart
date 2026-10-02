import '../models/meal_plan_entry.dart';
import '../models/shopping_item.dart';
import '../state/app_state.dart';

/// Lapisan repository simulasi di atas [AppState].
///
/// [AppState] sendiri tetap sinkron (murni di memori), tapi semua operasi
/// tulis (create/update/delete) di modul Kalender dan Daftar Belanja lewat
/// sini dulu, supaya UI bisa menampilkan loading, menyimulasikan kegagalan,
/// dan punya satu tempat untuk mencegah submit ganda.
///
/// Pola ini mengikuti contoh "repository simulasi" di materi UTS:
/// delay buatan + parameter [simulateError] opsional untuk menguji skenario
/// gagal + tombol "Coba lagi".
class AppRepository {
  AppRepository(this._state);

  final AppState _state;

  static const _delay = Duration(milliseconds: 700);

  //  Meal Plan 

  Future<MealPlanEntry> saveMealPlan({
    required String date,
    required String mealType,
    required String recipeId,
    String? existingId,
    bool simulateError = false,
  }) async {
    await Future<void>.delayed(_delay);
    if (simulateError) {
      throw Exception('Gagal menyimpan rencana makan. Periksa koneksi dan coba lagi.');
    }
    if (existingId != null) {
      _state.updateMealPlan(existingId, mealType: mealType, recipeId: recipeId);
      return _state.mealPlan.firstWhere((e) => e.id == existingId);
    }
    return _state.addMealPlan(date: date, mealType: mealType, recipeId: recipeId);
  }

  Future<void> deleteMealPlan(String id, {bool simulateError = false}) async {
    await Future<void>.delayed(_delay);
    if (simulateError) {
      throw Exception('Gagal menghapus rencana makan. Coba lagi.');
    }
    _state.deleteMealPlan(id);
  }

  //  Shopping List 

  Future<ShoppingItem> saveShoppingItem({
    required String name,
    required String amount,
    String? existingId,
    String? sourceRecipeId,
    bool simulateError = false,
  }) async {
    await Future<void>.delayed(_delay);
    if (simulateError) {
      throw Exception('Gagal menyimpan item belanja. Coba lagi.');
    }
    if (existingId != null) {
      _state.updateShoppingItem(existingId, name: name, amount: amount);
      return _state.shoppingItems.firstWhere((e) => e.id == existingId);
    }
    return _state.addShoppingItem(name: name, amount: amount, sourceRecipeId: sourceRecipeId);
  }

  Future<void> deleteShoppingItem(String id, {bool simulateError = false}) async {
    await Future<void>.delayed(_delay);
    if (simulateError) {
      throw Exception('Gagal menghapus item belanja. Coba lagi.');
    }
    _state.deleteShoppingItem(id);
  }
}

/// Satu instance dipakai bersama, sama seperti [appState].
final appRepository = AppRepository(appState);