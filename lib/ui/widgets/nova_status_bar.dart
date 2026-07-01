import 'package:flutter/material.dart';
import '../../services/connectivity/connectivity_service.dart';
import '../theme/nova_theme.dart';

class NovaStatusBar extends StatefulWidget {
  const NovaStatusBar({super.key});
  @override
  State<NovaStatusBar> createState() => _NovaStatusBarState();
}

class _NovaStatusBarState extends State<NovaStatusBar> {
  bool _online = false;

  @override
  void initState() {
    super.initState();
    _checkConnectivity();
    ConnectivityService.instance.onConnectivityChanged.listen((_) => _checkConnectivity());
  }

  Future<void> _checkConnectivity() async {
    final online = await ConnectivityService.instance.isOnline();
    setState(() => _online = online);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
        child: Row(
          children: [
            ShaderMask(
              shaderCallback: (b) => NovaTheme.accentGradient.createShader(b),
              child: const Text(
                "NOVA",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 4,
                ),
              ),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: (_online ? NovaTheme.accent : NovaTheme.error).withOpacity(0.15),
                border: Border.all(
                  color: _online ? NovaTheme.accent : NovaTheme.error,
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 6, height: 6,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _online ? NovaTheme.accent : NovaTheme.error,
                    ),
                  ),
                  const SizedBox(width: 5),
                  Text(
                    _online ? "online" : "offline",
                    style: TextStyle(
                      color: _online ? NovaTheme.accent : NovaTheme.error,
                      fontSize: 11,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
