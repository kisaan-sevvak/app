import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:avatar_glow/avatar_glow.dart';
import '../../services/chatbot_service.dart';
import '../../models/chatbot_model.dart';

class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;
  final String? type;
  final Map<String, dynamic>? data;

  ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
    this.type,
    this.data,
  });
}

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({super.key});

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<ChatMessage> _messages = [];
  final stt.SpeechToText _speech = stt.SpeechToText();
  final ChatbotService _chatbotService = ChatbotService();
  bool _isListening = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initSpeech();
    _loadChatHistory();
  }

  Future<void> _loadChatHistory() async {
    final history = await _chatbotService.loadChatHistory();
    if (history.isEmpty) {
      // Add welcome message if no history
      _messages.add(
        ChatMessage(
          text: 'chatbot.welcome'.tr(),
          isUser: false,
          timestamp: DateTime.now(),
          type: 'text',
        ),
      );
    } else {
      setState(() {
        _messages.addAll(history);
      });
    }
  }

  void _initSpeech() async {
    bool available = await _speech.initialize();
    if (mounted) {
      setState(() {
        if (!available) {
          // Handle case where speech recognition is not available
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('chatbot.speech_not_available'.tr())),
          );
        }
      });
    }
  }

  Future<void> _sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    setState(() {
      _messages.add(
        ChatMessage(
          text: text,
          isUser: true,
          timestamp: DateTime.now(),
          type: 'text',
        ),
      );
      _isLoading = true;
    });

    _messageController.clear();

    try {
      final response = await _chatbotService.sendMessage(text);
      
      if (mounted) {
        setState(() {
          _messages.add(
            ChatMessage(
              text: response.message,
              isUser: false,
              timestamp: DateTime.now(),
              type: response.type,
              data: response.data,
            ),
          );
          _isLoading = false;
        });
      }

      // Save chat history after each message
      await _chatbotService.saveChatHistory(_messages);
    } catch (e) {
      if (mounted) {
        setState(() {
          _messages.add(
            ChatMessage(
              text: 'chatbot.error'.tr(),
              isUser: false,
              timestamp: DateTime.now(),
              type: 'error',
            ),
          );
          _isLoading = false;
        });
      }
    }
  }

  void _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize();
      if (available) {
        setState(() => _isListening = true);
        _speech.listen(
          onResult: (result) {
            setState(() {
              _messageController.text = result.recognizedWords;
            });
          },
          localeId: context.locale.languageCode,
        );
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('chatbot.title'.tr()),
        elevation: 2,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[_messages.length - 1 - index];
                return _buildMessage(message);
              },
            ),
          ),
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: CircularProgressIndicator(),
            ),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              boxShadow: [
                BoxShadow(
                  offset: const Offset(0, -2),
                  blurRadius: 4,
                  color: Colors.black.withOpacity(0.1),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'chatbot.message_hint'.tr(),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                    ),
                    onSubmitted: _sendMessage,
                  ),
                ),
                const SizedBox(width: 8),
                AvatarGlow(
                  animate: _isListening,
                  glowColor: Theme.of(context).primaryColor,
                  endRadius: 24,
                  duration: const Duration(milliseconds: 2000),
                  repeatPauseDuration: const Duration(milliseconds: 100),
                  repeat: true,
                  child: IconButton(
                    onPressed: _listen,
                    icon: Icon(
                      _isListening ? Icons.mic : Icons.mic_none,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => _sendMessage(_messageController.text),
                  icon: Icon(
                    Icons.send,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessage(ChatMessage message) {
    return Align(
      alignment: message.isUser
          ? Alignment.centerRight
          : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 10,
        ),
        decoration: BoxDecoration(
          color: message.isUser
              ? Theme.of(context).primaryColor
              : Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              offset: const Offset(0, 2),
              blurRadius: 4,
              color: Colors.black.withOpacity(0.1),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message.text,
              style: TextStyle(
                color: message.isUser
                    ? Colors.white
                    : Theme.of(context).textTheme.bodyLarge?.color,
              ),
            ),
            if (message.type == 'error')
              Text(
                'chatbot.try_again'.tr(),
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 12,
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }
} 