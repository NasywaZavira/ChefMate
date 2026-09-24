/// Data referensi/kategori resep. Dihubungkan ke Recipe lewat categoryId
/// (relasi ID antar entitas).
class Category {
  const Category({required this.id, required this.name});

  final String id;
  final String name;
}