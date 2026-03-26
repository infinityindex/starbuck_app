import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../data/models/drink_model.dart';

/// Reusable list tile for displaying drink items in list views.
/// Used in MenuScreen (list view) and SearchScreen (results).
class DrinkListTile extends StatelessWidget {
  final DrinkModel drink;
  final VoidCallback onTap;
  final bool showDescription;
  final bool showCategory;
  final bool showRating;

  const DrinkListTile({
    super.key,
    required this.drink,
    required this.onTap,
    this.showDescription = true,
    this.showCategory = false,
    this.showRating = true,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            _buildImage(),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(drink.name, style: AppTypography.labelMedium(context)),
                  const SizedBox(height: 4),
                  if (showDescription)
                    Text(
                      drink.description,
                      style: AppTypography.bodySmall(context).copyWith(
                        color: isDark ? Colors.white70 : AppColors.textSecondary,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  if (showCategory && !showDescription)
                    Text(
                      drink.category,
                      style: AppTypography.bodySmall(context).copyWith(
                        color: isDark ? Colors.white70 : AppColors.textSecondary,
                      ),
                    ),
                  const SizedBox(height: 6),
                  _buildPriceRow(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImage() {
    return Hero(
      tag: 'drink_image_${drink.id}',
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.network(
          drink.imageUrl,
          width: 80,
          height: 80,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => Container(
            width: 80,
            height: 80,
            color: AppColors.primaryGreenLight,
            child: const Icon(Icons.local_cafe, color: AppColors.primaryGreen),
          ),
        ),
      ),
    );
  }

  Widget _buildPriceRow(BuildContext context) {
    return Row(
      children: [
        Text('\$${drink.price.toStringAsFixed(2)}', style: AppTypography.price(context)),
        const Spacer(),
        if (showRating)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.star_rounded, color: AppColors.starGold, size: 14),
              const SizedBox(width: 2),
              Text(drink.rating.toStringAsFixed(1), style: AppTypography.caption(context)),
            ],
          ),
      ],
    );
  }
}
