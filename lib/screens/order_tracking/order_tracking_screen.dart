import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'dart:async';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../data/models/order_model.dart';
import '../../data/mock/mock_orders.dart';
import '../../router/route_names.dart';

class OrderTrackingScreen extends StatefulWidget {
  const OrderTrackingScreen({super.key});

  @override
  State<OrderTrackingScreen> createState() => _OrderTrackingScreenState();
}

class _OrderTrackingScreenState extends State<OrderTrackingScreen> {
  OrderStatus _currentStatus = OrderStatus.preparing;
  Timer? _progressTimer;
  late OrderModel _currentOrder;

  final _steps = [
    {
      'status': OrderStatus.received,
      'label': 'Order Received',
      'icon': Icons.receipt_long_rounded,
      'description': 'Your order has been confirmed',
      'time': '2:30 PM'
    },
    {
      'status': OrderStatus.preparing,
      'label': 'Preparing Your Order',
      'icon': Icons.coffee_maker_outlined,
      'description': 'Our barista is crafting your drink',
      'time': '2:32 PM'
    },
    {
      'status': OrderStatus.almostReady,
      'label': 'Almost Ready',
      'icon': Icons.timer_outlined,
      'description': 'Your order will be ready soon',
      'time': '2:35 PM'
    },
    {
      'status': OrderStatus.ready,
      'label': 'Ready for Pickup',
      'icon': Icons.check_circle_outline_rounded,
      'description': 'Your order is ready at the counter',
      'time': '2:37 PM'
    },
  ];

  @override
  void initState() {
    super.initState();
    _currentOrder = mockOrderHistory.first;
    // Demo: auto-progress through stages
    _progressTimer = Timer.periodic(const Duration(seconds: 5), (_) {
      if (!mounted) return;
      final statuses = OrderStatus.values;
      final currentIndex = statuses.indexOf(_currentStatus);
      if (currentIndex < statuses.indexOf(OrderStatus.ready)) {
        setState(() => _currentStatus = statuses[currentIndex + 1]);
      }
    });
  }

  @override
  void dispose() {
    _progressTimer?.cancel();
    super.dispose();
  }

  int get _currentStepIndex {
    return _steps.indexWhere((s) => s['status'] == _currentStatus);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text('Track Your Order', style: AppTypography.headingMedium(context)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Order header card
            Container(
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.primaryGreen, Color(0xFF006241)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryGreen.withValues(alpha: 0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Order Number',
                            style: AppTypography.bodySmall(context).copyWith(
                              color: Colors.white70,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '#${_currentOrder.id.substring(4, 10).toUpperCase()}',
                            style: AppTypography.headingLarge(context).copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.access_time_rounded, color: Colors.white, size: 18),
                            const SizedBox(width: 6),
                            Text(
                              '~${_currentOrder.estimatedMinutes} min',
                              style: AppTypography.labelMedium(context).copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Divider(color: Colors.white.withValues(alpha: 0.3)),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(Icons.store_rounded, color: Colors.white70, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _currentOrder.storeName,
                          style: AppTypography.bodyMedium(context).copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ).animate().fadeIn().slideY(begin: -0.1, end: 0),

            // Progress indicator
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Order Progress',
                        style: AppTypography.headingMedium(context),
                      ),
                      Text(
                        'Step ${_currentStepIndex + 1} of ${_steps.length}',
                        style: AppTypography.bodySmall(context).copyWith(
                          color: isDark ? Colors.white70 : AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Progress bar
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: (_currentStepIndex + 1) / _steps.length,
                      backgroundColor: isDark ? Colors.white10 : AppColors.divider,
                      valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primaryGreen),
                      minHeight: 8,
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn(delay: 100.ms),

            const SizedBox(height: 32),

            // Timeline steps
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: List.generate(_steps.length, (index) {
                  final step = _steps[index];
                  final status = step['status'] as OrderStatus;
                  final isCompleted = OrderStatus.values.indexOf(_currentStatus) > index;
                  final isCurrent = status == _currentStatus;

                  return _TimelineStepItem(
                    label: step['label'] as String,
                    description: step['description'] as String,
                    time: step['time'] as String,
                    icon: step['icon'] as IconData,
                    isCompleted: isCompleted,
                    isCurrent: isCurrent,
                    isLast: index == _steps.length - 1,
                  ).animate(delay: (150 + index * 100).ms).fadeIn().slideX(begin: -0.1, end: 0);
                }),
              ),
            ),

            const SizedBox(height: 32),

            // Order items summary
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: isDark ? Colors.white.withValues(alpha: 0.05) : AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isDark ? Colors.white10 : AppColors.divider,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Order Items', style: AppTypography.labelLarge(context)),
                    const SizedBox(height: 12),
                    ...List.generate(_currentOrder.items.length, (index) {
                      final item = _currentOrder.items[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Row(
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: AppColors.primaryGreen,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                '${item.quantity}x ${item.drink.name} (${item.size})',
                                style: AppTypography.bodyMedium(context),
                              ),
                            ),
                            Text(
                              '\$${item.totalPrice.toStringAsFixed(2)}',
                              style: AppTypography.labelMedium(context).copyWith(
                                color: AppColors.primaryGreen,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                    const Divider(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Total', style: AppTypography.labelLarge(context)),
                        Text(
                          '\$${_currentOrder.total.toStringAsFixed(2)}',
                          style: AppTypography.headingMedium(context).copyWith(
                            color: AppColors.primaryGreen,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ).animate().fadeIn(delay: 600.ms),

            const SizedBox(height: 24),

            // Bottom action
            Padding(
              padding: const EdgeInsets.all(20),
              child: GestureDetector(
                onTap: () => context.go(RouteNames.home),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColors.primaryGreen, Color(0xFF006241)],
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primaryGreen.withValues(alpha: 0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      'Back to Home',
                      style: AppTypography.labelLarge(context).copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ).animate().fadeIn(delay: 700.ms),
            ),
          ],
        ),
      ),
    );
  }
}

class _TimelineStepItem extends StatefulWidget {
  final String label;
  final String description;
  final String time;
  final IconData icon;
  final bool isCompleted;
  final bool isCurrent;
  final bool isLast;

  const _TimelineStepItem({
    required this.label,
    required this.description,
    required this.time,
    required this.icon,
    required this.isCompleted,
    required this.isCurrent,
    required this.isLast,
  });

  @override
  State<_TimelineStepItem> createState() => _TimelineStepItemState();
}

class _TimelineStepItemState extends State<_TimelineStepItem> with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    
    if (widget.isCurrent) {
      _pulseController.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(_TimelineStepItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isCurrent && !oldWidget.isCurrent) {
      _pulseController.repeat(reverse: true);
    } else if (!widget.isCurrent && oldWidget.isCurrent) {
      _pulseController.stop();
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Timeline indicator
        Column(
          children: [
            // Icon with animation
            SizedBox(
              width: 60,
              height: 60,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Outer pulse ring for current step
                  if (widget.isCurrent)
                    AnimatedBuilder(
                      animation: _pulseController,
                      builder: (context, child) {
                        return Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppColors.primaryGreen.withValues(
                                alpha: 0.3 * (1 - _pulseController.value),
                              ),
                              width: 2,
                            ),
                          ),
                        );
                      },
                    ),
                  // Main circle
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: widget.isCompleted || widget.isCurrent
                          ? AppColors.primaryGreen
                          : isDark ? Colors.white.withValues(alpha: 0.1) : AppColors.divider,
                      shape: BoxShape.circle,
                      boxShadow: widget.isCurrent
                          ? [
                              BoxShadow(
                                color: AppColors.primaryGreen.withValues(alpha: 0.4),
                                blurRadius: 16,
                                spreadRadius: 2,
                              ),
                            ]
                          : null,
                    ),
                    child: Icon(
                      widget.isCompleted && !widget.isCurrent
                          ? Icons.check_rounded
                          : widget.icon,
                      color: widget.isCompleted || widget.isCurrent
                          ? Colors.white
                          : isDark ? Colors.white30 : AppColors.textHint,
                      size: 24,
                    ),
                  ),
                ],
              ),
            ),
            // Connecting line
            if (!widget.isLast)
              AnimatedContainer(
                duration: const Duration(milliseconds: 400),
                width: 3,
                height: 50,
                margin: const EdgeInsets.symmetric(vertical: 4),
                decoration: BoxDecoration(
                  gradient: widget.isCompleted
                      ? const LinearGradient(
                          colors: [AppColors.primaryGreen, AppColors.primaryGreen],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        )
                      : LinearGradient(
                          colors: [
                            widget.isCurrent ? AppColors.primaryGreen : AppColors.divider,
                            AppColors.divider,
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
          ],
        ),
        const SizedBox(width: 20),
        // Content
        Expanded(
          child: Container(
            margin: EdgeInsets.only(bottom: widget.isLast ? 0 : 8),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: widget.isCurrent
                  ? AppColors.primaryGreen.withValues(alpha: 0.08)
                  : isDark ? Colors.white.withValues(alpha: 0.03) : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: widget.isCurrent
                    ? AppColors.primaryGreen.withValues(alpha: 0.3)
                    : Colors.transparent,
                width: 1.5,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        widget.label,
                        style: AppTypography.labelLarge(context).copyWith(
                          color: widget.isCompleted || widget.isCurrent
                              ? (isDark ? Colors.white : AppColors.textPrimary)
                              : (isDark ? Colors.white38 : AppColors.textHint),
                          fontWeight: widget.isCurrent ? FontWeight.w700 : FontWeight.w600,
                        ),
                      ),
                    ),
                    if (widget.isCompleted || widget.isCurrent)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: widget.isCurrent
                              ? AppColors.primaryGreen
                              : AppColors.success.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          widget.time,
                          style: AppTypography.bodySmall(context).copyWith(
                            color: widget.isCurrent
                                ? Colors.white
                                : AppColors.success,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  widget.description,
                  style: AppTypography.bodySmall(context).copyWith(
                    color: widget.isCompleted || widget.isCurrent
                        ? (isDark ? Colors.white60 : AppColors.textSecondary)
                        : (isDark ? Colors.white24 : AppColors.textHint),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
