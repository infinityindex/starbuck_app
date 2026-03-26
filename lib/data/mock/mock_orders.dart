import '../models/order_model.dart';
import '../models/cart_item_model.dart';
import 'mock_drinks.dart';

final List<OrderModel> mockOrderHistory = [
  OrderModel(
    id: 'ORD-2024-001',
    items: [
      CartItemModel(id: 'ci1', drink: mockDrinks[0], size: 'Grande', quantity: 1),
      CartItemModel(id: 'ci2', drink: mockDrinks[3], size: 'Tall', quantity: 2),
    ],
    status: OrderStatus.completed,
    timestamp: DateTime.now().subtract(const Duration(days: 1)),
    total: 14.35,
    storeName: 'Starbucks Reserve Roastery',
  ),
  OrderModel(
    id: 'ORD-2024-002',
    items: [
      CartItemModel(id: 'ci3', drink: mockDrinks[5], size: 'Venti', quantity: 1),
    ],
    status: OrderStatus.completed,
    timestamp: DateTime.now().subtract(const Duration(days: 3)),
    total: 6.25,
    storeName: 'Starbucks - 1st & Pike',
  ),
  OrderModel(
    id: 'ORD-2024-003',
    items: [
      CartItemModel(id: 'ci4', drink: mockDrinks[1], size: 'Grande', quantity: 1),
      CartItemModel(id: 'ci5', drink: mockDrinks[7], size: 'Grande', quantity: 1),
    ],
    status: OrderStatus.cancelled,
    timestamp: DateTime.now().subtract(const Duration(days: 7)),
    total: 10.70,
    storeName: 'Starbucks - University Village',
  ),
  OrderModel(
    id: 'ORD-2024-004',
    items: [
      CartItemModel(id: 'ci6', drink: mockDrinks[10], size: 'Grande', quantity: 2),
      CartItemModel(id: 'ci7', drink: mockDrinks[2], size: 'Tall', quantity: 1),
    ],
    status: OrderStatus.completed,
    timestamp: DateTime.now().subtract(const Duration(days: 14)),
    total: 15.40,
    storeName: 'Starbucks - Capitol Hill',
  ),
];
