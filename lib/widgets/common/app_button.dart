import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';

class AppButton extends StatefulWidget {
  final String label;
  final VoidCallback? onTap;
  final bool isLoading;
  final bool isFullWidth;
  final _ButtonVariant variant;
  final Widget? icon;
  final double? height;

  const AppButton.primary({
    super.key,
    required this.label,
    this.onTap,
    this.isLoading = false,
    this.isFullWidth = true,
    this.icon,
    this.height,
  }) : variant = _ButtonVariant.primary;

  const AppButton.secondary({
    super.key,
    required this.label,
    this.onTap,
    this.isLoading = false,
    this.isFullWidth = true,
    this.icon,
    this.height,
  }) : variant = _ButtonVariant.secondary;

  const AppButton.text({
    super.key,
    required this.label,
    this.onTap,
    this.isLoading = false,
    this.isFullWidth = false,
    this.icon,
    this.height,
  }) : variant = _ButtonVariant.text;

  @override
  State<AppButton> createState() => _AppButtonState();
}

enum _ButtonVariant { primary, secondary, text }

class _AppButtonState extends State<AppButton> with SingleTickerProviderStateMixin {
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.96).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails _) => _scaleController.forward();
  void _onTapUp(TapUpDetails _) => _scaleController.reverse();
  void _onTapCancel() => _scaleController.reverse();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: widget.onTap != null ? _onTapDown : null,
      onTapUp: widget.onTap != null ? _onTapUp : null,
      onTapCancel: widget.onTap != null ? _onTapCancel : null,
      onTap: widget.onTap,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: _buildButton(),
      ),
    );
  }

  Widget _buildButton() {
    switch (widget.variant) {
      case _ButtonVariant.primary:
        return _PrimaryButton(
          label: widget.label,
          isLoading: widget.isLoading,
          isFullWidth: widget.isFullWidth,
          icon: widget.icon,
          height: widget.height,
          isEnabled: widget.onTap != null,
        );
      case _ButtonVariant.secondary:
        return _SecondaryButton(
          label: widget.label,
          isLoading: widget.isLoading,
          isFullWidth: widget.isFullWidth,
          icon: widget.icon,
          height: widget.height,
        );
      case _ButtonVariant.text:
        return _TextButton(
          label: widget.label,
          isLoading: widget.isLoading,
          icon: widget.icon,
        );
    }
  }
}

class _PrimaryButton extends StatelessWidget {
  final String label;
  final bool isLoading;
  final bool isFullWidth;
  final Widget? icon;
  final double? height;
  final bool isEnabled;

  const _PrimaryButton({
    required this.label,
    required this.isLoading,
    required this.isFullWidth,
    this.icon,
    this.height,
    this.isEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: isFullWidth ? double.infinity : null,
      height: height ?? 56,
      decoration: BoxDecoration(
        color: isEnabled ? AppColors.primaryGreen : AppColors.divider,
        borderRadius: BorderRadius.circular(30),
        boxShadow: isEnabled
            ? [BoxShadow(color: AppColors.primaryGreen.withOpacity(0.3), blurRadius: 12, offset: const Offset(0, 4))]
            : null,
      ),
      child: Center(
        child: isLoading
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2.5,
                ),
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (icon != null) ...[icon!, const SizedBox(width: 8)],
                  Text(label, style: AppTypography.labelLarge(context).copyWith(color: Colors.white)),
                ],
              ),
      ),
    );
  }
}

class _SecondaryButton extends StatelessWidget {
  final String label;
  final bool isLoading;
  final bool isFullWidth;
  final Widget? icon;
  final double? height;

  const _SecondaryButton({
    required this.label,
    required this.isLoading,
    required this.isFullWidth,
    this.icon,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: isFullWidth ? double.infinity : null,
      height: height ?? 56,
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border.all(color: AppColors.primaryGreen, width: 1.5),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Center(
        child: isLoading
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  color: AppColors.primaryGreen,
                  strokeWidth: 2.5,
                ),
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (icon != null) ...[icon!, const SizedBox(width: 8)],
                  Text(label, style: AppTypography.labelLarge(context).copyWith(color: AppColors.primaryGreen)),
                ],
              ),
      ),
    );
  }
}

class _TextButton extends StatelessWidget {
  final String label;
  final bool isLoading;
  final Widget? icon;

  const _TextButton({
    required this.label,
    required this.isLoading,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[icon!, const SizedBox(width: 4)],
          Text(label, style: AppTypography.labelMedium(context).copyWith(color: AppColors.primaryGreen)),
        ],
      ),
    );
  }
}
