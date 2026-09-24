/// Satu item di daftar belanja. sourceRecipeId opsional — kalau item ini
/// berasal dari agregasi bahan suatu resep (FR-16), ID resepnya dicatat
/// di sini (relasi ID). Item yang ditambah manual (FR-17) nilainya null.
class ShoppingItem {
  ShoppingItem({
    required this.id,
    required this.name,
    required this.amount,
    this.checked = false,
    this.sourceRecipeId,
  });

  final String id;
  String name;
  String amount;
  bool checked;
  String? sourceRecipeId;
}