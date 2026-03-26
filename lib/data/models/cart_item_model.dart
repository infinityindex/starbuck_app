import 'drink_model.dart';

class CartItemModel {
  final String id;
  final DrinkModel drink;
  final String size;
  final int quantity;
  final Map<String, dynamic> customizations;

  const CartItemModel({
    required this.id,
    required this.drink,
    this.size = 'Grande',
    this.quantity = 1,
    this.customizations = const {},
  });

  double get unitPrice {
    double base = drink.price;
    if (size == 'Tall') base -= 0.50;
    if (size == 'Venti') base += 0.50;
    if (size == 'Trenta') base += 1.00;
    return base;
  }

  double get totalPrice => unitPrice * quantity;

  CartItemModel copyWith({
    String? size,
    int? quantity,
    Map<String, dynamic>? customizations,
  }) {
    return CartItemModel(
      id: id,
      drink: drink,
      size: size ?? this.size,
      quantity: quantity ?? this.quantity,
      customizations: customizations ?? this.customizations,
    );
  }
}
