import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class AuthProvider extends ChangeNotifier {
  UserModel? _currentUser;

  UserModel? get currentUser => _currentUser;

  bool get isAuthenticated => _currentUser != null;

  Future<bool> login(String email, String password) async {
    try {
      UserCredential userCredential;
      try {
        userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found' || e.code == 'invalid-credential' || e.code == 'invalid-login-credentials') {
          // Auto-register for dev purposes based on the credentials
          userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: email,
            password: password,
          );
          String role = (email == 'sinai@gmail.com' || email == 'manager@gmail.com') ? 'admin' : 'staff';
          await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).set({
            'email': email,
            'role': role,
            'name': email.split('@')[0],
          });
        } else {
          rethrow; // Other errors like network issue
        }
      }

      // Fetch user role from Firestore
      final doc = await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).get();
      final roleStr = doc.data()?['role'] ?? 'staff';
      _currentUser = UserModel(
        id: userCredential.user!.uid,
        email: email,
        name: doc.data()?['name'] ?? 'User',
        role: roleStr == 'admin' ? UserRole.manager : UserRole.employee,
      );
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint("Login error: $e");
      return false;
    }
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

  void logout() async {
    await FirebaseAuth.instance.signOut();
    _currentUser = null;
    notifyListeners();
  }
}
