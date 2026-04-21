import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/order_model.dart';
import '../models/dish_model.dart';
import 'auth_provider.dart';

class CartProvider extends ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => _items;

  double get subtotal => _items.fold(0, (total, current) => total + (current.dish.price * current.quantity));
  
  int get totalItems => _items.fold(0, (total, current) => total + current.quantity);

  void addItem(DishModel dish) {
    int index = _items.indexWhere((item) => item.dish.id == dish.id);
    if (index >= 0) {
      _items[index].quantity += 1;
    } else {
      _items.add(CartItem(dish: dish));
    }
    notifyListeners();
  }

  void removeItem(String dishId) {
    _items.removeWhere((item) => item.dish.id == dishId);
    notifyListeners();
  }

  void decrementQuantity(String dishId) {
    int index = _items.indexWhere((item) => item.dish.id == dishId);
    if (index >= 0) {
      if (_items[index].quantity > 1) {
        _items[index].quantity -= 1;
      } else {
        _items.removeAt(index);
      }
      notifyListeners();
    }
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }

  Future<bool> checkout(AuthProvider authProvider) async {
    if (_items.isEmpty) return false;

    final user = authProvider.currentUser;
    final String clientId = user?.id ?? 'guest_${DateTime.now().millisecondsSinceEpoch}';
    final String clientName = user?.name ?? 'Guest Client';

    try {
      await FirebaseFirestore.instance.collection('orders').add({
        'clientId': clientId,
        'clientName': clientName,
        'items': _items.map((e) => e.toMap()).toList(),
        'totalPrice': subtotal,
        'status': 'pending',
        'createdAt': FieldValue.serverTimestamp(),
      });
      clearCart();
      return true;
    } catch (e) {
      debugPrint("Checkout Error: \$e");
      return false;
    }
  }
}
