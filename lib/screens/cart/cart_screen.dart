import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../providers/cart_provider.dart';
import '../../router/route_names.dart';
import '../../widgets/common/app_button.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text('Your Order', style: AppTypography.headingMedium(context)),
      ),
      body: Consumer<CartProvider>(
        builder: (context, cart, _) {
          if (cart.isEmpty) {
            return _EmptyState();
          }
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: cart.items.length,
                  itemBuilder: (context, index) {
                    final item = cart.items[index];
                    return _CartItemTile(
                          item: item,
                          onUpdateQty: (q) => cart.updateQuantity(item.id, q),
                          onDelete: () => cart.removeItem(item.id),
                        )
                        .animate(delay: (index * 50).ms)
                        .fadeIn()
                        .slideX(begin: 0.1, end: 0);
                  },
                ),
              ),
              _PriceSummary(
                cart: cart,
              ).animate().fadeIn().slideY(begin: 0.2, end: 0),
            ],
          );
        },
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: AppColors.primaryGreenLight,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.shopping_bag_outlined,
              color: AppColors.primaryGreen,
              size: 48,
            ),
          ).animate().scale(duration: 600.ms, curve: Curves.elasticOut),
          const SizedBox(height: 24),
          Text(
            'Your cart is empty',
            style: AppTypography.headingMedium(context),
          ).animate().fadeIn(delay: 200.ms),
          const SizedBox(height: 8),
          Text(
            'Add some drinks to get started',
            style: AppTypography.bodyMedium(
              context,
            ).copyWith(color: AppColors.textSecondary),
          ).animate().fadeIn(delay: 250.ms),
          const SizedBox(height: 32),
          AppButton.primary(
            label: 'Browse Menu',
            onTap: () => context.pop(),
          ).animate().fadeIn(delay: 300.ms),
        ],
      ),
    );
  }
}

class _CartItemTile extends StatelessWidget {
  final dynamic item;
  final Function(int) onUpdateQty;
  final VoidCallback onDelete;

  const _CartItemTile({
    required this.item,
    required this.onUpdateQty,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(item.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onDelete(),
      background: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: AppColors.error,
          borderRadius: BorderRadius.circular(16),
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(Icons.delete_outline_rounded, color: Colors.white),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            // Image
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: CachedNetworkImage(
                imageUrl: item.drink.imageUrl,
                width: 70,
                height: 70,
                fit: BoxFit.cover,
                errorWidget: (_, _, _) => Container(
                  width: 70,
                  height: 70,
                  color: AppColors.primaryGreenLight,
                  child: const Icon(
                    Icons.local_cafe,
                    color: AppColors.primaryGreen,
                    size: 24,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.drink.name,
                    style: AppTypography.labelMedium(context),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Size: ${item.size}',
                    style: AppTypography.bodySmall(
                      context,
                    ).copyWith(color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '\$${item.totalPrice.toStringAsFixed(2)}',
                    style: AppTypography.price(context),
                  ),
                ],
              ),
            ),
            // Quantity
            Container(
              decoration: BoxDecoration(
                color: AppColors.inputFill,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.remove_rounded, size: 18),
                    onPressed: () => onUpdateQty(item.quantity - 1),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(
                      minWidth: 36,
                      minHeight: 36,
                    ),
                  ),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    transitionBuilder: (child, anim) =>
                        ScaleTransition(scale: anim, child: child),
                    child: SizedBox(
                      width: 24,
                      child: Text(
                        '${item.quantity}',
                        style: AppTypography.labelMedium(context),
                        textAlign: TextAlign.center,
                        key: ValueKey(item.quantity),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add_rounded, size: 18),
                    onPressed: () => onUpdateQty(item.quantity + 1),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(
                      minWidth: 36,
                      minHeight: 36,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PriceSummary extends StatelessWidget {
  final CartProvider cart;

  const _PriceSummary({required this.cart});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: AppColors.cardShadow,
            blurRadius: 12,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Subtotal',
                  style: AppTypography.bodyMedium(
                    context,
                  ).copyWith(color: AppColors.textSecondary),
                ),
                Text(
                  '\$${cart.subtotal.toStringAsFixed(2)}',
                  style: AppTypography.bodyMedium(context),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Tax (8.75%)',
                  style: AppTypography.bodyMedium(
                    context,
                  ).copyWith(color: AppColors.textSecondary),
                ),
                Text(
                  '\$${cart.tax.toStringAsFixed(2)}',
                  style: AppTypography.bodyMedium(context),
                ),
              ],
            ),
            const Divider(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Total', style: AppTypography.headingMedium(context)),
                Text(
                  '\$${cart.total.toStringAsFixed(2)}',
                  style: AppTypography.priceLarge(context),
                ),
              ],
            ),
            const SizedBox(height: 16),
            AppButton.primary(
              label: 'Proceed to Checkout',
              onTap: () => context.push(RouteNames.checkout),
            ),
          ],
        ),
      ),
    );
  }
}
