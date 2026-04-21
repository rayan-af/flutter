import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class AuthProvider extends ChangeNotifier {
  UserModel? _currentUser;

  UserModel? get currentUser => _currentUser;

  bool get isAuthenticated => _currentUser != null;

  Future<bool> login(String email, String password) async {
    email = email.trim().toLowerCase();
    if (!email.contains('@')) {
      email = '$email@resto.com';
    }
    if (password.length < 6) {
      password = password.padRight(6, '0');
    }
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
          String role = (email == 'sinai@gmail.com' || email == 'manager@gmail.com') ? 'admin' : (email.startsWith('recp') ? 'reception' : (email.startsWith('chef') ? 'chef' : 'staff'));
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
        imageUrl: doc.data()?['imageUrl'],
        role: roleStrToEnum(roleStr),
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

  Future<bool> register(String email, String password, String name) async {
    email = email.trim().toLowerCase();
    if (!email.contains('@')) {
      email = '$email@resto.com';
    }
    if (password.length < 6) {
      password = password.padRight(6, '0');
    }
    try {
      final userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      String role = (email == 'sinai@gmail.com' || email == 'manager@gmail.com') ? 'admin' : (email.startsWith('recp') ? 'reception' : (email.startsWith('chef') ? 'chef' : 'staff'));
      await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).set({
        'email': email,
        'name': name,
        'role': role,
        'imageUrl': null,
      });

      _currentUser = UserModel(
        id: userCredential.user!.uid,
        email: email,
        name: name,
        role: roleStrToEnum(role),
      );
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint("Register error: $e");
      return false;
    }
  }

  Future<bool> updateProfile(String name, String? imageUrl) async {
    if (_currentUser == null) return false;
    try {
      if (_currentUser!.id.startsWith('guest_')) {
        _currentUser = UserModel(
          id: _currentUser!.id,
          email: _currentUser!.email,
          name: name,
          imageUrl: imageUrl,
          role: _currentUser!.role,
        );
        notifyListeners();
        return true;
      }

      await FirebaseFirestore.instance.collection('users').doc(_currentUser!.id).update({
        'name': name,
        if (imageUrl != null) 'imageUrl': imageUrl,
      });

      _currentUser = UserModel(
        id: _currentUser!.id,
        email: _currentUser!.email,
        name: name,
        imageUrl: imageUrl,
        role: _currentUser!.role,
      );
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint("Update Profile error: $e");
      return false;
    }
  }

  UserRole roleStrToEnum(String role) {
    if (role == 'admin') return UserRole.manager;
    if (role == 'reception') return UserRole.reception;
    if (role == 'chef') return UserRole.chef;
    return UserRole.employee;
  }
}
