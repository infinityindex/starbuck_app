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
}
