import 'package:flutter/foundation.dart';


import '../models/meal_plan_entry.dart';
import '../models/shopping_item.dart';

/// State aplikasi di memori (simulasi database). Dua modul CRUD ada di
/// sini: mealPlan (Kalender) dan shoppingItems (Daftar Belanja).
/// ChangeNotifier dipakai supaya semua layar yang "mendengarkan" ikut
/// ter-refresh begitu ada perubahan data (create/update/delete).
class AppState extends ChangeNotifier {
  AppState() {
    _seed();
  }

  final List<MealPlanEntry> _mealPlan = [];
  final List<ShoppingItem> _shoppingItems = [];
  int _idCounter = 100;

  List<MealPlanEntry> get mealPlan => List.unmodifiable(_mealPlan);
  List<ShoppingItem> get shoppingItems => List.unmodifiable(_shoppingItems);

  String _nextId(String prefix) => '$prefix-${_idCounter++}';

  String userName = 'Jane Doe';
  String userEmail = 'JaneDoe@email.com';
  String dietPreference = 'Halal';
  String dailyBudget = '50000';
  bool likesSpicy = true;

  void updateProfile({
    required String name,
    required String email,
    required String diet,
    required String budget,
    required bool spicy,
  }) {
    userName = name;
    userEmail = email;
    dietPreference = diet;
    dailyBudget = budget;
    likesSpicy = spicy;
    notifyListeners();
  }

  //  Pengaturan notifikasi 

  bool notifyReminder = true;
  bool notifyPromo = false;

  void setNotifyReminder(bool value) {
    notifyReminder = value;
    notifyListeners();
  }

  void setNotifyPromo(bool value) {
    notifyPromo = value;
    notifyListeners();
  }

  //  Resep favorit (bookmark), relasi Set<recipeId> 

  final Set<String> _bookmarkedRecipeIds = {};

  bool isBookmarked(String recipeId) => _bookmarkedRecipeIds.contains(recipeId);

  void toggleBookmark(String recipeId) {
    if (_bookmarkedRecipeIds.contains(recipeId)) {
      _bookmarkedRecipeIds.remove(recipeId);
    } else {
      _bookmarkedRecipeIds.add(recipeId);
    }
    notifyListeners();
  }

  //  Meal Plan CRUD (relasi ID ke Recipe lewat recipeId) 

  List<MealPlanEntry> mealsForDate(String date) =>
      _mealPlan.where((e) => e.date == date).toList();

  MealPlanEntry addMealPlan({
    required String date,
    required String mealType,
    required String recipeId,
  }) {
    final entry = MealPlanEntry(
      id: _nextId('mp'),
      date: date,
      mealType: mealType,
      recipeId: recipeId,
    );
    _mealPlan.add(entry);
    notifyListeners();
    return entry;
  }

  void updateMealPlan(String id, {String? mealType, String? recipeId}) {
    final entry = _mealPlan.firstWhere((e) => e.id == id);
    if (mealType != null) entry.mealType = mealType;
    if (recipeId != null) entry.recipeId = recipeId;
    notifyListeners();
  }

  void deleteMealPlan(String id) {
    _mealPlan.removeWhere((e) => e.id == id);
    notifyListeners();
  }

  //  Shopping List CRUD 

  ShoppingItem addShoppingItem({
    required String name,
    required String amount,
    String? sourceRecipeId,
  }) {
    final item = ShoppingItem(
      id: _nextId('sl'),
      name: name,
      amount: amount,
      sourceRecipeId: sourceRecipeId,
    );
    _shoppingItems.add(item);
    notifyListeners();
    return item;
  }

  void updateShoppingItem(String id, {String? name, String? amount}) {
    final item = _shoppingItems.firstWhere((e) => e.id == id);
    if (name != null) item.name = name;
    if (amount != null) item.amount = amount;
    notifyListeners();
  }

  void toggleShoppingItem(String id) {
    final item = _shoppingItems.firstWhere((e) => e.id == id);
    item.checked = !item.checked;
    notifyListeners();
  }

  void deleteShoppingItem(String id) {
    _shoppingItems.removeWhere((e) => e.id == id);
    notifyListeners();
  }

  //  Data simulasi awal 

  void _seed() {
    _mealPlan.addAll([
      MealPlanEntry(id: _nextId('mp'), date: '2026-09-10', mealType: 'Sarapan', recipeId: 'nasi-goreng-spesial'),
      MealPlanEntry(id: _nextId('mp'), date: '2026-09-10', mealType: 'Makan Siang', recipeId: 'soto-ayam-bening'),
      MealPlanEntry(id: _nextId('mp'), date: '2026-09-08', mealType: 'Makan Malam', recipeId: 'ayam-teriyaki'),
      MealPlanEntry(id: _nextId('mp'), date: '2026-09-09', mealType: 'Sarapan', recipeId: 'sup-jagung'),
      MealPlanEntry(id: _nextId('mp'), date: '2026-09-15', mealType: 'Makan Malam', recipeId: 'rendang-daging'),
      MealPlanEntry(id: _nextId('mp'), date: '2026-09-22', mealType: 'Makan Siang', recipeId: 'gado-gado'),
    ]);

    _shoppingItems.addAll([
      ShoppingItem(id: _nextId('sl'), name: 'Daun jeruk', amount: '3 lembar', sourceRecipeId: 'ayam-teriyaki'),
      ShoppingItem(id: _nextId('sl'), name: 'Santan kental', amount: '200 ml', sourceRecipeId: 'rendang-daging'),
      ShoppingItem(id: _nextId('sl'), name: 'Kentang', amount: '3 buah'),
      ShoppingItem(id: _nextId('sl'), name: 'Ayam fillet', amount: '250 g', checked: true, sourceRecipeId: 'soto-ayam-bening'),
      ShoppingItem(id: _nextId('sl'), name: 'Kunyit', amount: '2 ruas', checked: true),
    ]);
  }
}


final appState = AppState();