import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart'; // for debugPrint
import 'dart:math';
import '../models/order_model.dart';
import '../models/dish_model.dart';
import 'auth_provider.dart';

part 'cart_provider.g.dart';

@riverpod
class CartNotifier extends _$CartNotifier {
  @override
  List<CartItem> build() {
    return [];
  }

  double get subtotal => state.fold(0, (total, current) => total + (current.dish.price * current.quantity));
  
  int get totalItems => state.fold(0, (total, current) => total + current.quantity);

  void addItem(DishModel dish) {
    final currentState = [...state];
    int index = currentState.indexWhere((item) => item.dish.id == dish.id);
    if (index >= 0) {
      final item = currentState[index];
      currentState[index] = CartItem(dish: item.dish)..quantity = item.quantity + 1;
    } else {
      currentState.add(CartItem(dish: dish));
    }
    state = currentState;
  }

  void removeItem(String dishId) {
    state = state.where((item) => item.dish.id != dishId).toList();
  }

  void decrementQuantity(String dishId) {
    final currentState = [...state];
    int index = currentState.indexWhere((item) => item.dish.id == dishId);
    if (index >= 0) {
      final item = currentState[index];
      if (item.quantity > 1) {
        currentState[index] = CartItem(dish: item.dish)..quantity = item.quantity - 1;
      } else {
        currentState.removeAt(index);
      }
      state = currentState;
    }
  }

  void clearCart() {
    state = [];
  }

  Future<bool> checkout(String tableNumber) async {
    if (state.isEmpty) return false;

    // Use Riverpod's ability to read other providers (Dependency Injection)
    final user = ref.read(authProvider);
    final String clientId = user?.id ?? 'guest_${DateTime.now().millisecondsSinceEpoch}';
    final String clientName = user?.name ?? 'Guest Client';

    final String orderId = (1000 + Random().nextInt(9000)).toString();

    final List<Map<String, dynamic>> chefFormattedItems = state.map((item) {
      return {
        'name': item.dish.name,
        'quantity': item.quantity,
        'price': item.dish.price,
      };
    }).toList();

    try {
      await FirebaseFirestore.instance.collection('orders').add({
        'clientId': clientId,
        'clientName': clientName,
        'tableNumber': tableNumber,
        'orderId': orderId,
        'items': chefFormattedItems,
        'totalPrice': subtotal,
        'status': 'In Kitchen',
        'timestamp': FieldValue.serverTimestamp(),
      });

      await FirebaseFirestore.instance.collection('tables').doc(tableNumber).set({
        'tableNumber': tableNumber,
        'isOccupied': true,
        'foodStatus': 'In Kitchen',
        'activeSince': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      clearCart();
      return true;
    } catch (e) {
      debugPrint("Checkout Error: $e");
      return false;
    }
  }
}
