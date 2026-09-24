import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class ChatbotScreen extends StatelessWidget {
  const ChatbotScreen({super.key});

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
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              children: [
                const _BotBubble(
                  text: 'Halo! Ada bahan apa di dapurmu hari ini? Aku bisa saranin resep atau penggantinya.',
                ),
                const SizedBox(height: 10),
                const _UserBubble(
                  text: 'Aku ada ayam, tapi enggak ada daun jeruk',
                ),
                const SizedBox(height: 10),
                const _BotBubble(
                  text: 'Daun jeruk bisa diganti kulit jeruk nipis parut, atau dilewati saja \u2014 rasanya tetap gurih dari bumbu lain.',
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: const [
                    _SuggestionChip(label: 'Resep dari ayam'),
                    _SuggestionChip(label: 'Substitusi bahan lain'),
                    _SuggestionChip(label: 'Resep rendah karbohidrat'),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
            child: Container(
              height: 46,
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.line),
              ),
              child: Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Tanya soal resep atau bahan...',
                      style: TextStyle(fontSize: 13, color: AppColors.muted),
                    ),
                  ),
                  Container(
                    width: 30,
                    height: 30,
                    decoration: const BoxDecoration(
                      color: AppColors.orange,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.arrow_upward_rounded,
                      size: 16,
                      color: Colors.white,
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
  const _SuggestionChip({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
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
    );
  }
}
