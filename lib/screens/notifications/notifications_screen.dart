import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../data/mock/mock_notifications.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text('Notifications', style: AppTypography.headingMedium(context)),
        bottom: TabBar(
          controller: _tabController,
          labelStyle: AppTypography.labelMedium(context),
          unselectedLabelStyle: AppTypography.labelMedium(context),
          indicatorColor: AppColors.primaryGreen,
          labelColor: AppColors.primaryGreen,
          unselectedLabelColor: AppColors.textHint,
          tabs: const [
            Tab(text: 'Offers & Deals'),
            Tab(text: 'Order Updates'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildOffersList(),
          _buildOrderUpdatesList(),
        ],
      ),
    );
  }

  Widget _buildOffersList() {
    final offers = mockNotifications.where((n) => n.type == 'offer' || n.type == 'promo').toList();

    if (offers.isEmpty) {
      return const _EmptyState();
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: offers.length,
      itemBuilder: (context, index) {
        final notification = offers[index];
        return _NotificationCard(notification: notification)
            .animate(delay: (index * 50).ms)
            .fadeIn()
            .slideY(begin: 0.1, end: 0);
      },
    );
  }

  Widget _buildOrderUpdatesList() {
    final orders = mockNotifications.where((n) => n.type == 'order').toList();

    if (orders.isEmpty) {
      return const _EmptyState();
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final notification = orders[index];
        return _NotificationCard(notification: notification)
            .animate(delay: (index * 50).ms)
            .fadeIn()
            .slideY(begin: 0.1, end: 0);
      },
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.notifications_none_rounded, size: 64, color: AppColors.textHint),
          const SizedBox(height: 16),
          Text('No notifications', style: AppTypography.headingMedium(context)),
          const SizedBox(height: 8),
          Text('You\'re all caught up!', style: AppTypography.bodyMedium(context).copyWith(color: AppColors.textSecondary)),
        ],
      ),
    );
  }
}

class _NotificationCard extends StatelessWidget {
  final dynamic notification;

  const _NotificationCard({required this.notification});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: notification.isRead ? AppColors.surface : AppColors.primaryGreenLight,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          // Image/Icon
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: AppColors.primaryGreen.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: notification.imageUrl != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      notification.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const Icon(Icons.local_offer_rounded, color: AppColors.primaryGreen),
                    ),
                  )
                : const Icon(Icons.notifications_rounded, color: AppColors.primaryGreen),
          ),
          const SizedBox(width: 12),
          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  notification.title,
                  style: AppTypography.labelMedium(context),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  notification.body,
                  style: AppTypography.bodySmall(context).copyWith(color: AppColors.textSecondary),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  _getTimeAgo(notification.timestamp),
                  style: AppTypography.caption(context),
                ),
              ],
            ),
          ),
          // Unread indicator
          if (!notification.isRead)
            Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: AppColors.primaryGreen,
                shape: BoxShape.circle,
              ),
            ),
        ],
      ),
    );
  }

  String _getTimeAgo(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }
}
