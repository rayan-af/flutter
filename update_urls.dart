import 'dart:io';

void main() {
  final file = File('lib/core/models/dish_model.dart');
  var content = file.readAsStringSync();

  final replacements = {
    'bev_1': 'macchiato.jpg',
    'bev_2': 'coffee.jpg',
    'bev_3': 'latte.jpg',
    'bev_4': 'iced_tea.jpg',
    'bev_5': 'coffee.jpg',
    'bev_6': 'icedtea.jpg',
    'food_1': 'salad.jpg',
    'food_2': 'burger.jpg',
    'food_3': 'avocadotoast.jpg',
    'chilis_1': 'fries.jpg',
    'chilis_2': 'fajitas.jpg',
    'chilis_3': 'margarita.jpg',
    'new_1': 'fries.jpg',
    'new_2': 'burger.jpg',
    'new_3': 'latte.jpg',
    'new_4': 'tiramisu.jpg',
    'new_5': 'salad.jpg',
    'new_6': 'margarita.jpg',
  };

  for (final entry in replacements.entries) {
    // Regex to match the block starting with id: 'entry.key' and replace the imageUrl line
    final regex = RegExp(r"(id:\s*'" + entry.key + r"'.*?imageUrl:\s*')[^']+'", dotAll: true);
    content = content.replaceAllMapped(regex, (match) {
      return "${match.group(1)}assets/images/${entry.value}'";
    });
  }

  file.writeAsStringSync(content);
  print('Updated dish_model.dart');
}
