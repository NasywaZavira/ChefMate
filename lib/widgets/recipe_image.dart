import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../utils/recipe_image_path.dart';

class RecipeImage extends StatelessWidget {
  const RecipeImage({
    super.key,
    required this.recipeTitle,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.placeholderColor = AppColors.orangeLight,
    this.placeholderIconColor = AppColors.orange,
    this.placeholderIconSize = 28,
    this.showPlaceholderIcon = true,
  });

  final String recipeTitle;
  final double? width;
  final double? height;
  final BoxFit fit;
  final Color placeholderColor;
  final Color placeholderIconColor;
  final double placeholderIconSize;
  final bool showPlaceholderIcon;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      recipeImagePath(recipeTitle),
      width: width,
      height: height,
      fit: fit,
      errorBuilder: (context, error, stackTrace) => Container(
        width: width,
        height: height,
        color: placeholderColor,
        alignment: Alignment.center,
        child: showPlaceholderIcon
            ? Icon(
                Icons.image_outlined,
                color: placeholderIconColor,
                size: placeholderIconSize,
              )
            : null,
      ),
    );
  }
}
