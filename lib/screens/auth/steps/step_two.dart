import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../core/theme/app_typography.dart';
import '../../../widgets/common/app_text_field.dart';

class StepTwo extends StatelessWidget {
  final TextEditingController passwordController;
  final bool obscure;
  final VoidCallback onToggleObscure;

  const StepTwo({required this.passwordController, required this.obscure, required this.onToggleObscure, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Create a password',
            style: AppTypography.headingLarge(context),
          ).animate().fadeIn().slideY(begin: 0.2, end: 0),
          const SizedBox(height: 8),
          Text(
            'At least 8 characters with a number.',
            style: AppTypography.bodyMedium(
              context,
            ).copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
          ).animate(delay: 50.ms).fadeIn(),
          const SizedBox(height: 32),
          AppTextField(
            label: 'Password',
            hint: '••••••••',
            controller: passwordController,
            obscureText: obscure,
            prefix: const Icon(LucideIcons.lock),
            suffix: IconButton(
              icon: Icon(obscure ? LucideIcons.eyeOff : LucideIcons.eye),
              onPressed: onToggleObscure,
            ),
          ).animate(delay: 100.ms).fadeIn().slideX(begin: -0.1, end: 0),
        ],
      ),
    );
  }
}
