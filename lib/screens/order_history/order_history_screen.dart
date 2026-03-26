import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../data/mock/mock_orders.dart';
import '../../data/models/order_model.dart';


class OrderHistoryScreen extends StatelessWidget {
  const OrderHistoryScreen({super.key});

  Color _getStatusColor(OrderStatus status) {
    switch (status) {
      case OrderStatus.completed:
        return AppColors.success;
      case OrderStatus.cancelled:
        return AppColors.error;
      default:
        return AppColors.primaryGreen;
    }
  }

  String _getStatusText(OrderStatus status) {
    switch (status) {
      case OrderStatus.completed:
        return 'Completed';
      case OrderStatus.cancelled:
        return 'Cancelled';
      default:
        return 'In Progress';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text('Order History', style: AppTypography.headingMedium(context)),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: mockOrderHistory.length,
        itemBuilder: (context, index) {
          final order = mockOrderHistory[index];
          return _OrderHistoryCard(
            order: order,
            statusColor: _getStatusColor(order.status),
            statusText: _getStatusText(order.status),
            onReorder: () {},
          ).animate(delay: (index * 80).ms).fadeIn().slideY(begin: 0.15, end: 0);
        },
      ),
    );
  }
}

class _OrderHistoryCard extends StatelessWidget {
  final dynamic order;
  final Color statusColor;
  final String statusText;
  final VoidCallback onReorder;

  const _OrderHistoryCard({
    required this.order,
    required this.statusColor,
    required this.statusText,
    required this.onReorder,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    order.id.substring(4, 10).toUpperCase(),
                    style: AppTypography.labelLarge(context),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${order.timestamp.day}/${order.timestamp.month}/${order.timestamp.year}',
                    style: AppTypography.bodySmall(context).copyWith(color: AppColors.textSecondary),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  statusText,
                  style: AppTypography.labelSmall(context).copyWith(color: statusColor),
                ),
              ),
            ],
          ),
          const Divider(height: 24),
          // Items preview
          Text(
            order.items.map((i) => '${i.quantity}x ${i.drink.name}').join(', '),
            style: AppTypography.bodyMedium(context),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 12),
          // Footer
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '\$${order.total.toStringAsFixed(2)}',
                style: AppTypography.price(context),
              ),
              if (order.status == OrderStatus.completed)
                GestureDetector(
                  onTap: onReorder,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.primaryGreen,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.refresh_rounded, color: Colors.white, size: 16),
                        const SizedBox(width: 4),
                        Text('Reorder', style: AppTypography.labelSmall(context).copyWith(color: Colors.white)),
                      ],
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
