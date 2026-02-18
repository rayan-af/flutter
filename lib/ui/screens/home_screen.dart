import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/providers/auth_provider.dart';
import '../../core/models/dish_model.dart';
import '../widgets/custom_drawer.dart';
import '../widgets/home/restaurant_card.dart';
import 'reservation/reservation_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Categories
  final List<String> categories = [
    "All",
    "Fast food",
    "Casual",
    "Fine dining",
    "Cafe",
    "Buffet",
  ];
  String _selectedCategory = "All";

  @override
  Widget build(BuildContext context) {
    final authAndUser = Provider.of<AuthProvider>(context);
    final user = authAndUser.currentUser;
    final theme = Theme.of(context);

    // Filter Lists
    final allDishes = DishModel.mockDishes;
    final displayedDishes = _selectedCategory == "All"
        ? allDishes
        : allDishes.where((d) => d.category == _selectedCategory).toList();

    // Split into "Popular" and "New" for demo purposes
    // (In a real app, this would be based on backend flags or logic)
    final popularDishes = displayedDishes
        .where((d) => d.rating >= 4.8)
        .toList();
    final newDishes = displayedDishes.where((d) => d.rating < 4.8).toList();

    return Scaffold(
      drawer: const CustomDrawer(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ReservationScreen()),
          );
        },
        label: const Text("Book a Table"),
        icon: const Icon(Icons.table_restaurant),
        backgroundColor: theme.primaryColor,
        foregroundColor: theme.colorScheme.onPrimary,
      ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Header & Search
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: 20.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top Bar
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Profile & Greeting
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 24,
                              backgroundImage: const NetworkImage(
                                "https://images.unsplash.com/photo-1544005313-94ddf0286df2?q=80&w=200&auto=format&fit=crop",
                              ), // Placeholder
                              onBackgroundImageError: (_, _) {},
                              child: user?.name == null
                                  ? const Icon(Icons.person)
                                  : null,
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Hey, ${user?.name.split(' ').first ?? 'Guest'}",
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  "Hungry?",
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: theme.colorScheme.onSurface
                                        .withOpacity(0.6),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),

                        // Icons
                        Row(
                          children: [
                            IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.favorite_border),
                              color: theme.colorScheme.onSurface,
                            ),
                            IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.notifications_none),
                              color: theme.colorScheme.onSurface,
                            ),
                            Builder(
                              builder: (context) => IconButton(
                                icon: const Icon(Icons.menu),
                                onPressed: () =>
                                    Scaffold.of(context).openDrawer(),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Search Bar
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 50,
                            decoration: BoxDecoration(
                              color:
                                  theme.colorScheme.surfaceContainerHighest
                                      .withOpacity(0.3) ??
                                  theme.cardColor,
                              borderRadius: BorderRadius.circular(
                                28,
                              ), // Check theme consistency
                              border: Border.all(
                                color: theme.dividerColor.withOpacity(0.1),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.03),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                const SizedBox(width: 16),
                                Icon(
                                  Icons.search,
                                  color: theme.colorScheme.onSurface
                                      .withOpacity(0.5),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: TextField(
                                    decoration: InputDecoration(
                                      hintText: "Search dishes...",
                                      hintStyle: TextStyle(
                                        color: theme.colorScheme.onSurface
                                            .withOpacity(0.5),
                                      ),
                                      border: InputBorder.none,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                            color:
                                theme.colorScheme.surfaceContainerHighest
                                    .withOpacity(0.3) ??
                                theme.cardColor,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: theme.dividerColor.withOpacity(0.1),
                            ),
                          ),
                          child: Icon(
                            Icons.filter_list,
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Categories
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 24.0),
                child: colWithHeader(
                  context,
                  title: "Browse by category",
                  child: SizedBox(
                    height: 48, // Increased height for chips
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      scrollDirection: Axis.horizontal,
                      itemCount: categories.length,
                      separatorBuilder: (_, _) => const SizedBox(width: 10),
                      itemBuilder: (context, index) {
                        final category = categories[index];
                        final isSelected = _selectedCategory == category;
                        return ChoiceChip(
                          label: Text(category),
                          selected: isSelected,
                          onSelected: (selected) {
                            setState(() {
                              _selectedCategory = category;
                            });
                          },
                          selectedColor: theme.primaryColor,
                          backgroundColor: theme.canvasColor,
                          labelStyle: TextStyle(
                            color: isSelected
                                ? theme.colorScheme.onPrimary
                                : theme.colorScheme.onSurface,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                          side: BorderSide(
                            color: isSelected
                                ? Colors.transparent
                                : theme.dividerColor,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                          showCheckmark: false,
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),

            // Popular Dishes
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 24.0),
                child: colWithHeader(
                  context,
                  title: "Popular Dishes",
                  child: SizedBox(
                    height: 240, // Height for card + shadow
                    child: popularDishes.isEmpty
                        ? Center(
                            child: Text(
                              "No popular dishes found",
                              style: theme.textTheme.bodyMedium,
                            ),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 10,
                            ),
                            scrollDirection: Axis.horizontal,
                            itemCount: popularDishes.length,
                            itemBuilder: (context, index) {
                              return RestaurantCard(dish: popularDishes[index]);
                            },
                          ),
                  ),
                ),
              ),
            ),

            // All Dishes (or New)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 24.0),
                child: colWithHeader(
                  context,
                  title: "Try Something New",
                  child: SizedBox(
                    height: 240,
                    child: newDishes.isEmpty
                        ? Center(
                            child: Text(
                              "No other dishes found",
                              style: theme.textTheme.bodyMedium,
                            ),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 10,
                            ),
                            scrollDirection: Axis.horizontal,
                            itemCount: newDishes.length,
                            itemBuilder: (context, index) {
                              return RestaurantCard(dish: newDishes[index]);
                            },
                          ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget colWithHeader(
    BuildContext context, {
    required String title,
    required Widget child,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 0.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              Text(
                "See more",
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: Colors.grey),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        child,
      ],
    );
  }
}
