import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dart_openai/dart_openai.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'tts_service.dart';
import '../providers/tts_settings_provider.dart';

// Provides a singleton instance of CafeAssistantService
final cafeAiServiceProvider = Provider<CafeAssistantService>((ref) {
  final tts = ref.read(ttsServiceProvider);
  return CafeAssistantService(tts, ref);
});

class CafeAssistantService {
  final stt.SpeechToText _speech = stt.SpeechToText();
  final TtsService _tts;
  final Ref _ref;

  bool _isSpeechInitialized = false;
  bool _initialized = false;
  final List<OpenAIChatCompletionChoiceMessageModel> _messages = [];

  CafeAssistantService(this._tts, this._ref);

  // Late initialization to easily pass the API key from UI or Config
  void initializeWithKey(String apiKey) {
    if (_initialized) return; // Already initialized

    OpenAI.baseUrl = "https://openrouter.ai/api";
    OpenAI.requestsTimeOut = const Duration(seconds: 60);
    OpenAI.apiKey = apiKey;
    _initialized = true;

    _messages.add(
      OpenAIChatCompletionChoiceMessageModel(
        role: OpenAIChatMessageRole.system,
        content: [
          OpenAIChatCompletionChoiceMessageContentItemModel.text(
            "You are a conversational AI voice assistant for a restaurant management system. Your responses will be read aloud to the user via a text-to-speech engine, so you must write exclusively for the ear, not the eye.\n\nFollow these strict formatting rules:\n1. NEVER use emojis, emoticons, or special characters (e.g., do not use 🙂, @, #, etc.).\n2. NEVER use markdown formatting like asterisks, bolding, italics, or bullet points (e.g., do not write **bold** or *italics*).\n3. Keep responses highly concise, conversational, and direct. Use short sentences. Aim for 1 to 3 sentences maximum unless explicitly asked for a detailed list.\n4. Spell out numbers or symbols if they sound better verbally (e.g., write \"percent\" instead of \"%\").\n5. If the user asks a question that requires a list, present it as a natural, spoken sentence (e.g., \"We have pizza, burgers, and pasta available,\" instead of a bulleted list)."
          )
        ],
      ),
    );
  }

  Stream<String> sendMessageStream(String userText) async* {
    if (!_initialized) {
      yield "AI Service not initialized with an API key.";
      return;
    }
    
    try {
      _messages.add(
        OpenAIChatCompletionChoiceMessageModel(
          role: OpenAIChatMessageRole.user,
          content: [
            OpenAIChatCompletionChoiceMessageContentItemModel.text(userText)
          ],
        )
      );

      final stream = OpenAI.instance.chat.createStream(
        model: "openrouter/free", // OpenRouter auto-fallback for free models
        messages: _messages,
      );

      String fullReply = "";
      await stopListening();

      await for (final chunk in stream) {
        final contentList = chunk.choices.first.delta.content;
        if (contentList != null && contentList.isNotEmpty) {
          final textChunk = contentList.first?.text ?? "";
          fullReply += textChunk;
          yield fullReply;
        }
      }

      _messages.add(
        OpenAIChatCompletionChoiceMessageModel(
          role: OpenAIChatMessageRole.assistant,
          content: [
             OpenAIChatCompletionChoiceMessageContentItemModel.text(fullReply)
          ],
        )
      );
      
      // Speak the text out loud after generation finishes if enabled
      final isTtsEnabled = _ref.read(ttsEnabledProvider);
      if (isTtsEnabled) {
        final voiceId = _ref.read(ttsVoiceIdProvider);
        await _tts.speak(fullReply, voice: voiceId);
      }
    } catch (e) {
      yield "Connection error: $e";
    }
  }

  Future<void> startListening({
    required Function(String) onResult,
    required Function() onListeningComplete,
  }) async {
    if (!_isSpeechInitialized) {
      _isSpeechInitialized = await _speech.initialize(
        onStatus: (status) {
          if (status == 'done' || status == 'notListening') {
            onListeningComplete();
          }
        },
        onError: (errorNotification) {
          print("STT Error: $errorNotification");
          onListeningComplete();
        },
      );
    }

    if (_isSpeechInitialized) {
      // Stop any active text-to-speech loops before listening
      await stopSpeaking();
      
      _speech.listen(
        onResult: (result) {
          onResult(result.recognizedWords);
        },
        listenFor: const Duration(seconds: 30),
        pauseFor: const Duration(seconds: 3),
        partialResults: true,
        cancelOnError: true,
        listenMode: stt.ListenMode.dictation,
      );
    } else {
      print("Speech initialization failed");
      onListeningComplete();
    }
  }

  Future<void> stopListening() async {
    await _speech.stop();
  }

  Future<void> stopSpeaking() async {
    _tts.stop();
  }
}
