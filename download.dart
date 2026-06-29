import 'dart:io';

void main() async {
  final directory = Directory('assets/images');
  if (!directory.existsSync()) {
    directory.createSync(recursive: true);
  }

  final items = [
    'macchiato',
    'latte',
    'tiramisu',
    'avocadotoast',
    'icedtea',
    'burger',
    'salad',
    'margarita',
    'coffee',
    'fries',
    'fajitas'
  ];

  final client = HttpClient();
  
  for (int i = 0; i < items.length; i++) {
    final item = items[i];
    // loremflickr uses keywords and redirects to an image.
    final url = 'https://loremflickr.com/800/800/$item,food,coffee/all';
    
    print('Downloading $item from $url...');
    try {
      final request = await client.getUrl(Uri.parse(url));
      final response = await request.close();
      
      // Handle redirect manually since picsum redirects
      var finalUrl = url;
      if (response.isRedirect) {
         finalUrl = response.headers.value('location') ?? url;
         print('Redirected to $finalUrl');
         final req2 = await client.getUrl(Uri.parse(finalUrl));
         final res2 = await req2.close();
         final file = File('assets/images/$item.jpg');
         await res2.pipe(file.openWrite());
      } else {
         final file = File('assets/images/$item.jpg');
         await response.pipe(file.openWrite());
      }
      print('Saved assets/images/$item.jpg');
    } catch (e) {
      print('Failed to download $item: $e');
    }
  }
  
  client.close();
  print('Done downloading images.');
}
