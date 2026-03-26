import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../data/mock/mock_user.dart';
import '../../providers/theme_provider.dart';
import '../../router/route_names.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: CustomScrollView(
        slivers: [
          // Header
          SliverToBoxAdapter(
            child: Container(
              padding: EdgeInsets.fromLTRB(24, MediaQuery.of(context).padding.top + 16, 24, 24),
              color: Theme.of(context).scaffoldBackgroundColor,
              child: Column(
                children: [
                  Row(
                    children: [
                      // Avatar
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: AppColors.primaryGreenLight,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primaryGreen.withValues(alpha: 0.2),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: ClipOval(
                          child: Image.network(
                            mockUser.avatarUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => const Icon(
                              Icons.person_rounded,
                              color: AppColors.primaryGreen,
                              size: 40,
                            ),
                          ),
                        ),
                      ).animate().scale(duration: 500.ms, curve: Curves.elasticOut),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(mockUser.name, style: AppTypography.headingMedium(context))
                                .animate().fadeIn(delay: 100.ms),
                            const SizedBox(height: 4),
                            Text(
                              'Member since ${mockUser.memberSince.year}',
                              style: AppTypography.bodyMedium(context).copyWith(
                                color: isDark ? Colors.white70 : AppColors.textSecondary,
                              ),
                            ).animate().fadeIn(delay: 150.ms),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.secondaryGold,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.secondaryGold.withValues(alpha: 0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.star_rounded, color: Colors.white, size: 14),
                            const SizedBox(width: 4),
                            Text(mockUser.tier, style: AppTypography.labelSmall(context).copyWith(color: Colors.white)),
                          ],
                        ),
                      ).animate().fadeIn(delay: 200.ms),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Menu items
          SliverList(
            delegate: SliverChildListDelegate([
              const SizedBox(height: 16),
              // Activity Block
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                decoration: BoxDecoration(
                  color: isDark ? Theme.of(context).colorScheme.surface : AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    _MenuItem(
                      icon: Icons.history_rounded,
                      iconColor: AppColors.primaryGreen,
                      label: 'Order History',
                      onTap: () => context.push(RouteNames.orderHistory),
                    ),
                    Divider(height: 1, color: isDark ? Colors.white10 : AppColors.divider),
                    _MenuItem(
                      icon: Icons.credit_card_rounded,
                      iconColor: AppColors.secondaryGold,
                      label: 'Payment Methods',
                      onTap: () {},
                    ),
                    Divider(height: 1, color: isDark ? Colors.white10 : AppColors.divider),
                    _MenuItem(
                      icon: Icons.store_rounded,
                      iconColor: Colors.orange,
                      label: 'Store Locator',
                      onTap: () => context.push(RouteNames.storeLocator),
                    ),
                  ],
                ),
              ).animate().fadeIn(delay: 100.ms).slideY(begin: 0.1),

              // Settings Block
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                decoration: BoxDecoration(
                  color: isDark ? Theme.of(context).colorScheme.surface : AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    _MenuItem(
                      icon: Icons.notifications_rounded,
                      iconColor: Colors.purple,
                      label: 'Notifications',
                      badge: '3',
                      onTap: () => context.push(RouteNames.notifications),
                    ),
                    Divider(height: 1, color: isDark ? Colors.white10 : AppColors.divider),
                    _MenuItem(
                      icon: Icons.settings_rounded,
                      iconColor: isDark ? Colors.white70 : AppColors.textSecondary,
                      label: 'Settings',
                      onTap: () => context.push(RouteNames.settings),
                    ),
                    Divider(height: 1, color: isDark ? Colors.white10 : AppColors.divider),
                    Consumer<ThemeProvider>(
                      builder: (context, theme, _) {
                        return _MenuItem(
                          icon: theme.isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
                          iconColor: theme.isDark ? Colors.amber : Colors.indigo,
                          label: theme.isDark ? 'Light Mode' : 'Dark Mode',
                          trailing: Switch(
                            value: theme.isDark,
                            onChanged: (_) => theme.toggleTheme(),
                            activeColor: AppColors.primaryGreen,
                          ),
                          onTap: () => theme.toggleTheme(),
                        );
                      },
                    ),
                  ],
                ),
              ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.1),

              // Account Block
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                decoration: BoxDecoration(
                  color: isDark ? Theme.of(context).colorScheme.surface : AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: _MenuItem(
                  icon: Icons.logout_rounded,
                  iconColor: AppColors.error,
                  label: 'Sign Out',
                  onTap: () => context.go('/login'),
                ),
              ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.1),

              const SizedBox(height: 24),
            ]),
          ),
        ],
      ),
    );
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String? badge;
  final Widget? trailing;
  final VoidCallback onTap;

  const _MenuItem({
    required this.icon,
    required this.iconColor,
    required this.label,
    this.badge,
    this.trailing,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: iconColor.withValues(alpha: 0.15),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: iconColor, size: 20),
      ),
      title: Text(
        label, 
        style: AppTypography.bodyMedium(context).copyWith(
          color: isDark ? Colors.white : AppColors.textPrimary,
        ),
      ),
      trailing: trailing ?? Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (badge != null)
            Container(
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.error,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(badge!, style: AppTypography.caption(context).copyWith(color: Colors.white)),
            ),
          Icon(
            Icons.arrow_forward_ios_rounded, 
            size: 16, 
            color: isDark ? Colors.white30 : AppColors.textHint,
          ),
        ],
      ),
    );
  }
}
