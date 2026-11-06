/// Returns the asset path for a recipe photo based on its title.
String recipeImagePath(String title) {
  final slug = title
      .toLowerCase()
      .replaceAll(RegExp(r'[^a-z0-9]+'), '_')
      .replaceAll(RegExp(r'^_+|_+$'), '');
  final file = slug == 'tumis_kangkung' ? 'tumis_kankung' : slug;
  return 'assets/images/$file.jpg';
}
