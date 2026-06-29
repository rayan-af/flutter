import 'dart:io';

void main() {
  final file = File('lib/core/models/dish_model.dart');
  var content = file.readAsStringSync();

  // Add ?v=2 to cache bust
  content = content.replaceAll('.jpg\'', '.jpg?v=2\'');

  file.writeAsStringSync(content);
}
