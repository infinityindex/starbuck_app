class UserModel {
  final String id;
  final String name;
  final String email;
  final String avatarUrl;
  final int stars;
  final String tier;
  final DateTime memberSince;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.avatarUrl = '',
    this.stars = 340,
    this.tier = 'Gold',
    required this.memberSince,
  });
}
