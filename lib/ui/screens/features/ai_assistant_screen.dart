import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/services/cafe_ai_service.dart';
import '../../../core/config/api_keys.dart';
import '../../widgets/role_shell.dart'; // For color palette
import '../../../core/providers/tts_settings_provider.dart';

class AIAssistantScreen extends ConsumerStatefulWidget {
  const AIAssistantScreen({super.key});

  @override
  ConsumerState<AIAssistantScreen> createState() => _AIAssistantScreenState();
}

class _AIAssistantScreenState extends ConsumerState<AIAssistantScreen> {
  bool _isListening = false;
  String _currentSpeechText = "Tap the mic and say something...";
  String _aiReplyText = "I'm ready to help you order!";
  
  late CafeAssistantService _aiService;
  final TextEditingController _textController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    // In a real app you might want to call this carefully
    // We are initializing the service with our key
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _aiService = ref.read(cafeAiServiceProvider);
    _aiService.initializeWithKey(ApiKeys.aiApiKey);
  }

  @override
  void dispose() {
    _aiService.stopListening();
    _aiService.stopSpeaking();
    _textController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _showSettingsModal() {
    final theme = Theme.of(context);
    showModalBottomSheet(
      context: context,
      backgroundColor: theme.colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Consumer(
          builder: (context, ref, child) {
            final isTtsEnabled = ref.watch(ttsEnabledProvider);
            final voiceId = ref.watch(ttsVoiceIdProvider);
            final isMale = voiceId == 'pNInz6obpgDQGcFmaJgB';

            return Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'AI Voice Settings',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 24),
                  SwitchListTile(
                    title: const Text('Enable Text-to-Speech'),
                    activeColor: theme.colorScheme.primary,
                    value: isTtsEnabled,
                    onChanged: (val) {
                      ref.read(ttsEnabledProvider.notifier).state = val;
                      if (!val) {
                        _aiService.stopSpeaking();
                      }
                    },
                  ),
                  Divider(color: theme.dividerColor),
                  ListTile(
                    title: const Text('Voice Type'),
                    trailing: DropdownButton<String>(
                      value: isMale ? 'Male (Adam)' : 'Female (Bella)',
                      dropdownColor: theme.colorScheme.surface,
                      underline: const SizedBox(),
                      items: const [
                        DropdownMenuItem(
                          value: 'Male (Adam)',
                          child: Text('Male (Adam)'),
                        ),
                        DropdownMenuItem(
                          value: 'Female (Bella)',
                          child: Text('Female (Bella)'),
                        ),
                      ],
                      onChanged: (val) {
                        if (val == 'Male (Adam)') {
                          ref.read(ttsVoiceIdProvider.notifier).state = 'pNInz6obpgDQGcFmaJgB';
                        } else {
                          ref.read(ttsVoiceIdProvider.notifier).state = 'EXAVITQu4vr4xnSDxMaL';
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _toggleVoiceInteraction() async {
    if (_isListening) {
      // User manually stopped speaking
      setState(() => _isListening = false);
      await _aiService.stopListening();
      
      if (_currentSpeechText.isNotEmpty && 
          !_currentSpeechText.startsWith("Tap the mic") && 
          _currentSpeechText != "Listening...") {
        
        setState(() => _aiReplyText = "Thinking...");
        
        _aiService.sendMessageStream(_currentSpeechText).listen((chunk) {
          if (mounted) {
            setState(() {
              _aiReplyText = chunk;
            });
          }
        }, onDone: () {
          if (mounted) {
            setState(() {
              _textController.text = "";
              _currentSpeechText = "Tap the mic and say something...";
            });
          }
        });
      } else {
        if (mounted) {
          setState(() {
            _textController.text = "";
            _currentSpeechText = "Tap the mic and say something...";
          });
        }
      }
    } else {
      // Start listening
      await _aiService.stopSpeaking(); 
      setState(() {
        _isListening = true;
        _currentSpeechText = "Listening...";
        _aiReplyText = "...";
      });

      await _aiService.startListening(
        onResult: (speechString) {
          if (mounted) {
            setState(() {
              _currentSpeechText = speechString;
            });
          }
        },
        onListeningComplete: () {
          // The STT engine automatically stopped (e.g. timeout or silence)
          if (mounted && _isListening) {
             _toggleVoiceInteraction(); // triggers the stop and send phase
          }
        }
      );
    }
  }

  void _sendTextMessage() async {
    final text = _textController.text.trim();
    if (text.isEmpty) return;

    if (_isListening) {
      await _aiService.stopListening();
      setState(() => _isListening = false);
    }

    setState(() {
      _currentSpeechText = text;
      _aiReplyText = "Thinking...";
    });
    
    _focusNode.unfocus();
    _aiService.sendMessageStream(text).listen((chunk) {
      if (mounted) {
        setState(() {
          _aiReplyText = chunk;
        });
      }
    }, onDone: () {
      if (mounted) {
        setState(() {
          _textController.text = "";
          _currentSpeechText = "Tap the mic and say something...";
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('AI Voice Assistant'),
        backgroundColor: theme.colorScheme.surface,
        foregroundColor: theme.colorScheme.onSurface,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: _showSettingsModal,
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // AI Avatar
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: _isListening ? theme.primaryColor : theme.colorScheme.surface,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: (_isListening ? theme.primaryColor : Colors.black).withOpacity(0.1),
                      blurRadius: 20,
                      spreadRadius: _isListening ? 10 : 0,
                    )
                  ],
                ),
                child: Center(
                  child: Icon(
                    Icons.auto_awesome,
                    size: 60,
                    color: _isListening ? Colors.white : theme.primaryColor,
                  ),
                ),
              ).animate(target: _isListening ? 1 : 0)
               .scaleXY(end: 1.1, duration: 300.ms, curve: Curves.easeOutBack),
               
              const SizedBox(height: 48),
              
              // AI Speech Bubble
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: theme.dividerColor),
                ),
                child: Text(
                  _aiReplyText,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.onSurface,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              
              const Spacer(),
              
              // Style Input Bar
              Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: theme.brightness == Brightness.dark 
                      ? theme.colorScheme.surfaceVariant 
                      : theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(32),
                  boxShadow: theme.brightness == Brightness.light ? [
                    BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 5))
                  ] : null,
                  border: theme.brightness == Brightness.light ? Border.all(color: theme.dividerColor) : null,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _textController,
                        focusNode: _focusNode,
                        style: TextStyle(color: theme.colorScheme.onSurface),
                        decoration: InputDecoration(
                          hintText: 'Ask Assistant',
                          hintStyle: TextStyle(color: theme.colorScheme.onSurfaceVariant, fontSize: 16),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        ),
                        onSubmitted: (_) => _sendTextMessage(),
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        _isListening ? Icons.graphic_eq : Icons.mic_none, 
                        color: _isListening ? theme.primaryColor : theme.colorScheme.onSurfaceVariant
                      ),
                      onPressed: _toggleVoiceInteraction,
                    ).animate(target: _isListening ? 1 : 0)
                     .scaleXY(end: 1.1, duration: 200.ms),
                    const SizedBox(width: 4),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
