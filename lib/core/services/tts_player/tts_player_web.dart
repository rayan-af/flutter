import 'dart:html' as html;
import 'dart:typed_data';
import 'tts_player.dart';

class WebTtsPlayer implements TtsPlayer {
  html.AudioElement? _audioElement;

  @override
  void play(String url) {
    stop();
    _audioElement = html.AudioElement(url);
    _audioElement?.play();
  }

  @override
  Future<void> playBytes(Uint8List bytes) async {
    stop();
    final blob = html.Blob([bytes], 'audio/mpeg');
    final url = html.Url.createObjectUrlFromBlob(blob);
    _audioElement = html.AudioElement(url);
    _audioElement?.play();
  }

  @override
  void stop() {
    if (_audioElement != null) {
      _audioElement?.pause();
      if (_audioElement!.src.startsWith('blob:')) {
        html.Url.revokeObjectUrl(_audioElement!.src);
      }
      _audioElement = null;
    }
  }
}

TtsPlayer getTtsPlayer() => WebTtsPlayer();
