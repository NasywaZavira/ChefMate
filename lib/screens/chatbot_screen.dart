import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({super.key});

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  final List<_ChatMessage> _messages = [
    const _ChatMessage(
      isUser: false,
      text: 'Halo! Ada bahan apa di dapurmu hari ini? Aku bisa saranin resep atau penggantinya.',
    ),
    const _ChatMessage(
      isUser: true,
      text: 'Aku ada ayam, tapi enggak ada daun jeruk',
    ),
    const _ChatMessage(
      isUser: false,
      text: 'Daun jeruk bisa diganti kulit jeruk nipis parut, atau dilewati saja — rasanya tetap gurih dari bumbu lain.',
    ),
  ];

  bool get _canSend => _textController.text.trim().isNotEmpty;

  void _sendMessage([String? overrideText]) {
    final text = (overrideText ?? _textController.text).trim();
    if (text.isEmpty) {
      return;
    }

    setState(() {
      _messages.add(_ChatMessage(isUser: true, text: text));
      _messages.add(_ChatMessage(isUser: false, text: _buildReply(text)));
      _textController.clear();
    });

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

  String _buildReply(String input) {
    final lower = input.toLowerCase();

    if (lower.contains('ayam')) {
      return 'Ayam bisa dibuat sambal kecap, ayam rica-rica, atau ayam panggang dengan bumbu sederhana. Mau aku kasih resep yang cepat?';
    }
    if (lower.contains('vegetarian') || lower.contains('tanpa daging')) {
      return 'Coba bikin tumis sayur, tahu tempe bumbu kecap, atau mie goreng sayur yang gampang dan sehat.';
    }
    if (lower.contains('rendah karbohidrat') || lower.contains('diet')) {
      return 'Untuk versi rendah karbohidrat, pilih sayur, protein, dan hindari nasi/mi berlebih. Aku bisa bantu bikin menu yang pas.';
    }
    if (lower.contains('substitusi') || lower.contains('pengganti')) {
      return 'Bisa diganti dengan bahan yang punya rasa mirip, seperti daun salam, lemon, atau bumbu aromatik lain sesuai resepnya.';
    }

    return 'Coba buat menu yang sederhana dan cepat: pilih protein utama, tambahkan sayur, lalu sesuaikan rasa dengan garam, bawang, dan cabai. Mau aku bantu pilihkan resep?';
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
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _SuggestionChip(
                      label: 'Resep dari ayam',
                      onTap: () => _sendMessage('Resep dari ayam'),
                    ),
                    _SuggestionChip(
                      label: 'Substitusi bahan lain',
                      onTap: () => _sendMessage('Substitusi bahan lain'),
                    ),
                    _SuggestionChip(
                      label: 'Resep rendah karbohidrat',
                      onTap: () => _sendMessage('Resep rendah karbohidrat'),
                    ),
                  ],
                ),
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

class _SuggestionChip extends StatelessWidget {
  const _SuggestionChip({required this.label, required this.onTap});
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.orangeLight,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.orange,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
