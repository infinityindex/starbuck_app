import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../router/route_names.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _bgController;
  late AnimationController _logoController;
  late Animation<Color?> _bgColorAnim;
  late Animation<double> _logoScaleAnim;
  late Animation<double> _logoOpacityAnim;

  @override
  void initState() {
    super.initState();

    _bgController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );
    _bgColorAnim =
        ColorTween(
          begin: AppColors.surface,
          end: AppColors.primaryGreen,
        ).animate(
          CurvedAnimation(
            parent: _bgController,
            curve: Curves.easeInOutCubicEmphasized,
          ),
        );

    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );

    _logoScaleAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: const Cubic(0.05, 0.7, 0.1, 1.0),
      ),
    );

    _logoOpacityAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: const Interval(0.0, 0.65, curve: Curves.easeOut),
      ),
    );

    _bgController.forward();
    _logoController.forward();

    Future.delayed(const Duration(milliseconds: 2800), () {
      if (mounted) context.go(RouteNames.onboarding);
    });
  }

  @override
  void dispose() {
    _bgController.dispose();
    _logoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_bgColorAnim, _logoController]),
      builder: (context, child) => Scaffold(
        backgroundColor: _bgColorAnim.value,
        body: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    _bgColorAnim.value ?? AppColors.primaryGreen,
                    (_bgColorAnim.value ?? AppColors.primaryGreen).withValues(
                      alpha: 0.85,
                    ),
                  ],
                ),
              ),
            ),

            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimatedBuilder(
                    animation: _logoController,
                    builder: (context, child) => Transform.scale(
                      scale: _logoScaleAnim.value,
                      child: Opacity(
                        opacity: _logoOpacityAnim.value,
                        child: const Icon(
                          LucideIcons.coffee,
                          color: AppColors.surface,
                          size: 80,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),

                  Text(
                        'STARBUCKS',
                        style: AppTypography.headingLarge(context).copyWith(
                          color: AppColors.surface,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 8,
                          height: 1.2,
                        ),
                      )
                      .animate(delay: 400.ms)
                      .fadeIn(duration: 600.ms, curve: Curves.easeOut)
                      .slideY(
                        begin: 0.2,
                        end: 0,
                        duration: 700.ms,
                        curve: Curves.easeOutCubic,
                      ),

                  const SizedBox(height: 12),

                  Text(
                        'Brewed for you',
                        style: AppTypography.bodyMedium(context).copyWith(
                          color: AppColors.surface.withValues(alpha: 0.85),
                          letterSpacing: 3,
                          fontWeight: FontWeight.w400,
                        ),
                      )
                      .animate(delay: 800.ms)
                      .fadeIn(duration: 500.ms, curve: Curves.easeOut)
                      .slideY(
                        begin: 0.15,
                        end: 0,
                        duration: 600.ms,
                        curve: Curves.easeOutCubic,
                      ),
                ],
              ),
            ),

            Positioned(
              bottom: 64,
              left: 0,
              right: 0,
              child: Center(
                child:
                    SizedBox(
                          width: 40,
                          height: 40,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              AppColors.surface.withValues(alpha: 0.4),
                            ),
                          ),
                        )
                        .animate(delay: 1200.ms)
                        .fadeIn(duration: 400.ms, curve: Curves.easeOut),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
