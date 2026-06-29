import 'package:cloud_firestore/cloud_firestore.dart';
import 'dish_model.dart';

class CartItem {
  final DishModel dish;
  int quantity;

  CartItem({required this.dish, this.quantity = 1});

  Map<String, dynamic> toMap() {
    return {
      'dish': dish.toMap(),
      'quantity': quantity,
    };
  }

  factory CartItem.fromMap(Map<String, dynamic> map) {
    return CartItem(
      dish: DishModel.fromMap(map['dish'], map['dish']['id']),
      quantity: map['quantity'] ?? 1,
    );
  }
}

class OrderModel {
  final String id;
  final String clientId;
  final String clientName;
  final List<CartItem> items;
  final double totalPrice;
  final String status; // 'pending', 'cooking', 'done'
  final DateTime createdAt;

  OrderModel({
    required this.id,
    required this.clientId,
    required this.clientName,
    required this.items,
    required this.totalPrice,
    this.status = 'pending',
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'clientId': clientId,
      'clientName': clientName,
      'items': items.map((e) => e.toMap()).toList(),
      'totalPrice': totalPrice,
      'status': status,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  factory OrderModel.fromMap(Map<String, dynamic> map, String documentId) {
    var itemsList = (map['items'] as List?) ?? [];
    return OrderModel(
      id: documentId,
      clientId: map['clientId'] ?? '',
      clientName: map['clientName'] ?? 'Guest',
      items: itemsList.map((e) => CartItem.fromMap(e)).toList(),
      totalPrice: (map['totalPrice'] ?? 0).toDouble(),
      status: map['status'] ?? 'pending',
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }
}
