import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:http/http.dart' as http;
import 'tts_player/tts_player.dart';

class TtsService {
  final TtsPlayer _player = TtsPlayer();
  final FlutterTts _flutterTts = FlutterTts();
  static const String apiKey = 'sk_a5d02d2cd3c1c2a276eec3835c2d1f24911155e95eb4c8f9';

  Future<void> speak(String text, {String voice = 'EXAVITQu4vr4xnSDxMaL', double speed = 1.0}) async {
    if (text.isEmpty) return;
    
    if (!kIsWeb) {
      try {
        await _flutterTts.setLanguage("en-US");
        await _flutterTts.setSpeechRate(speed * 0.5);
        await _flutterTts.setVolume(1.0);
        await _flutterTts.setPitch(1.0);
        await _flutterTts.speak(text);
      } catch (e) {
        print('Failed to speak via flutter_tts: $e');
      }
      return;
    }
    
    final url = Uri.parse('https://api.elevenlabs.io/v1/text-to-speech/$voice');
    
    try {
      final response = await http.post(
        url,
        headers: {
          'xi-api-key': apiKey,
          'Content-Type': 'application/json',
          'Accept': 'audio/mpeg',
        },
        body: jsonEncode({
          "text": text,
          "model_id": "eleven_multilingual_v2",
          "voice_settings": {
            "stability": 0.5,
            "similarity_boost": 0.5
          }
        }),
      );

      if (response.statusCode == 200) {
        await _player.playBytes(response.bodyBytes);
      } else {
        print('Failed to play TTS from ElevenLabs: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Failed to play TTS: $e');
    }
  }

  void stop() {
    try {
      if (!kIsWeb) {
        _flutterTts.stop();
      } else {
        _player.stop();
      }
    } catch (e) {
      print('Failed to stop TTS: $e');
    }
  }
}

final ttsServiceProvider = Provider<TtsService>((ref) {
  return TtsService();
});
