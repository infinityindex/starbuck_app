import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../router/route_names.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late AnimationController _bgController;
  late Animation<Color?> _bgColorAnim;

  @override
  void initState() {
    super.initState();
    _bgController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _bgColorAnim = ColorTween(
      begin: Colors.white,
      end: AppColors.primaryGreen,
    ).animate(CurvedAnimation(parent: _bgController, curve: Curves.easeInOut));

    _bgController.forward();
    Future.delayed(const Duration(milliseconds: 2500), () {
      if (mounted) context.go(RouteNames.onboarding);
    });
  }

  @override
  void dispose() {
    _bgController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _bgColorAnim,
      builder: (context, child) => Scaffold(
        backgroundColor: _bgColorAnim.value,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Siren icon (using a coffee icon as placeholder for the SVG)
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 30,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.local_cafe_rounded,
                  color: AppColors.primaryGreen,
                  size: 52,
                ),
              )
                  .animate()
                  .scale(
                    duration: 1200.ms,
                    curve: Curves.elasticOut,
                    begin: const Offset(0, 0),
                    end: const Offset(1, 1),
                  )
                  .fadeIn(duration: 600.ms),
              const SizedBox(height: 24),
              Text(
                'STARBUCKS',
                style: AppTypography.headingLarge(context).copyWith(
                  color: Colors.white,
                  letterSpacing: 6,
                ),
              )
                  .animate(delay: 600.ms)
                  .fadeIn(duration: 600.ms)
                  .slideY(begin: 0.3, end: 0, curve: Curves.easeOut),
              const SizedBox(height: 8),
              Text(
                'Brewed for you',
                style: AppTypography.bodyMedium(context).copyWith(
                  color: Colors.white70,
                  letterSpacing: 2,
                ),
              )
                  .animate(delay: 900.ms)
                  .fadeIn(duration: 500.ms),
            ],
          ),
        ),
      ),
    );
  }
}
