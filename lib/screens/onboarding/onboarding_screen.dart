import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../router/route_names.dart';
import '../../widgets/common/app_button.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _pageController = PageController();
  int _currentPage = 0;

  final _pages = const [
    _OnboardingData(
      title: 'Order your\nfavorite drink',
      subtitle: 'Skip the line and order ahead with the Starbucks app.',
      imageUrl: 'https://images.unsplash.com/photo-1495474472287-4d71bcdd2085?w=600',
      gradient: [Color(0xFF1E3932), Color(0xFF00704A)],
    ),
    _OnboardingData(
      title: 'Earn stars\nwith every sip',
      subtitle: 'Collect stars on every purchase and redeem them for free drinks.',
      imageUrl: 'https://images.unsplash.com/photo-1509042239860-f550ce710b93?w=600',
      gradient: [Color(0xFF2C1810), Color(0xFF8B4513)],
    ),
    _OnboardingData(
      title: 'Customize\nyour perfect cup',
      subtitle: 'Adjust size, milk, syrups and more — exactly how you like it.',
      imageUrl: 'https://images.unsplash.com/photo-1514432324607-a09d9b4aefdd?w=600',
      gradient: [Color(0xFF004E3C), Color(0xFF00704A)],
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: _pages.length,
            onPageChanged: (i) => setState(() => _currentPage = i),
            itemBuilder: (context, index) {
              return _OnboardingPage(data: _pages[index], pageController: _pageController, index: index);
            },
          ),
          // Bottom controls
          Positioned(
            left: 24,
            right: 24,
            bottom: 48,
            child: Column(
              children: [
                SmoothPageIndicator(
                  controller: _pageController,
                  count: _pages.length,
                  effect: ExpandingDotsEffect(
                    activeDotColor: AppColors.primaryGreen,
                    dotColor: AppColors.primaryGreenLight,
                    dotHeight: 8,
                    dotWidth: 8,
                    expansionFactor: 4,
                  ),
                ),
                const SizedBox(height: 24),
                if (_currentPage == _pages.length - 1)
                  AppButton.primary(
                    label: 'Get Started',
                    onTap: () => context.go(RouteNames.login),
                  ).animate().fadeIn(duration: 300.ms)
                else
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _TextButton(label: 'Skip', onTap: () => context.go(RouteNames.login)),
                      GestureDetector(
                        onTap: () => _pageController.nextPage(
                          duration: const Duration(milliseconds: 400),
                          curve: Curves.easeInOut,
                        ),
                        child: Container(
                          width: 56,
                          height: 56,
                          decoration: const BoxDecoration(
                            color: AppColors.primaryGreen,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.arrow_forward_rounded, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TextButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const _TextButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(label, style: AppTypography.labelMedium(context).copyWith(color: AppColors.textSecondary)),
      ),
    );
  }
}

class _OnboardingData {
  final String title;
  final String subtitle;
  final String imageUrl;
  final List<Color> gradient;

  const _OnboardingData({
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    required this.gradient,
  });
}

class _OnboardingPage extends StatelessWidget {
  final _OnboardingData data;
  final PageController pageController;
  final int index;

  const _OnboardingPage({
    required this.data,
    required this.pageController,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background image with gradient
        Positioned.fill(
          child: AnimatedBuilder(
            animation: pageController,
            builder: (context, child) {
              double page = 0;
              try {
                page = pageController.page ?? index.toDouble();
              } catch (_) {
                page = index.toDouble();
              }
              final offset = (page - index) * 80;
              return Transform.translate(
                offset: Offset(offset, 0),
                child: child,
              );
            },
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: data.gradient,
                ),
              ),
              child: Opacity(
                opacity: 0.4,
                child: Image.network(
                  data.imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                ),
              ),
            ),
          ),
        ),
        // White bottom card
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: Container(
            padding: const EdgeInsets.fromLTRB(28, 32, 28, 140),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.title,
                  style: AppTypography.displayMedium(context),
                ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.2, end: 0),
                const SizedBox(height: 12),
                Text(
                  data.subtitle,
                  style: AppTypography.bodyLarge(context).copyWith(color: AppColors.textSecondary),
                ).animate(delay: 100.ms).fadeIn(duration: 400.ms).slideY(begin: 0.2, end: 0),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
