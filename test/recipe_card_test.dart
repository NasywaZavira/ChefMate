import 'package:chefmate/data/recipe_data.dart';
import 'package:chefmate/widgets/recipe_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('recipe card shows recipe details and separates favorite tap', (
    tester,
  ) async {
    final recipe = dummyRecipes.first;
    var favoriteTapCount = 0;
    var cardTapCount = 0;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 180,
            height: 220,
            child: RecipeCard(
              recipe: recipe,
              isFavorite: false,
              onFavoriteTap: () => favoriteTapCount++,
              onTap: () => cardTapCount++,
            ),
          ),
        ),
      ),
    );

    expect(find.text(recipe.title), findsOneWidget);
    expect(find.text(recipe.subtitle), findsOneWidget);

    await tester.tap(find.byTooltip('Tambah ke favorit'));
    await tester.pump();

    expect(favoriteTapCount, 1);
    expect(cardTapCount, 0);

    await tester.tap(find.text(recipe.title));
    await tester.pump();
    expect(cardTapCount, 1);
  });
}
