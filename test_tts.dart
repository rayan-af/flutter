import 'dart:convert';
import 'package:http/http.dart' as http;

void main() async {
  final apiKey = 'sk_a5d02d2cd3c1c2a276eec3835c2d1f24911155e95eb4c8f9';
  final voice = 'EXAVITQu4vr4xnSDxMaL';
  final url = Uri.parse('https://api.elevenlabs.io/v1/text-to-speech/$voice');
  
  final response = await http.post(
    url,
    headers: {
      'xi-api-key': apiKey,
      'Content-Type': 'application/json',
      'Accept': 'audio/mpeg',
    },
    body: jsonEncode({
      "text": "Hello world",
      "model_id": "eleven_multilingual_v2",
      "voice_settings": {
        "stability": 0.5,
        "similarity_boost": 0.5
      }
    }),
  );

  print('Status: ' + response.statusCode.toString());
  if (response.statusCode != 200) {
    print('Body: ' + response.body);
  } else {
    print('Success! Received ' + response.bodyBytes.length.toString() + ' bytes.');
  }
}
