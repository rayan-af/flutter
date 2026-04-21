import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/models/user_model.dart';
import '../../core/providers/auth_provider.dart';
import '../screens/home_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/menu_screen.dart';
import '../screens/drinks_screen.dart';
import '../screens/dashboard/manager_dashboard_screen.dart';
import '../screens/inventory/inventory_screen.dart';
import '../screens/pos/pos_screen.dart';
import '../screens/features/recipe_costing_screen.dart';
import '../screens/login_screen.dart';
import '../screens/features/table_mapping_screen.dart';
import '../screens/features/schedule_screen.dart';
import '../screens/dashboard/chef_orders_screen.dart';
import '../../l10n/app_localizations.dart';

class CustomBottomNavBar extends StatelessWidget {
  const CustomBottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.currentUser;
    final theme = Theme.of(context);
    
    final currentRoute = ModalRoute.of(context)?.settings.name ?? '';
    final role = user?.role ?? UserRole.customer;
    final l10n = AppLocalizations.of(context)!;

    return Container(
      decoration: BoxDecoration(
        color: theme.bottomNavigationBarTheme.backgroundColor ?? theme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: theme.brightness == Brightness.dark 
              ? Colors.black.withOpacity(0.4) 
              : theme.primaryColor.withOpacity(0.1),
            blurRadius: 20,
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
              if (role == UserRole.reception || role == UserRole.chef)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ..._buildLeftItems(context, role, currentRoute, theme, l10n),
                    ..._buildRightItems(context, role, currentRoute, theme, l10n),
                  ],
                )
              else
                Row(
                  children: [
                     Expanded(
                       child: Row(
                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                         children: _buildLeftItems(context, role, currentRoute, theme, l10n),
                       ),
                     ),
                     const SizedBox(width: 70), // Space for center FAB
                     Expanded(
                       child: Row(
                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                         children: _buildRightItems(context, role, currentRoute, theme, l10n),
                       ),
                     ),
                  ],
                ),
              
              // Center Floating Action Button
              if (role != UserRole.reception && role != UserRole.chef)
                Positioned(
                  top: -24,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: _buildCenterButton(context, role, currentRoute, theme, l10n),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildLeftItems(BuildContext context, UserRole role, String currentRoute, ThemeData theme, AppLocalizations l10n) {
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
        items.add(_buildNavItem(context, Icons.home_outlined, Icons.home_rounded, l10n.navHome, 
          currentRoute == '/' || currentRoute == '/home', () {
            if (currentRoute != '/' && currentRoute != '/home') {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomeScreen()));
            }
          }, theme));
        items.add(_buildNavItem(context, Icons.local_bar_outlined, Icons.local_bar_rounded, l10n.navDrinks, 
          currentRoute == '/drinks', () {
            if (currentRoute != '/drinks') {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const DrinksScreen()));
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
        items.add(_buildNavItem(context, Icons.receipt_long_outlined, Icons.receipt_long_rounded, l10n.navOrders, 
          currentRoute == '/' || currentRoute == '/chef_orders', () {
            if (currentRoute != '/' && currentRoute != '/chef_orders') {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const ChefOrdersScreen()));
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

  List<Widget> _buildRightItems(BuildContext context, UserRole role, String currentRoute, ThemeData theme, AppLocalizations l10n) {
    List<Widget> items = [];

    switch (role) {
      case UserRole.manager:
      case UserRole.employee:
        items.add(_buildNavItem(context, Icons.inventory_2_outlined, Icons.inventory_2_rounded, l10n.navInventory, 
          currentRoute == '/inventory', () {
            if (currentRoute != '/inventory') {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => InventoryScreen(isReadOnly: role == UserRole.employee)));
            }
          }, theme));
        break;
      case UserRole.reception:
      case UserRole.chef:
        items.add(_buildNavItem(context, Icons.calendar_month_outlined, Icons.calendar_month_rounded, l10n.navSchedule, 
          currentRoute == '/schedule', () {
            if (currentRoute != '/schedule') {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const ScheduleScreen()));
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
        final auth = Provider.of<AuthProvider>(context, listen: false);
        auth.logout();
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
              color: isActive ? theme.colorScheme.primary : theme.colorScheme.onSurface.withOpacity(0.5),
              size: 26,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                color: isActive ? theme.colorScheme.primary : theme.colorScheme.onSurface.withOpacity(0.5),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCenterButton(BuildContext context, UserRole role, String currentRoute, ThemeData theme, AppLocalizations l10n) {
    // Determine the action based on role
    IconData icon = Icons.shopping_bag_outlined;
    VoidCallback onTap = () {};
    
    if (role == UserRole.reception) {
       // Reception might just use center for quick-booking
       icon = Icons.event_available_outlined;
       onTap = () {
          // Placeholder for Reception Center Button
       };
    } else if (role == UserRole.customer) {
       icon = Icons.shopping_cart_outlined;
       onTap = () {
         if (currentRoute != '/menu') {
           Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const MenuScreen()));
         }
       };
    } else {
       // Manager/Employee default is POS
       icon = Icons.shopping_bag_outlined;
       onTap = () {
         if (currentRoute != '/pos') {
           Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const POSScreen()));
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
          child: Icon(
            icon,
            color: theme.colorScheme.onPrimary,
            size: 28,
          ),
        ),
      ),
    );
  }
}
