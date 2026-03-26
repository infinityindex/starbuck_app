import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';

/// A horizontal scrollable list of category filter chips.
/// 
/// Usage:
/// ```dart
/// CategoryFilter(
///   categories: ['All', 'Coffee', 'Tea'],
///   selectedCategory: _selected,
///   onCategorySelected: (cat) => setState(() => _selected = cat),
/// )
/// ```
class CategoryFilter extends StatelessWidget {
  final List<String> categories;
  final String selectedCategory;
  final ValueChanged<String> onCategorySelected;
  final double height;
  final EdgeInsets padding;

  const CategoryFilter({
    super.key,
    required this.categories,
    required this.selectedCategory,
    required this.onCategorySelected,
    this.height = 44,
    this.padding = const EdgeInsets.symmetric(horizontal: 20),
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: padding,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = selectedCategory == category;
          return CategoryChip(
            label: category,
            isSelected: isSelected,
            onTap: () => onCategorySelected(category),
          );
        },
      ),
    );
  }
}

/// Individual category chip with animation.
class CategoryChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const CategoryChip({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: isSelected 
                ? AppColors.primaryGreen 
                : Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isSelected ? AppColors.primaryGreen : AppColors.divider,
            ),
          ),
          child: Center(
            child: Text(
              label,
              style: AppTypography.labelSmall(context).copyWith(
                color: isSelected 
                    ? Colors.white 
                    : isDark ? Colors.white70 : AppColors.textSecondary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
