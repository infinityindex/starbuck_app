import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'dart:async';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../data/mock/mock_drinks.dart';
import '../../data/models/drink_model.dart';
import '../../router/route_names.dart';
import '../../widgets/cards/drink_card.dart';
import '../../widgets/cards/featured_drink_card.dart';
import '../../widgets/animations/shimmer_wrapper.dart';
import '../../widgets/common/category_filter.dart';
import '../../widgets/common/app_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _featuredController = PageController(viewportFraction: 0.88);
  int _featuredPage = 0;
  String _selectedCategory = 'All';
  bool _isLoaded = false;
  Timer? _autoScrollTimer;

  // Cache featured drinks to avoid recomputing
  late final List<DrinkModel> _featured;

  @override
  void initState() {
    super.initState();
    _featured = mockDrinks.where((d) => d.isFeatured).toList();

    // Simulate loading delay
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) setState(() => _isLoaded = true);
    });

    // Auto-scroll carousel
    _autoScrollTimer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (_featuredController.hasClients && _featured.isNotEmpty) {
        final next = (_featuredPage + 1) % _featured.length;
        _featuredController.animateToPage(
          next,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _featuredController.dispose();
    _autoScrollTimer?.cancel();
    super.dispose();
  }

  List<DrinkModel> get _filteredDrinks {
    if (_selectedCategory == 'All') return mockDrinks;
    return mockDrinks.where((d) => d.category == _selectedCategory).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: CustomScrollView(
        slivers: [
          _buildHeader(context),
          _buildFeaturedSection(context),
          _buildMenuSection(context),
          _buildDrinksGrid(context),
          const SliverToBoxAdapter(child: SizedBox(height: 24)),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final greeting = _getGreeting();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          24,
          MediaQuery.of(context).padding.top + 16,
          24,
          16,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  greeting,
                  style: AppTypography.bodyMedium(context).copyWith(
                    color: isDark ? Colors.white70 : AppColors.textSecondary,
                  ),
                ),
                Text('CC Jr', style: AppTypography.headingMedium(context)),
              ],
            ).animate().fadeIn(delay: 100.ms),
            Row(
              children: [
                AppIconButton(
                  icon: Icons.location_on_outlined,
                  onTap: () => context.push(RouteNames.storeLocator),
                ),
                const SizedBox(width: 8),
                AppIconButton(
                  icon: Icons.notifications_outlined,
                  onTap: () => context.push(RouteNames.notifications),
                  badge: const NotificationBadge(),
                ),
              ],
            ).animate().fadeIn(delay: 100.ms),
          ],
        ),
      ),
    );
  }

  Widget _buildFeaturedSection(BuildContext context) {
    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 12),
            child: Text(
              'Featured',
              style: AppTypography.headingSmall(context),
            ).animate().fadeIn(delay: 200.ms),
          ),
          SizedBox(
            height: 220,
            child: PageView.builder(
              controller: _featuredController,
              itemCount: _featured.length,
              onPageChanged: (i) => setState(() => _featuredPage = i),
              itemBuilder: (context, index) {
                return FeaturedDrinkCard(
                  drink: _featured[index],
                  onTap: () => context.push(
                    RouteNames.productDetail,
                    extra: _featured[index],
                  ),
                );
              },
            ),
          ).animate().fadeIn(delay: 250.ms),
          const SizedBox(height: 8),
          _PageIndicator(count: _featured.length, currentPage: _featuredPage),
        ],
      ),
    );
  }

  Widget _buildMenuSection(BuildContext context) {
    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 12),
            child: Text(
              'Our Menu',
              style: AppTypography.headingSmall(context),
            ).animate().fadeIn(delay: 300.ms),
          ),
          CategoryFilter(
            categories: mockCategories,
            selectedCategory: _selectedCategory,
            onCategorySelected: (cat) =>
                setState(() => _selectedCategory = cat),
            height: 40,
          ).animate().fadeIn(delay: 350.ms),
        ],
      ),
    );
  }

  Widget _buildDrinksGrid(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.all(16),
      sliver: _isLoaded
          ? SliverGrid(
              delegate: SliverChildBuilderDelegate((context, index) {
                final drink = _filteredDrinks[index];
                return DrinkCard(
                      key: ValueKey(drink.id),
                      drink: drink,
                      onTap: () =>
                          context.push(RouteNames.productDetail, extra: drink),
                    )
                    .animate(delay: (index * 50).ms)
                    .fadeIn()
                    .slideY(begin: 0.2, end: 0);
              }, childCount: _filteredDrinks.length),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.75,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
              ),
            )
          : SliverGrid(
              delegate: SliverChildBuilderDelegate(
                (context, index) => const ShimmerDrinkCard(),
                childCount: 6,
              ),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.75,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
              ),
            ),
    );
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 17) return 'Good afternoon';
    return 'Good evening';
  }
}

/// Page indicator dots for carousels.
class _PageIndicator extends StatelessWidget {
  final int count;
  final int currentPage;

  const _PageIndicator({required this.count, required this.currentPage});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        count,
        (i) => AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.symmetric(horizontal: 3),
          width: i == currentPage ? 20 : 6,
          height: 6,
          decoration: BoxDecoration(
            color: i == currentPage
                ? AppColors.primaryGreen
                : AppColors.primaryGreenLight,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
      ),
    );
  }
}
