import 'package:flutter/material.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';
import '../../core/intent/intent_router.dart';
import '../../features/overlay/overlay_service.dart';
import '../theme/nova_theme.dart';

/// The floating Furina widget that appears over other apps.
/// Phase 1: placeholder circle. Phase 3: replaced with actual sprite.
class OverlayScreen extends StatefulWidget {
  const OverlayScreen({super.key});
  @override
  State<OverlayScreen> createState() => _OverlayScreenState();
}

class _OverlayScreenState extends State<OverlayScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulse;
  String _state = 'idle'; // idle | listening | talking | walking
  bool _listening = false;

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);

    // Listen for commands from main app
    FlutterOverlayWindow.overlayListener.listen((data) {
      if (data is Map && data['state'] != null) {
        setState(() => _state = data['state']);
      }
    });
  }

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: GestureDetector(
        onTap: _onTap,
        child: AnimatedBuilder(
          animation: _pulse,
          builder: (ctx, child) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // ── Furina sprite placeholder ──────────────────────────
                // Phase 3: replace Container with SpriteWidget(state: _state)
                Container(
                  width: 120,
                  height: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    // Glow effect while listening
                    boxShadow: _listening
                        ? [
                            BoxShadow(
                              color: NovaTheme.accent.withOpacity(0.3 + 0.2 * _pulse.value),
                              blurRadius: 20,
                              spreadRadius: 4,
                            ),
                          ]
                        : [],
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Sprite goes here in Phase 3
                        Text(
                          "✦",
                          style: TextStyle(
                            fontSize: 48,
                            color: Color.lerp(
                              NovaTheme.accent,
                              NovaTheme.accentGlow,
                              _pulse.value,
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Nova",
                          style: const TextStyle(
                            color: NovaTheme.textSecondary,
                            fontSize: 11,
                            letterSpacing: 1.5,
                          ),
                        ),
                        Text(
                          _stateLabel(),
                          style: const TextStyle(
                            color: NovaTheme.accent,
                            fontSize: 9,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  String _stateLabel() {
    switch (_state) {
      case 'listening': return '● listening';
      case 'talking':   return '♪ speaking';
      case 'walking':   return '~ moving';
      default:          return '· idle';
    }
  }

  void _onTap() {
    setState(() => _listening = !_listening);
    // TODO Phase 3: trigger listening animation + wake STT
  }
}
