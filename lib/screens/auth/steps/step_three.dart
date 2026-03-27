import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../core/theme/app_typography.dart';

class StepThree extends StatelessWidget {
  final bool acceptTerms;
  final ValueChanged<bool?> onAcceptTerms;

  const StepThree({required this.acceptTerms, required this.onAcceptTerms, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Almost there!',
            style: AppTypography.headingLarge(context),
          ).animate().fadeIn().slideY(begin: 0.2, end: 0),
          const SizedBox(height: 8),
          Text(
            'Review and accept our terms.',
            style: AppTypography.bodyMedium(
              context,
            ).copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
          ).animate(delay: 50.ms).fadeIn(),
          const SizedBox(height: 32),
          GestureDetector(
            onTap: () => onAcceptTerms(!acceptTerms),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Checkbox(
                    value: acceptTerms,
                    onChanged: onAcceptTerms,
                    activeColor: Theme.of(context).colorScheme.primary,
                  ),
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        text: 'I agree to the ',
                        style: AppTypography.bodyMedium(context),
                        children: [
                          TextSpan(
                            text: 'Terms of Service',
                            style: AppTypography.bodyMedium(
                              context,
                            ).copyWith(color: Theme.of(context).colorScheme.primary),
                          ),
                          const TextSpan(text: ' and '),
                          TextSpan(
                            text: 'Privacy Policy',
                            style: AppTypography.bodyMedium(
                              context,
                            ).copyWith(color: Theme.of(context).colorScheme.primary),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ).animate(delay: 100.ms).fadeIn(),
        ],
      ),
    );
  }
}
