import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../providers/auth_provider.dart';
import '../../router/route_names.dart';
import '../../widgets/common/app_button.dart';
import '../../widgets/common/app_text_field.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _pageController = PageController();
  int _currentStep = 0;
  bool _isLoading = false;

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _acceptTerms = false;
  bool _obscurePassword = true;

  void _nextStep() {
    if (_currentStep < 2) {
      setState(() => _currentStep++);
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      _signUp();
    }
  }

  void _prevStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
      _pageController.previousPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      context.pop();
    }
  }

  Future<void> _signUp() async {
    setState(() => _isLoading = true);
    await context.read<AuthProvider>().signUp(
      _nameController.text,
      _emailController.text,
      _passwordController.text,
    );
    if (mounted) context.go(RouteNames.home);
  }

  @override
  void dispose() {
    _pageController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          onPressed: _prevStep,
        ),
        title: Text(
          'Create Account',
          style: AppTypography.headingSmall(context),
        ),
      ),
      body: Column(
        children: [
          // Step indicator
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
            child: Row(
              children: List.generate(
                3,
                (i) => _StepDot(index: i, currentStep: _currentStep),
              ),
            ),
          ),
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _StepOne(
                  nameController: _nameController,
                  emailController: _emailController,
                ),
                _StepTwo(
                  passwordController: _passwordController,
                  obscure: _obscurePassword,
                  onToggleObscure: () =>
                      setState(() => _obscurePassword = !_obscurePassword),
                ),
                _StepThree(
                  acceptTerms: _acceptTerms,
                  onAcceptTerms: (v) =>
                      setState(() => _acceptTerms = v ?? false),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(28),
            child: AppButton.primary(
              label: _currentStep == 2 ? 'Create Account' : 'Continue',
              isLoading: _isLoading,
              onTap: _isLoading ? null : _nextStep,
            ),
          ),
        ],
      ),
    );
  }
}

class _StepDot extends StatelessWidget {
  final int index;
  final int currentStep;

  const _StepDot({required this.index, required this.currentStep});

  @override
  Widget build(BuildContext context) {
    final isCompleted = index < currentStep;
    final isActive = index == currentStep;

    return Expanded(
      child: Container(
        margin: EdgeInsets.only(right: index < 2 ? 8 : 0),
        child: Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: isCompleted || isActive
                    ? AppColors.primaryGreen
                    : AppColors.divider,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: isCompleted
                    ? const Icon(
                        Icons.check_rounded,
                        color: Colors.white,
                        size: 14,
                      )
                    : Text(
                        '${index + 1}',
                        style: TextStyle(
                          color: isActive ? Colors.white : AppColors.textHint,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
              ),
            ),
            if (index < 2)
              Expanded(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  height: 2,
                  color: isCompleted
                      ? AppColors.primaryGreen
                      : AppColors.divider,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _StepOne extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController emailController;

  const _StepOne({required this.nameController, required this.emailController});

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
            ).copyWith(color: AppColors.textSecondary),
          ).animate(delay: 50.ms).fadeIn(),
          const SizedBox(height: 32),
          AppTextField(
            label: 'Full Name',
            hint: 'CC Jr',
            controller: nameController,
            prefix: const Icon(
              Icons.person_outline,
              color: AppColors.textSecondary,
              size: 20,
            ),
          ).animate(delay: 100.ms).fadeIn().slideX(begin: -0.1, end: 0),
          const SizedBox(height: 16),
          AppTextField(
            label: 'Email',
            hint: 'you@example.com',
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            prefix: const Icon(
              Icons.email_outlined,
              color: AppColors.textSecondary,
              size: 20,
            ),
          ).animate(delay: 150.ms).fadeIn().slideX(begin: -0.1, end: 0),
        ],
      ),
    );
  }
}

class _StepTwo extends StatelessWidget {
  final TextEditingController passwordController;
  final bool obscure;
  final VoidCallback onToggleObscure;

  const _StepTwo({
    required this.passwordController,
    required this.obscure,
    required this.onToggleObscure,
  });

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
            ).copyWith(color: AppColors.textSecondary),
          ).animate(delay: 50.ms).fadeIn(),
          const SizedBox(height: 32),
          AppTextField(
            label: 'Password',
            hint: '••••••••',
            controller: passwordController,
            obscureText: obscure,
            prefix: const Icon(
              Icons.lock_outline_rounded,
              color: AppColors.textSecondary,
              size: 20,
            ),
            suffix: IconButton(
              icon: Icon(
                obscure
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                color: AppColors.textSecondary,
                size: 20,
              ),
              onPressed: onToggleObscure,
            ),
          ).animate(delay: 100.ms).fadeIn().slideX(begin: -0.1, end: 0),
        ],
      ),
    );
  }
}

class _StepThree extends StatelessWidget {
  final bool acceptTerms;
  final ValueChanged<bool?> onAcceptTerms;

  const _StepThree({required this.acceptTerms, required this.onAcceptTerms});

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
            ).copyWith(color: AppColors.textSecondary),
          ).animate(delay: 50.ms).fadeIn(),
          const SizedBox(height: 32),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Checkbox(
                  value: acceptTerms,
                  onChanged: onAcceptTerms,
                  activeColor: AppColors.primaryGreen,
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
                          ).copyWith(color: AppColors.primaryGreen),
                        ),
                        const TextSpan(text: ' and '),
                        TextSpan(
                          text: 'Privacy Policy',
                          style: AppTypography.bodyMedium(
                            context,
                          ).copyWith(color: AppColors.primaryGreen),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ).animate(delay: 100.ms).fadeIn(),
        ],
      ),
    );
  }
}
