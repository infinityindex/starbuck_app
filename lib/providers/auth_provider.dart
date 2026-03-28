import 'package:flutter/foundation.dart';
import '../data/models/user_model.dart';
import '../data/mock/mock_user.dart';

class AuthProvider extends ChangeNotifier {
  bool _isLoggedIn = false;
  UserModel? _user;

  bool get isLoggedIn => _isLoggedIn;
  UserModel? get user => _user;

  Future<void> signIn(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 1500));
    _isLoggedIn = true;
    _user = mockUser;
    notifyListeners();
  }

  Future<void> signUp(String name, String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 1500));
    _isLoggedIn = true;
    _user = UserModel(
      id: 'u_new',
      name: name,
      email: email,
      memberSince: DateTime.now(),
    );
    notifyListeners();
  }

  void signOut() {
    _isLoggedIn = false;
    _user = null;
    notifyListeners();
  }

  // Simulated OTP flow for password reset
  String? _lastOtp;

  Future<void> sendPasswordResetOtp(String email) async {
    // simulate network delay and OTP generation
    await Future.delayed(const Duration(milliseconds: 1200));
    // generate a 6-digit OTP (for simulation)
    _lastOtp = (100000 + (DateTime.now().millisecondsSinceEpoch % 899999)).toString();
    // In a real app, send OTP to user's email via backend
    notifyListeners();
  }

  Future<bool> verifyPasswordResetOtp(String otp) async {
    await Future.delayed(const Duration(milliseconds: 800));
    return _lastOtp != null && otp.trim() == _lastOtp!.trim();
  }
}
