/// Model data untuk satu bahan dalam resep.
class Ingredient {
  const Ingredient({
    required this.name,
    required this.amount,
    this.available = true,
  });

  final String name;
  final String amount;

  /// FR-08: dipakai untuk menyorot bahan yang belum dimiliki pengguna.
  final bool available;
}

/// Model data untuk satu resep. Semua kartu resep di Beranda memanggil
/// data dari sini (lihat lib/data/recipe_data.dart), jadi kalau mau
/// menambah/mengubah resep, cukup edit di satu tempat itu.
class Recipe {
  const Recipe({
    required this.id,
    required this.title,
    required this.time,
    required this.difficulty,
    required this.servings,
    required this.categoryId,
    required this.ingredients,
    required this.equipment,
    required this.steps,
  });

  final String id;
  final String title;
  final String time;
  final String difficulty;
  final int servings;

  /// Relasi ID ke Category.
  final String categoryId;
  final List<Ingredient> ingredients;
  final List<String> equipment;
  final List<String> steps;

  String get subtitle => '$time \u00b7 $difficulty';
}