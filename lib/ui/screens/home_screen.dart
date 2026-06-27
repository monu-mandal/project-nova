import 'package:flutter/material.dart';
import '../../core/intent/intent_router.dart';
import '../../core/llm/llm_service.dart';
import '../../core/memory/nova_memory.dart';
import '../../features/overlay/overlay_service.dart';
import '../../services/media/media_service.dart';
import '../../services/android/app_service.dart';
import '../theme/nova_theme.dart';
import '../widgets/nova_chat_bubble.dart';
import '../widgets/nova_input_bar.dart';
import '../widgets/nova_status_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<_ChatMessage> _messages = [];
  final ScrollController _scroll = ScrollController();
  bool _thinking = false;

  @override
  void initState() {
    super.initState();
    _boot();
  }

  Future<void> _boot() async {
    await LlmService.instance.init();
    _addNovaMessage("The Hydro Archon has arrived. Say 'Nova hide' to have me float on-screen, or just tell me what you need.");
  }

  void _addNovaMessage(String text) {
    setState(() {
      _messages.add(_ChatMessage(role: 'nova', content: text));
    });
    _scrollToBottom();
  }

  void _addUserMessage(String text) {
    setState(() {
      _messages.add(_ChatMessage(role: 'user', content: text));
    });
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scroll.hasClients) {
        _scroll.animateTo(
          _scroll.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _handleInput(String input) async {
    if (input.trim().isEmpty) return;
    _addUserMessage(input);
    await NovaMemory.instance.saveMessage(role: 'user', content: input, session: 'main');

    setState(() => _thinking = true);

    final intent = IntentRouter.instance.route(input);
    String response;

    switch (intent.intent) {
      case NovaIntent.novaHide:
        await OverlayService.instance.show(); // show floating Nova
        response = "As you wish. I'll be watching from above~";
        break;

      case NovaIntent.playMusic:
        final query = intent.params['query'] ?? '';
        await MediaService.instance.playMusic(query);
        response = "Playing $query — consider it done, moi delivers.";
        break;

      case NovaIntent.openApp:
        final app = intent.params['app'] ?? '';
        final opened = await AppService.instance.openApp(app);
        response = opened
            ? "Opening $app — right away!"
            : "Hmm, I couldn't find $app on your device.";
        break;

      case NovaIntent.uninstallApp:
        final app = intent.params['app'] ?? '';
        await AppService.instance.uninstallApp(app);
        response = "Uninstalling $app — it shall trouble you no longer.";
        break;

      case NovaIntent.memorize:
        final fact = intent.params['fact'] ?? '';
        await NovaMemory.instance.learnFact('user_note_${DateTime.now().millisecondsSinceEpoch}', fact);
        response = "Noted and remembered. I shan't forget.";
        break;

      case NovaIntent.conversation:
      default:
        response = await LlmService.instance.generate(input);
        break;
    }

    await NovaMemory.instance.saveMessage(role: 'nova', content: response, session: 'main');
    setState(() => _thinking = false);
    _addNovaMessage(response);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NovaTheme.background,
      body: Column(
        children: [
          const NovaStatusBar(),
          Expanded(
            child: _messages.isEmpty
                ? _emptyState()
                : ListView.builder(
                    controller: _scroll,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    itemCount: _messages.length + (_thinking ? 1 : 0),
                    itemBuilder: (ctx, i) {
                      if (_thinking && i == _messages.length) {
                        return NovaChatBubble(role: 'nova', content: '...', isTyping: true);
                      }
                      final m = _messages[i];
                      return NovaChatBubble(role: m.role, content: m.content);
                    },
                  ),
          ),
          NovaInputBar(onSubmit: _handleInput),
        ],
      ),
    );
  }

  Widget _emptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("✦", style: TextStyle(fontSize: 48, color: NovaTheme.accent)),
          const SizedBox(height: 16),
          Text(
            "Nova",
            style: Theme.of(context).textTheme.displayLarge?.copyWith(
              color: NovaTheme.accent,
              letterSpacing: 4,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Your Hydro Archon awaits",
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}

class _ChatMessage {
  final String role;
  final String content;
  const _ChatMessage({required this.role, required this.content});
}
