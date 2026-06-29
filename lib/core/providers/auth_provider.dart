import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

part 'auth_provider.g.dart';

@Riverpod(keepAlive: true)
class AuthNotifier extends _$AuthNotifier {
  @override
  UserModel? build() {
    return null;
  }

  bool get isAuthenticated => state != null;
  UserModel? get currentUser => state;

  UserRole _roleStrToEnum(String role) {
    if (role == 'admin') return UserRole.manager;
    if (role == 'reception') return UserRole.reception;
    if (role == 'chef') return UserRole.chef;
    return UserRole.employee;
  }

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
          rethrow;
        }
      }

      final doc = await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).get();
      String roleStr = doc.data()?['role'] ?? 'staff';
      if (email.startsWith('chef')) {
        roleStr = 'chef';
      }
      
      state = UserModel(
        id: userCredential.user!.uid,
        email: email,
        name: doc.data()?['name'] ?? 'User',
        imageUrl: doc.data()?['imageUrl'],
        role: _roleStrToEnum(roleStr),
      );
      return true;
    } catch (e) {
      debugPrint("Login error: $e");
      return false;
    }
  }

  Future<void> loginAsGuest() async {
    try {
      final email = 'guest_${DateTime.now().millisecondsSinceEpoch}@resto.com';
      final password = 'guestpassword';
      final userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).set({
        'email': email,
        'name': 'Guest',
        'role': 'admin',
        'imageUrl': null,
      });

      state = UserModel(
        id: userCredential.user!.uid,
        email: email,
        name: "Guest",
        role: UserRole.customer,
      );
    } catch (e) {
      debugPrint("Guest login error: $e");
      state = UserModel(
        id: 'guest_${DateTime.now().millisecondsSinceEpoch}',
        email: 'guest@public',
        name: "Guest",
        role: UserRole.customer,
      );
    }
  }

  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
    state = null;
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

      state = UserModel(
        id: userCredential.user!.uid,
        email: email,
        name: name,
        role: _roleStrToEnum(role),
      );
      return true;
    } catch (e) {
      debugPrint("Register error: $e");
      return false;
    }
  }

  Future<bool> updateProfile(String name, String? imageUrl) async {
    if (state == null) return false;
    try {
      if (state!.id.startsWith('guest_')) {
        state = UserModel(
          id: state!.id,
          email: state!.email,
          name: name,
          imageUrl: imageUrl,
          role: state!.role,
        );
        return true;
      }

      await FirebaseFirestore.instance.collection('users').doc(state!.id).update({
        'name': name,
        if (imageUrl != null) 'imageUrl': imageUrl,
      });

      state = UserModel(
        id: state!.id,
        email: state!.email,
        name: name,
        imageUrl: imageUrl,
        role: state!.role,
      );
      return true;
    } catch (e) {
      debugPrint("Update Profile error: $e");
      return false;
    }
  }
}
