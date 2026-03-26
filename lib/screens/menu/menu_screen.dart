import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../data/mock/mock_drinks.dart';
import '../../data/models/drink_model.dart';
import '../../router/route_names.dart';
import '../../widgets/cards/drink_card.dart';
import '../../widgets/cards/drink_list_tile.dart';
import '../../widgets/common/category_filter.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  String _selectedCategory = 'All';
  bool _isGridView = true;
  
  // Cache filtered drinks to avoid recomputing on every build
  List<DrinkModel>? _cachedFilteredDrinks;
  String? _cachedCategory;

  List<DrinkModel> get _filteredDrinks {
    if (_cachedCategory != _selectedCategory) {
      _cachedCategory = _selectedCategory;
      _cachedFilteredDrinks = _selectedCategory == 'All'
          ? mockDrinks
          : mockDrinks.where((d) => d.category == _selectedCategory).toList();
    }
    return _cachedFilteredDrinks!;
  }

  void _onCategorySelected(String category) {
    setState(() => _selectedCategory = category);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text('Menu', style: AppTypography.headingMedium(context)),
        actions: [
          IconButton(
            icon: Icon(_isGridView ? Icons.view_list_rounded : Icons.grid_view_rounded),
            onPressed: () => setState(() => _isGridView = !_isGridView),
          ),
        ],
      ),
      body: Column(
        children: [
          _SearchBar(
            onTap: () => context.push(RouteNames.search),
            isDark: isDark,
          ),
          CategoryFilter(
            categories: mockCategories,
            selectedCategory: _selectedCategory,
            onCategorySelected: _onCategorySelected,
            height: 44,
          ).animate().fadeIn(delay: 100.ms),
          const SizedBox(height: 8),
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: _isGridView ? _buildGridView() : _buildListView(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGridView() {
    return GridView.builder(
      key: const Key('grid'),
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
      ),
      itemCount: _filteredDrinks.length,
      itemBuilder: (context, index) {
        final drink = _filteredDrinks[index];
        return DrinkCard(
          key: ValueKey(drink.id),
          drink: drink,
          onTap: () => context.push(RouteNames.productDetail, extra: drink),
        ).animate(delay: (index * 30).ms).fadeIn().slideY(begin: 0.15, end: 0);
      },
    );
  }

  Widget _buildListView() {
    return ListView.builder(
      key: const Key('list'),
      padding: const EdgeInsets.all(16),
      itemCount: _filteredDrinks.length,
      itemBuilder: (context, index) {
        final drink = _filteredDrinks[index];
        return DrinkListTile(
          key: ValueKey(drink.id),
          drink: drink,
          onTap: () => context.push(RouteNames.productDetail, extra: drink),
        ).animate(delay: (index * 30).ms).fadeIn().slideX(begin: 0.1, end: 0);
      },
    );
  }
}

/// Search bar widget for menu screen.
class _SearchBar extends StatelessWidget {
  final VoidCallback onTap;
  final bool isDark;

  const _SearchBar({required this.onTap, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Icon(Icons.search, color: isDark ? Colors.white54 : AppColors.textHint, size: 20),
              const SizedBox(width: 12),
              Text(
                'Search drinks...',
                style: AppTypography.bodyMedium(context).copyWith(
                  color: isDark ? Colors.white54 : AppColors.textHint,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
