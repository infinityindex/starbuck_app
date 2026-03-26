import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../data/models/drink_model.dart';
import '../../providers/cart_provider.dart';
import '../../router/route_names.dart';

class ProductDetailScreen extends StatefulWidget {
  final DrinkModel drink;
  const ProductDetailScreen({super.key, required this.drink});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  String _selectedSize = 'Grande';
  int _quantity = 1;
  bool _isAdding = false;

  final _sizes = ['Tall', 'Grande', 'Venti'];

  double get _adjustedPrice {
    double price = widget.drink.price;
    if (_selectedSize == 'Tall') price -= 0.50;
    if (_selectedSize == 'Venti') price += 0.50;
    return price * _quantity;
  }

  void _incrementQuantity() {
    if (_quantity < 10) {
      setState(() => _quantity++);
    }
  }

  void _decrementQuantity() {
    if (_quantity > 1) {
      setState(() => _quantity--);
    }
  }

  Future<void> _addToCart() async {
    setState(() => _isAdding = true);
    await Future.delayed(const Duration(milliseconds: 600));
    if (mounted) {
      // Add item multiple times based on quantity
      for (int i = 0; i < _quantity; i++) {
        context.read<CartProvider>().addItem(widget.drink, size: _selectedSize);
      }
      setState(() => _isAdding = false);
      
      // Show success notification
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle_rounded, color: AppColors.success),
              const SizedBox(width: 12),
              Text(
                '$_quantity item${_quantity > 1 ? 's' : ''} added to cart',
                style: AppTypography.labelMedium(context).copyWith(color: Colors.white),
              ),
            ],
          ),
          backgroundColor: AppColors.primaryGreen,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          margin: const EdgeInsets.all(16),
          duration: const Duration(milliseconds: 2000),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final cartItemCount = context.watch<CartProvider>().totalItems;
    
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      extendBodyBehindAppBar: true,
      body: Column(
        children: [
          // Hero Image with custom app bar
          Expanded(
            flex: 3,
            child: Hero(
              tag: 'drink_image_${widget.drink.id}',
              child: Stack(
                children: [
                  Positioned.fill(
                    child: CachedNetworkImage(
                      imageUrl: widget.drink.imageUrl,
                      fit: BoxFit.cover,
                      errorWidget: (_, __, ___) => Container(color: AppColors.primaryGreenLight),
                    ),
                  ),
                  // Modern gradient overlay for visibility
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    height: MediaQuery.of(context).padding.top + 100,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withValues(alpha: 0.7),
                            Colors.black.withValues(alpha: 0.3),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Modern App Bar
                  Positioned(
                    top: MediaQuery.of(context).padding.top + 12,
                    left: 0,
                    right: 0,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        children: [
                          // Modern back button
                          _ModernIconButton(
                            icon: Icons.arrow_back_ios_new_rounded,
                            onTap: () => context.pop(),
                          ),
                          const Spacer(),
                          // Modern cart button with badge
                          _ModernCartButton(
                            itemCount: cartItemCount,
                            onTap: () => context.push(RouteNames.cart),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Category badge
                  Positioned(
                    top: MediaQuery.of(context).padding.top + 70,
                    left: 20,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.secondaryGold,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        widget.drink.category,
                        style: AppTypography.labelSmall(context).copyWith(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Content
          Expanded(
            flex: 4,
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Name and rating
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            widget.drink.name,
                            style: AppTypography.headingLarge(context),
                          ).animate().fadeIn(),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: AppColors.primaryGreenLight,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.star_rounded, color: AppColors.starGold, size: 16),
                              const SizedBox(width: 4),
                              Text(widget.drink.rating.toStringAsFixed(1), style: AppTypography.labelSmall(context)),
                            ],
                          ),
                        ).animate().fadeIn(delay: 50.ms),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.drink.description,
                      style: AppTypography.bodyMedium(context).copyWith(
                        color: Theme.of(context).brightness == Brightness.dark 
                            ? Colors.white70 
                            : AppColors.textSecondary,
                      ),
                    ).animate().fadeIn(delay: 100.ms),
                    const SizedBox(height: 24),

                    // Size selector
                    Text('Size', style: AppTypography.labelLarge(context))
                        .animate().fadeIn(delay: 150.ms),
                    const SizedBox(height: 12),
                    Row(
                      children: _sizes.map((size) {
                        final isSelected = _selectedSize == size;
                        return GestureDetector(
                          onTap: () => setState(() => _selectedSize = size),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            margin: const EdgeInsets.only(right: 12),
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                            decoration: BoxDecoration(
                              color: isSelected ? AppColors.primaryGreen : Theme.of(context).colorScheme.surface,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: isSelected ? AppColors.primaryGreen : AppColors.divider,
                              ),
                            ),
                            child: Text(
                              size,
                              style: AppTypography.labelMedium(context).copyWith(
                                color: isSelected ? Colors.white : AppColors.textSecondary,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ).animate().fadeIn(delay: 200.ms),

                    const SizedBox(height: 24),

                    // Quantity selector
                    Text('Quantity', style: AppTypography.labelLarge(context))
                        .animate().fadeIn(delay: 220.ms),
                    const SizedBox(height: 12),
                    _QuantitySelector(
                      quantity: _quantity,
                      onIncrement: _incrementQuantity,
                      onDecrement: _decrementQuantity,
                    ).animate().fadeIn(delay: 240.ms),

                    const SizedBox(height: 24),

                    // Price and add to cart
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Total Price',
                              style: AppTypography.bodySmall(context).copyWith(
                                color: Theme.of(context).brightness == Brightness.dark 
                                    ? Colors.white54 
                                    : AppColors.textHint,
                              ),
                            ),
                            Text(
                              '\$${_adjustedPrice.toStringAsFixed(2)}',
                              style: AppTypography.priceLarge(context),
                            ),
                          ],
                        ).animate().fadeIn(delay: 250.ms),
                        SizedBox(
                          width: 160,
                          height: 56,
                          child: _isAdding
                              ? Container(
                                  decoration: BoxDecoration(
                                    color: AppColors.primaryGreen,
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  child: const Center(
                                    child: SizedBox(
                                      width: 24,
                                      height: 24,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2.5,
                                      ),
                                    ),
                                  ),
                                )
                              : GestureDetector(
                                  onTap: _addToCart,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: AppColors.primaryGreen,
                                      borderRadius: BorderRadius.circular(30),
                                      boxShadow: [
                                        BoxShadow(
                                          color: AppColors.primaryGreen.withValues(alpha: 0.3),
                                          blurRadius: 12,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        const Icon(Icons.add_shopping_cart, color: Colors.white, size: 20),
                                        const SizedBox(width: 8),
                                        Text('Add to Cart', style: AppTypography.labelMedium(context).copyWith(color: Colors.white)),
                                      ],
                                    ),
                                  ),
                                ).animate().fadeIn(delay: 300.ms).scale(),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),
                    // Nutrition info
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _NutritionItem(label: 'Calories', value: '${widget.drink.calories}'),
                          Container(width: 1, height: 40, color: AppColors.divider),
                          _NutritionItem(label: 'Protein', value: '8g'),
                          Container(width: 1, height: 40, color: AppColors.divider),
                          _NutritionItem(label: 'Caffeine', value: '75mg'),
                        ],
                      ),
                    ).animate().fadeIn(delay: 350.ms),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Modern icon button with glassmorphism effect.
class _ModernIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _ModernIconButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.3),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
    );
  }
}

/// Modern cart button with badge and glassmorphism effect.
class _ModernCartButton extends StatelessWidget {
  final int itemCount;
  final VoidCallback onTap;

  const _ModernCartButton({required this.itemCount, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.3),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            const Center(
              child: Icon(Icons.shopping_bag_outlined, color: Colors.white, size: 22),
            ),
            if (itemCount > 0)
              Positioned(
                top: -6,
                right: -6,
                child: Container(
                  constraints: BoxConstraints(minWidth: itemCount > 9 ? 22 : 20),
                  height: 20,
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColors.error, Color(0xFFFF6B6B)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white, width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.error.withValues(alpha: 0.5),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      itemCount > 99 ? '99+' : itemCount.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        height: 1,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// OLD WIDGETS - Keeping for reference but not used
class _AppBarButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _AppBarButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.3),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
        ),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
    );
  }
}

/// Cart button with item count badge.
class _CartButton extends StatelessWidget {
  final int itemCount;
  final VoidCallback onTap;

  const _CartButton({required this.itemCount, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.3),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            const Center(
              child: Icon(Icons.shopping_bag_outlined, color: Colors.white, size: 20),
            ),
            if (itemCount > 0)
              Positioned(
                top: -4,
                right: -4,
                child: Container(
                  constraints: BoxConstraints(minWidth: itemCount > 9 ? 20 : 18),
                  height: 18,
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  decoration: BoxDecoration(
                    color: AppColors.error,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.white, width: 1.5),
                  ),
                  child: Center(
                    child: Text(
                      itemCount > 99 ? '99+' : itemCount.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// Quantity selector with +/- buttons.
class _QuantitySelector extends StatelessWidget {
  final int quantity;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  const _QuantitySelector({
    required this.quantity,
    required this.onIncrement,
    required this.onDecrement,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.divider),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _QuantityButton(
            icon: Icons.remove,
            onTap: onDecrement,
            enabled: quantity > 1,
          ),
          Container(
            width: 50,
            alignment: Alignment.center,
            child: Text(
              quantity.toString(),
              style: AppTypography.headingSmall(context),
            ),
          ),
          _QuantityButton(
            icon: Icons.add,
            onTap: onIncrement,
            enabled: quantity < 10,
          ),
        ],
      ),
    );
  }
}

/// Individual quantity button.
class _QuantityButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool enabled;

  const _QuantityButton({
    required this.icon,
    required this.onTap,
    required this.enabled,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: enabled ? AppColors.primaryGreen : AppColors.divider,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          icon,
          color: enabled ? Colors.white : AppColors.textHint,
          size: 20,
        ),
      ),
    );
  }
}

class _NutritionItem extends StatelessWidget {
  final String label;
  final String value;

  const _NutritionItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: AppTypography.labelLarge(context).copyWith(color: AppColors.primaryGreen)),
        const SizedBox(height: 2),
        Text(label, style: AppTypography.caption(context)),
      ],
    );
  }
}
