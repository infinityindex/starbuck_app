class DrinkModel {
  final String id;
  final String name;
  final String category;
  final String imageUrl;
  final double price;
  final String description;
  final int calories;
  final bool isAvailable;
  final bool isFeatured;
  final List<String> tags;
  final double rating;
  final int reviewCount;

  const DrinkModel({
    required this.id,
    required this.name,
    required this.category,
    required this.imageUrl,
    required this.price,
    required this.description,
    this.calories = 0,
    this.isAvailable = true,
    this.isFeatured = false,
    this.tags = const [],
    this.rating = 4.5,
    this.reviewCount = 0,
  });
}
