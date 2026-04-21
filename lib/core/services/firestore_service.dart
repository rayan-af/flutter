import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/dish_model.dart';
import '../models/inventory_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  static final FirestoreService _instance = FirestoreService._internal();
  factory FirestoreService() => _instance;
  FirestoreService._internal();

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Collections
  CollectionReference get _inventory => _db.collection('inventory');
  CollectionReference get _recipes => _db.collection('recipes');
  CollectionReference get _orders => _db.collection('orders');
  CollectionReference get _wasteLog => _db.collection('waste_log');

  // --- Streams ---
  
  Stream<List<InventoryModel>> getInventoryStream() {
    return _inventory.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => InventoryModel.fromMap(doc.data() as Map<String, dynamic>, doc.id)).toList();
    });
  }

  Stream<List<DishModel>> getMenuStream() {
    return _recipes.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => DishModel.fromMap(doc.data() as Map<String, dynamic>, doc.id)).toList();
    });
  }

  Stream<QuerySnapshot> getWasteLogsStream() {
    return _wasteLog.orderBy('timestamp', descending: true).limit(50).snapshots();
  }
  
  Stream<QuerySnapshot> getOrdersStream() {
    return _orders.orderBy('timestamp', descending: true).limit(100).snapshots();
  }

  Future<bool> checkIfAdmin() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return false;
    final doc = await _db.collection('users').doc(user.uid).get();
    if (doc.exists && doc.data()?['role'] == 'admin') {
      return true;
    }
    return false;
  }

  // --- Actions ---

  Future<void> logWaste(String itemId, double quantity, String reason, String userId) async {
    final itemRef = _inventory.doc(itemId);
    final itemSnapshot = await itemRef.get();
    final cost = (itemSnapshot.data() as Map<String, dynamic>?)?['cost'] ?? 0.0;
    final costLost = (cost as num).toDouble() * quantity;

    final batch = _db.batch();

    // 1. Create Waste Log
    final logRef = _wasteLog.doc();
    batch.set(logRef, {
      'itemId': itemId,
      'quantity': quantity,
      'reason': reason,
      'cost_lost': costLost,
      'userId': userId,
      'timestamp': FieldValue.serverTimestamp(),
    });

    // 2. Decrement Inventory
    batch.update(itemRef, {
      'quantity': FieldValue.increment(-quantity),
    });

    await batch.commit();
  }

  Future<void> restockItem(String itemId, double quantity) async {
    await _inventory.doc(itemId).update({
      'quantity': FieldValue.increment(quantity),
    });
  }

  Future<void> addInventoryItem(String name, double quantity, String unit, double cost) async {
    final newItemRef = _inventory.doc();
    await newItemRef.set({
      'name': name,
      'quantity': quantity,
      'unit': unit,
      'cost': cost,
      'isLowStock': false, // Base logic, can be customized later
      'lastUpdated': FieldValue.serverTimestamp(),
    });
  }

  Future<void> deleteInventoryItem(String id) async {
    await _inventory.doc(id).delete();
  }

  Future<void> addRecipeItem(String name, double price, String category) async {
    final newRecipeRef = _recipes.doc();
    await newRecipeRef.set({
      'name': name,
      'price': price,
      'category': category,
      'description': 'New item added via POS',
      'rating': 0.0,
      'reviewCount': 0,
      'calories': 0,
      'imageUrl': 'https://placehold.co/400x400/1E1E2C/FFF',
      'ingredients': [],
      'recipe': {},
      'lastUpdated': FieldValue.serverTimestamp(),
    });
  }

  // Smart POS Transaction
  Future<void> submitOrder(List<DishModel> items, String userId) async {
    return _db.runTransaction((transaction) async {
      // 1. Calculate total ingredients needed
      Map<String, double> ingredientsNeeded = {};
      
      for (var dish in items) {
        dish.recipe.forEach((ingName, qty) {
          ingredientsNeeded[ingName] = (ingredientsNeeded[ingName] ?? 0) + qty;
        });
      }

      // 2. Read inventory for these ingredients
      // Note: This is tricky because we stored recipe by NAME in mock data, 
      // but Firestore should ideally use IDs. 
      // For now, assuming we keyed by Name or have a way to lookup. 
      // To keep it robust, we should query inventory by name.
      
      // OPTIMIZATION: In a real app, use IDs in recipe. 
      // Here we'll read all inventory items needed.
      
      // Since we can't query inside transaction easily for multiple names without IDs,
      // We will rely on the fact that we seeded inventory and should know IDs or match by name.
      // Let's assume we fetch all inventory first or query by name.
      // For simplicity in this "Smart" step: Query all inventory (small list) or specific docs if we used IDs in recipe.
      
      // CRITICAL: We need IDs. We'll update DishModel to use IDs in recipe or map names to IDs.
      // For this implementation, let's assume we map Name -> DocID via a lookup or just query.
      // Querying inside transaction for 'whereIn' is possible.
      
      final inventorySnapshot = await _inventory.get(); // Read all for safety in this scale (cafe)
      final inventoryDocs = inventorySnapshot.docs;
      
      // Check availability
      for (var entry in ingredientsNeeded.entries) {
        final name = entry.key;
        final requiredQty = entry.value;
        
        try {
          final doc = inventoryDocs.firstWhere((d) => (d.data() as Map)['name'] == name);
          final currentQty = (doc.data() as Map)['quantity'] as num;
          
          if (currentQty < requiredQty) {
            throw Exception("Insufficient stock for $name");
          }
          
          // Decrement
          transaction.update(doc.reference, {
            'quantity': FieldValue.increment(-requiredQty)
          });
          
        } catch (e) {
             if (e is StateError) {
               throw Exception("Ingredient $name not found in inventory");
             }
             rethrow;
        }
      }

      // 3. Create Order
      final orderRef = _orders.doc();
      transaction.set(orderRef, {
        'items': items.map((i) => {'id': i.id, 'name': i.name, 'price': i.price}).toList(),
        'total': items.fold(0.0, (sum, i) => sum + i.price),
        'userId': userId,
        'status': 'pending',
        'timestamp': FieldValue.serverTimestamp(),
      });

      // 4. Update Popular Dishes stats
      Map<String, int> dishCounts = {};
      for (var dish in items) {
        dishCounts[dish.id] = (dishCounts[dish.id] ?? 0) + 1;
      }
      for (var entry in dishCounts.entries) {
        final recipeRef = _recipes.doc(entry.key);
        transaction.update(recipeRef, {
          'orderCount': FieldValue.increment(entry.value)
        });
      }
    });
  }

  Future<void> resetPopularDishesStats() async {
    final snapshot = await _recipes.get();
    final batch = _db.batch();
    for (var doc in snapshot.docs) {
      batch.update(doc.reference, {'orderCount': 0});
    }
    await batch.commit();
  }

  // Seeding (One-time)
  Future<void> seedDatabase(List<DishModel> dishes, List<InventoryModel> inventory) async {
    final batch = _db.batch();

    // Clear existing (optional, or just overwrite)
    // For safety, let's just add/merge
    
    for (var item in inventory) {
      final ref = _inventory.doc(item.id); //'inv_1', etc
      batch.set(ref, item.toMap());
    }

    for (var dish in dishes) {
      final ref = _recipes.doc(dish.id);
      batch.set(ref, dish.toMap());
    }

    await batch.commit();
  }
}
