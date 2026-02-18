import 'package:flutter/material.dart';
import '../../core/models/dish_model.dart';
import 'dish_detail_screen.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // Group dishes by category
    final Map<String, List<DishModel>> categorizedDishes = {};
    for (var dish in DishModel.mockDishes) {
      if (!categorizedDishes.containsKey(dish.category)) {
        categorizedDishes[dish.category] = [];
      }
      categorizedDishes[dish.category]!.add(dish);
    }

    // Sort categories primarily found in mock data
    final sortedCategories = [
      'Appetizers',
      'Entrees',
      'Fajitas',
      'Ribs',
      'Burgers',
      'Sandwiches',
      'Salads',
      'Sides',
      'Desserts',
      'Kids Menu',
      'Drinks',
    ];
    // Filter to only existing categories
    final displayCategories = sortedCategories
        .where((c) => categorizedDishes.containsKey(c))
        .toList();
    // Add any others not in the priority list
    displayCategories.addAll(
      categorizedDishes.keys.where((k) => !sortedCategories.contains(k)),
    );

    return DefaultTabController(
      length: displayCategories.length,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Our Menu"),
          backgroundColor: theme.appBarTheme.backgroundColor,
          foregroundColor: theme.appBarTheme.foregroundColor,
          bottom: TabBar(
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            indicatorColor: theme.primaryColor,
            labelColor: theme.primaryColor,
            unselectedLabelColor: theme.colorScheme.onSurface.withValues(
              alpha: 0.7,
            ),
            tabs: displayCategories
                .map((category) => Tab(text: category))
                .toList(),
          ),
        ),
        body: TabBarView(
          children: displayCategories.map((category) {
            final dishes = categorizedDishes[category]!;
            return ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 16),
              itemCount: dishes.length,
              itemBuilder: (context, index) {
                final dish = dishes[index];
                return _buildDishItem(context, theme, dish);
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildDishItem(BuildContext context, ThemeData theme, DishModel dish) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      elevation: 4,
      color: theme.cardColor,
      child: InkWell(
        borderRadius: BorderRadius.circular(28),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DishDetailScreen(dish: dish),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image
              ClipRRect(
                borderRadius: BorderRadius.circular(28),
                child: Image.network(
                  dish.imageUrl,
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: 100,
                    height: 100,
                    color: theme.colorScheme.surface,
                    child: const Icon(Icons.restaurant, size: 40),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              // Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      dish.name,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      dish.description,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.7,
                        ),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "\$${dish.price.toStringAsFixed(2)}",
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: theme.primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Row(
                          children: [
                            const Icon(
                              Icons.star,
                              size: 16,
                              color: Colors.orange,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              "${dish.rating}",
                              style: theme.textTheme.bodySmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
