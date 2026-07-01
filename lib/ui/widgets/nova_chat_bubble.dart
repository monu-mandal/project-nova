import 'package:flutter/material.dart';
import '../theme/nova_theme.dart';

class NovaChatBubble extends StatelessWidget {
  final String role;
  final String content;
  final bool isTyping;

  const NovaChatBubble({
    super.key,
    required this.role,
    required this.content,
    this.isTyping = false,
  });

  bool get isNova => role == 'nova';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: isNova ? MainAxisAlignment.start : MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (isNova) ...[
            _novaAvatar(),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: isNova ? NovaTheme.surface : NovaTheme.accent.withOpacity(0.15),
                borderRadius: BorderRadius.only(
                  topLeft:     const Radius.circular(16),
                  topRight:    const Radius.circular(16),
                  bottomLeft:  Radius.circular(isNova ? 4 : 16),
                  bottomRight: Radius.circular(isNova ? 16 : 4),
                ),
                border: isNova
                    ? Border.all(color: NovaTheme.surfaceLight, width: 1)
                    : Border.all(color: NovaTheme.accent.withOpacity(0.3), width: 1),
              ),
              child: isTyping
                  ? _typingIndicator()
                  : Text(
                      content,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: isNova ? NovaTheme.textPrimary : NovaTheme.textPrimary,
                      ),
                    ),
            ),
          ),
          if (!isNova) const SizedBox(width: 8),
        ],
      ),
    );
  }

  Widget _novaAvatar() {
    return Container(
      width: 28,
      height: 28,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: NovaTheme.accentGradient,
      ),
      child: const Center(
        child: Text("✦", style: TextStyle(fontSize: 12, color: Colors.white)),
      ),
    );
  }

  Widget _typingIndicator() {
    return const Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _Dot(delay: 0),
        SizedBox(width: 4),
        _Dot(delay: 200),
        SizedBox(width: 4),
        _Dot(delay: 400),
      ],
    );
  }
}

class _Dot extends StatefulWidget {
  final int delay;
  const _Dot({required this.delay});
  @override
  State<_Dot> createState() => _DotState();
}

class _DotState extends State<_Dot> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 600));
    _anim = Tween<double>(begin: 0.4, end: 1.0).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut),
    );
    Future.delayed(Duration(milliseconds: widget.delay), () {
      if (mounted) _ctrl.repeat(reverse: true);
    });
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (_, __) => Opacity(
        opacity: _anim.value,
        child: Container(
          width: 6, height: 6,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: NovaTheme.accent,
          ),
        ),
      ),
    );
  }
}
