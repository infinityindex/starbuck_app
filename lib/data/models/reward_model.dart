class RewardModel {
  final String id;
  final String title;
  final String description;
  final int starCost;
  final String imageUrl;
  final bool isAvailable;

  const RewardModel({
    required this.id,
    required this.title,
    required this.description,
    required this.starCost,
    required this.imageUrl,
    this.isAvailable = true,
  });
}
