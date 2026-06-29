import 'package:flutter_riverpod/flutter_riverpod.dart';

class TtsEnabledNotifier extends Notifier<bool> {
  @override
  bool build() => true;
}

final ttsEnabledProvider = NotifierProvider<TtsEnabledNotifier, bool>(TtsEnabledNotifier.new);

class TtsVoiceIdNotifier extends Notifier<String> {
  @override
  String build() => 'EXAVITQu4vr4xnSDxMaL';
}

final ttsVoiceIdProvider = NotifierProvider<TtsVoiceIdNotifier, String>(TtsVoiceIdNotifier.new);
