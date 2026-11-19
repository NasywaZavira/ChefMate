import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../services/ai_service.dart';
import '../theme/app_theme.dart';

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({super.key});

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final AiService _aiService = AiService();

  final List<_ChatMessage> _messages = [
    const _ChatMessage(
      isUser: false,
      text: 'Halo! Ada bahan apa di dapurmu hari ini? Aku bisa saranin resep atau penggantinya.',
    ),
  ];

  bool _isLoading = false;

  bool get _canSend => !_isLoading && _textController.text.trim().isNotEmpty;

  Future<void> _sendMessage() async {
    final text = _textController.text.trim();
    if (text.isEmpty || _isLoading) {
      return;
    }

    setState(() {
      _messages.add(_ChatMessage(isUser: true, text: text));
      _isLoading = true;
      _textController.clear();
    });
    _scrollToBottom();

    try {
      final response = await _aiService.ask(text);
      if (!mounted) return;
      setState(() {
        _messages.add(
          _ChatMessage(isUser: false, text: _formatResponse(response)),
        );
      });
    } catch (error, stackTrace) {
      FlutterError.reportError(
        FlutterErrorDetails(
          exception: error,
          stack: stackTrace,
          library: 'ChefMate chatbot',
          context: ErrorDescription('while requesting an AI response'),
        ),
      );
      if (!mounted) return;
      setState(() {
        _messages.add(
          _ChatMessage(
            isUser: false,
            text: kDebugMode
                ? error.toString()
                : 'Maaf, jawaban belum bisa dimuat. Coba lagi sebentar.',
          ),
        );
      });
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
        _scrollToBottom();
      }
    }
  }
  String _formatResponse(Map<String, dynamic> response) {
    final reply = response['reply'] as String;
    final recipe = response['recipe'];
    if (recipe is! Map<String, dynamic>) return reply;

    final details = <String>[];
    final name = recipe['name'];
    if (name is String && name.isNotEmpty) {
      details.add(name);
    }

    final ingredients = recipe['ingredients'];
    if (ingredients is List) {
      final items = ingredients.whereType<String>().toList();
      if (items.isNotEmpty) {
        details.add('Bahan:\n${items.map((item) => '• $item').join('\n')}');
      }
    }

    final steps = recipe['steps'];
    if (steps is List) {
      final items = steps.whereType<String>().toList();
      if (items.isNotEmpty) {
        details.add(
          'Langkah:\n${items.asMap().entries.map((entry) => '${entry.key + 1}. ${entry.value}').join('\n')}',
        );
      }
    }

    return details.isEmpty ? reply : '$reply\n\n${details.join('\n\n')}';
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        backgroundColor: AppColors.cream,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: AppColors.orange,
          ),
          splashRadius: 20,
        ),
        title: Text(
          'Chatbot',
          style: Theme.of(context).textTheme.displayLarge
              ?.copyWith(fontSize: 22, color: AppColors.orange),
        ),
        centerTitle: false,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              children: [
                for (final message in _messages)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: message.isUser
                        ? _UserBubble(text: message.text)
                        : _BotBubble(text: message.text),
                  ),
                if (_isLoading)
                  const Padding(
                    padding: EdgeInsets.only(bottom: 10),
                    child: _TypingIndicator(),
                  ),
                const SizedBox(height: 12),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
            child: Container(
              constraints: const BoxConstraints(minHeight: 46),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.line),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _textController,
                      onChanged: (_) => setState(() {}),
                      onSubmitted: (_) => _sendMessage(),
                      textInputAction: TextInputAction.send,
                      decoration: const InputDecoration(
                        isDense: true,
                        border: InputBorder.none,
                        hintText: 'Tanya soal resep atau bahan...',
                        hintStyle: TextStyle(
                          fontSize: 13,
                          color: AppColors.muted,
                        ),
                        contentPadding: EdgeInsets.symmetric(vertical: 8),
                      ),
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.ink,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: _canSend ? () => _sendMessage() : null,
                    child: Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        color: _canSend ? AppColors.orange : AppColors.muted,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.arrow_upward_rounded,
                        size: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TypingIndicator extends StatelessWidget {
  const _TypingIndicator();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.line),
        ),
        child: const SizedBox(
          width: 16,
          height: 16,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: AppColors.orange,
          ),
        ),
      ),
    );
  }
}

class _ChatMessage {
  const _ChatMessage({required this.isUser, required this.text});

  final bool isUser;
  final String text;
}

class _BotBubble extends StatelessWidget {
  const _BotBubble({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 240),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.line),
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 13,
            color: AppColors.ink,
            height: 1.4,
          ),
        ),
      ),
    );
  }
}

class _UserBubble extends StatelessWidget {
  const _UserBubble({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 220),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.orange,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 13,
            color: Colors.white,
            height: 1.4,
          ),
        ),
      ),
    );
  }
}
