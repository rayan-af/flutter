import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/models/dish_model.dart';
import '../../../core/providers/waiter_cart_provider.dart';
import '../../../core/services/firestore_service.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../core/services/tts_service.dart';
import '../home_screen.dart'; // for menuStreamProvider
import '../../widgets/role_shell.dart';
import '../../widgets/dish_image.dart';

class WaiterPOSScreen extends ConsumerStatefulWidget {
  final String tableNumber;

  const WaiterPOSScreen({super.key, required this.tableNumber});

  @override
  ConsumerState<WaiterPOSScreen> createState() => _WaiterPOSScreenState();
}

class _WaiterPOSScreenState extends ConsumerState<WaiterPOSScreen> {
  String _selectedCategory = "All";
  bool _isCheckingOut = false;

  void _checkout() async {
    final cart = ref.read(waiterCartProvider);
    if (cart.isEmpty) return;

    setState(() {
      _isCheckingOut = true;
    });

    try {
      final user = ref.read(authProvider);
      final userId = user?.id ?? 'unknown_waiter';
      
      final cartItems = List<DishModel>.from(cart);
      
      await FirestoreService().submitOrder(cart, userId, widget.tableNumber);
      
      if (mounted) {
        // Speak order confirmation using local Kokoro TTS
        final itemsSummary = cartItems.map((d) => d.name).join(', ');
        ref.read(ttsServiceProvider).speak('Order submitted for Table ${widget.tableNumber}: $itemsSummary');
        
        ref.read(waiterCartProvider.notifier).clearCart();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Order submitted successfully!')),
        );
        Navigator.pop(context); // Go back to Waiter dashboard
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isCheckingOut = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final menuAsync = ref.watch(menuStreamProvider);
    final cart = ref.watch(waiterCartProvider);
    
    double total = cart.fold(0.0, (sum, item) => sum + item.price);
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 800;

    final categories = ["All", "Burgers", "Coffee", "Drinks", "Salads", "Pastries", "Breakfast", "Appetizers", "Desserts", "Entrees", "Fajitas"];

    final menuArea = Column(
      children: [
        // Category Filter
        SizedBox(
          height: 60,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final cat = categories[index];
              final isSelected = _selectedCategory == cat;
              return Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: ChoiceChip(
                  label: Text(cat, style: TextStyle(color: isSelected ? Colors.white : BistroPalette.ink)),
                  selected: isSelected,
                  selectedColor: BistroPalette.orange,
                  backgroundColor: BistroPalette.surface,
                  onSelected: (val) {
                    if (val) setState(() => _selectedCategory = cat);
                  },
                ),
              );
            },
          ),
        ),
        // Grid
        Expanded(
          child: menuAsync.when(
            data: (dishes) {
              final filtered = _selectedCategory == "All" 
                  ? dishes 
                  : dishes.where((d) => d.category == _selectedCategory).toList();
                  
              return GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: isDesktop ? 4 : (screenWidth > 500 ? 3 : 2),
                  childAspectRatio: 0.8,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: filtered.length,
                itemBuilder: (context, index) {
                  final dish = filtered[index];
                  return InkWell(
                    onTap: () {
                      ref.read(waiterCartProvider.notifier).addItem(dish);
                    },
                    child: Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                              child: DishImage(
                                imageUrl: dish.imageUrl,
                                fit: BoxFit.cover,
                                width: double.infinity,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(dish.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                                      const SizedBox(height: 4),
                                      Text('\$${dish.price.toStringAsFixed(2)}', style: const TextStyle(color: BistroPalette.green, fontWeight: FontWeight.bold, fontSize: 13)),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.add, size: 18, color: BistroPalette.orange),
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(),
                                  onPressed: () {
                                    ref.read(waiterCartProvider.notifier).addItem(dish);
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, s) => Center(child: Text('Error: $e')),
          ),
        ),
      ],
    );

    final cartArea = Container(
      width: isDesktop ? 350 : double.infinity,
      decoration: const BoxDecoration(
        color: BistroPalette.surface,
        border: Border(left: BorderSide(color: BistroPalette.line)),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: BistroPalette.black,
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Current Order', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                if (!isDesktop)
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
              ],
            ),
          ),
          Expanded(
            child: cart.isEmpty 
                ? const Center(child: Text('Cart is empty', style: TextStyle(color: BistroPalette.muted)))
                : ListView.builder(
                    itemCount: cart.length,
                    itemBuilder: (context, index) {
                      final item = cart[index];
                      return ListTile(
                        title: Text(item.name, style: const TextStyle(fontSize: 14)),
                        subtitle: Text('\$${item.price.toStringAsFixed(2)}', style: const TextStyle(color: BistroPalette.green)),
                        trailing: IconButton(
                          icon: const Icon(Icons.remove_circle_outline, color: BistroPalette.red),
                          onPressed: () {
                            ref.read(waiterCartProvider.notifier).removeItem(item);
                          },
                        ),
                      );
                    },
                  ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: BistroPalette.line)),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Total:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    Text('\$${total.toStringAsFixed(2)}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: BistroPalette.ink)),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: BistroPalette.orange,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    onPressed: cart.isEmpty || _isCheckingOut ? null : _checkout,
                    child: _isCheckingOut 
                        ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                        : const Text('Send to Kitchen', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );

    return Scaffold(
      backgroundColor: BistroPalette.background,
      appBar: AppBar(
        title: Text('Table ${widget.tableNumber} POS', style: const TextStyle(fontWeight: FontWeight.bold, color: BistroPalette.ink)),
        backgroundColor: BistroPalette.surface,
        iconTheme: const IconThemeData(color: BistroPalette.ink),
        elevation: 0,
      ),
      body: isDesktop
          ? Row(
              children: [
                Expanded(child: menuArea),
                cartArea,
              ],
            )
          : menuArea,
      floatingActionButton: isDesktop ? null : FloatingActionButton.extended(
        backgroundColor: BistroPalette.black,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.shopping_cart),
        label: Text('${cart.length} Items - \$${total.toStringAsFixed(2)}'),
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (context) {
              return FractionallySizedBox(
                heightFactor: 0.8,
                child: cartArea,
              );
            },
          );
        },
      ),
    );
  }
}
