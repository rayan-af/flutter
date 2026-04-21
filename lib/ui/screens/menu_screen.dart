import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../../core/models/dish_model.dart';
import '../../core/providers/cart_provider.dart';
import '../widgets/custom_bottom_nav.dart';
import 'dish_detail_screen.dart';
import 'features/cart_screen.dart';
import '../../l10n/app_localizations.dart';


class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

    final l10n = AppLocalizations.of(context)!;

    // Group dishes by category
    final Map<String, List<DishModel>> categorizedDishes = {};
    for (var dish in DishModel.mockDishes) {
      if (!categorizedDishes.containsKey(dish.category)) {
        categorizedDishes[dish.category] = [];
      }
      categorizedDishes[dish.category]!.add(dish);
    }

    // Category display name mapping
    final Map<String, String> categoryNames = {
      'Appetizers': l10n.catAppetizers,
      'Entrees': l10n.catEntrees,
      'Fajitas': l10n.catFajitas,
      'Ribs': l10n.catRibs,
      'Burgers': l10n.catBurgers,
      'Sandwiches': l10n.catSandwiches,
      'Salads': l10n.catSalads,
      'Sides': l10n.catSides,
      'Desserts': l10n.catDesserts,
      'Kids Menu': l10n.catKidsMenu,
      'Drinks': l10n.catDrinks,
    };

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
        // drawer: const CustomDrawer(),
        appBar: AppBar(
          title: Text(l10n.menuTitle),
          backgroundColor: theme.appBarTheme.backgroundColor,
          foregroundColor: theme.appBarTheme.foregroundColor,
          actions: [
            Consumer<CartProvider>(
              builder: (context, cart, child) {
                return Stack(
                  alignment: Alignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.shopping_cart_outlined),
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => const CartScreen()));
                      },
                    ),
                    if (cart.totalItems > 0)
                      Positioned(
                        right: 8,
                        top: 8,
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                          child: Text(
                            '\${cart.totalItems}',
                            style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
            const SizedBox(width: 8),
          ],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(64),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: TabBar(
                isScrollable: true,
                tabAlignment: TabAlignment.start,
                dividerColor: Colors.transparent,
                indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(28),
                  color: theme.primaryColor,
                ),
                indicatorSize: TabBarIndicatorSize.tab,
                labelColor: theme.colorScheme.onPrimary,
                unselectedLabelColor: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                splashBorderRadius: BorderRadius.circular(28),
                tabs: displayCategories
                    .map((category) => Tab(
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Text(
                              categoryNames[category] ?? category,
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ))
                    .toList(),
              ),
            ),
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
                return _DishItemCard(dish: dish)
                    .animate(delay: (index * 50).ms)
                    .slideY(begin: 0.2, end: 0, duration: 400.ms, curve: Curves.easeOutQuart)
                    .fadeIn(duration: 400.ms);
              },
            );
          }).toList(),
        ),
        bottomNavigationBar: const CustomBottomNavBar(),
      ),
    );
  }
}

class _DishItemCard extends StatefulWidget {
  final DishModel dish;

  const _DishItemCard({required this.dish});

  @override
  State<_DishItemCard> createState() => _DishItemCardState();
}

class _DishItemCardState extends State<_DishItemCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        elevation: _isHovered ? 8 : 0,
        color: _isHovered 
            ? theme.colorScheme.surface 
            : theme.cardTheme.color ?? theme.colorScheme.surfaceContainerHigh,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          borderRadius: BorderRadius.circular(28),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DishDetailScreen(dish: widget.dish),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Image
                Hero(
                  tag: 'dish_image_${widget.dish.id}',
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.08),
                          blurRadius: 12,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: Image.network(
                        widget.dish.imageUrl,
                        width: 110,
                        height: 110,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          width: 110,
                          height: 110,
                          color: theme.colorScheme.surfaceContainerHighest,
                          child: Icon(Icons.restaurant, size: 40, color: theme.colorScheme.onSurface.withValues(alpha: 0.5)),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                // Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.dish.name,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        widget.dish.description,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurface.withValues(
                            alpha: 0.6,
                          ),
                          height: 1.3,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Text(
                                "\$${widget.dish.price.toStringAsFixed(2)}",
                                style: theme.textTheme.titleMedium?.copyWith(
                                  color: theme.primaryColor,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Icon(
                                Icons.star_rounded,
                                size: 18,
                                color: Colors.orange.shade400,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                "${widget.dish.rating}",
                                style: theme.textTheme.bodySmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
                                ),
                              ),
                            ],
                          ),
                          // Add Button
                          GestureDetector(
                            onTap: () {
                              Provider.of<CartProvider>(context, listen: false).addItem(widget.dish);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(AppLocalizations.of(context)!.addedToCart(widget.dish.name)),
                                  duration: const Duration(seconds: 1),
                                ),
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: theme.primaryColor,
                                borderRadius: BorderRadius.circular(14),
                              ),
                              padding: const EdgeInsets.all(8),
                              child: Icon(
                                Icons.add_rounded,
                                size: 20,
                                color: theme.colorScheme.onPrimary,
                              ),
                            ),
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
      ).animate(target: _isHovered ? 1 : 0)
       .scaleXY(end: 1.02, duration: 250.ms, curve: Curves.easeOutBack)
       .tint(color: theme.primaryColor.withValues(alpha: 0.02), end: 1),
    );
  }
}

