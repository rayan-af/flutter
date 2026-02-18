import 'package:flutter/material.dart';
import '../models/user_model.dart';

class AuthProvider extends ChangeNotifier {
  UserModel? _currentUser;

  UserModel? get currentUser => _currentUser;

  bool get isAuthenticated => _currentUser != null;

  Future<bool> login(String email, String password) async {
    // Mock Login Logic with Hardcoded Credentials
    await Future.delayed(const Duration(seconds: 1)); // Simulate network delay

    if (email == 'manager@gmail.com' && password == '1234') {
      _currentUser = UserModel(
        id: 'manager_01',
        email: email,
        name: "Manager User",
        role: UserRole.manager,
      );
      notifyListeners();
      return true;
    }

    if ((email == 'sinai@gmail.com' || email == 'sinai@gmai.com') && password == '1234') {
      _currentUser = UserModel(
        id: 'staff_01',
        email: email,
        name: "Sinai Staff",
        role: UserRole.employee,
      );
      notifyListeners();
      return true;
    }

    return false;
  }

  void loginAsGuest() {
    _currentUser = UserModel(
      id: 'guest_${DateTime.now().millisecondsSinceEpoch}',
      email: 'guest@public',
      name: "Guest",
      role: UserRole.customer,
    );
    notifyListeners();
  }

  void logout() {
    _currentUser = null;
    notifyListeners();
  }
}

