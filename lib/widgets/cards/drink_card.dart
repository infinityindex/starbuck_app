import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../data/models/drink_model.dart';
import '../../providers/favorites_provider.dart';
import '../animations/scale_tap_widget.dart';
import '../animations/shimmer_wrapper.dart';

class DrinkCard extends StatelessWidget {
  final DrinkModel drink;
  final VoidCallback? onTap;
  final bool showFavorite;

  const DrinkCard({
    super.key,
    required this.drink,
    this.onTap,
    this.showFavorite = true,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return ScaleTapWidget(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: AppColors.cardShadow,
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Hero(
                      tag: 'drink_image_${drink.id}',
                      child: CachedNetworkImage(
                        imageUrl: drink.imageUrl,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => const ShimmerBox(height: double.infinity, radius: 0),
                        errorWidget: (context, url, error) => Container(
                          color: AppColors.primaryGreenLight,
                          child: const Icon(Icons.local_cafe, color: AppColors.primaryGreen, size: 40),
                        ),
                      ),
                    ),
                    if (showFavorite)
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Consumer<FavoritesProvider>(
                          builder: (context, favs, _) {
                            final isFav = favs.isFavorite(drink.id);
                            return GestureDetector(
                              onTap: () => favs.toggle(drink.id),
                              child: Container(
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.9),
                                  shape: BoxShape.circle,
                                ),
                                child: AnimatedSwitcher(
                                  duration: const Duration(milliseconds: 200),
                                  transitionBuilder: (child, anim) =>
                                      ScaleTransition(scale: anim, child: child),
                                  child: Icon(
                                    isFav ? Icons.favorite_rounded : Icons.favorite_outline_rounded,
                                    key: ValueKey(isFav),
                                    color: isFav ? AppColors.heartRed : AppColors.textHint,
                                    size: 16,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    if (drink.isFeatured)
                      Positioned(
                        top: 8,
                        left: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.secondaryGold,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            'Popular',
                            style: AppTypography.caption(context).copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            // Info
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    drink.name,
                    style: AppTypography.labelMedium(context),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '\$${drink.price.toStringAsFixed(2)}',
                        style: AppTypography.bodyMedium(context).copyWith(
                          color: AppColors.primaryGreen,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(Icons.star_rounded, color: AppColors.starGold, size: 14),
                          const SizedBox(width: 2),
                          Text(drink.rating.toStringAsFixed(1), style: AppTypography.caption(context)),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
