import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/models/user_model.dart';
import '../../core/providers/auth_provider.dart';
import '../screens/home_screen.dart';
import '../screens/profile_screen.dart';
import '../../core/providers/cart_provider.dart';
import '../screens/menu_screen.dart';
import '../screens/dashboard/manager_dashboard_screen.dart';
import '../screens/dashboard/menu_editor_screen.dart';
import '../screens/inventory/inventory_screen.dart';
import '../screens/pos/pos_screen.dart';
import '../screens/features/recipe_costing_screen.dart';
import '../screens/login_screen.dart';
import '../screens/features/table_mapping_screen.dart';
import '../screens/features/schedule_screen.dart';
import '../screens/chef/chef_screen.dart';
import '../screens/waiter/waiter_screen.dart';
import '../../l10n/app_localizations.dart';

class CustomBottomNavBar extends ConsumerWidget {
  const CustomBottomNavBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider);
    final theme = Theme.of(context);
    
    final currentRoute = ModalRoute.of(context)?.settings.name ?? '';
    final role = user?.role ?? UserRole.customer;
    final l10n = AppLocalizations.of(context)!;

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 18,
            offset: const Offset(0, -5),
          )
        ],
      ),
      child: SafeArea(
        child: SizedBox(
          height: 70,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              // Bottom Bar Icons Row
              if (role == UserRole.reception || role == UserRole.chef || role == UserRole.employee)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ..._buildLeftItems(context, role, currentRoute, theme, l10n, ref),
                    ..._buildRightItems(context, role, currentRoute, theme, l10n, ref),
                  ],
                )
              else
                Row(
                  children: [
                     Expanded(
                       child: Row(
                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                         children: _buildLeftItems(context, role, currentRoute, theme, l10n, ref),
                       ),
                     ),
                     const SizedBox(width: 70), // Space for center FAB
                     Expanded(
                       child: Row(
                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                         children: _buildRightItems(context, role, currentRoute, theme, l10n, ref),
                       ),
                     ),
                  ],
                ),
              
              // Center Floating Action Button
              if (role != UserRole.reception && role != UserRole.chef && role != UserRole.employee)
                Positioned(
                  top: -24,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: _buildCenterButton(context, role, currentRoute, theme, l10n, ref),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildLeftItems(BuildContext context, UserRole role, String currentRoute, ThemeData theme, AppLocalizations l10n, WidgetRef ref) {
    List<Widget> items = [];
    
    switch (role) {
      case UserRole.manager:
        items.add(_buildNavItem(context, Icons.dashboard_outlined, Icons.dashboard_rounded, l10n.navHome, 
          currentRoute == '/' || currentRoute == '/manager_dashboard', () {
            if (currentRoute != '/manager_dashboard' && currentRoute != '/') {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const ManagerDashboardScreen()));
            }
          }, theme));
        items.add(_buildNavItem(context, Icons.calculate_outlined, Icons.calculate, l10n.navCosting, 
          currentRoute == '/recipe_costing', () {
            if (currentRoute != '/recipe_costing') {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const RecipeCostingScreen()));
            }
          }, theme));
        break;
      case UserRole.employee:
        items.add(_buildNavItem(context, Icons.room_service_outlined, Icons.room_service_rounded, 'Waiter', 
          currentRoute == '/' || currentRoute == '/waiter_screen', () {
            if (currentRoute != '/' && currentRoute != '/waiter_screen') {
              Navigator.pushReplacement(context, MaterialPageRoute(
                settings: const RouteSettings(name: '/waiter_screen'),
                builder: (_) => const WaiterScreen()
              ));
            }
          }, theme));
        break;
      case UserRole.reception:
        items.add(_buildNavItem(context, Icons.table_restaurant_outlined, Icons.table_restaurant_rounded, l10n.navTableMap, 
          currentRoute == '/' || currentRoute == '/table_mapping', () {
            if (currentRoute != '/' && currentRoute != '/table_mapping') {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const TableMappingScreen()));
            }
          }, theme));
        break;
      case UserRole.chef:
        items.add(_buildNavItem(context, Icons.kitchen_outlined, Icons.kitchen_rounded, 'Chef', 
          currentRoute == '/' || currentRoute == '/chef_screen', () {
            if (currentRoute != '/' && currentRoute != '/chef_screen') {
              Navigator.pushReplacement(context, MaterialPageRoute(
                settings: const RouteSettings(name: '/chef_screen'),
                builder: (_) => const ChefScreen()
              ));
            }
          }, theme));
        break;
      case UserRole.customer:
      default:
        items.add(_buildNavItem(context, Icons.home_outlined, Icons.home_rounded, l10n.navHome, 
          currentRoute == '/' || currentRoute == '/home', () {
            if (currentRoute != '/' && currentRoute != '/home') {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomeScreen()));
            }
          }, theme));
        items.add(_buildNavItem(context, Icons.search_outlined, Icons.search_rounded, l10n.navSearch, 
          false, () { }, theme)); // Mock search for now
        break;
    }

    return items;
  }

  List<Widget> _buildRightItems(BuildContext context, UserRole role, String currentRoute, ThemeData theme, AppLocalizations l10n, WidgetRef ref) {
    List<Widget> items = [];

    switch (role) {
      case UserRole.manager:
        items.add(_buildNavItem(context, Icons.inventory_2_outlined, Icons.inventory_2_rounded, l10n.navInventory, 
          currentRoute == '/inventory', () {
            if (currentRoute != '/inventory') {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => InventoryScreen(isReadOnly: role == UserRole.employee)));
            }
          }, theme));
        break;
      case UserRole.employee:
      case UserRole.reception:
      case UserRole.chef:
        items.add(_buildNavItem(context, Icons.calendar_month_outlined, Icons.calendar_month_rounded, l10n.navSchedule, 
          currentRoute == '/schedule', () {
            if (currentRoute != '/schedule') {
              Navigator.pushReplacement(context, MaterialPageRoute(
                settings: const RouteSettings(name: '/schedule'),
                builder: (_) => const ScheduleScreen()
              ));
            }
          }, theme));
        break;
      case UserRole.customer:
      default:
        // Removed Favs for customer role
        break;
    }

    // Common Profile Tab
    items.add(_buildNavItem(context, Icons.person_outline, Icons.person_rounded, l10n.navProfile, 
      currentRoute == '/profile', () {
        if (currentRoute != '/profile') {
          Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfileScreen()));
        }
      }, theme));

    // Logout Item
    items.add(_buildNavItem(context, Icons.logout_rounded, Icons.logout_rounded, l10n.navLogout, 
      false, () {
        ref.read(authProvider.notifier).logout();
        Navigator.pushAndRemoveUntil(
          context, 
          MaterialPageRoute(builder: (_) => const LoginScreen()),
          (Route<dynamic> route) => false
        );
      }, theme));

    return items;
  }

  Widget _buildNavItem(BuildContext context, IconData inactiveIcon, IconData activeIcon, String label, bool isActive, VoidCallback onTap, ThemeData theme) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 50, // Slightly reduced width to fit 3 items beautifully
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isActive ? activeIcon : inactiveIcon, 
              color: isActive ? const Color(0xFFF58A45) : const Color(0xFF857B72),
              size: 26,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                color: isActive ? const Color(0xFFF58A45) : const Color(0xFF857B72),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCenterButton(
    BuildContext context,
    UserRole role,
    String currentRoute,
    ThemeData theme,
    AppLocalizations l10n,
    WidgetRef ref,
  ) {
    // Determine the action based on role
    IconData icon = Icons.shopping_bag_outlined;
    VoidCallback onTap = () {};
    int cartCount = 0;
    
    if (role == UserRole.reception) {
       // Reception might just use center for quick-booking
       icon = Icons.event_available_outlined;
       onTap = () {
          // Placeholder for Reception Center Button
       };
    } else if (role == UserRole.customer) {
       icon = Icons.shopping_cart_outlined;
       final cartItems = ref.watch(cartProvider);
       cartCount = cartItems.fold<int>(0, (sum, item) => sum + item.quantity);
       onTap = () {
         if (currentRoute != '/menu') {
           Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const MenuScreen()));
         }
       };
    } else if (role == UserRole.employee) {
       icon = Icons.shopping_bag_outlined;
       onTap = () {
         if (currentRoute != '/pos') {
           Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const POSScreen()));
         }
       };
    } else {
       // Manager default is Menu Editor (previously POS)
       icon = Icons.edit_document;
       onTap = () {
         if (currentRoute != '/menu_editor') {
           Navigator.pushReplacement(context, MaterialPageRoute(
             settings: const RouteSettings(name: '/menu_editor'),
             builder: (_) => const MenuEditorScreen()
           ));
         }
       };
    }
    
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          color: theme.colorScheme.primary, // Adapts to app theme
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: theme.colorScheme.primary.withOpacity(0.4),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Center(
          child: cartCount > 0
              ? Badge(
                  label: Text(
                    '$cartCount',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  backgroundColor: theme.colorScheme.error,
                  child: Icon(
                    icon,
                    color: theme.colorScheme.onPrimary,
                    size: 28,
                  ),
                )
              : Icon(
                  icon,
                  color: theme.colorScheme.onPrimary,
                  size: 28,
                ),
        ),
      ),
    );
  }
}
