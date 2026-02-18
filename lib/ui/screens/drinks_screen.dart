import 'package:flutter/material.dart';
import '../../core/constants/menu_data.dart';

class DrinksScreen extends StatelessWidget {
  const DrinksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Drinks & Food'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Drinks', icon: Icon(Icons.local_drink)),
              Tab(text: 'Food', icon: Icon(Icons.restaurant)),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            _CategoryList(type: 'Drinks'),
            _CategoryList(type: 'Food'),
          ],
        ),
      ),
    );
  }
}

class _CategoryList extends StatelessWidget {
  final String type;

  const _CategoryList({required this.type});

  @override
  Widget build(BuildContext context) {
    // Collect all items for this type from all sources
    final List<Map<String, dynamic>> items = [];
    menuData.forEach((source, data) {
      if (data.containsKey(type)) {
        // Add a header for the source
        items.add({'isHeader': true, 'title': source});
        // Add the items
        items.addAll(List<Map<String, dynamic>>.from(data[type]));
      }
    });

    if (items.isEmpty) {
      return Center(
        child: Text('No $type available'),
      );
    }

    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        if (item.containsKey('isHeader')) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              item['title'],
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          );
        } else {
          // It's a category of items
          final categoryName = item['category'];
          final categoryItems = item['items'] as List;

          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ExpansionTile(
              title: Text(
                categoryName,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              children: categoryItems.map<Widget>((drinkItem) {
                return ListTile(
                  title: Text(drinkItem['name']),
                  subtitle: drinkItem['description'] != null
                      ? Text(drinkItem['description'])
                      : null,
                  leading: Icon(
                    type == 'Drinks' ? Icons.local_bar : Icons.restaurant_menu,
                    color: Theme.of(context).primaryColor,
                  ),
                );
              }).toList(),
            ),
          );
        }
      },
    );
  }
}
