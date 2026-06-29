import 'dart:io';

void main() {
  final files = [
    'lib/ui/screens/dish_detail_screen.dart',
    'lib/ui/screens/features/cart_screen.dart',
    'lib/ui/screens/menu_screen.dart',
    'lib/ui/screens/pos/pos_screen.dart',
    'lib/ui/widgets/home/restaurant_card.dart'
  ];

  for (var f in files) {
    final file = File(f);
    if (!file.existsSync()) continue;
    var content = file.readAsStringSync();
    
    // Replace Image.network(dish.imageUrl, ...)
    content = content.replaceAll(
      'Image.network(\n              dish.imageUrl,', 
      "dish.imageUrl.startsWith('http') ? Image.network(\n              dish.imageUrl,"
    );
    // There might be another format without newlines
    content = content.replaceAll(
      'Image.network(dish.imageUrl', 
      "dish.imageUrl.startsWith('http') ? Image.network(dish.imageUrl"
    );

    // Replace Image.network(widget.dish.imageUrl, ...)
    content = content.replaceAll(
      'Image.network(\n                        widget.dish.imageUrl,', 
      "widget.dish.imageUrl.startsWith('http') ? Image.network(\n                        widget.dish.imageUrl,"
    );
    content = content.replaceAll(
      'Image.network(widget.dish.imageUrl', 
      "widget.dish.imageUrl.startsWith('http') ? Image.network(widget.dish.imageUrl"
    );

    // Replace Image.network(item.imageUrl, ...)
    content = content.replaceAll(
      'Image.network(\n                              item.imageUrl,', 
      "item.imageUrl.startsWith('http') ? Image.network(\n                              item.imageUrl,"
    );
    content = content.replaceAll(
      'Image.network(item.imageUrl', 
      "item.imageUrl.startsWith('http') ? Image.network(item.imageUrl"
    );

    // Now we need to append the fallback for the ternary operator.
    // This is tricky using pure string replacement because of the errorBuilder blocks.
    // Instead of string replace, let's just create a global helper in DishModel!
  }
}
