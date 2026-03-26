import 'package:flutter/foundation.dart';
import '../data/models/cart_item_model.dart';
import '../data/models/drink_model.dart';

class CartProvider extends ChangeNotifier {
  final List<CartItemModel> _items = [];

  List<CartItemModel> get items => List.unmodifiable(_items);
  int get totalItems => _items.fold(0, (sum, item) => sum + item.quantity);
  bool get isEmpty => _items.isEmpty;

  double get subtotal => _items.fold(0, (sum, item) => sum + item.totalPrice);
  double get tax => subtotal * 0.0875;
  double get total => subtotal + tax;

  void addItem(DrinkModel drink, {String size = 'Grande', Map<String, dynamic> customizations = const {}}) {
    final existingIndex = _items.indexWhere(
      (item) => item.drink.id == drink.id && item.size == size,
    );
    if (existingIndex >= 0) {
      _items[existingIndex] = _items[existingIndex].copyWith(
        quantity: _items[existingIndex].quantity + 1,
      );
    } else {
      _items.add(CartItemModel(
        id: '${drink.id}_${size}_${DateTime.now().millisecondsSinceEpoch}',
        drink: drink,
        size: size,
        customizations: customizations,
      ));
    }
    notifyListeners();
  }

  void removeItem(String itemId) {
    _items.removeWhere((item) => item.id == itemId);
    notifyListeners();
  }

  void updateQuantity(String itemId, int quantity) {
    if (quantity <= 0) {
      removeItem(itemId);
      return;
    }
    final index = _items.indexWhere((item) => item.id == itemId);
    if (index >= 0) {
      _items[index] = _items[index].copyWith(quantity: quantity);
      notifyListeners();
    }
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}
