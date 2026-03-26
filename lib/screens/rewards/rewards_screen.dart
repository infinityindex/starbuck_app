import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../data/models/reward_model.dart';
import '../../providers/rewards_provider.dart';

class RewardsScreen extends StatelessWidget {
  const RewardsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<RewardsProvider>(
      builder: (context, rewards, _) {
        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          body: CustomScrollView(
            slivers: [
              // Header with progress
              SliverToBoxAdapter(
                child: Container(
                  padding: EdgeInsets.fromLTRB(24, MediaQuery.of(context).padding.top + 16, 24, 32),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [AppColors.primaryGreenDark, AppColors.primaryGreen],
                    ),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Rewards', style: AppTypography.headingLarge(context).copyWith(color: Colors.white)),
                          GestureDetector(
                            onTap: () => _showRedeemedRewards(context, rewards),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.card_giftcard, color: Colors.white, size: 16),
                                  const SizedBox(width: 6),
                                  Text(
                                    'My Rewards',
                                    style: AppTypography.labelSmall(context).copyWith(color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ).animate().fadeIn(),
                      const SizedBox(height: 24),
                      // Progress ring
                      TweenAnimationBuilder<double>(
                        tween: Tween(begin: 0.0, end: rewards.progressToNextTier),
                        duration: const Duration(milliseconds: 1500),
                        curve: Curves.easeOutCubic,
                        builder: (context, value, child) {
                          return SizedBox(
                            width: 180,
                            height: 180,
                            child: CustomPaint(
                              painter: _ProgressRingPainter(progress: value),
                              child: Center(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    TweenAnimationBuilder<double>(
                                      tween: Tween(begin: 0, end: rewards.stars.toDouble()),
                                      duration: const Duration(milliseconds: 1800),
                                      curve: Curves.easeOutCubic,
                                      builder: (context, stars, _) {
                                        return Text(
                                          stars.toInt().toString(),
                                          style: AppTypography.displayLarge(context).copyWith(
                                            color: Colors.white,
                                            fontSize: 48,
                                          ),
                                        );
                                      },
                                    ),
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Icon(Icons.star_rounded, color: AppColors.starGold, size: 16),
                                        const SizedBox(width: 4),
                                        Text(
                                          'Stars',
                                          style: AppTypography.labelMedium(context).copyWith(color: Colors.white70),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      rewards.tier,
                                      style: AppTypography.bodySmall(context).copyWith(color: AppColors.secondaryGold),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 16),
                      if (rewards.starsToNextTier > 0)
                        Text(
                          '${rewards.starsToNextTier} stars to next level',
                          style: AppTypography.bodyMedium(context).copyWith(color: Colors.white70),
                        ).animate().fadeIn(delay: 300.ms)
                      else
                        Text(
                          'You\'re at maximum tier! 🎉',
                          style: AppTypography.bodyMedium(context).copyWith(color: Colors.white70),
                        ).animate().fadeIn(delay: 300.ms),
                    ],
                  ),
                ),
              ),

              // Rewards list
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Text('Redeem Rewards', style: AppTypography.headingMedium(context))
                      .animate().fadeIn(delay: 200.ms),
                ),
              ),

              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final reward = rewards.availableRewards[index];
                      return _RewardCard(
                        reward: reward,
                        userStars: rewards.stars,
                        onRedeem: () => _showRedeemConfirmation(context, reward, rewards),
                      ).animate(delay: (index * 80).ms).fadeIn().slideY(begin: 0.15, end: 0);
                    },
                    childCount: rewards.availableRewards.length,
                  ),
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 24)),
            ],
          ),
        );
      },
    );
  }

  void _showRedeemConfirmation(BuildContext context, RewardModel reward, RewardsProvider rewards) {
    if (!rewards.canRedeem(reward)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Not enough stars to redeem this reward',
            style: AppTypography.labelMedium(context).copyWith(color: Colors.white),
          ),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _RedeemConfirmationSheet(
        reward: reward,
        onConfirm: () {
          Navigator.pop(context);
          final success = rewards.redeemReward(reward);
          if (success) {
            _showRedeemSuccess(context, reward, rewards.stars);
          }
        },
      ),
    );
  }

  void _showRedeemSuccess(BuildContext context, RewardModel reward, int remainingStars) {
    showDialog(
      context: context,
      builder: (context) => _RedeemSuccessDialog(
        reward: reward,
        remainingStars: remainingStars,
      ),
    );
  }

  void _showRedeemedRewards(BuildContext context, RewardsProvider rewards) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _RedeemedRewardsSheet(rewards: rewards),
    );
  }
}

class _ProgressRingPainter extends CustomPainter {
  final double progress;

  _ProgressRingPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 8;
    const strokeWidth = 12.0;

    // Background ring
    final bgPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;
    canvas.drawCircle(center, radius, bgPaint);

    // Progress ring
    final progressPaint = Paint()
      ..color = AppColors.starGold
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;
    final sweepAngle = 2 * math.pi * progress;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      sweepAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _ProgressRingPainter old) => progress != old.progress;
}

class _RewardCard extends StatelessWidget {
  final RewardModel reward;
  final int userStars;
  final VoidCallback onRedeem;

  const _RewardCard({
    required this.reward,
    required this.userStars,
    required this.onRedeem,
  });

  @override
  Widget build(BuildContext context) {
    final isAvailable = reward.isAvailable;
    final canAfford = userStars >= reward.starCost;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: isAvailable && canAfford ? onRedeem : null,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
          border: isAvailable && canAfford
              ? Border.all(color: AppColors.primaryGreen.withValues(alpha: 0.3), width: 1.5)
              : Border.all(color: AppColors.divider),
        ),
        child: Row(
          children: [
            // Image
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                color: isAvailable && canAfford
                    ? AppColors.primaryGreenLight
                    : (isDark ? Colors.white12 : AppColors.divider.withValues(alpha: 0.3)),
                borderRadius: BorderRadius.circular(16),
              ),
              child: isAvailable && canAfford
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.network(
                        reward.imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => const Icon(Icons.local_cafe, color: AppColors.primaryGreen),
                      ),
                    )
                  : Icon(
                      isAvailable ? Icons.stars_rounded : Icons.lock_rounded,
                      color: isDark ? Colors.white24 : AppColors.textHint,
                    ),
            ),
            const SizedBox(width: 16),
            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    reward.title,
                    style: AppTypography.labelMedium(context).copyWith(
                      color: isAvailable && canAfford
                          ? (isDark ? Colors.white : AppColors.textPrimary)
                          : (isDark ? Colors.white38 : AppColors.textHint),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    reward.description,
                    style: AppTypography.bodySmall(context).copyWith(
                      color: isDark ? Colors.white60 : AppColors.textSecondary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.star_rounded, color: AppColors.starGold, size: 14),
                      const SizedBox(width: 4),
                      Text(
                        '${reward.starCost} Stars',
                        style: AppTypography.labelSmall(context).copyWith(
                          color: canAfford ? AppColors.primaryGreen : AppColors.error,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            if (isAvailable && canAfford)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.primaryGreen,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text('Redeem', style: AppTypography.labelSmall(context).copyWith(color: Colors.white)),
              )
            else if (!isAvailable)
              Icon(Icons.lock_rounded, color: isDark ? Colors.white24 : AppColors.textHint, size: 20),
          ],
        ),
      ),
    );
  }
}

class _RedeemConfirmationSheet extends StatelessWidget {
  final RewardModel reward;
  final VoidCallback onConfirm;

  const _RedeemConfirmationSheet({
    required this.reward,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.fromLTRB(24, 24, 24, MediaQuery.of(context).padding.bottom + 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.divider,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 24),
          Text('Redeem Reward?', style: AppTypography.headingMedium(context)),
          const SizedBox(height: 16),
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: AppColors.primaryGreenLight,
              borderRadius: BorderRadius.circular(20),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.network(
                reward.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const Icon(Icons.local_cafe, color: AppColors.primaryGreen, size: 40),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(reward.title, style: AppTypography.headingSmall(context), textAlign: TextAlign.center),
          const SizedBox(height: 8),
          Text(
            reward.description,
            style: AppTypography.bodyMedium(context).copyWith(color: AppColors.textSecondary),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.primaryGreenLight,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.star_rounded, color: AppColors.starGold, size: 20),
                const SizedBox(width: 8),
                Text(
                  '${reward.starCost} Stars will be deducted',
                  style: AppTypography.labelMedium(context).copyWith(color: AppColors.primaryGreen),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.divider),
                    ),
                    child: Center(
                      child: Text('Cancel', style: AppTypography.labelMedium(context)),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: GestureDetector(
                  onTap: onConfirm,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      color: AppColors.primaryGreen,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Center(
                      child: Text('Redeem Now', style: AppTypography.labelMedium(context).copyWith(color: Colors.white)),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _RedeemSuccessDialog extends StatelessWidget {
  final RewardModel reward;
  final int remainingStars;

  const _RedeemSuccessDialog({
    required this.reward,
    required this.remainingStars,
  });

  @override
  Widget build(BuildContext context) {
    final redeemed = context.read<RewardsProvider>().redeemedRewards.last;
    
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: const BoxDecoration(
                color: AppColors.success,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check_rounded, color: Colors.white, size: 40),
            ).animate().scale(duration: 400.ms, curve: Curves.elasticOut),
            const SizedBox(height: 20),
            Text('Reward Redeemed!', style: AppTypography.headingMedium(context))
                .animate().fadeIn(delay: 200.ms),
            const SizedBox(height: 8),
            Text(
              reward.title,
              style: AppTypography.bodyLarge(context).copyWith(color: AppColors.primaryGreen),
              textAlign: TextAlign.center,
            ).animate().fadeIn(delay: 300.ms),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.primaryGreenLight,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Text('Redemption Code', style: AppTypography.labelSmall(context)),
                  const SizedBox(height: 8),
                  Text(
                    redeemed.code,
                    style: AppTypography.headingLarge(context).copyWith(
                      color: AppColors.primaryGreen,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Show this code at checkout',
                    style: AppTypography.caption(context),
                  ),
                ],
              ),
            ).animate().fadeIn(delay: 400.ms),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Expires in ${redeemed.daysUntilExpiry} days',
                  style: AppTypography.bodySmall(context).copyWith(color: AppColors.textSecondary),
                ),
              ],
            ).animate().fadeIn(delay: 500.ms),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: AppColors.primaryGreen,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(
                  child: Text('Done', style: AppTypography.labelMedium(context).copyWith(color: Colors.white)),
                ),
              ),
            ).animate().fadeIn(delay: 600.ms),
          ],
        ),
      ),
    );
  }
}

class _RedeemedRewardsSheet extends StatelessWidget {
  final RewardsProvider rewards;

  const _RedeemedRewardsSheet({required this.rewards});

  @override
  Widget build(BuildContext context) {
    final redeemed = rewards.redeemedRewards;
    
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.divider,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 16),
                Text('My Redeemed Rewards', style: AppTypography.headingMedium(context)),
              ],
            ),
          ),
          Expanded(
            child: redeemed.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.card_giftcard, size: 64, color: AppColors.textHint),
                        const SizedBox(height: 16),
                        Text('No redeemed rewards yet', style: AppTypography.bodyLarge(context)),
                        const SizedBox(height: 8),
                        Text(
                          'Start redeeming to see your rewards here',
                          style: AppTypography.bodyMedium(context).copyWith(color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                    itemCount: redeemed.length,
                    itemBuilder: (context, index) {
                      final item = redeemed[redeemed.length - 1 - index]; // Reverse order
                      return _RedeemedRewardItem(item: item);
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _RedeemedRewardItem extends StatelessWidget {
  final RedeemedReward item;

  const _RedeemedRewardItem({required this.item});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: item.isValid
            ? Border.all(color: AppColors.primaryGreen.withValues(alpha: 0.3))
            : Border.all(color: AppColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: AppColors.primaryGreenLight,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    item.reward.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => const Icon(Icons.local_cafe, color: AppColors.primaryGreen, size: 24),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item.reward.title, style: AppTypography.labelMedium(context)),
                    const SizedBox(height: 4),
                    Text(
                      'Code: ${item.code}',
                      style: AppTypography.bodySmall(context).copyWith(
                        color: isDark ? Colors.white70 : AppColors.textSecondary,
                        fontFamily: 'monospace',
                      ),
                    ),
                  ],
                ),
              ),
              if (item.isUsed)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.divider,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text('Used', style: AppTypography.caption(context)),
                )
              else if (item.isExpired)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.error.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Expired',
                    style: AppTypography.caption(context).copyWith(color: AppColors.error),
                  ),
                )
              else
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.success.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Active',
                    style: AppTypography.caption(context).copyWith(color: AppColors.success),
                  ),
                ),
            ],
          ),
          if (item.isValid) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.primaryGreenLight,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.access_time, size: 16, color: AppColors.primaryGreen),
                  const SizedBox(width: 8),
                  Text(
                    'Expires in ${item.daysUntilExpiry} days',
                    style: AppTypography.caption(context).copyWith(color: AppColors.primaryGreen),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
