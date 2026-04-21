import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../widgets/custom_drawer.dart';
import '../../widgets/custom_bottom_nav.dart';
import '../../../core/providers/inventory_provider.dart';
import '../../../core/models/dish_model.dart';
import '../../../core/models/inventory_model.dart';

class RecipeCostingScreen extends StatefulWidget {
  const RecipeCostingScreen({super.key});

  @override
  State<RecipeCostingScreen> createState() => _RecipeCostingScreenState();
}

class _RecipeCostingScreenState extends State<RecipeCostingScreen> {
  // We can either calculate for an existing Dish or a custom one.
  // Let's allow selecting an existing Dish from the menu to see its cost, 
  // OR manually entering a cost.
  // Given the "Calculator" nature, let's mix both. 
  // 1. Select Dish -> Pre-fills cost based on current inventory prices.
  // 2. Override Cost -> Calculate Margin.
  
  DishModel? _selectedDish;
  final TextEditingController _plateCostController = TextEditingController();
  final TextEditingController _salesPriceController = TextEditingController();
  
  double _margin = 0.0;
  double _profit = 0.0;

  @override
  void initState() {
    super.initState();
    _plateCostController.addListener(_calculateManual);
    _salesPriceController.addListener(_calculateManual);
  }
  
  @override
  void dispose() {
    _plateCostController.dispose();
    _salesPriceController.dispose();
    super.dispose();
  }

  void _calculateManual() {
     _calculate();
  }

  void _calculate() {
    final cost = double.tryParse(_plateCostController.text) ?? 0.0;
    final price = double.tryParse(_salesPriceController.text) ?? 0.0;

    if (price > 0) {
      setState(() {
        _profit = price - cost;
        _margin = (_profit / price) * 100;
      });
    } else {
       setState(() {
        _profit = -cost;
        _margin = 0.0;
      });
    }
  }
  
  void _onDishSelected(DishModel? dish, List<InventoryModel> inventory) {
    if (dish == null) return;
    
    // Calculate cost from recipe
    double totalCost = 0.0;
    bool missingIngredients = false;
    
    // DishModel recipe is Map<String, double> (Name -> Quantity)
    // We need to match Name to Inventory Item to get Cost
    
    dish.recipe.forEach((ingName, qty) {
      try {
        // Matching by name for now, as established in data model
        final item = inventory.firstWhere((i) => i.name == ingName);
        totalCost += item.cost * qty;
      } catch (e) {
        // Ingredient not found in inventory
        missingIngredients = true;
      }
    });

    setState(() {
      _selectedDish = dish;
      _plateCostController.text = totalCost.toStringAsFixed(2);
      _salesPriceController.text = dish.price.toStringAsFixed(2);
      _calculate();
    });
    
    if (missingIngredients) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Warning: Some ingredients not found in inventory. Cost may be inaccurate.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final inventoryProvider = Provider.of<InventoryProvider>(context);

    // Mock dishes (or fetch from provider/firestore if we had a MenuProvider exposed)
    // For now, using static mock dishes for selection or we can fetch.
    // Ideally we should stream menu, but let's use the static list for simplicity 
    // or if we had access to FirestoreService here. 
    // Let's use DishModel.mockDishes for the dropdown list validation.
    final dishes = DishModel.mockDishes; 

    // Determine color based on margin
    Color marginColor = theme.colorScheme.error;
    if (_margin >= 70) marginColor = const Color(0xFF10B981); // Emerald Green
    else if (_margin >= 30) marginColor = const Color(0xFFF59E0B); // Amber

    return Scaffold(
      appBar: AppBar(
        title: const Text('Recipe Costing'),
      ),
      // drawer: const CustomDrawer(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
        child: Column(
          children: [
             // Dish Selector
             Card(
               child: Padding(
                 padding: const EdgeInsets.all(24.0),
                 child: Column(
                   crossAxisAlignment: CrossAxisAlignment.start,
                   children: [
                      Text(
                        'Select Template',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.textTheme.bodySmall?.color,
                        ),
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<DishModel>(
                        decoration: InputDecoration(
                          labelText: 'Select Menu Item (Optional)',
                          prefixIcon: Icon(Icons.restaurant_menu_rounded, color: theme.colorScheme.primary),
                          filled: true,
                          fillColor: theme.colorScheme.surfaceContainerHighest.withOpacity(0.3),
                        ),
                        items: dishes.map((d) => DropdownMenuItem(value: d, child: Text(d.name, style: const TextStyle(fontWeight: FontWeight.w600)))).toList(),
                        onChanged: (val) => _onDishSelected(val, inventoryProvider.items),
                      ),
                   ],
                 ),
               ),
             ).animate().fade(duration: 500.ms).slideY(begin: 0.1),
             const SizedBox(height: 32),
             
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Input Card
                Expanded(
                  flex: 1,
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.primary.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(Icons.calculate_rounded, color: theme.colorScheme.primary),
                              ),
                              const SizedBox(width: 16),
                              Text('Plate Inputs', 
                                style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)
                              ),
                            ],
                          ),
                          const SizedBox(height: 32),
                          TextField(
                            controller: _plateCostController,
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            decoration: InputDecoration(
                              labelText: 'Total Plate Cost (\$)',
                              hintText: '0.00',
                              helperText: 'Auto-calculated from recipe or manual.',
                              suffixText: 'USD',
                              prefixIcon: Icon(Icons.attach_money, color: theme.colorScheme.secondary),
                              filled: true,
                              fillColor: theme.colorScheme.surfaceContainerHighest.withOpacity(0.3),
                            ),
                          ),
                          const SizedBox(height: 24),
                          TextField(
                            controller: _salesPriceController,
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            decoration: InputDecoration(
                              labelText: 'Target Sales Price (\$)',
                              hintText: '0.00',
                              helperText: 'Menu price for the customer.',
                              suffixText: 'USD',
                              prefixIcon: Icon(Icons.point_of_sale_rounded, color: theme.colorScheme.primary),
                              filled: true,
                              fillColor: theme.colorScheme.surfaceContainerHighest.withOpacity(0.3),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ).animate(delay: 200.ms).fade(duration: 500.ms).slideX(begin: -0.1),
                ),
                const SizedBox(width: 24),
                // Output Card
                Expanded(
                  flex: 1,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      gradient: LinearGradient(
                        colors: [
                          marginColor.withOpacity(0.1),
                          marginColor.withOpacity(0.05),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      border: Border.all(color: marginColor.withOpacity(0.2), width: 2),
                      boxShadow: [
                        BoxShadow(
                          color: marginColor.withOpacity(0.1),
                          blurRadius: 24,
                          offset: const Offset(0, 8),
                        )
                      ]
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(48.0),
                      child: Column(
                         mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: marginColor.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Text(
                              'GROSS PROFIT MARGIN', 
                              style: TextStyle(
                                color: marginColor,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 1.5,
                                fontSize: 12,
                              )
                            ),
                          ),
                          const SizedBox(height: 32),
                          Text(
                            '${_margin.toStringAsFixed(1)}%',
                            style: TextStyle(
                              fontSize: 72,
                              fontWeight: FontWeight.w900,
                              height: 1,
                              color: marginColor,
                              letterSpacing: -2,
                            ),
                          ),
                          const SizedBox(height: 24),
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.surface,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: theme.colorScheme.onSurface.withOpacity(0.05)),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.monetization_on_rounded, color: marginColor),
                                const SizedBox(width: 12),
                                Text(
                                  'Profit per Plate: ',
                                  style: TextStyle(color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7), fontWeight: FontWeight.w600),
                                ),
                                Text(
                                  '\$${_profit.toStringAsFixed(2)}',
                                   style: TextStyle(color: theme.textTheme.bodyLarge?.color, fontWeight: FontWeight.w900, fontSize: 18),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ).animate(delay: 300.ms).fade(duration: 500.ms).slideX(begin: 0.1),
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: const CustomBottomNavBar(),
    );
  }
}
