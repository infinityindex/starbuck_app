import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../core/theme/app_typography.dart';
import '../../../widgets/common/app_text_field.dart';

class StepOne extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController emailController;

  const StepOne({required this.nameController, required this.emailController, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "What's your name?",
            style: AppTypography.headingLarge(context),
          ).animate().fadeIn().slideY(begin: 0.2, end: 0),
          const SizedBox(height: 8),
          Text(
            'We\'d love to personalize your experience.',
            style: AppTypography.bodyMedium(
              context,
            ).copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
          ).animate(delay: 50.ms).fadeIn(),
          const SizedBox(height: 32),
          AppTextField(
            label: 'Full Name',
            hint: 'john doe',
            controller: nameController,
            prefix: const Icon(LucideIcons.user),
          ).animate(delay: 100.ms).fadeIn().slideX(begin: -0.1, end: 0),
          const SizedBox(height: 16),
          AppTextField(
            label: 'Email',
            hint: 'you@example.com',
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            prefix: const Icon(LucideIcons.mail),
          ).animate(delay: 150.ms).fadeIn().slideX(begin: -0.1, end: 0),
        ],
      ),
    );
  }
}
