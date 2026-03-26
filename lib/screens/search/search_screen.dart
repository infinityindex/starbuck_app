import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../data/mock/mock_drinks.dart';
import '../../data/models/drink_model.dart';
import '../../router/route_names.dart';
import '../../widgets/cards/drink_list_tile.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();
  List<DrinkModel> _results = [];
  final List<String> _recentSearches = ['Latte', 'Cold Brew', 'Matcha'];

  @override
  void initState() {
    super.initState();
    _focusNode.requestFocus();
    _results = mockDrinks;
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onSearch(String query) {
    setState(() {
      if (query.isEmpty) {
        _results = mockDrinks;
      } else {
        final lowerQuery = query.toLowerCase();
        _results = mockDrinks.where((d) =>
          d.name.toLowerCase().contains(lowerQuery) ||
          d.category.toLowerCase().contains(lowerQuery)
        ).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          onPressed: () => context.pop(),
        ),
        title: _SearchField(
          controller: _controller,
          focusNode: _focusNode,
          onChanged: _onSearch,
          isDark: isDark,
        ),
      ),
      body: _controller.text.isEmpty ? _buildSuggestions() : _buildResults(),
    );
  }

  Widget _buildSuggestions() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_recentSearches.isNotEmpty) ...[
            Text('Recent Searches', style: AppTypography.labelMedium(context)).animate().fadeIn(),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _recentSearches.asMap().entries.map((entry) {
                return _SearchChip(
                  label: entry.value,
                  onTap: () {
                    _controller.text = entry.value;
                    _onSearch(entry.value);
                  },
                ).animate().fadeIn(delay: (entry.key * 50).ms);
              }).toList(),
            ),
            const SizedBox(height: 32),
          ],
          Text('Popular Now', style: AppTypography.labelMedium(context)).animate().fadeIn(delay: 100.ms),
          const SizedBox(height: 12),
          ...mockDrinks.take(5).map((drink) {
            return DrinkListTile(
              drink: drink,
              showDescription: false,
              showCategory: true,
              onTap: () => context.push(RouteNames.productDetail, extra: drink),
            ).animate(delay: 100.ms).fadeIn().slideX(begin: 0.1, end: 0);
          }),
        ],
      ),
    );
  }

  Widget _buildResults() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    if (_results.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off_rounded,
              size: 64,
              color: isDark ? Colors.white54 : AppColors.textHint,
            ),
            const SizedBox(height: 16),
            Text('No drinks found', style: AppTypography.headingMedium(context)),
            const SizedBox(height: 8),
            Text(
              'Try a different search term',
              style: AppTypography.bodyMedium(context).copyWith(
                color: isDark ? Colors.white70 : AppColors.textSecondary,
              ),
            ),
          ],
        ).animate().fadeIn(),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _results.length,
      itemBuilder: (context, index) {
        final drink = _results[index];
        return DrinkListTile(
          key: ValueKey(drink.id),
          drink: drink,
          showDescription: false,
          showCategory: true,
          onTap: () => context.push(RouteNames.productDetail, extra: drink),
        ).animate(delay: (index * 30).ms).fadeIn().slideX(begin: 0.1, end: 0);
      },
    );
  }
}

/// Search input field.
class _SearchField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String> onChanged;
  final bool isDark;

  const _SearchField({
    required this.controller,
    required this.focusNode,
    required this.onChanged,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final hintColor = isDark ? Colors.white54 : AppColors.textHint;
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(Icons.search, color: hintColor, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: controller,
              focusNode: focusNode,
              onChanged: onChanged,
              decoration: InputDecoration(
                hintText: 'Search drinks...',
                hintStyle: TextStyle(color: hintColor),
                border: InputBorder.none,
                isDense: true,
              ),
              style: AppTypography.bodyMedium(context),
            ),
          ),
          if (controller.text.isNotEmpty)
            IconButton(
              icon: Icon(Icons.clear_rounded, color: hintColor, size: 18),
              onPressed: () {
                controller.clear();
                onChanged('');
              },
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
            ),
        ],
      ),
    );
  }
}

/// Search history chip.
class _SearchChip extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _SearchChip({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: isDark ? Colors.white24 : AppColors.divider),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: AppTypography.labelSmall(context).copyWith(
                color: isDark ? Colors.white70 : AppColors.textSecondary,
              ),
            ),
            const SizedBox(width: 4),
            Icon(
              Icons.close_rounded,
              size: 14,
              color: isDark ? Colors.white54 : AppColors.textHint,
            ),
          ],
        ),
      ),
    );
  }
}
