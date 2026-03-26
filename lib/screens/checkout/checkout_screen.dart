import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../providers/cart_provider.dart';
import '../../providers/order_provider.dart';
import '../../router/route_names.dart';
import '../../widgets/common/app_button.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  String _selectedPayment = 'Starbucks Card';
  bool _isProcessing = false;

  final _paymentMethods = [
    {'id': 'Starbucks Card', 'icon': Icons.card_giftcard_rounded, 'balance': '\$25.40'},
    {'id': 'Apple Pay', 'icon': Icons.apple, 'balance': ''},
    {'id': 'Credit Card', 'icon': Icons.credit_card_rounded, 'balance': ''},
  ];

  Future<void> _placeOrder() async {
    setState(() => _isProcessing = true);
    await Future.delayed(const Duration(milliseconds: 1500));

    if (mounted) {
      final cart = context.read<CartProvider>();
      await context.read<OrderProvider>().placeOrder(cart.items, cart.total);
      cart.clearCart();

      if (mounted) context.go(RouteNames.orderConfirmation);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text('Checkout', style: AppTypography.headingMedium(context)),
      ),
      body: Consumer2<CartProvider, OrderProvider>(
        builder: (context, cart, orders, _) {
          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Order Summary
                      Text('Order Summary', style: AppTypography.headingMedium(context))
                          .animate().fadeIn(),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          children: [
                            ...cart.items.map((item) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8),
                                child: Row(
                                  children: [
                                    Text('${item.quantity}x', style: AppTypography.labelMedium(context)),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        item.drink.name,
                                        style: AppTypography.bodyMedium(context),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Text('\$${item.totalPrice.toStringAsFixed(2)}',
                                        style: AppTypography.bodyMedium(context)),
                                  ],
                                ),
                              );
                            }).toList(),
                            const Divider(height: 24),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Subtotal', style: AppTypography.bodyMedium(context).copyWith(color: AppColors.textSecondary)),
                                Text('\$${cart.subtotal.toStringAsFixed(2)}', style: AppTypography.bodyMedium(context)),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Tax (8.75%)', style: AppTypography.bodyMedium(context).copyWith(color: AppColors.textSecondary)),
                                Text('\$${cart.tax.toStringAsFixed(2)}', style: AppTypography.bodyMedium(context)),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Total', style: AppTypography.headingSmall(context)),
                                Text('\$${cart.total.toStringAsFixed(2)}', style: AppTypography.priceLarge(context)),
                              ],
                            ),
                          ],
                        ),
                      ).animate().fadeIn(delay: 100.ms),

                      const SizedBox(height: 24),

                      // Payment Method
                      Text('Payment Method', style: AppTypography.headingMedium(context))
                          .animate().fadeIn(delay: 150.ms),
                      const SizedBox(height: 12),
                      ..._paymentMethods.map((method) {
                        final isSelected = _selectedPayment == method['id'];
                        return _PaymentMethodTile(
                          id: method['id'] as String,
                          icon: method['icon'] as IconData,
                          balance: method['balance'] as String,
                          isSelected: isSelected,
                          onTap: () => setState(() => _selectedPayment = method['id'] as String),
                        ).animate(delay: (200 + _paymentMethods.indexOf(method) * 50).ms).fadeIn();
                      }).toList(),

                      const SizedBox(height: 24),

                      // Store Info
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                color: AppColors.primaryGreenLight,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(Icons.store_rounded, color: AppColors.primaryGreen),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Pickup at', style: AppTypography.caption(context)),
                                  Text('Starbucks Reserve', style: AppTypography.labelMedium(context)),
                                  Text('1124 Pike St, Seattle', style: AppTypography.bodySmall(context).copyWith(color: AppColors.textSecondary)),
                                ],
                              ),
                            ),
                            Text('~5 min', style: AppTypography.labelSmall(context).copyWith(color: AppColors.primaryGreen)),
                          ],
                        ),
                      ).animate().fadeIn(delay: 300.ms),
                    ],
                  ),
                ),
              ),
              // Place Order Button
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  boxShadow: [BoxShadow(color: AppColors.cardShadow, blurRadius: 12, offset: const Offset(0, -4))],
                ),
                child: SafeArea(
                  child: _isProcessing
                      ? Container(
                          height: 56,
                          decoration: BoxDecoration(
                            color: AppColors.primaryGreen,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: const Center(
                            child: SizedBox(
                              width: 28,
                              height: 28,
                              child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
                            ),
                          ),
                        )
                      : AppButton.primary(
                          label: 'Place Order • \$${cart.total.toStringAsFixed(2)}',
                          onTap: _placeOrder,
                        ).animate().fadeIn(delay: 350.ms),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _PaymentMethodTile extends StatelessWidget {
  final String id;
  final IconData icon;
  final String balance;
  final bool isSelected;
  final VoidCallback onTap;

  const _PaymentMethodTile({
    required this.id,
    required this.icon,
    required this.balance,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.primaryGreen : AppColors.divider,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.inputFill,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: AppColors.textPrimary, size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(id, style: AppTypography.labelMedium(context)),
                  if (balance.isNotEmpty)
                    Text(balance, style: AppTypography.bodySmall(context).copyWith(color: AppColors.primaryGreen)),
                ],
              ),
            ),
            if (isSelected)
              Container(
                width: 24,
                height: 24,
                decoration: const BoxDecoration(
                  color: AppColors.primaryGreen,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check_rounded, color: Colors.white, size: 16),
              ),
          ],
        ),
      ),
    );
  }
}
