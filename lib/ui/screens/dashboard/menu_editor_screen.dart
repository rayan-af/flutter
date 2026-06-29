import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/models/dish_model.dart';
import '../../../core/services/firestore_service.dart';
import 'dish_editor_screen.dart';
import '../../widgets/role_shell.dart'; // Using the standard design tokens from the app
import '../../widgets/custom_bottom_nav.dart';
import '../../widgets/dish_image.dart';
import '../../../l10n/app_localizations.dart';

class MenuEditorScreen extends ConsumerStatefulWidget {
  const MenuEditorScreen({super.key});

  @override
  ConsumerState<MenuEditorScreen> createState() => _MenuEditorScreenState();
}

class _MenuEditorScreenState extends ConsumerState<MenuEditorScreen> {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: BistroPalette.background,
      appBar: AppBar(
        title: Text(
          l10n.menuEditorTitle,
          style: TextStyle(
            color: BistroPalette.ink,
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
        ),
        backgroundColor: BistroPalette.surface,
        elevation: 0,
        iconTheme: const IconThemeData(color: BistroPalette.ink),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(
            color: BistroPalette.line,
            height: 1.0,
          ),
        ),
      ),
      body: StreamBuilder<List<DishModel>>(
        stream: FirestoreService().getMenuStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: BistroPalette.ink),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                '${l10n.errorLoadingMenu}: ${snapshot.error}',
                style: const TextStyle(color: BistroPalette.red),
              ),
            );
          }

          final dishes = snapshot.data ?? [];

          if (dishes.isEmpty) {
            return Center(
              child: Text(
                l10n.noMenuItemsFound,
                style: TextStyle(color: BistroPalette.muted),
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: dishes.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final dish = dishes[index];
              return _buildDishTile(context, dish);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: BistroPalette.black,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: Text(l10n.addDishLabel),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const DishEditorScreen(),
            ),
          );
        },
      ),
      bottomNavigationBar: const CustomBottomNavBar(),
    );
  }

  Widget _buildDishTile(BuildContext context, DishModel dish) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DishEditorScreen(dish: dish),
          ),
        );
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          color: BistroPalette.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: BistroPalette.line),
        ),
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: DishImage(
                imageUrl: dish.imageUrl,
                width: 64,
                height: 64,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: 64,
                  height: 64,
                  color: BistroPalette.line,
                  child: const Icon(Icons.image_not_supported, color: BistroPalette.muted),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    dish.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: BistroPalette.ink,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    dish.category,
                    style: const TextStyle(
                      fontSize: 13,
                      color: BistroPalette.muted,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '\$${dish.price.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    color: BistroPalette.ink,
                  ),
                ),
                const SizedBox(height: 4),
                const Icon(
                  Icons.chevron_right,
                  color: BistroPalette.muted,
                  size: 20,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
