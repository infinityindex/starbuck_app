import '../models/reward_model.dart';

const List<RewardModel> mockRewards = [
  RewardModel(
    id: 'r1',
    title: 'Free Customization',
    description: 'Add an extra shot, syrup, or milk alternative',
    starCost: 25,
    imageUrl: 'https://images.unsplash.com/photo-1495474472287-4d71bcdd2085?w=200',
    isAvailable: true,
  ),
  RewardModel(
    id: 'r2',
    title: 'Free Hot Brewed Coffee',
    description: 'Any size hot brewed coffee or tea',
    starCost: 50,
    imageUrl: 'https://images.unsplash.com/photo-1509042239860-f550ce710b93?w=200',
    isAvailable: true,
  ),
  RewardModel(
    id: 'r3',
    title: 'Free Handcrafted Drink',
    description: 'Any size espresso, cold brew or tea',
    starCost: 150,
    imageUrl: 'https://images.unsplash.com/photo-1514432324607-a09d9b4aefdd?w=200',
    isAvailable: true,
  ),
  RewardModel(
    id: 'r4',
    title: 'Free Food Item',
    description: 'Any pastry, sandwich or protein box',
    starCost: 200,
    imageUrl: 'https://images.unsplash.com/photo-1555507036-ab1f4038808a?w=200',
    isAvailable: false,
  ),
  RewardModel(
    id: 'r5',
    title: 'Free Merchandise',
    description: 'A Starbucks mug or merchandise',
    starCost: 400,
    imageUrl: 'https://images.unsplash.com/photo-1506619216599-9d16d0903dfd?w=200',
    isAvailable: false,
  ),
];
