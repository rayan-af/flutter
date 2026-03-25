import 'dart:async';
import 'package:flutter/material.dart';
import '../models/inventory_model.dart';
import '../models/dish_model.dart';
import '../services/firestore_service.dart';

class InventoryProvider extends ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();
  
  List<InventoryModel> _items = [];
  List<InventoryModel> get items => _items;
  
  List<InventoryModel> get lowStockItems => 
      _items.where((item) => item.isLowStock).toList();

  int get lowStockCount => lowStockItems.length;

  double get totalInventoryValue {
    return _items.fold(0.0, (sum, item) => sum + (item.quantity * 0.5)); // Mock cost for now
  }

  StreamSubscription? _subscription;

  InventoryProvider(); // Removed automatic stream initialization to avoid permission-denied.

  void initialize() {
    _subscription?.cancel();
    _subscription = _firestoreService.getInventoryStream().listen((snapshot) {
      _items = snapshot;
      notifyListeners();
    });
  }

  void stopStream() {
    _subscription?.cancel();
    _subscription = null;
    _items = [];
    notifyListeners();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  // Seeding
  Future<void> seedData() async {
    // Hardcoded mock data to seed
     final List<InventoryModel> mockInventory = [
      InventoryModel(id: 'inv_1', name: 'Espresso Beans', quantity: 5000, threshold: 1000, unit: 'g', cost: 0.02),
      InventoryModel(id: 'inv_2', name: 'Milk', quantity: 10000, threshold: 2000, unit: 'ml', cost: 0.0015),
      InventoryModel(id: 'inv_3', name: 'Cold Brew Concentrate', quantity: 5000, threshold: 1000, unit: 'ml', cost: 0.01),
      InventoryModel(id: 'inv_4', name: 'Vanilla Syrup', quantity: 50, threshold: 10, unit: 'pumps', cost: 0.10),
      InventoryModel(id: 'inv_5', name: 'Caramel Sauce', quantity: 1000, threshold: 200, unit: 'g', cost: 0.05),
      InventoryModel(id: 'inv_6', name: 'Water', quantity: 50000, threshold: 1000, unit: 'ml', cost: 0.00),
      InventoryModel(id: 'inv_7', name: 'Fettuccine', quantity: 2000, threshold: 500, unit: 'g', cost: 0.005),
      InventoryModel(id: 'inv_8', name: 'Alfredo Sauce', quantity: 3000, threshold: 500, unit: 'ml', cost: 0.008),
      InventoryModel(id: 'inv_9', name: 'Grilled Chicken', quantity: 50, threshold: 10, unit: 'breasts', cost: 1.50),
      InventoryModel(id: 'inv_10', name: 'Parmesan', quantity: 1000, threshold: 200, unit: 'g', cost: 0.02),
      InventoryModel(id: 'inv_11', name: 'Beef Patty', quantity: 40, threshold: 10, unit: 'patties', cost: 2.00),
      InventoryModel(id: 'inv_12', name: 'Bun', quantity: 60, threshold: 12, unit: 'buns', cost: 0.40),
      InventoryModel(id: 'inv_13', name: 'Lettuce', quantity: 20, threshold: 5, unit: 'heads', cost: 1.00),
      InventoryModel(id: 'inv_14', name: 'Tomato', quantity: 30, threshold: 5, unit: 'units', cost: 0.50),
      InventoryModel(id: 'inv_15', name: 'Cheddar Cheese', quantity: 100, threshold: 20, unit: 'slices', cost: 0.20),
      InventoryModel(id: 'inv_16', name: 'Sourdough Bread', quantity: 40, threshold: 10, unit: 'slices', cost: 0.30),
      InventoryModel(id: 'inv_17', name: 'Avocado', quantity: 25, threshold: 5, unit: 'units', cost: 1.20),
      InventoryModel(id: 'inv_18', name: 'Egg', quantity: 100, threshold: 24, unit: 'units', cost: 0.25),
    ];

    await _firestoreService.seedDatabase(DishModel.mockDishes, mockInventory);
  }

  // --- Actions forwarded to Service ---

  Future<void> processOrder(DishModel dish) async {
    // This is now handled by Firestore Transaction in POS, 
    // but we might keep this for local optimistic updates if needed,
    // or better, remove it to rely strictly on streams.
    // The POS screen should call FirestoreService.submitOrder.
  }

  Future<void> restockItem(String id, double amount) async {
    await _firestoreService.restockItem(id, amount);
  }
}
