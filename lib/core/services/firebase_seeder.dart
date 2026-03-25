import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseSeeder {
  static Future<void> syncLocalDataToCloud() async {
    final firestore = FirebaseFirestore.instance;
    final batch = firestore.batch();

    // --- 1. Inventory Items (10 items) ---
    final List<Map<String, dynamic>> mockInventory = [
      {"id": "INV-M-001", "name": "Premium Saffron Threads", "category": "Spice", "quantity": 0.5, "unit": "kg", "threshold": 0.1, "cost": 1200.00},
      {"id": "INV-M-002", "name": "Organic Argan Oil (Culinary)", "category": "Oil", "quantity": 5.0, "unit": "liters", "threshold": 1.0, "cost": 45.00},
      {"id": "INV-M-003", "name": "Fresh Mint Leaves", "category": "Produce", "quantity": 10.0, "unit": "kg", "threshold": 2.0, "cost": 3.50},
      {"id": "INV-M-004", "name": "Gunpowder Green Tea", "category": "Dry", "quantity": 15.0, "unit": "kg", "threshold": 3.0, "cost": 12.00},
      {"id": "INV-M-005", "name": "Orange Blossom Water", "category": "Liquid", "quantity": 8.0, "unit": "liters", "threshold": 2.0, "cost": 8.00},
      {"id": "INV-M-006", "name": "Almond Paste", "category": "Dry", "quantity": 20.0, "unit": "kg", "threshold": 5.0, "cost": 15.00},
      {"id": "INV-M-007", "name": "Khobz (Moroccan Bread)", "category": "Bakery", "quantity": 100.0, "unit": "pcs", "threshold": 20.0, "cost": 0.50},
      {"id": "INV-M-008", "name": "Amlou Spread", "category": "Pantry", "quantity": 10.0, "unit": "kg", "threshold": 2.0, "cost": 25.00},
      {"id": "INV-M-009", "name": "Fresh Figs", "category": "Produce", "quantity": 12.0, "unit": "kg", "threshold": 3.0, "cost": 6.00},
      {"id": "INV-M-010", "name": "Medjool Dates", "category": "Produce", "quantity": 25.0, "unit": "kg", "threshold": 5.0, "cost": 18.00}
    ];

    for (var item in mockInventory) {
      final docRef = firestore.collection('inventory').doc(item['id']);
      batch.set(docRef, item);
    }

    // --- 2. Recipes / Menu Items (10 items) ---
    final List<Map<String, dynamic>> mockRecipes = [
      {
        "id": "REC-M-001", "name": "Royal Moroccan Mint Tea", "category": "Drinks", "price": 4.50, "rating": 4.9, "reviewCount": 340,
        "description": "Authentic gunpowder green tea infused with copious fresh mint and a hint of orange blossom water.", "calories": 40, "imageUrl": "https://placehold.co/400x400/1E1E2C/FFF",
        "ingredients": ["Gunpowder Green Tea", "Fresh Mint Leaves", "Sugar", "Orange Blossom Water"], 
        "recipe": {"Gunpowder Green Tea": 0.05, "Fresh Mint Leaves": 0.05, "Orange Blossom Water": 0.01}
      },
      {
        "id": "REC-M-002", "name": "Saffron & Almond Pastilla", "category": "Pastries", "price": 12.00, "rating": 4.8, "reviewCount": 210,
        "description": "Sweet and savory crisp pastry filled with spiced almonds and a delicate saffron infusion.", "calories": 420, "imageUrl": "https://placehold.co/400x400/1E1E2C/FFF",
        "ingredients": ["Almond Paste", "Premium Saffron Threads", "Phyllo Dough", "Honey"], 
        "recipe": {"Almond Paste": 0.1, "Premium Saffron Threads": 0.001}
      },
      {
        "id": "REC-M-003", "name": "Amlou Toast with Fresh Figs", "category": "Breakfast", "price": 8.50, "rating": 4.7, "reviewCount": 150,
        "description": "Warm artisanal Khobz topped with rich almond-argan Amlou spread and sliced fresh figs.", "calories": 380, "imageUrl": "https://placehold.co/400x400/1E1E2C/FFF",
        "ingredients": ["Khobz (Moroccan Bread)", "Amlou Spread", "Fresh Figs"], 
        "recipe": {"Khobz (Moroccan Bread)": 1.0, "Amlou Spread": 0.05, "Fresh Figs": 0.1}
      },
      {
        "id": "REC-M-004", "name": "Medjool Date Smoothie", "category": "Drinks", "price": 6.50, "rating": 4.6, "reviewCount": 95,
        "description": "Creamy almond milk blended with premium Medjool dates and a dash of cinnamon.", "calories": 290, "imageUrl": "https://placehold.co/400x400/1E1E2C/FFF",
        "ingredients": ["Medjool Dates", "Almond Milk", "Cinnamon"], 
        "recipe": {"Medjool Dates": 0.15}
      },
      {
        "id": "REC-M-005", "name": "Argan Oil Drizzled Salad", "category": "Salads", "price": 10.00, "rating": 4.5, "reviewCount": 110,
        "description": "Fresh citrus and fennel salad dressed with culinary grade organic Argan oil.", "calories": 220, "imageUrl": "https://placehold.co/400x400/1E1E2C/FFF",
        "ingredients": ["Organic Argan Oil (Culinary)", "Fennel", "Orange", "Pistachios"], 
        "recipe": {"Organic Argan Oil (Culinary)": 0.02}
      },
      {
        "id": "REC-M-006", "name": "Gazelle Horns (Cornes de Gazelle)", "category": "Pastries", "price": 3.50, "rating": 4.9, "reviewCount": 520,
        "description": "Traditional crescent-shaped cookies filled with almond paste and orange blossom water.", "calories": 180, "imageUrl": "https://placehold.co/400x400/1E1E2C/FFF",
        "ingredients": ["Almond Paste", "Orange Blossom Water", "Flour"], 
        "recipe": {"Almond Paste": 0.05, "Orange Blossom Water": 0.01}
      },
      {
        "id": "REC-M-007", "name": "Spiced Saffron Coffee", "category": "Drinks", "price": 5.00, "rating": 4.4, "reviewCount": 85,
        "description": "Rich espresso brewed with a pinch of premium saffron threads for a unique floral profile.", "calories": 15, "imageUrl": "https://placehold.co/400x400/1E1E2C/FFF",
        "ingredients": ["Espresso", "Premium Saffron Threads"], 
        "recipe": {"Premium Saffron Threads": 0.0005}
      },
      {
        "id": "REC-M-008", "name": "Fig & Almond Tart", "category": "Desserts", "price": 9.00, "rating": 4.8, "reviewCount": 130,
        "description": "A buttery tart shell filled with almond frangipane and baked fresh figs.", "calories": 410, "imageUrl": "https://placehold.co/400x400/1E1E2C/FFF",
        "ingredients": ["Fresh Figs", "Almond Paste", "Butter", "Flour"], 
        "recipe": {"Fresh Figs": 0.15, "Almond Paste": 0.08}
      },
      {
        "id": "REC-M-009", "name": "Traditional Khobz Platter", "category": "Sides", "price": 4.00, "rating": 4.5, "reviewCount": 200,
        "description": "Warm slices of traditional Moroccan bread served with a side of Argan oil for dipping.", "calories": 250, "imageUrl": "https://placehold.co/400x400/1E1E2C/FFF",
        "ingredients": ["Khobz (Moroccan Bread)", "Organic Argan Oil (Culinary)"], 
        "recipe": {"Khobz (Moroccan Bread)": 2.0, "Organic Argan Oil (Culinary)": 0.03}
      },
      {
        "id": "REC-M-010", "name": "Date & Walnut Cake", "category": "Desserts", "price": 7.50, "rating": 4.6, "reviewCount": 175,
        "description": "Moist cake naturally sweetened with Medjool dates and textured with toasted walnuts.", "calories": 360, "imageUrl": "https://placehold.co/400x400/1E1E2C/FFF",
        "ingredients": ["Medjool Dates", "Walnuts", "Flour", "Eggs"], 
        "recipe": {"Medjool Dates": 0.1}
      }
    ];

    for (var recipe in mockRecipes) {
      final docRef = firestore.collection('recipes').doc(recipe['id']);
      batch.set(docRef, recipe);
    }

    // --- 3. Waste Log (10 items) ---
    final List<Map<String, dynamic>> wasteLogs = [
      {"log_id": "WST-M-001", "itemId": "INV-M-003", "date": "2026-03-20T08:15:00Z", "reason": "Wilted mint leaves", "quantity": 0.5, "userId": "user-staff-1", "timestamp": FieldValue.serverTimestamp()},
      {"log_id": "WST-M-002", "itemId": "INV-M-007", "date": "2026-03-20T09:30:00Z", "reason": "Stale bread from yesterday", "quantity": 5.0, "userId": "user-staff-1", "timestamp": FieldValue.serverTimestamp()},
      {"log_id": "WST-M-003", "itemId": "INV-M-009", "date": "2026-03-20T10:45:00Z", "reason": "Overripe figs", "quantity": 1.2, "userId": "user-staff-2", "timestamp": FieldValue.serverTimestamp()},
      {"log_id": "WST-M-004", "itemId": "INV-M-005", "date": "2026-03-20T11:20:00Z", "reason": "Spilled orange blossom water", "quantity": 0.2, "userId": "user-staff-1", "timestamp": FieldValue.serverTimestamp()},
      {"log_id": "WST-M-005", "itemId": "INV-M-006", "date": "2026-03-20T12:10:00Z", "reason": "Dried out almond paste", "quantity": 0.3, "userId": "user-staff-2", "timestamp": FieldValue.serverTimestamp()},
      {"log_id": "WST-M-006", "itemId": "INV-M-010", "date": "2026-03-20T13:00:00Z", "reason": "Found spoiled dates", "quantity": 0.5, "userId": "user-staff-3", "timestamp": FieldValue.serverTimestamp()},
      {"log_id": "WST-M-007", "itemId": "INV-M-002", "date": "2026-03-20T14:15:00Z", "reason": "Accidental spill of Argan oil", "quantity": 0.1, "userId": "user-staff-1", "timestamp": FieldValue.serverTimestamp()},
      {"log_id": "WST-M-008", "itemId": "INV-M-004", "date": "2026-03-20T15:30:00Z", "reason": "Torn tea bag package", "quantity": 0.25, "userId": "user-staff-2", "timestamp": FieldValue.serverTimestamp()},
      {"log_id": "WST-M-009", "itemId": "INV-M-007", "date": "2026-03-20T16:45:00Z", "reason": "Dropped bread on floor", "quantity": 2.0, "userId": "user-staff-1", "timestamp": FieldValue.serverTimestamp()},
      {"log_id": "WST-M-010", "itemId": "INV-M-008", "date": "2026-03-20T17:20:00Z", "reason": "Expired Amlou batch", "quantity": 0.8, "userId": "user-staff-3", "timestamp": FieldValue.serverTimestamp()}
    ];

    for (var log in wasteLogs) {
      batch.set(firestore.collection('waste_log').doc(log['log_id']), log);
    }

    // --- 4. Orders (10 items) ---
    final List<Map<String, dynamic>> orders = [
      {"order_id": "ORD-M-001", "total": 12.50, "userId": "user-staff-1", "timestamp": FieldValue.serverTimestamp(), "items": [{"id": "REC-M-001", "name": "Royal Moroccan Mint Tea", "price": 4.50}, {"id": "REC-M-003", "name": "Amlou Toast with Fresh Figs", "price": 8.00}]},
      {"order_id": "ORD-M-002", "total": 24.00, "userId": "user-staff-2", "timestamp": FieldValue.serverTimestamp(), "items": [{"id": "REC-M-002", "name": "Saffron & Almond Pastilla", "price": 12.00}, {"id": "REC-M-002", "name": "Saffron & Almond Pastilla", "price": 12.00}]},
      {"order_id": "ORD-M-003", "total": 16.50, "userId": "user-staff-1", "timestamp": FieldValue.serverTimestamp(), "items": [{"id": "REC-M-005", "name": "Argan Oil Drizzled Salad", "price": 10.00}, {"id": "REC-M-004", "name": "Medjool Date Smoothie", "price": 6.50}]},
      {"order_id": "ORD-M-004", "total": 11.00, "userId": "user-staff-3", "timestamp": FieldValue.serverTimestamp(), "items": [{"id": "REC-M-006", "name": "Gazelle Horns", "price": 3.50}, {"id": "REC-M-010", "name": "Date & Walnut Cake", "price": 7.50}]},
      {"order_id": "ORD-M-005", "total": 18.00, "userId": "user-staff-2", "timestamp": FieldValue.serverTimestamp(), "items": [{"id": "REC-M-008", "name": "Fig & Almond Tart", "price": 9.00}, {"id": "REC-M-008", "name": "Fig & Almond Tart", "price": 9.00}]},
      {"order_id": "ORD-M-006", "total": 8.50, "userId": "user-staff-1", "timestamp": FieldValue.serverTimestamp(), "items": [{"id": "REC-M-007", "name": "Spiced Saffron Coffee", "price": 5.00}, {"id": "REC-M-006", "name": "Gazelle Horns", "price": 3.50}]},
      {"order_id": "ORD-M-007", "total": 13.00, "userId": "user-staff-2", "timestamp": FieldValue.serverTimestamp(), "items": [{"id": "REC-M-009", "name": "Traditional Khobz Platter", "price": 4.00}, {"id": "REC-M-008", "name": "Fig & Almond Tart", "price": 9.00}]},
      {"order_id": "ORD-M-008", "total": 21.00, "userId": "user-staff-3", "timestamp": FieldValue.serverTimestamp(), "items": [{"id": "REC-M-002", "name": "Saffron & Almond Pastilla", "price": 12.00}, {"id": "REC-M-008", "name": "Fig & Almond Tart", "price": 9.00}]},
      {"order_id": "ORD-M-009", "total": 15.00, "userId": "user-staff-1", "timestamp": FieldValue.serverTimestamp(), "items": [{"id": "REC-M-005", "name": "Argan Oil Drizzled Salad", "price": 10.00}, {"id": "REC-M-007", "name": "Spiced Saffron Coffee", "price": 5.00}]},
      {"order_id": "ORD-M-010", "total": 11.00, "userId": "user-staff-2", "timestamp": FieldValue.serverTimestamp(), "items": [{"id": "REC-M-001", "name": "Royal Moroccan Mint Tea", "price": 4.50}, {"id": "REC-M-004", "name": "Medjool Date Smoothie", "price": 6.50}]}
    ];

    for (var order in orders) {
      batch.set(firestore.collection('orders').doc(order['order_id']), order);
    }

    await batch.commit();
    print("Marrakech Cafe Data successfully seeded to Firestore!");
  }
}
