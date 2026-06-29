import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/models/dish_model.dart';
import '../../../core/providers/cart_provider.dart';
import '../../screens/dish_detail_screen.dart';
import '../dish_image.dart';

class RestaurantCard extends ConsumerStatefulWidget {
  final DishModel dish;
  final VoidCallback? onTap;
  final String? heroTagPrefix;

  const RestaurantCard({super.key, required this.dish, this.onTap, this.heroTagPrefix});

  @override
  ConsumerState<RestaurantCard> createState() => _RestaurantCardState();
}

class _RestaurantCardState extends ConsumerState<RestaurantCard> {
  bool _isHovered = false;
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final primary = theme.colorScheme.primary;
    final screenWidth = MediaQuery.of(context).size.width;

    // Dynamic sizing
    final cardWidth = screenWidth * 0.48 > 190.0 ? 190.0 : screenWidth * 0.48;
    final imageHeight = cardWidth * 0.78;

    // Cart state
    final cartItems = ref.watch(cartProvider);
    final cartItemIndex = cartItems.indexWhere((item) => item.dish.id == widget.dish.id);
    final inCartCount = cartItemIndex >= 0 ? cartItems[cartItemIndex].quantity : 0;
    final isSelected = inCartCount > 0;

    // Resolve interactive state values
    final double scale = _isPressed ? 0.97 : (_isHovered ? 1.02 : 1.0);

    final Color borderColor = (isSelected || _isHovered)
        ? primary.withValues(alpha: _isHovered ? 0.75 : 0.55)
        : (isDark
            ? theme.dividerColor.withValues(alpha: 0.08)
            : const Color(0xFFF0F0F0));

    final double borderWidth = (isSelected || _isHovered) ? 1.6 : 1.0;

    final List<BoxShadow> shadows = isSelected
        ? [
            BoxShadow(
              color: primary.withValues(alpha: 0.14),
              blurRadius: 16,
              spreadRadius: 1,
              offset: const Offset(0, 6),
            ),
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.03),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ]
        : _isHovered
            ? [
                BoxShadow(
                  color: primary.withValues(alpha: 0.10),
                  blurRadius: 14,
                  spreadRadius: 0,
                  offset: const Offset(0, 6),
                ),
                BoxShadow(
                  color: Colors.black.withValues(alpha: isDark ? 0.18 : 0.03),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ]
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: isDark ? 0.22 : 0.05),
                  blurRadius: 12,
                  offset: const Offset(0, 5),
                ),
              ];

    return AnimatedScale(
      scale: scale,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOutCubic,
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() {
          _isHovered = false;
          _isPressed = false;
        }),
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTapDown: (_) => setState(() => _isPressed = true),
          onTapUp: (_) => setState(() => _isPressed = false),
          onTapCancel: () => setState(() => _isPressed = false),
          onTap: widget.onTap ?? () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DishDetailScreen(
                  dish: widget.dish,
                  heroTag: '${widget.heroTagPrefix ?? 'restaurant_card'}_image_${widget.dish.id}',
                ),
              ),
            );
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOutCubic,
            width: cardWidth,
            margin: const EdgeInsets.only(right: 14, bottom: 8, top: 4),
            decoration: BoxDecoration(
              color: isDark ? theme.colorScheme.surface : Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: borderColor, width: borderWidth),
              boxShadow: shadows,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(23),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Image Section ──────────────────────────────────────────
                  Stack(
                    children: [
                      Hero(
                        tag: '${widget.heroTagPrefix ?? 'restaurant_card'}_image_${widget.dish.id}',
                        child: ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(23),
                          ),
                          child: DishImage(
                            imageUrl: widget.dish.imageUrl,
                            height: imageHeight,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),



                      // Rating badge
                      Positioned(
                        bottom: 8,
                        left: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.68),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.star_rounded,
                                  size: 14, color: Colors.amber),
                              const SizedBox(width: 2),
                              Text(
                                "${widget.dish.rating}",
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                  // ── Info & Actions ─────────────────────────────────────────
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Title & meta
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.dish.name,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: -0.2,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 3),
                              Text(
                                "${widget.dish.calories} kcal • 15-20m",
                                style: TextStyle(
                                  fontSize: 10,
                                  color: theme.colorScheme.onSurface
                                      .withValues(alpha: 0.5),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),

                          // Price + quantity
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: Text(
                                  "\$${widget.dish.price.toStringAsFixed(2)}",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w800,
                                    color: theme.colorScheme.primary,
                                    fontSize: 14,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              AnimatedSwitcher(
                                duration: const Duration(milliseconds: 200),
                                transitionBuilder: (child, animation) =>
                                    ScaleTransition(
                                        scale: animation, child: child),
                                child: inCartCount > 0
                                    ? _QuantityCounter(
                                        key: const ValueKey('counter'),
                                        count: inCartCount,
                                        primary: primary,
                                        onDecrement: () => ref
                                            .read(cartProvider.notifier)
                                            .decrementQuantity(widget.dish.id),
                                        onIncrement: () => ref
                                            .read(cartProvider.notifier)
                                            .addItem(widget.dish),
                                      )
                                    : _AddButton(
                                        key: const ValueKey('add_btn'),
                                        primary: primary,
                                        onTap: () {
                                          ref
                                              .read(cartProvider.notifier)
                                              .addItem(widget.dish);
                                          ScaffoldMessenger.of(context)
                                              .clearSnackBars();
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                  "${widget.dish.name} added to cart!"),
                                              duration:
                                                  const Duration(seconds: 1),
                                              behavior:
                                                  SnackBarBehavior.floating,
                                              action: SnackBarAction(
                                                label: "Undo",
                                                textColor: Colors.white,
                                                onPressed: () => ref
                                                    .read(cartProvider.notifier)
                                                    .decrementQuantity(
                                                        widget.dish.id),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Sub-widgets ──────────────────────────────────────────────────────────────

class _QuantityCounter extends StatelessWidget {
  final int count;
  final Color primary;
  final VoidCallback onDecrement;
  final VoidCallback onIncrement;

  const _QuantityCounter({
    super.key,
    required this.count,
    required this.primary,
    required this.onDecrement,
    required this.onIncrement,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 2),
      decoration: BoxDecoration(
        color: primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: primary.withValues(alpha: 0.2), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _CircleIconButton(
              icon: Icons.remove, primary: primary, onTap: onDecrement),
          const SizedBox(width: 6),
          Text(
            "$count",
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 11, color: primary),
          ),
          const SizedBox(width: 6),
          _CircleIconButton(
              icon: Icons.add, primary: primary, onTap: onIncrement),
        ],
      ),
    );
  }
}

class _AddButton extends StatefulWidget {
  final Color primary;
  final VoidCallback onTap;
  const _AddButton({super.key, required this.primary, required this.onTap});

  @override
  State<_AddButton> createState() => _AddButtonState();
}

class _AddButtonState extends State<_AddButton> {
  bool _hovered = false;
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
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
          scale: _pressed ? 0.88 : (_hovered ? 1.1 : 1.0),
          duration: const Duration(milliseconds: 160),
          curve: Curves.easeOutBack,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: widget.primary,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: widget.primary.withValues(alpha: _hovered ? 0.38 : 0.22),
                  blurRadius: _hovered ? 8 : 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Icon(Icons.add, color: Colors.white, size: 14),
          ),
        ),
      ),
    );
  }
}

class _CircleIconButton extends StatefulWidget {
  final IconData icon;
  final Color primary;
  final VoidCallback onTap;
  const _CircleIconButton(
      {required this.icon, required this.primary, required this.onTap});

  @override
  State<_CircleIconButton> createState() => _CircleIconButtonState();
}

class _CircleIconButtonState extends State<_CircleIconButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _pressed ? 0.85 : 1.0,
        duration: const Duration(milliseconds: 130),
        curve: Curves.easeOut,
        child: Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
              color: widget.primary, shape: BoxShape.circle),
          child: Icon(widget.icon, color: Colors.white, size: 10),
        ),
      ),
    );
  }
}
