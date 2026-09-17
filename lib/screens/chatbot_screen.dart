import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../theme/app_fonts.dart';

import '../theme/app_colors.dart';
import '../widgets/common_widgets.dart';

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({super.key});

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final _controller = TextEditingController();
  final _messages = <(bool isUser, String text)>[
    (false, 'Bonjour ! Je suis le guide patrimoine EcoAR. Posez-moi une question sur Kerkennah.'),
    (true, "Qu'est-ce qu'une charfiya ?"),
    (
      false,
      'La charfiya est une embarcation traditionnelle emblématique des Kerkennah, liée aux savoir-faire maritimes transmis de génération en génération.'
    ),
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _send() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _messages.add((true, text));
      _messages.add((
        false,
        'Je m\'appuie sur les contenus EcoAR (lieux, parcours, transcriptions). Demandez-moi un parcours, un lieu ou une tradition.'
      ));
      _controller.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        backgroundColor: AppColors.navy,
        leading: SoftCircleButton(
          icon: Icons.arrow_back_ios_new_rounded,
          background: Colors.transparent,
          foreground: AppColors.white,
          onPressed: () => context.pop(),
        ),
        title: Column(
          children: [
            const EcoLogo(compact: true, showSubtitle: false),
            Text(
              'Chatbot patrimoine',
              style: AppFonts.dmSans(color: AppColors.white, fontSize: 12),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                final isUser = msg.$1;
                return Align(
                  alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    constraints: BoxConstraints(maxWidth: MediaQuery.sizeOf(context).width * 0.78),
                    decoration: BoxDecoration(
                      color: isUser ? AppColors.navy : AppColors.white,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Text(
                      msg.$2,
                      style: AppFonts.dmSans(
                        color: isUser ? AppColors.white : AppColors.textPrimary,
                        height: 1.4,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(14, 8, 14, 14),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: const InputDecoration(
                        hintText: 'Posez une question sur Kerkennah...',
                      ),
                      onSubmitted: (_) => _send(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  SoftCircleButton(
                    icon: Icons.send_rounded,
                    background: AppColors.gold,
                    foreground: AppColors.white,
                    onPressed: _send,
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
