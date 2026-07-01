import 'package:flutter/material.dart';
import '../theme/nova_theme.dart';

class NovaInputBar extends StatefulWidget {
  final Future<void> Function(String) onSubmit;
  const NovaInputBar({super.key, required this.onSubmit});
  @override
  State<NovaInputBar> createState() => _NovaInputBarState();
}

class _NovaInputBarState extends State<NovaInputBar> {
  final TextEditingController _ctrl = TextEditingController();
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _ctrl.addListener(() => setState(() => _hasText = _ctrl.text.isNotEmpty));
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  void _submit() {
    final text = _ctrl.text.trim();
    if (text.isEmpty) return;
    _ctrl.clear();
    widget.onSubmit(text);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      decoration: const BoxDecoration(
        color: NovaTheme.surface,
        border: Border(top: BorderSide(color: NovaTheme.surfaceLight)),
      ),
      child: Row(
        children: [
          // Mic button — Phase 3: triggers voice input
          Container(
            width: 44, height: 44,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: NovaTheme.surfaceLight),
            ),
            child: IconButton(
              icon: const Icon(Icons.mic, color: NovaTheme.accent, size: 20),
              onPressed: () {
                // TODO Phase 3: start STT
              },
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: _ctrl,
              style: const TextStyle(color: NovaTheme.textPrimary),
              decoration: const InputDecoration(
                hintText: "Tell Nova something...",
                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              onSubmitted: (_) => _submit(),
              textInputAction: TextInputAction.send,
            ),
          ),
          const SizedBox(width: 8),
          AnimatedOpacity(
            opacity: _hasText ? 1.0 : 0.4,
            duration: const Duration(milliseconds: 200),
            child: GestureDetector(
              onTap: _hasText ? _submit : null,
              child: Container(
                width: 44, height: 44,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: _hasText ? NovaTheme.accentGradient : null,
                  color: _hasText ? null : NovaTheme.surfaceLight,
                ),
                child: const Icon(Icons.arrow_upward, color: Colors.white, size: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
