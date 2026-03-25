import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/models/dish_model.dart';
import '../../../core/models/user_model.dart';
import '../../../core/providers/inventory_provider.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../core/services/firestore_service.dart';
import '../../widgets/custom_drawer.dart';

class POSScreen extends StatefulWidget {
  const POSScreen({super.key});

  @override
  State<POSScreen> createState() => _POSScreenState();
}

class _POSScreenState extends State<POSScreen> {
  final Map<DishModel, int> _cart = {};
  final FirestoreService _firestoreService = FirestoreService();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final theme = Theme.of(context);
    
    // Strict Theme: Background #1A1616 (Scaffold), Card #2D2424 (CardTheme)
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Point of Sale'),
        actions: [
            Padding(
              padding: const EdgeInsets.only(right: 24.0),
              child: Center(
                child: Text(
                  _cart.isEmpty ? 'Cart Empty' : '${_cart.values.reduce((a, b) => a + b)} Items',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
             // Seeding Button for Debugging (Optional, can remove later)
            IconButton(
              icon: const Icon(Icons.cloud_upload),
              onPressed: () {
                Provider.of<InventoryProvider>(context, listen: false).seedData();
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Seeding Database...')));
              },
            ),
        ],
      ),
      floatingActionButton: (authProvider.currentUser?.role == UserRole.manager)
          ? FloatingActionButton.extended(
              onPressed: () => _showAddRecipeDialog(context),
              backgroundColor: const Color(0xFF00C853),
              foregroundColor: Colors.white,
              icon: const Icon(Icons.add),
              label: const Text('Add Menu Item'),
            )
          : null,
      drawer: const CustomDrawer(),
      body: Row(
        children: [
          // Menu Grid Section
          Expanded(
            flex: 3,
            child: StreamBuilder<List<DishModel>>(
              stream: _firestoreService.getMenuStream(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                   return const Center(child: CircularProgressIndicator());
                }
                
                final dishes = snapshot.data ?? [];
                if (dishes.isEmpty) {
                   return const Center(child: Text("No items in menu. Try seeding data."));
                }

                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3, 
                      childAspectRatio: 0.75, // Taller for image + button
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    itemCount: dishes.length,
                    itemBuilder: (context, index) {
                      final dish = dishes[index];
                      return Card(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(
                              flex: 3,
                              child: ClipRRect(
                                borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
                                child: Image.network(
                                  dish.imageUrl,
                                  fit: BoxFit.cover,
                                  errorBuilder: (c,e,s) => Container(color: Colors.grey[800], child: const Icon(Icons.fastfood, size: 40)),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      children: [
                                        Text(
                                          dish.name.toUpperCase(),
                                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                                          textAlign: TextAlign.center,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          '\$${dish.price.toStringAsFixed(2)}',
                                          style: TextStyle(color: theme.primaryColor, fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      width: double.infinity,
                                        child: ElevatedButton(
                                          onPressed: () {
                                            setState(() {
                                              _cart[dish] = (_cart[dish] ?? 0) + 1;
                                            });
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(
                                                content: Text('Added ${dish.name} to cart'),
                                                duration: const Duration(milliseconds: 500),
                                              ),
                                            );
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: theme.primaryColor,
                                            padding: const EdgeInsets.symmetric(vertical: 0),
                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                                          ),
                                          child: const Text('ADD TO CART', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                                        ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                );
              }
            ),
          ),
          
          // Cart/Sidebar (Optional debugger)
          if (_cart.isNotEmpty)
            Expanded(
              flex: 1,
              child: Container(
                color: theme.cardTheme.color,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text('Session Log', style: theme.textTheme.titleMedium),
                    ),
                    Expanded(
                      child: ListView(
                        children: _cart.entries.map((entry) {
                           return ListTile(
                            title: Text(entry.key.name),
                            subtitle: Text('\$${(entry.key.price * entry.value).toStringAsFixed(2)}'),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.remove_circle_outline, size: 20),
                                  onPressed: () {
                                    setState(() {
                                      if (_cart[entry.key]! > 1) {
                                        _cart[entry.key] = _cart[entry.key]! - 1;
                                      } else {
                                        _cart.remove(entry.key);
                                      }
                                    });
                                  },
                                ),
                                Text('${entry.value}', style: const TextStyle(fontWeight: FontWeight.bold)),
                                IconButton(
                                  icon: const Icon(Icons.add_circle_outline, size: 20),
                                  onPressed: () {
                                    setState(() {
                                      _cart[entry.key] = _cart[entry.key]! + 1;
                                    });
                                  },
                                ),
                              ],
                            ),
                            dense: true,
                          );
                        }).toList(),
                      ),
                    ),
                    const Divider(),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Total:', style: TextStyle(fontWeight: FontWeight.bold)),
                              Text(
                                '\$${_cart.entries.fold(0.0, (sum, e) => sum + (e.key.price * e.value)).toStringAsFixed(2)}',
                                style: TextStyle(fontWeight: FontWeight.bold, color: theme.primaryColor, fontSize: 18),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _isLoading ? null : () => _handleCheckout(authProvider.currentUser?.id ?? 'guest'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green[700],
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                              child: _isLoading 
                                ? const CircularProgressIndicator(color: Colors.white)
                                : const Text('CONFIRM ORDER', style: TextStyle(fontWeight: FontWeight.bold)),
                            ),
                          ),
                          TextButton(
                            onPressed: () => setState(() => _cart.clear()),
                            child: const Text('Clear Cart', style: TextStyle(color: Colors.redAccent)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _handleCheckout(String userId) async {
    if (_cart.isEmpty) return;
    
    setState(() => _isLoading = true);

    try {
      // Flatten cart into a list of items (including duplicates for quantity)
      final List<DishModel> itemsToOrder = [];
      _cart.forEach((dish, qty) {
        for (int i = 0; i < qty; i++) {
          itemsToOrder.add(dish);
        }
      });

      // Submit all at once
      await _firestoreService.submitOrder(itemsToOrder, userId);

      setState(() {
        _cart.clear();
        _isLoading = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Order Confirmed Successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Order Failed: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _showAddRecipeDialog(BuildContext context) {
    final nameController = TextEditingController();
    final priceController = TextEditingController();
    String? selectedCat;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            final isValid = nameController.text.trim().isNotEmpty &&
                            priceController.text.trim().isNotEmpty &&
                            double.tryParse(priceController.text) != null &&
                            selectedCat != null;

            return AlertDialog(
              title: const Text('Add Menu Item'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(labelText: 'Item Name'),
                      onChanged: (_) => setState(() {}),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: priceController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      decoration: const InputDecoration(labelText: 'Price'),
                      onChanged: (_) => setState(() {}),
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: selectedCat,
                      decoration: const InputDecoration(labelText: 'Category'),
                      items: const [
                        DropdownMenuItem(value: 'Drinks', child: Text('Drinks')),
                        DropdownMenuItem(value: 'Salads', child: Text('Salads')),
                        DropdownMenuItem(value: 'Pastries', child: Text('Pastries')),
                        DropdownMenuItem(value: 'Breakfast', child: Text('Breakfast')),
                        DropdownMenuItem(value: 'Desserts', child: Text('Desserts')),
                        DropdownMenuItem(value: 'Sides', child: Text('Sides')),
                      ],
                      onChanged: (v) => setState(() => selectedCat = v),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
                ElevatedButton(
                  onPressed: isValid ? () async {
                    await _firestoreService.addRecipeItem(
                      nameController.text.trim(),
                      double.parse(priceController.text.trim()),
                      selectedCat!,
                    );
                    if (context.mounted) Navigator.pop(context);
                  } : null,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
                  child: const Text('Save'),
                ),
              ],
            );
          }
        );
      }
    );
  }
}
