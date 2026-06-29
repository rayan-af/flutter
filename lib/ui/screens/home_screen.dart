import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/providers/auth_provider.dart';
import '../../core/models/dish_model.dart';
import '../widgets/custom_bottom_nav.dart';
import '../widgets/home/restaurant_card.dart';
import '../widgets/role_shell.dart';
import 'reservation/reservation_screen.dart';
import 'features/ai_assistant_screen.dart';
import '../../core/services/firestore_service.dart';
import '../../l10n/app_localizations.dart';
import '../../l10n/mock_translations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:ui';
import 'package:url_launcher/url_launcher.dart';

final menuStreamProvider = StreamProvider.autoDispose<List<DishModel>>((ref) {
  return FirestoreService().getMenuStream();
});

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _isFabVisible = true;
  String _searchQuery = "";
  String _selectedCategory = "All";

  final List<Map<String, dynamic>> offers = [
    {
      "title": "50% OFF",
      "subtitle": "On your first order",
      "code": "WELCOME50",
      "gradient": [const Color(0xFFF58A45), const Color(0xFFE86A33)],
      "icon": Icons.local_offer_rounded,
    },
    {
      "title": "FREE DELIVERY",
      "subtitle": "For all burger categories",
      "code": "BURGERFREE",
      "gradient": [const Color(0xFF4F8F6B), const Color(0xFF3B6E52)],
      "icon": Icons.delivery_dining_rounded,
    },
    {
      "title": "BOGO DEAL",
      "subtitle": "Buy 1 Get 1 Free on Coffees",
      "code": "COFFEEBOGO",
      "gradient": [const Color(0xFFD89224), const Color(0xFFB0751A)],
      "icon": Icons.local_cafe_rounded,
    },
  ];

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.userScrollDirection == ScrollDirection.reverse) {
        if (_isFabVisible) {
          setState(() {
            _isFabVisible = false;
          });
        }
      } else if (_scrollController.position.userScrollDirection == ScrollDirection.forward) {
        if (!_isFabVisible) {
          setState(() {
            _isFabVisible = true;
          });
        }
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authProvider);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;
    final menuAsyncValue = ref.watch(menuStreamProvider);

    final Map<String, String> categoryNames = {
      "All": l10n.catAll,
      "Burgers": MockTranslations.getCategory(context, "Burgers"),
      "Coffee": MockTranslations.getCategory(context, "Coffee"),
      "Drinks": MockTranslations.getCategory(context, "Drinks"),
      "Salads": MockTranslations.getCategory(context, "Salads"),
      "Pastries": MockTranslations.getCategory(context, "Pastries"),
      "Breakfast": MockTranslations.getCategory(context, "Breakfast"),
      "Desserts": MockTranslations.getCategory(context, "Desserts"),
      "Entrees": MockTranslations.getCategory(context, "Entrees"),
      "Appetizers": MockTranslations.getCategory(context, "Appetizers"),
    };
    final List<String> categoriesList = categoryNames.keys.toList();

    return Scaffold(
      bottomNavigationBar: const CustomBottomNavBar(),
      floatingActionButton: AnimatedSlide(
        duration: const Duration(milliseconds: 300),
        offset: _isFabVisible ? Offset.zero : const Offset(0, 2),
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 250),
          opacity: _isFabVisible ? 1.0 : 0.0,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              FloatingActionButton.extended(
                heroTag: "ai_assistant_fab",
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AIAssistantScreen(),
                    ),
                  );
                },
                label: Text(l10n.aiAssistant),
                icon: const Icon(Icons.auto_awesome_rounded),
                backgroundColor: theme.colorScheme.secondary,
                foregroundColor: theme.colorScheme.onSecondary,
                elevation: 4,
              ),
              const SizedBox(height: 12),
              FloatingActionButton.extended(
                heroTag: "book_table_fab",
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ReservationScreen(),
                    ),
                  );
                },
                label: Text(l10n.bookTable),
                icon: const Icon(Icons.table_restaurant),
                backgroundColor: theme.primaryColor,
                foregroundColor: theme.colorScheme.onPrimary,
              ),
            ],
          ),
        ),
      ),
      body: menuAsyncValue.when(
        loading: () =>
            Center(child: CircularProgressIndicator(color: theme.primaryColor)),
        error: (err, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.wifi_off, size: 50, color: Colors.grey),
              const SizedBox(height: 16),
              Text(
                "Unable to load menu. Please check your connection.",
                style: theme.textTheme.bodyLarge,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.refresh(menuStreamProvider),
                child: const Text("Retry"),
              ),
            ],
          ),
        ),
        data: (snapshotData) {
          final allDishes = snapshotData.isNotEmpty ? snapshotData : DishModel.mockDishes;

          final displayedDishes = _selectedCategory == "All"
              ? allDishes
              : allDishes
                    .where((d) => d.category == _selectedCategory)
                    .toList();

          final filteredDishes = _searchQuery.isEmpty
              ? displayedDishes
              : displayedDishes
                    .where((d) =>
                        d.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                        d.description.toLowerCase().contains(_searchQuery.toLowerCase()))
                    .toList();

          List<DishModel> popularDishes = List.from(filteredDishes)
            ..sort((a, b) => b.orderCount.compareTo(a.orderCount));

          if (popularDishes.where((d) => d.orderCount > 0).isEmpty) {
            popularDishes = filteredDishes
                .where((d) => d.rating >= 4.8)
                .toList();
          } else {
            popularDishes = popularDishes.take(10).toList();
          }

          final newDishes = filteredDishes
              .where((d) => d.rating < 4.8)
              .toList();

          final screenWidth = MediaQuery.of(context).size.width;
          final cardWidth = screenWidth * 0.48 > 190.0 ? 190.0 : screenWidth * 0.48;
          final imageHeight = cardWidth * 0.78;
          final cardHeight = imageHeight + 145; // Increased dynamic height with safe vertical padding

          Widget applyBlur(Widget child) => _searchQuery.isEmpty ? child : ImageFiltered(imageFilter: ImageFilter.blur(sigmaX: 6, sigmaY: 6), child: child);

          return SafeArea(
            child: CustomScrollView(
              controller: _scrollController,
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: theme.colorScheme.primary.withOpacity(0.2),
                                        width: 2,
                                      ),
                                    ),
                                    child: CircleAvatar(
                                      radius: 24,
                                      backgroundColor: theme.colorScheme.surfaceContainerHighest,
                                      backgroundImage:
                                          user?.imageUrl != null &&
                                              user!.imageUrl!.isNotEmpty
                                          ? NetworkImage(user!.imageUrl!)
                                          : null,
                                      onBackgroundImageError:
                                          user?.imageUrl != null &&
                                              user!.imageUrl!.isNotEmpty
                                          ? (_, __) {}
                                          : null,
                                      child:
                                          user?.imageUrl == null ||
                                              user!.imageUrl!.isEmpty
                                          ? Text(
                                              (user?.name.isNotEmpty == true)
                                                  ? user!.name
                                                        .substring(0, 1)
                                                        .toUpperCase()
                                                  : 'G',
                                              style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.w900,
                                                color: theme.colorScheme.primary,
                                              ),
                                            )
                                          : null,
                                    ),
                                  ),
                                  const SizedBox(width: 14),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Hi ${user?.name.split(' ').first ?? 'Guest'},',
                                          style: TextStyle(
                                            fontSize: 14, 
                                            fontWeight: FontWeight.w500, 
                                            color: theme.colorScheme.onSurface.withOpacity(0.5)
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        Text(
                                          'Find your flavor!',
                                          style: TextStyle(
                                            fontSize: 20, 
                                            fontWeight: FontWeight.w800, 
                                            color: theme.colorScheme.onSurface,
                                            letterSpacing: -0.5,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        InkWell(
                                          onTap: () async {
                                            final url = Uri.parse('https://www.google.com/maps/place/Ecole+Racine+Marrakech/@31.6342482,-8.0106813,18z');
                                            try {
                                              await launchUrl(url, mode: LaunchMode.externalApplication);
                                            } catch (e) {
                                              if (context.mounted) {
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  SnackBar(content: Text("Could not launch Maps: $e")),
                                                );
                                              }
                                            }
                                          },
                                          borderRadius: BorderRadius.circular(12),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Icon(Icons.location_on_rounded, size: 14, color: theme.colorScheme.primary),
                                              const SizedBox(width: 3),
                                              Flexible(
                                                child: Text(
                                                  '51 Rue Loubnane, Marrakesh 40000', 
                                                  style: TextStyle(
                                                    fontSize: 12, 
                                                    fontWeight: FontWeight.w700, 
                                                    color: theme.colorScheme.onSurface,
                                                  ),
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ),
                                              Icon(
                                                Icons.keyboard_arrow_down_rounded, 
                                                size: 14, 
                                                color: theme.colorScheme.onSurface.withOpacity(0.6),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              children: [

                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.4), 
                                    shape: BoxShape.circle
                                  ),
                                  child: Icon(Icons.notifications_none_rounded, color: theme.colorScheme.onSurface, size: 20),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                height: 50,
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.4),
                                  borderRadius: BorderRadius.circular(28),
                                  border: Border.all(
                                    color: theme.colorScheme.onSurface.withOpacity(0.06),
                                    width: 1.5,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(isDark ? 0.1 : 0.02),
                                      blurRadius: 10,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  children: [
                                    const SizedBox(width: 16),
                                    Icon(
                                      Icons.search_rounded,
                                      color: theme.colorScheme.onSurface.withOpacity(0.4),
                                      size: 22,
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: TextField(
                                        onChanged: (val) {
                                          setState(() {
                                            _searchQuery = val.trim();
                                          });
                                        },
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: theme.colorScheme.onSurface,
                                        ),
                                        decoration: InputDecoration(
                                          hintText: l10n.searchDishes,
                                          hintStyle: TextStyle(
                                            color: theme.colorScheme.onSurface.withOpacity(0.4),
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                          ),
                                          border: InputBorder.none,
                                          filled: false,
                                          contentPadding: EdgeInsets.zero,
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
                                color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.4),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: theme.colorScheme.onSurface.withOpacity(0.06),
                                  width: 1.5,
                                ),
                              ),
                              child: Icon(
                                  Icons.filter_list_rounded,
                                  color: theme.colorScheme.onSurface,
                                  size: 22,
                                ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                if (user?.id != null)
                  SliverToBoxAdapter(
                    child: applyBlur(
                      StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('orders')
                          .where('clientId', isEqualTo: user!.id)
                          .snapshots(),
                      builder: (context, orderSnapshot) {
                        if (!orderSnapshot.hasData) {
                          return const SizedBox.shrink();
                        }

                        final activeOrders = orderSnapshot.data!.docs.where((
                          doc,
                        ) {
                          final status = doc.get('status') as String?;
                          return status == 'In Kitchen' ||
                              status == 'Ready to Serve';
                        }).toList();

                        if (activeOrders.isEmpty) {
                          return const SizedBox.shrink();
                        }

                        activeOrders.sort((a, b) {
                          final aTime = a.get('timestamp') as Timestamp?;
                          final bTime = b.get('timestamp') as Timestamp?;
                          if (aTime == null || bTime == null) return 0;
                          return bTime.compareTo(aTime);
                        });

                        final order = activeOrders.first;
                        final status =
                            order.get('status') as String? ?? 'In Kitchen';
                        final tableNumber = order.get('tableNumber') ?? 'N/A';
                        final orderId = order.get('orderId') ?? order.id;

                        return GlassmorphicOrderStatusCard(
                          status: status,
                          tableNumber: tableNumber.toString(),
                          orderId: orderId.toString(),
                        );
                      },
                    ),
                    ),
                  ),

                // Categories Row
                SliverToBoxAdapter(
                  child: applyBlur(
                    Padding(
                      padding: const EdgeInsets.only(bottom: 24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Text(
                            l10n.browseByCategory,
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              letterSpacing: -0.5,
                            ),
                          ),
                        ),
                        const SizedBox(height: 14),
                        SizedBox(
                          height: 48,
                          child: ListView.separated(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            scrollDirection: Axis.horizontal,
                            itemCount: categoriesList.length,
                            separatorBuilder: (_, _) => const SizedBox(width: 10),
                            itemBuilder: (context, index) {
                              final category = categoriesList[index];
                              final displayName = categoryNames[category] ?? category;
                              final isSelected = _selectedCategory == category;
                              
                              IconData getIcon(String cat) {
                                switch (cat) {
                                  case 'Burgers': return Icons.lunch_dining_rounded;
                                  case 'Coffee': return Icons.local_cafe_rounded;
                                  case 'Drinks': return Icons.local_bar_rounded;
                                  case 'Salads': return Icons.eco_rounded;
                                  case 'Pastries': return Icons.bakery_dining_rounded;
                                  case 'Breakfast': return Icons.breakfast_dining_rounded;
                                  case 'Desserts': return Icons.icecream_rounded;
                                  case 'Entrees': return Icons.dinner_dining_rounded;
                                  case 'Appetizers': return Icons.tapas_rounded;
                                  default: return Icons.restaurant_menu_rounded;
                                }
                              }

                              return _CategoryChip(
                                category: category,
                                displayName: displayName,
                                icon: getIcon(category),
                                isSelected: isSelected,
                                onTap: () => setState(() {
                                  _selectedCategory = category;
                                }),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                    ),
                  ),
                ),

                // Special Offers Banner Carousel
                SliverToBoxAdapter(
                  child: applyBlur(
                    Padding(
                      padding: const EdgeInsets.only(bottom: 24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Text(
                            MockTranslations.translate(context, "Special Offers"),
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              letterSpacing: -0.5,
                            ),
                          ),
                        ),
                        const SizedBox(height: 14),
                        SizedBox(
                          height: 145,
                          child: ListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            scrollDirection: Axis.horizontal,
                            itemCount: offers.length,
                            itemBuilder: (context, index) {
                              final offer = offers[index];
                              return _OfferCard(
                                offer: offer,
                                width: screenWidth * 0.82,
                              );
                            },
                          ),
                        ),
                      ],
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
                      title: l10n.popularDishes,
                      l10n: l10n,
                      child: SizedBox(
                        height: cardHeight,
                        child: popularDishes.isEmpty
                            ? Center(
                                child: Text(
                                  l10n.noPopularDishes,
                                  style: theme.textTheme.bodyMedium,
                                ),
                              )
                            : ListView.builder(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 4,
                                ),
                                scrollDirection: Axis.horizontal,
                                itemCount: popularDishes.length,
                                itemBuilder: (context, index) {
                                  return RestaurantCard(
                                    dish: popularDishes[index],
                                    heroTagPrefix: 'popular',
                                  );
                                },
                              ),
                      ),
                    ),
                  ),
                ),

                // Recommended For You (renamed trySomethingNew)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 24.0),
                    child: colWithHeader(
                      context,
                      title: "Recommended For You",
                      l10n: l10n,
                      child: SizedBox(
                        height: cardHeight,
                        child: newDishes.isEmpty
                            ? Center(
                                child: Text(
                                  l10n.noNewDishes,
                                  style: theme.textTheme.bodyMedium,
                                ),
                              )
                            : ListView.builder(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 4,
                                ),
                                scrollDirection: Axis.horizontal,
                                itemCount: newDishes.length,
                                itemBuilder: (context, index) {
                                  return RestaurantCard(
                                    dish: newDishes[index],
                                    heroTagPrefix: 'recommended',
                                  );
                                },
                              ),
                      ),
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

  Widget colWithHeader(
    BuildContext context, {
    required String title,
    required Widget child,
    required AppLocalizations l10n,
  }) {
    final theme = Theme.of(context);
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
                style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              Text(
                l10n.seeMore,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        child,
      ],
    );
  }
}

class GlassmorphicOrderStatusCard extends StatelessWidget {
  final String status;
  final String tableNumber;
  final String orderId;

  const GlassmorphicOrderStatusCard({
    super.key,
    required this.status,
    required this.tableNumber,
    required this.orderId,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isReady = status == 'Ready to Serve';
    final accent = isReady ? BistroPalette.green : BistroPalette.orange;
    final soft = isReady ? BistroPalette.greenSoft : BistroPalette.orangeSoft;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: BistroCard(
        color: soft,
        padding: EdgeInsets.zero,
        child: Container(
          decoration: BoxDecoration(
            color: soft,
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isReady ? Icons.restaurant_menu : Icons.soup_kitchen,
                  color: accent,
                  size: 28,
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isReady ? 'ORDER READY!' : 'PREPARING...',
                      style: GoogleFonts.outfit(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                        color: accent,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      isReady
                          ? 'Your order is ready at Table $tableNumber.'
                          : 'Our chef is preparing your meal.',
                      style: GoogleFonts.inter(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Order ID: #$orderId',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: theme.colorScheme.onSurface.withOpacity(0.6),
                      ),
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

// ─── Stateful interactive sub-widgets ─────────────────────────────────────────

class _CategoryChip extends StatefulWidget {
  final String category;
  final String displayName;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _CategoryChip({
    required this.category,
    required this.displayName,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<_CategoryChip> createState() => _CategoryChipState();
}

class _CategoryChipState extends State<_CategoryChip> {
  bool _hovered = false;
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    final bool active = widget.isSelected || _hovered;

    final Color bgColor = widget.isSelected
        ? primary
        : _hovered
            ? primary.withValues(alpha: 0.06)
            : theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.4);

    final Color borderColor = active
        ? primary.withValues(alpha: widget.isSelected ? 1.0 : 0.5)
        : theme.colorScheme.onSurface.withValues(alpha: 0.08);

    final List<BoxShadow>? shadows = widget.isSelected
        ? [
            BoxShadow(
              color: primary.withValues(alpha: 0.22),
              blurRadius: 8,
              offset: const Offset(0, 3),
            )
          ]
        : _hovered
            ? [
                BoxShadow(
                  color: primary.withValues(alpha: 0.12),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                )
              ]
            : null;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() {
        _hovered = false;
        _pressed = false;
      }),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTapDown: (_) => setState(() => _pressed = true),
        onTapUp: (_) => setState(() => _pressed = false),
        onTapCancel: () => setState(() => _pressed = false),
        onTap: widget.onTap,
        child: AnimatedScale(
          scale: _pressed ? 0.95 : 1.0,
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeOut,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOutCubic,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: borderColor, width: 1.5),
              boxShadow: shadows,
            ),
            child: Row(
              children: [
                Icon(
                  widget.icon,
                  size: 16,
                  color: widget.isSelected
                      ? theme.colorScheme.onPrimary
                      : _hovered
                          ? primary
                          : theme.colorScheme.onSurface.withValues(alpha: 0.7),
                ),
                const SizedBox(width: 8),
                Text(
                  widget.displayName,
                  style: TextStyle(
                    color: widget.isSelected
                        ? theme.colorScheme.onPrimary
                        : _hovered
                            ? primary
                            : theme.colorScheme.onSurface.withValues(alpha: 0.8),
                    fontWeight: (widget.isSelected || _hovered)
                        ? FontWeight.bold
                        : FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _OfferCard extends StatefulWidget {
  final Map<String, dynamic> offer;
  final double width;

  const _OfferCard({required this.offer, required this.width});

  @override
  State<_OfferCard> createState() => _OfferCardState();
}

class _OfferCardState extends State<_OfferCard> {
  bool _hovered = false;
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final colors = widget.offer["gradient"] as List<Color>;
    final double scale = _pressed ? 0.97 : (_hovered ? 1.015 : 1.0);

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() {
        _hovered = false;
        _pressed = false;
      }),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTapDown: (_) => setState(() => _pressed = true),
        onTapUp: (_) => setState(() => _pressed = false),
        onTapCancel: () => setState(() => _pressed = false),
        onTap: () {},
        child: AnimatedScale(
          scale: scale,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOutCubic,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOutCubic,
            width: widget.width,
            margin: const EdgeInsets.only(right: 14),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: colors,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: colors.first.withValues(
                      alpha: _hovered ? 0.38 : (_pressed ? 0.28 : 0.22)),
                  blurRadius: _hovered ? 14 : 8,
                  spreadRadius: _hovered ? 1 : 0,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Stack(
              children: [
                Positioned(
                  right: -10,
                  bottom: -10,
                  child: Icon(
                    widget.offer["icon"] as IconData,
                    size: 110,
                    color: Colors.white.withValues(alpha: 0.12),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.offer["title"] as String,
                            style: GoogleFonts.outfit(
                              fontSize: 24,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                              height: 1,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            widget.offer["subtitle"] as String,
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Colors.white.withValues(alpha: 0.9),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          "Use Code: ${widget.offer["code"]}",
                          style: GoogleFonts.inter(
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            color: colors.first,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
