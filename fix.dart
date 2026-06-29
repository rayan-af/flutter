import 'dart:io';

void main() {
  final file = File('lib/core/models/dish_model.dart');
  var content = file.readAsStringSync();

  final regex = RegExp(r"imageUrl:\s*'https://(images\.unsplash\.com|loremflickr\.com)[^']+'");
  
  content = content.replaceAllMapped(regex, (match) {
    final seed = match.group(0).hashCode.abs() % 1000;
    return "imageUrl: 'https://picsum.photos/seed/$seed/800/800'";
  });

  file.writeAsStringSync(content);
}
