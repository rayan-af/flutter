import 'dart:io';

void main() {
  final file = File('lib/core/models/dish_model.dart');
  var content = file.readAsStringSync();

  // Reset to original Unsplash/LoremFlickr URLs just to be safe if the previous regex didn't catch everything, or just replace picsum.photos
  // Actually, let's just replace all picsum.photos
  content = content.replaceAll(RegExp(r"imageUrl:\s*'https://picsum\.photos/seed/\d+/800/800'"), "imageUrl: 'http://127.0.0.1:8081/burger.jpg'");

  // Then do specific ones based on name
  content = content.replaceAll("'Caramel Macchiato',\\s+imageUrl: 'http://127.0.0.1:8081/burger.jpg'", "'Caramel Macchiato',\\n      imageUrl: 'http://127.0.0.1:8081/macchiato.jpg'");
  content = content.replaceAll("'Caffè Latte',\\s+imageUrl: 'http://127.0.0.1:8081/burger.jpg'", "'Caffè Latte',\\n      imageUrl: 'http://127.0.0.1:8081/latte.jpg'");
  content = content.replaceAll("'Iced Black Tea Lemonade',\\s+imageUrl: 'http://127.0.0.1:8081/burger.jpg'", "'Iced Black Tea Lemonade',\\n      imageUrl: 'http://127.0.0.1:8081/icedtea.jpg'");
  content = content.replaceAll("'Avocado Toast',\\s+imageUrl: 'http://127.0.0.1:8081/burger.jpg'", "'Avocado Toast',\\n      imageUrl: 'http://127.0.0.1:8081/avocadotoast.jpg'");
  content = content.replaceAll("'Classic Tiramisu',\\s+imageUrl: 'http://127.0.0.1:8081/burger.jpg'", "'Classic Tiramisu',\\n      imageUrl: 'http://127.0.0.1:8081/tiramisu.jpg'");
  
  // Update other ones too
  content = content.replaceAll("'Classic Burger',\\s+imageUrl: 'http://127.0.0.1:8081/burger.jpg'", "'Classic Burger',\\n      imageUrl: 'http://127.0.0.1:8081/burger.jpg'");
  content = content.replaceAll("'Chicken Alfredo',\\s+imageUrl: 'http://127.0.0.1:8081/burger.jpg'", "'Chicken Alfredo',\\n      imageUrl: 'http://127.0.0.1:8081/salad.jpg'");
  content = content.replaceAll("'Margarita Pizza',\\s+imageUrl: 'http://127.0.0.1:8081/burger.jpg'", "'Margarita Pizza',\\n      imageUrl: 'http://127.0.0.1:8081/margarita.jpg'");
  content = content.replaceAll("'Texas Cheese Fries',\\s+imageUrl: 'http://127.0.0.1:8081/burger.jpg'", "'Texas Cheese Fries',\\n      imageUrl: 'http://127.0.0.1:8081/fries.jpg'");
  content = content.replaceAll("'Steak Fajitas',\\s+imageUrl: 'http://127.0.0.1:8081/burger.jpg'", "'Steak Fajitas',\\n      imageUrl: 'http://127.0.0.1:8081/fajitas.jpg'");
  content = content.replaceAll("'Cold Brew',\\s+imageUrl: 'http://127.0.0.1:8081/burger.jpg'", "'Cold Brew',\\n      imageUrl: 'http://127.0.0.1:8081/coffee.jpg'");
  content = content.replaceAll("'Flat White',\\s+imageUrl: 'http://127.0.0.1:8081/burger.jpg'", "'Flat White',\\n      imageUrl: 'http://127.0.0.1:8081/latte.jpg'");
  content = content.replaceAll("'Pike Place® Roast',\\s+imageUrl: 'http://127.0.0.1:8081/burger.jpg'", "'Pike Place® Roast',\\n      imageUrl: 'http://127.0.0.1:8081/coffee.jpg'");
  content = content.replaceAll("'Strawberry Açaí Lemonade',\\s+imageUrl: 'http://127.0.0.1:8081/burger.jpg'", "'Strawberry Açaí Lemonade',\\n      imageUrl: 'http://127.0.0.1:8081/icedtea.jpg'");
  
  // Catch any remaining ones
  content = content.replaceAll(RegExp(r"imageUrl:\s*'https://[^']+'"), "imageUrl: 'http://127.0.0.1:8081/burger.jpg'");

  file.writeAsStringSync(content);
}
