import 'dart:io';

void main() {
  final file = File('lib/core/models/dish_model.dart');
  var content = file.readAsStringSync();

  final map = {
    'bev_1': 'macchiato.jpg',
    'bev_2': 'coffee.jpg',
    'bev_3': 'latte.jpg',
    'bev_4': 'latte.jpg',
    'bev_5': 'coffee.jpg',
    'bev_6': 'icedtea.jpg',
    'bev_7': 'icedtea.jpg',
    'food_1': 'burger.jpg',
    'food_2': 'salad.jpg',
    'food_3': 'avocadotoast.jpg',
    'food_4': 'fries.jpg',
    'food_5': 'fajitas.jpg',
    'new_1': 'margarita.jpg',
    'new_2': 'tiramisu.jpg',
    'new_3': 'tiramisu.jpg',
    'new_4': 'tiramisu.jpg',
  };

  for (final entry in map.entries) {
    // We look for: id: 'bev_1',
    // ... lines ...
    // imageUrl: 'http://127.0.0.1:8081/burger.jpg',
    
    // We can use a regex to replace the imageUrl right after the id
    final regex = RegExp(r"(id:\s*'" + entry.key + r"'.*?imageUrl:\s*')([^']+)'", dotAll: true);
    content = content.replaceAllMapped(regex, (match) {
      return "${match.group(1)}http://127.0.0.1:8081/${entry.value}'";
    });
  }

  file.writeAsStringSync(content);
}
