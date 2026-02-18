import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/models/user_model.dart';
import '../../core/providers/auth_provider.dart';
import '../../core/providers/theme_provider.dart';
import '../screens/login_screen.dart';
import '../screens/menu_screen.dart';
import '../screens/drinks_screen.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final user = authProvider.currentUser;

    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
            ),
            accountName: Text(
              user?.name ?? 'Guest',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
            accountEmail: Text(
              user?.email ?? 'Please Login',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.8),
              ),
            ),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Theme.of(context).colorScheme.surface,
              child: Text(
                user?.name.substring(0, 1) ?? 'G',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                if (user != null) 
                  ..._buildRoleSpecificLinks(user.role, context)
                else 
                   // Guest specific links when not logged in (or if Guest role is used)
                   ..._buildRoleSpecificLinks(UserRole.customer, context),
                
                const Divider(),
                SwitchListTile(
                  title: const Text('Theme'),
                  subtitle: Text(themeProvider.currentThemeName),
                  secondary:  Icon(
                     themeProvider.isDark ? Icons.dark_mode : Icons.light_mode,
                     color: Theme.of(context).primaryColor,
                  ),
                  value: themeProvider.isDark,
                  onChanged: (_) => themeProvider.toggleTheme(),
                ),
                 if (user != null)
                  ListTile(
                    leading: const Icon(Icons.logout),
                    title: const Text('Logout'),
                    onTap: () {
                      authProvider.logout();
                      // Navigate back to Login Screen
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => const LoginScreen()),
                        (route) => false,
                      );
                    },
                  )
                else
                  ListTile(
                    leading: const Icon(Icons.login),
                    title: const Text('Login'),
                    onTap: () {
                       // Navigate to Login Screen
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => const LoginScreen()),
                        (route) => false,
                      );
                    },
                  ),

              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildRoleSpecificLinks(UserRole role, BuildContext context) {
    switch (role) {
      case UserRole.manager:
        return [
          _buildListTile(context, Icons.bar_chart, 'Revenue', () {}),
          _buildListTile(context, Icons.people, 'Staff Hours', () {}),
          // Manager might also want to see inventory? Added for completeness based on general logic, but sticking to prompt "Revenue and Staff Hours" focus.
        ];
      case UserRole.employee:
        return [
          _buildListTile(context, Icons.inventory, 'Inventory (View Only)', () {}),
          _buildListTile(context, Icons.schedule, 'Personal Hours', () {}),
        ];
      case UserRole.customer:
        return [
          _buildListTile(context, Icons.local_bar, 'Drinks', () {
             Navigator.pop(context); // Close drawer
             Navigator.push(context, MaterialPageRoute(builder: (context) => const DrinksScreen()));
          }),
          _buildListTile(context, Icons.restaurant_menu, 'Menu', () {
             Navigator.pop(context); // Close drawer
             Navigator.push(context, MaterialPageRoute(builder: (context) => const MenuScreen()));
          }),
        ];
    }
  }

  Widget _buildListTile(BuildContext context, IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Theme.of(context).primaryColor),
      title: Text(title),
      onTap: onTap,
    );
  }
}
