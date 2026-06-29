import 'dart:io';

void main() async {
  final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 8081);
  print('Serving assets/images on localhost:8081');

  await for (HttpRequest request in server) {
    final path = request.uri.path;
    final file = File('assets/images$path');
    
    request.response.headers.add('Access-Control-Allow-Origin', '*');
    request.response.headers.add('Access-Control-Allow-Methods', 'GET, OPTIONS');
    request.response.headers.add('Access-Control-Allow-Headers', '*');
    request.response.headers.add('Access-Control-Allow-Private-Network', 'true');

    if (request.method == 'OPTIONS') {
      request.response.statusCode = HttpStatus.ok;
      await request.response.close();
      continue;
    }
    
    if (await file.exists()) {
      final bytes = await file.readAsBytes();
      if (path.endsWith('.jpg') || path.endsWith('.jpeg')) {
        request.response.headers.contentType = ContentType('image', 'jpeg');
      } else if (path.endsWith('.png')) {
        request.response.headers.contentType = ContentType('image', 'png');
      }
      request.response.add(bytes);
    } else {
      request.response.statusCode = HttpStatus.notFound;
    }
    await request.response.close();
  }
}
