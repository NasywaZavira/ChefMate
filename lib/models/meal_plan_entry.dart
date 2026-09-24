/// Satu baris rencana makan: tanggal + jenis makan, merujuk ke Recipe
/// lewat recipeId (relasi ID). Ini entitas utama modul CRUD Kalender.
class MealPlanEntry {
  MealPlanEntry({
    required this.id,
    required this.date,
    required this.mealType,
    required this.recipeId,
    this.note = '',
  });

  final String id;

  /// Format 'yyyy-MM-dd', supaya gampang dibandingkan/disortir tanpa
  /// perlu package tanggal tambahan.
  String date;
  String mealType;
  String recipeId;
  String note;
}