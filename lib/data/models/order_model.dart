import 'cart_item_model.dart';

enum OrderStatus { received, preparing, almostReady, ready, completed, cancelled }

class OrderModel {
  final String id;
  final List<CartItemModel> items;
  final OrderStatus status;
  final DateTime timestamp;
  final double total;
  final int estimatedMinutes;
  final String storeName;

  const OrderModel({
    required this.id,
    required this.items,
    required this.status,
    required this.timestamp,
    required this.total,
    this.estimatedMinutes = 5,
    this.storeName = 'Starbucks Reserve',
  });

  OrderModel copyWith({OrderStatus? status}) {
    return OrderModel(
      id: id,
      items: items,
      status: status ?? this.status,
      timestamp: timestamp,
      total: total,
      estimatedMinutes: estimatedMinutes,
      storeName: storeName,
    );
  }
}
