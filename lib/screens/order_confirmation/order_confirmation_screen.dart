import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../providers/order_provider.dart';
import '../../router/route_names.dart';

class OrderConfirmationScreen extends StatefulWidget {
  const OrderConfirmationScreen({super.key});

  @override
  State<OrderConfirmationScreen> createState() => _OrderConfirmationScreenState();
}

class _OrderConfirmationScreenState extends State<OrderConfirmationScreen> {
  @override
  Widget build(BuildContext context) {
    final order = context.watch<OrderProvider>().currentOrder;

    return Scaffold(
      backgroundColor: AppColors.primaryGreen,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Success checkmark
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check_rounded,
                    color: AppColors.primaryGreen,
                    size: 56,
                  ),
                ).animate().scale(duration: 600.ms, curve: Curves.elasticOut),
                const SizedBox(height: 32),
                Text(
                  'Order Placed!',
                  style: AppTypography.displayMedium(context).copyWith(color: Colors.white),
                ).animate().fadeIn(delay: 300.ms),
                const SizedBox(height: 12),
                Text(
                  'Your order is being prepared',
                  style: AppTypography.bodyLarge(context).copyWith(color: Colors.white70),
                ).animate().fadeIn(delay: 400.ms),
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      Text('Order Number', style: AppTypography.labelSmall(context).copyWith(color: Colors.white70)),
                      const SizedBox(height: 4),
                      Text(
                        order?.id.substring(4, 10).toUpperCase() ?? 'LOADING',
                        style: AppTypography.headingLarge(context).copyWith(
                          color: Colors.white,
                          letterSpacing: 4,
                        ),
                      ),
                    ],
                  ),
                ).animate().fadeIn(delay: 500.ms),
                const SizedBox(height: 8),
                Text(
                  'Estimated time: ~${order?.estimatedMinutes ?? 5} minutes',
                  style: AppTypography.bodyMedium(context).copyWith(color: Colors.white70),
                ).animate().fadeIn(delay: 600.ms),
                const SizedBox(height: 48),
                Row(
                  children: [
                    Expanded(
                      child: _ActionButton(
                        label: 'Track Order',
                        icon: Icons.track_changes_rounded,
                        onTap: () => context.go(RouteNames.orderTracking),
                      ),
                    ).animate().fadeIn(delay: 700.ms).slideX(begin: -0.2, end: 0),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _ActionButton(
                        label: 'Back to Home',
                        icon: Icons.home_rounded,
                        isSecondary: true,
                        onTap: () => context.go(RouteNames.home),
                      ),
                    ).animate().fadeIn(delay: 700.ms).slideX(begin: 0.2, end: 0),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSecondary;
  final VoidCallback onTap;

  const _ActionButton({
    required this.label,
    required this.icon,
    this.isSecondary = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: isSecondary ? Colors.white.withOpacity(0.2) : Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSecondary ? Colors.white : AppColors.primaryGreen,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: AppTypography.labelMedium(context).copyWith(
                color: isSecondary ? Colors.white : AppColors.primaryGreen,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
