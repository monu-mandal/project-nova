import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'core/memory/nova_memory.dart';
import 'ui/screens/home_screen.dart';
import 'ui/screens/overlay_screen.dart';
import 'ui/theme/nova_theme.dart';

/// Nova entry point.
/// The app runs in two modes:
///   1. Normal mode  — main UI, settings, chat history
///   2. Overlay mode — Furina floating over other apps
@pragma('vm:entry-point')
void overlayMain() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const NovaOverlayApp());
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Lock to portrait
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  // Boot memory system
  await NovaMemory.instance.init();

  runApp(const NovaApp());
}

// ─── Main App ────────────────────────────────────────────────────────────────

class NovaApp extends StatelessWidget {
  const NovaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nova',
      debugShowCheckedModeBanner: false,
      theme: NovaTheme.dark(),
      home: const HomeScreen(),
    );
  }
}

// ─── Overlay App ─────────────────────────────────────────────────────────────

class NovaOverlayApp extends StatelessWidget {
  const NovaOverlayApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: NovaTheme.dark(),
      home: const OverlayScreen(),
    );
  }
}
