import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/models/user_model.dart';
import '../../core/providers/auth_provider.dart';
import '../../core/providers/theme_provider.dart';
import '../screens/login_screen.dart';
import '../screens/menu_screen.dart';
import '../screens/drinks_screen.dart';
import '../screens/dashboard/manager_dashboard_screen.dart';
import '../screens/inventory/inventory_screen.dart';
import '../screens/pos/pos_screen.dart';
import '../screens/features/recipe_costing_screen.dart';
import '../screens/features/waste_log_screen.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final user = authProvider.currentUser;
    final theme = Theme.of(context);

    // Get current route name to highlight active tab (simple check)
    final String currentRoute = ModalRoute.of(context)?.settings.name ?? '';

    return Drawer(
      backgroundColor: theme.colorScheme.surface,
      elevation: 0,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(24, 64, 24, 32),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  theme.colorScheme.primary.withOpacity(0.2),
                  Colors.transparent,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [theme.colorScheme.primary, theme.colorScheme.secondary],
                    ),
                  ),
                  child: CircleAvatar(
                    radius: 28,
                    backgroundColor: theme.colorScheme.surface,
                    child: Text(
                      user?.name.substring(0, 1).toUpperCase() ?? 'G',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user?.name ?? 'Guest User',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        user?.role.toString().split('.').last.toUpperCase() ?? 'PLEASE LOGIN',
                        style: TextStyle(
                          color: theme.colorScheme.primary,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ).animate().fade(duration: 400.ms).slideX(begin: -0.2),
          
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              children: [
                if (user != null) 
                  ..._buildRoleSpecificLinks(user.role, context, currentRoute)
                else 
                   ..._buildRoleSpecificLinks(UserRole.customer, context, currentRoute),
                
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  child: Divider(),
                ),
                
                Padding(
                  padding: const EdgeInsets.only(left: 16, bottom: 8),
                  child: Text(
                    'PREFERENCES',
                    style: TextStyle(
                      color: theme.textTheme.bodySmall?.color?.withOpacity(0.5),
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                    ),
                  ),
                ).animate().fade().slideX(begin: -0.1),
                
                SwitchListTile(
                  title: const Text('Theme', style: TextStyle(fontWeight: FontWeight.w600)),
                  subtitle: Text(themeProvider.currentThemeName, style: const TextStyle(fontSize: 12)),
                  secondary: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                       themeProvider.isDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
                       color: theme.primaryColor,
                       size: 20,
                    ),
                  ),
                  value: themeProvider.isDark,
                  onChanged: (_) => themeProvider.toggleTheme(),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ).animate(delay: 400.ms).fade().slideX(begin: -0.1),
                
                const SizedBox(height: 8),
                
                if (user != null)
                  _buildListTile(context, Icons.logout_rounded, 'Logout', () {
                    authProvider.logout();
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => const LoginScreen()),
                      (route) => false,
                    );
                  }, isDestructive: true).animate(delay: 500.ms).fade().slideX(begin: -0.1)
                else
                  _buildListTile(context, Icons.login_rounded, 'Login', () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => const LoginScreen()),
                      (route) => false,
                    );
                  }).animate(delay: 500.ms).fade().slideX(begin: -0.1),
                  
                const SizedBox(height: 24),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildRoleSpecificLinks(UserRole role, BuildContext context, String currentRoute) {
    int delayMs = 100;
    Widget wrapAnim(Widget child) {
      final res = child.animate(delay: delayMs.ms).fade(duration: 400.ms).slideX(begin: -0.1);
      delayMs += 50;
      return res;
    }

    switch (role) {
      case UserRole.manager:
        return [
          wrapAnim(_buildListTile(context, Icons.dashboard_rounded, 'Dashboard', () {
             Navigator.pop(context);
             Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const ManagerDashboardScreen()));
          })),
          wrapAnim(_buildListTile(context, Icons.point_of_sale_rounded, 'POS Terminal', () {
             Navigator.pop(context);
             Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const POSScreen()));
          })),
          wrapAnim(_buildListTile(context, Icons.inventory_2_rounded, 'Inventory', () {
             Navigator.pop(context);
             Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const InventoryScreen(isReadOnly: false)));
          })),
          wrapAnim(_buildListTile(context, Icons.calculate_rounded, 'Recipe Costing', () {
             Navigator.pop(context);
             Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const RecipeCostingScreen()));
          })),
          wrapAnim(_buildListTile(context, Icons.delete_sweep_rounded, 'Waste Log', () {
             Navigator.pop(context);
             Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const WasteLogScreen()));
          })),
        ];
      case UserRole.employee:
        return [
          wrapAnim(_buildListTile(context, Icons.point_of_sale_rounded, 'POS (Ordering)', () {
             Navigator.pop(context);
             Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const POSScreen()));
          })),
          wrapAnim(_buildListTile(context, Icons.inventory_2_outlined, 'Inventory (View Only)', () {
             Navigator.pop(context);
             Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const InventoryScreen(isReadOnly: true)));
          })),
           wrapAnim(_buildListTile(context, Icons.local_bar_rounded, 'Drinks', () {
             Navigator.pop(context); 
             Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const DrinksScreen()));
          })),
        ];
      case UserRole.customer:
        return [
           wrapAnim(_buildListTile(context, Icons.local_bar_rounded, 'Drinks', () {
             Navigator.pop(context); 
             if (currentRoute != '/drinks') {
               Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const DrinksScreen()));
             }
          }, isActive: currentRoute == '/drinks' || currentRoute == '')),
          wrapAnim(_buildListTile(context, Icons.restaurant_menu_rounded, 'Menu', () {
             Navigator.pop(context); 
             if (currentRoute != '/menu') {
               Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const MenuScreen()));
             }
          }, isActive: currentRoute == '/menu')),
        ];
    }
  }

  Widget _buildListTile(BuildContext context, IconData icon, String title, VoidCallback onTap, {bool isActive = false, bool isDestructive = false}) {
    final theme = Theme.of(context);
    
    final textColor = isDestructive ? theme.colorScheme.error : (isActive ? theme.colorScheme.primary : theme.colorScheme.onSurface.withOpacity(0.7));
    final iconColor = isDestructive ? theme.colorScheme.error : (isActive ? theme.colorScheme.primary : theme.colorScheme.onSurface.withOpacity(0.7));
    final bgColor = isActive ? const Color(0xFF282A28) : Colors.transparent;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Icon(icon, color: iconColor, size: 24),
              const SizedBox(width: 12),
              Text(
                title, 
                style: TextStyle(
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.w500, 
                  color: textColor,
                  fontSize: 16,
                )
              ),
            ],
          ),
        ),
      ),
    );
  }
}
