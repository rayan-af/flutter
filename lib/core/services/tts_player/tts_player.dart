import 'dart:typed_data';
import 'tts_player_stub.dart'
    if (dart.library.html) 'tts_player_web.dart';

abstract class TtsPlayer {
  factory TtsPlayer() => getTtsPlayer();
  void play(String url);
  Future<void> playBytes(Uint8List bytes);
  void stop();
}
