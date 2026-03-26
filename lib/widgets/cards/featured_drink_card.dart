import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../data/models/drink_model.dart';
import '../animations/scale_tap_widget.dart';

class FeaturedDrinkCard extends StatelessWidget {
  final DrinkModel drink;
  final VoidCallback? onTap;

  const FeaturedDrinkCard({super.key, required this.drink, this.onTap});

  @override
  Widget build(BuildContext context) {
    return ScaleTapWidget(
      scaleFactor: 0.98,
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryGreen.withOpacity(0.2),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Stack(
            children: [
              // Background image
              Positioned.fill(
                child: Hero(
                  tag: 'featured_${drink.id}',
                  child: CachedNetworkImage(
                    imageUrl: drink.imageUrl,
                    fit: BoxFit.cover,
                    errorWidget: (context, url, error) => Container(
                      color: AppColors.primaryGreenLight,
                    ),
                  ),
                ),
              ),
              // Gradient overlay
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.7),
                      ],
                      stops: const [0.4, 1.0],
                    ),
                  ),
                ),
              ),
              // Content
              Positioned(
                left: 20,
                right: 20,
                bottom: 24,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (drink.tags.isNotEmpty)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        margin: const EdgeInsets.only(bottom: 8),
                        decoration: BoxDecoration(
                          color: AppColors.secondaryGold,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          drink.tags.first,
                          style: AppTypography.caption(context).copyWith(color: Colors.white, fontWeight: FontWeight.w600),
                        ),
                      ),
                    Text(
                      drink.name,
                      style: AppTypography.headingMedium(context).copyWith(color: Colors.white),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      drink.description,
                      style: AppTypography.bodySmall(context).copyWith(color: Colors.white70),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '\$${drink.price.toStringAsFixed(2)}',
                          style: AppTypography.headingSmall(context).copyWith(color: Colors.white),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: AppColors.primaryGreen,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            'Order Now',
                            style: AppTypography.labelSmall(context).copyWith(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
