import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../data/mock/mock_drinks.dart';
import '../../providers/favorites_provider.dart';
import '../../router/route_names.dart';
import '../../widgets/cards/drink_card.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text('Favorites', style: AppTypography.headingMedium(context)),
      ),
      body: Consumer<FavoritesProvider>(
        builder: (context, favs, _) {
          final favoriteDrinks = mockDrinks.where((d) => favs.isFavorite(d.id)).toList();

          if (favoriteDrinks.isEmpty) {
            return _EmptyState();
          }

          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.75,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
            ),
            itemCount: favoriteDrinks.length,
            itemBuilder: (context, index) {
              final drink = favoriteDrinks[index];
              return DrinkCard(
                drink: drink,
                onTap: () => context.push(RouteNames.productDetail, extra: drink),
              ).animate(delay: (index * 50).ms).fadeIn().slideY(begin: 0.2, end: 0);
            },
          );
        },
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: AppColors.primaryGreenLight,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.favorite_outline_rounded, color: AppColors.primaryGreen, size: 40),
          ).animate().scale(duration: 600.ms, curve: Curves.elasticOut),
          const SizedBox(height: 24),
          Text('No favorites yet', style: AppTypography.headingMedium(context))
              .animate().fadeIn(delay: 200.ms),
          const SizedBox(height: 8),
          Text('Save your favorite drinks for easy access',
              style: AppTypography.bodyMedium(context).copyWith(color: AppColors.textSecondary))
              .animate().fadeIn(delay: 250.ms),
          const SizedBox(height: 32),
          _ExploreButton(
            text: 'Explore Menu',
            onPressed: () => context.go(RouteNames.menu),
          ).animate().fadeIn(delay: 300.ms),
        ],
      ),
    );
  }
}

class _ExploreButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const _ExploreButton({required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.primaryGreen,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Text(text, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
      ),
    );
  }
}
