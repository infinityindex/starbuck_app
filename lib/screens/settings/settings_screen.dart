import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../providers/theme_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  Color _secondaryColor(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? Colors.white70 : AppColors.textSecondary;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text('Settings', style: AppTypography.headingMedium(context)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _SettingsSection(
            title: 'Notifications',
            items: [
              _SettingsItemData(
                icon: Icons.notifications_rounded,
                label: 'Push Notifications',
                trailing: Switch(value: true, onChanged: (_) {}),
              ),
              _SettingsItemData(
                icon: Icons.email_rounded,
                label: 'Email Offers',
                trailing: Switch(value: true, onChanged: (_) {}),
              ),
              _SettingsItemData(
                icon: Icons.local_cafe_rounded,
                label: 'Order Updates',
                trailing: Switch(value: true, onChanged: (_) {}),
              ),
            ],
          ).animate().fadeIn(),
          const SizedBox(height: 24),

          _SettingsSection(
            title: 'Privacy',
            items: [
              _SettingsItemData(
                icon: Icons.location_on_rounded,
                label: 'Location Services',
                trailing: Switch(value: true, onChanged: (_) {}),
              ),
              _SettingsItemData(
                icon: Icons.analytics_rounded,
                label: 'Analytics',
                trailing: Switch(value: false, onChanged: (_) {}),
              ),
            ],
          ).animate().fadeIn(delay: 100.ms),
          const SizedBox(height: 24),

          _DarkModeSetting().animate().fadeIn(delay: 200.ms),
          const SizedBox(height: 24),

          _SettingsSection(
            title: 'About',
            items: [
              _SettingsItemData(
                icon: Icons.info_rounded,
                label: 'App Version',
                trailing: Text('1.0.0', style: AppTypography.bodyMedium(context).copyWith(color: _secondaryColor(context))),
              ),
            ],
          ).animate().fadeIn(delay: 300.ms),
        ],
      ),
    );
  }
}

class _SettingsItemData {
  final IconData icon;
  final String label;
  final Widget trailing;

  _SettingsItemData({
    required this.icon,
    required this.label,
    required this.trailing,
  });
}

class _SettingsSection extends StatelessWidget {
  final String title;
  final List<_SettingsItemData> items;

  const _SettingsSection({
    required this.title,
    required this.items,
  });

  Color _hintColor(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? Colors.white54 : AppColors.textHint;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(4, 0, 0, 8),
          child: Text(title, style: AppTypography.labelSmall(context).copyWith(color: _hintColor(context))),
        ),
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              for (var i = 0; i < items.length; i++)
                Column(
                  children: [
                    _SettingsItem(
                      icon: items[i].icon,
                      label: items[i].label,
                      trailing: items[i].trailing,
                    ),
                    if (i < items.length - 1) Divider(
                      height: 1,
                      indent: 56,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white12
                          : AppColors.divider,
                    ),
                  ],
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SettingsItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final Widget trailing;

  const _SettingsItem({
    required this.icon,
    required this.label,
    required this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: isDark ? AppColors.primaryGreen.withValues(alpha: 0.2) : AppColors.primaryGreenLight,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: AppColors.primaryGreen, size: 18),
      ),
      title: Text(label, style: AppTypography.bodyMedium(context)),
      trailing: trailing,
    );
  }
}

class _DarkModeSetting extends StatelessWidget {
  Color _hintColor(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? Colors.white54 : AppColors.textHint;

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, theme, _) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(4, 0, 0, 8),
              child: Text('Appearance', style: AppTypography.labelSmall(context).copyWith(color: _hintColor(context))),
            ),
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(16),
              ),
              child: _SettingsItem(
                icon: Icons.dark_mode_rounded,
                label: 'Dark Mode',
                trailing: Switch(
                  value: theme.isDark,
                  onChanged: (_) => theme.toggleTheme(),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
