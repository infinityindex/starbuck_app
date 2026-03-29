import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../router/route_names.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<_OnboardingData> _pages = const [
    _OnboardingData(
      title: 'Order your\nfavorite drink',
      subtitle: 'Skip the line and order ahead with the Starbucks app.',
      imageUrl:
          'https://images.unsplash.com/photo-1495474472287-4d71bcdd2085?w=1200',
      gradient: [Color(0xFF1E3932), Color(0xFF00704A)],
    ),
    _OnboardingData(
      title: 'Earn stars\nwith every sip',
      subtitle:
          'Collect stars on every purchase and redeem them for free drinks.',
      imageUrl:
          'https://images.unsplash.com/photo-1509042239860-f550ce710b93?w=1200',
      gradient: [Color(0xFF2C1810), Color(0xFF8B4513)],
    ),
    _OnboardingData(
      title: 'Customize\nyour perfect cup',
      subtitle: 'Adjust size, milk, syrups and more — exactly how you like it.',
      imageUrl:
          'https://images.unsplash.com/photo-1514432324607-a09d9b4aefdd?w=1200',
      gradient: [Color(0xFF004E3C), Color(0xFF00704A)],
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _goNext() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      context.go(RouteNames.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    final surface = Theme.of(context).colorScheme.surface;
    return Scaffold(
      backgroundColor: Colors.black,
      bottomSheet: SafeArea(
        top: false,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
          decoration: BoxDecoration(
            color: surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 12,
                offset: const Offset(0, -6),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: Column(
                  key: ValueKey<int>(_currentPage),
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _pages[_currentPage].title,
                      style: AppTypography.displayMedium(context),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _pages[_currentPage].subtitle,
                      style: AppTypography.bodyLarge(
                        context,
                      ).copyWith(color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              Container(
                alignment: Alignment.center,
                child: SmoothPageIndicator(
                  controller: _pageController,
                  count: _pages.length,
                  effect: ExpandingDotsEffect(
                    activeDotColor: AppColors.primaryGreen,
                    dotColor: AppColors.primaryGreenLight,
                    dotHeight: 8,
                    dotWidth: 8,
                    expansionFactor: 3,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              FilledButton(
                onPressed: _goNext,
                style: FilledButton.styleFrom(
                  minimumSize: const Size.fromHeight(56),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  _currentPage == _pages.length - 1 ? 'Get Started' : 'Next',
                ),
              ),
            ],
          ),
        ),
      ),
      body: PageView.builder(
        controller: _pageController,
        itemCount: _pages.length,
        onPageChanged: (i) => setState(() => _currentPage = i),
        itemBuilder: (context, index) {
          final page = _pages[index];
          return _OnboardingPage(
            data: page,
            index: index,
            controller: _pageController,
          );
        },
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
  final int index;
  final PageController controller;
  const _OnboardingPage({
    required this.data,
    required this.index,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.network(
          data.imageUrl,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => const SizedBox.shrink(),
        ),
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                data.gradient.first.withOpacity(0.45),
                Colors.transparent,
              ],
            ),
          ),
        ),
      ],
    );
  }
}
