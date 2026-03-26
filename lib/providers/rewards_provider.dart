import 'package:flutter/foundation.dart';
import '../data/models/reward_model.dart';
import '../data/mock/mock_rewards.dart';

/// Provider for managing user rewards and stars.
class RewardsProvider extends ChangeNotifier {
  int _stars = 340; // Initial stars from mock user
  String _tier = 'Gold';
  final List<RedeemedReward> _redeemedRewards = [];
  final List<RewardModel> _availableRewards = List.from(mockRewards);

  // Getters
  int get stars => _stars;
  String get tier => _tier;
  List<RedeemedReward> get redeemedRewards => List.unmodifiable(_redeemedRewards);
  List<RewardModel> get availableRewards => _availableRewards;
  
  int get starsToNextTier {
    if (_tier == 'Green') return 300 - _stars;
    if (_tier == 'Gold') return 400 - _stars;
    return 0; // Platinum is max
  }

  double get progressToNextTier {
    if (_tier == 'Green') return _stars / 300.0;
    if (_tier == 'Gold') return _stars / 400.0;
    return 1.0;
  }

  /// Check if user can afford a reward
  bool canRedeem(RewardModel reward) {
    return reward.isAvailable && _stars >= reward.starCost;
  }

  /// Redeem a reward and deduct stars
  bool redeemReward(RewardModel reward) {
    if (!canRedeem(reward)) return false;

    _stars -= reward.starCost;
    _redeemedRewards.add(RedeemedReward(
      reward: reward,
      redeemedAt: DateTime.now(),
      code: _generateRedeemCode(),
      expiresAt: DateTime.now().add(const Duration(days: 30)),
    ));
    
    _updateTier();
    notifyListeners();
    return true;
  }

  /// Add stars (e.g., from a purchase)
  void addStars(int amount) {
    _stars += amount;
    _updateTier();
    notifyListeners();
  }

  /// Update tier based on current stars
  void _updateTier() {
    if (_stars >= 400) {
      _tier = 'Platinum';
    } else if (_stars >= 300) {
      _tier = 'Gold';
    } else {
      _tier = 'Green';
    }
  }

  /// Generate a random redemption code
  String _generateRedeemCode() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = DateTime.now().millisecondsSinceEpoch;
    String code = '';
    for (int i = 0; i < 8; i++) {
      code += chars[(random + i * 7) % chars.length];
    }
    return code;
  }

  /// Mark a redeemed reward as used
  void useReward(String code) {
    final index = _redeemedRewards.indexWhere((r) => r.code == code);
    if (index >= 0) {
      _redeemedRewards[index] = _redeemedRewards[index].copyWith(isUsed: true);
      notifyListeners();
    }
  }
}

/// A reward that has been redeemed by the user.
class RedeemedReward {
  final RewardModel reward;
  final DateTime redeemedAt;
  final String code;
  final DateTime expiresAt;
  final bool isUsed;

  const RedeemedReward({
    required this.reward,
    required this.redeemedAt,
    required this.code,
    required this.expiresAt,
    this.isUsed = false,
  });

  RedeemedReward copyWith({
    RewardModel? reward,
    DateTime? redeemedAt,
    String? code,
    DateTime? expiresAt,
    bool? isUsed,
  }) {
    return RedeemedReward(
      reward: reward ?? this.reward,
      redeemedAt: redeemedAt ?? this.redeemedAt,
      code: code ?? this.code,
      expiresAt: expiresAt ?? this.expiresAt,
      isUsed: isUsed ?? this.isUsed,
    );
  }

  bool get isExpired => DateTime.now().isAfter(expiresAt);
  bool get isValid => !isUsed && !isExpired;
  
  int get daysUntilExpiry => expiresAt.difference(DateTime.now()).inDays;
}
