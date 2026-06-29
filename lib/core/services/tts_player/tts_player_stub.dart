import 'dart:typed_data';
import 'tts_player.dart';

class StubTtsPlayer implements TtsPlayer {
  @override
  void play(String url) {
    throw UnsupportedError('TTS playback is only supported on Web currently.');
  }

  @override
  Future<void> playBytes(Uint8List bytes) async {
    throw UnsupportedError('TTS playback is only supported on Web currently.');
  }

  @override
  void stop() {}
}

TtsPlayer getTtsPlayer() => StubTtsPlayer();
