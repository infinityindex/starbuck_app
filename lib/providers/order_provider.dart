import 'package:flutter/foundation.dart';
import '../data/models/order_model.dart';
import '../data/models/cart_item_model.dart';
import '../data/mock/mock_orders.dart';

class OrderProvider extends ChangeNotifier {
  OrderModel? _currentOrder;
  final List<OrderModel> _history = List.from(mockOrderHistory);

  OrderModel? get currentOrder => _currentOrder;
  List<OrderModel> get history => List.unmodifiable(_history);

  Future<OrderModel> placeOrder(List<CartItemModel> items, double total) async {
    await Future.delayed(const Duration(milliseconds: 1500));
    final order = OrderModel(
      id: 'ORD-${DateTime.now().millisecondsSinceEpoch}',
      items: List.from(items),
      status: OrderStatus.received,
      timestamp: DateTime.now(),
      total: total,
    );
    _currentOrder = order;
    _history.insert(0, order);
    notifyListeners();
    return order;
  }

  void updateOrderStatus(OrderStatus status) {
    if (_currentOrder != null) {
      _currentOrder = _currentOrder!.copyWith(status: status);
      notifyListeners();
    }
  }
}
