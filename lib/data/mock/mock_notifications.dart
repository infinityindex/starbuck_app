import '../models/notification_model.dart';

final List<NotificationModel> mockNotifications = [
  NotificationModel(
    id: 'n1',
    title: 'Happy Hour is here! ☕',
    body: 'Buy one handcrafted drink, get one 50% off. Today only, 3-6 PM.',
    timestamp: DateTime.now().subtract(const Duration(minutes: 30)),
    isRead: false,
    type: 'offer',
    imageUrl: 'https://images.unsplash.com/photo-1495474472287-4d71bcdd2085?w=300',
  ),
  NotificationModel(
    id: 'n2',
    title: 'Your order is ready!',
    body: 'Your Caramel Macchiato is ready for pickup at Pike St location.',
    timestamp: DateTime.now().subtract(const Duration(hours: 2)),
    isRead: false,
    type: 'order',
  ),
  NotificationModel(
    id: 'n3',
    title: 'Earn 3x Stars this week',
    body: 'Order your favorite handcrafted drinks and earn triple stars through Sunday.',
    timestamp: DateTime.now().subtract(const Duration(days: 1)),
    isRead: true,
    type: 'promo',
    imageUrl: 'https://images.unsplash.com/photo-1572286258217-215cf8e9e06b?w=300',
  ),
  NotificationModel(
    id: 'n4',
    title: 'New Fall Menu Available',
    body: 'Pumpkin Spice Latte and other fall favorites are back!',
    timestamp: DateTime.now().subtract(const Duration(days: 3)),
    isRead: true,
    type: 'promo',
    imageUrl: 'https://images.unsplash.com/photo-1570968915860-54d5c301fa9f?w=300',
  ),
  NotificationModel(
    id: 'n5',
    title: 'You\'re 60 stars away from Gold!',
    body: 'Keep earning stars with every purchase to reach Gold status.',
    timestamp: DateTime.now().subtract(const Duration(days: 5)),
    isRead: true,
    type: 'offer',
  ),
];
