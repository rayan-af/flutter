import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/models/dish_model.dart';
import '../../../core/models/user_model.dart';
import '../../../core/providers/inventory_provider.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../core/providers/pos_cart_provider.dart';
import '../../../core/services/firestore_service.dart';
import '../../widgets/custom_bottom_nav.dart';
import '../../../l10n/app_localizations.dart';
import '../../widgets/dish_image.dart';

// Top level Riverpod providers to replace StreamBuilder and isolate business logic (Pillars 1 & 2)
final posMenuStreamProvider = StreamProvider.autoDispose<List<DishModel>>((ref) {
  return FirestoreService().getMenuStream();
});

final posControllerProvider = Provider((ref) => PosController());

class PosController {
  final FirestoreService _firestoreService = FirestoreService();
  
  Future<void> submitOrder(List<DishModel> items, String userId, String tableNumber) async {
    await _firestoreService.submitOrder(items, userId, tableNumber);
  }

  Future<void> addRecipeItem(String name, double price, String category) async {
    await _firestoreService.addRecipeItem(name, price, category);
  }
}

class POSScreen extends ConsumerStatefulWidget {
  const POSScreen({super.key});

  @override
  ConsumerState<POSScreen> createState() => _POSScreenState();
}

class _POSScreenState extends ConsumerState<POSScreen> {
  bool _isLoading = false;
  String _selectedCategory = 'All';
  String? _selectedTable;

  final List<String> _categories = [
    'All', 'Burgers', 'Coffee', 'Drinks', 'Salads', 'Pastries', 'Breakfast', 'Desserts', 'Sides', 'Entrees', 'Appetizers', 'Fajitas'
  ];

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final theme = Theme.of(context);
    final posCart = ref.watch(posCartProvider);
    final l10n = AppLocalizations.of(context)!;
    
    // Strict Theme: Background #1A1616 (Scaffold), Card #2D2424 (CardTheme)
    
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.posTitle),
        actions: [
            Padding(
              padding: const EdgeInsets.only(right: 24.0),
              child: Center(
                child: Text(
                  posCart.isEmpty ? l10n.cartEmpty : '${posCart.values.isEmpty ? 0 : posCart.values.reduce((a, b) => a + b)} ${l10n.itemsCount}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
             // Seeding Button for Debugging
            IconButton(
              icon: const Icon(Icons.cloud_upload),
              onPressed: () {
                ref.read(inventoryProvider.notifier).seedData();
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Seeding Database...')));
              },
            ),
        ],
      ),
      floatingActionButton: (authState?.role == UserRole.manager)
          ? FloatingActionButton.extended(
              onPressed: () => _showAddRecipeDialog(context),
              backgroundColor: const Color(0xFF00C853),
              foregroundColor: Colors.white,
              icon: const Icon(Icons.add),
              label: Text(l10n.addMenuItem),
            )
          : null,
      body: Row(
        children: [
          // Menu Grid Section
          Expanded(
            flex: 3,
            child: Column(
              children: [
                // Category Pills
                Container(
                  height: 60,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _categories.length,
                    itemBuilder: (context, index) {
                      final category = _categories[index];
                      final isSelected = _selectedCategory == category;
                      return Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedCategory = category;
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                            decoration: BoxDecoration(
                              color: isSelected ? theme.primaryColor : Colors.white.withOpacity(0.05),
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(
                                color: isSelected ? theme.primaryColor : Colors.white.withOpacity(0.1),
                                width: 1,
                              ),
                              boxShadow: isSelected ? [
                                BoxShadow(
                                  color: theme.primaryColor.withOpacity(0.3),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                )
                              ] : [],
                            ),
                            child: Center(
                              child: Text(
                                category,
                                style: TextStyle(
                                  color: isSelected ? Colors.black : Colors.white70,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Expanded(
                  child: ref.watch(posMenuStreamProvider).when(
                    loading: () => const Center(child: CircularProgressIndicator()),
                    error: (error, stack) => Center(child: Text("Failed to load menu: $error")),
                    data: (dishes) {
                      if (dishes.isEmpty) {
                         dishes = DishModel.mockDishes;
                      }

                      // Apply Category Filter
                      final filteredDishes = _selectedCategory == 'All'
                          ? dishes
                          : dishes.where((d) => d.category.toLowerCase() == _selectedCategory.toLowerCase()).toList();

                      if (filteredDishes.isEmpty) {
                         return Center(
                           child: Text(
                             "No items in this category",
                             style: theme.textTheme.titleMedium?.copyWith(color: Colors.white60),
                           ),
                         );
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
                          itemCount: filteredDishes.length,
                          itemBuilder: (context, index) {
                            final dish = filteredDishes[index];
                            return Card(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Expanded(
                                    flex: 3,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(16),
                                      child: DishImage(
                                        imageUrl: dish.imageUrl,
                                        width: double.infinity,
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
                                                  ref.read(posCartProvider.notifier).addItem(dish);
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
                                                child: Text(l10n.addToCart.toUpperCase(), style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
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
              ],
            ),
          ),
          
          // Cart/Sidebar
          if (posCart.isNotEmpty)
            Expanded(
              flex: 1,
              child: Container(
                color: theme.cardTheme.color,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(l10n.sessionLog, style: theme.textTheme.titleMedium),
                    ),
                    Expanded(
                      child: ListView(
                        children: posCart.entries.map((entry) {
                           return ListTile(
                            title: Text(entry.key.name),
                            subtitle: Text('\$${(entry.key.price * entry.value).toStringAsFixed(2)}'),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.remove_circle_outline, size: 20),
                                  onPressed: () {
                                    ref.read(posCartProvider.notifier).removeItem(entry.key);
                                  },
                                ),
                                Text('${entry.value}', style: const TextStyle(fontWeight: FontWeight.bold)),
                                IconButton(
                                  icon: const Icon(Icons.add_circle_outline, size: 20),
                                  onPressed: () {
                                    ref.read(posCartProvider.notifier).addItem(entry.key);
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
                          DropdownButtonFormField<String>(
                            value: _selectedTable,
                            dropdownColor: const Color(0xFF2D2424),
                            hint: const Text("Select Table", style: TextStyle(color: Colors.white54, fontSize: 14)),
                            items: ['1', '2', '3', '4', '5', '6'].map((table) {
                              return DropdownMenuItem(
                                value: table,
                                child: Text("Table $table", style: const TextStyle(color: Colors.white, fontSize: 14)),
                              );
                            }).toList(),
                            onChanged: (val) {
                              setState(() {
                                _selectedTable = val;
                              });
                            },
                            decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.table_restaurant, color: Colors.white54, size: 20),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('${l10n.total}:', style: const TextStyle(fontWeight: FontWeight.bold)),
                              Text(
                                '\$${posCart.entries.fold(0.0, (sum, e) => sum + (e.key.price * e.value)).toStringAsFixed(2)}',
                                style: TextStyle(fontWeight: FontWeight.bold, color: theme.primaryColor, fontSize: 18),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: (_isLoading || _selectedTable == null) ? null : () => _handleCheckout(authState?.id ?? 'guest', posCart),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green[700],
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                              child: _isLoading 
                                ? const CircularProgressIndicator(color: Colors.white)
                                : Text(l10n.confirmOrder.toUpperCase(), style: const TextStyle(fontWeight: FontWeight.bold)),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              ref.read(posCartProvider.notifier).clearCart();
                              setState(() {
                                _selectedTable = null;
                              });
                            },
                            child: Text(l10n.clearCart, style: const TextStyle(color: Colors.redAccent)),
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
      bottomNavigationBar: const CustomBottomNavBar(),
    );
  }

  Future<void> _handleCheckout(String userId, Map<DishModel, int> cart) async {
    if (cart.isEmpty) return;
    if (_selectedTable == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a table first!'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }
    
    setState(() => _isLoading = true);

    try {
      // Flatten cart into a list of items (including duplicates for quantity)
      final List<DishModel> itemsToOrder = [];
      cart.forEach((dish, qty) {
        for (int i = 0; i < qty; i++) {
          itemsToOrder.add(dish);
        }
      });

      // Submit via Riverpod Controller
      await ref.read(posControllerProvider).submitOrder(itemsToOrder, userId, _selectedTable!);

      ref.read(posCartProvider.notifier).clearCart();
      setState(() {
        _selectedTable = null;
        _isLoading = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.orderConfirmed),
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
                    await ref.read(posControllerProvider).addRecipeItem(
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
