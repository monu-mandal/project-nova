/// Intent types Nova can handle.
enum NovaIntent {
  // Media
  playMusic,
  pauseMusic,
  stopMusic,
  skipSong,

  // Connectivity
  wifiOn, wifiOff,
  bluetoothOn, bluetoothOff,
  dataOn, dataOff,

  // Apps
  openApp,
  installApp,
  uninstallApp,

  // Communication
  sendSms,
  makeCall,
  sendWhatsapp,

  // System
  setAlarm,
  setReminder,
  setVolume,
  setBrightness,
  takeScreenshot,
  readBattery,

  // Web
  webSearch,
  getWeather,
  getNews,

  // Nova core
  novaHide,
  novaShow,
  memorize,
  recall,

  // Fallback — handled by LLM
  conversation,
}

/// Parsed command from user input.
class ParsedIntent {
  final NovaIntent intent;
  final Map<String, String> params; // e.g. {song: "Run Rabbit", app: "Spotify"}
  final String rawInput;
  final double confidence;

  const ParsedIntent({
    required this.intent,
    required this.rawInput,
    this.params = const {},
    this.confidence = 1.0,
  });
}

/// Routes raw text commands to structured intents.
/// This is a keyword-based fast router — no LLM needed for common commands.
/// Complex / ambiguous input falls through to LLM conversation.
class IntentRouter {
  IntentRouter._();
  static final IntentRouter instance = IntentRouter._();

  ParsedIntent route(String input) {
    final text = input.toLowerCase().trim();

    // ── Hide / Show ─────────────────────────────────────────
    if (text == 'nova hide' || text == 'hide') {
      return ParsedIntent(intent: NovaIntent.novaHide, rawInput: input);
    }

    // ── Media ───────────────────────────────────────────────
    if (_matches(text, ['play', 'put on', 'start playing'])) {
      final song = _extractAfter(text, ['play', 'put on', 'start playing']);
      return ParsedIntent(
        intent: NovaIntent.playMusic,
        rawInput: input,
        params: {'query': song},
      );
    }
    if (_matches(text, ['pause', 'stop music', 'pause music'])) {
      return ParsedIntent(intent: NovaIntent.pauseMusic, rawInput: input);
    }
    if (_matches(text, ['skip', 'next song'])) {
      return ParsedIntent(intent: NovaIntent.skipSong, rawInput: input);
    }

    // ── Connectivity ─────────────────────────────────────────
    if (_matches(text, ['turn on wifi', 'enable wifi', 'wifi on'])) {
      return ParsedIntent(intent: NovaIntent.wifiOn, rawInput: input);
    }
    if (_matches(text, ['turn off wifi', 'disable wifi', 'wifi off'])) {
      return ParsedIntent(intent: NovaIntent.wifiOff, rawInput: input);
    }
    if (_matches(text, ['turn on bluetooth', 'bluetooth on', 'enable bluetooth'])) {
      return ParsedIntent(intent: NovaIntent.bluetoothOn, rawInput: input);
    }
    if (_matches(text, ['turn off bluetooth', 'bluetooth off', 'disable bluetooth'])) {
      return ParsedIntent(intent: NovaIntent.bluetoothOff, rawInput: input);
    }

    // ── Apps ─────────────────────────────────────────────────
    if (_matches(text, ['open', 'launch', 'start'])) {
      final app = _extractAfter(text, ['open', 'launch', 'start']);
      return ParsedIntent(
        intent: NovaIntent.openApp,
        rawInput: input,
        params: {'app': app},
      );
    }
    if (_matches(text, ['uninstall', 'remove app', 'delete app'])) {
      final app = _extractAfter(text, ['uninstall', 'remove app', 'delete app']);
      return ParsedIntent(
        intent: NovaIntent.uninstallApp,
        rawInput: input,
        params: {'app': app},
      );
    }

    // ── Communication ────────────────────────────────────────
    if (_matches(text, ['call', 'phone', 'ring'])) {
      final contact = _extractAfter(text, ['call', 'phone', 'ring']);
      return ParsedIntent(
        intent: NovaIntent.makeCall,
        rawInput: input,
        params: {'contact': contact},
      );
    }
    if (_matches(text, ['text', 'send message', 'sms'])) {
      return ParsedIntent(intent: NovaIntent.sendSms, rawInput: input);
    }

    // ── System ───────────────────────────────────────────────
    if (_matches(text, ['set alarm', 'wake me'])) {
      return ParsedIntent(intent: NovaIntent.setAlarm, rawInput: input);
    }
    if (_matches(text, ['remind me', 'set reminder'])) {
      return ParsedIntent(intent: NovaIntent.setReminder, rawInput: input);
    }
    if (_matches(text, ['battery', 'how much battery'])) {
      return ParsedIntent(intent: NovaIntent.readBattery, rawInput: input);
    }
    if (_matches(text, ['screenshot', 'take screenshot'])) {
      return ParsedIntent(intent: NovaIntent.takeScreenshot, rawInput: input);
    }

    // ── Web ──────────────────────────────────────────────────
    if (_matches(text, ['search', 'look up', 'google', 'find'])) {
      final query = _extractAfter(text, ['search', 'look up', 'google', 'find']);
      return ParsedIntent(
        intent: NovaIntent.webSearch,
        rawInput: input,
        params: {'query': query},
      );
    }
    if (_matches(text, ['weather', "what's the weather", 'temperature'])) {
      return ParsedIntent(intent: NovaIntent.getWeather, rawInput: input);
    }

    // ── Memory ───────────────────────────────────────────────
    if (_matches(text, ['remember that', 'remember my', 'note that'])) {
      final fact = _extractAfter(text, ['remember that', 'remember my', 'note that']);
      return ParsedIntent(
        intent: NovaIntent.memorize,
        rawInput: input,
        params: {'fact': fact},
      );
    }

    // ── Fallback to LLM ──────────────────────────────────────
    return ParsedIntent(
      intent: NovaIntent.conversation,
      rawInput: input,
      confidence: 0.5,
    );
  }

  bool _matches(String text, List<String> keywords) {
    return keywords.any((k) => text.contains(k));
  }

  String _extractAfter(String text, List<String> keywords) {
    for (final k in keywords) {
      if (text.contains(k)) {
        final idx = text.indexOf(k) + k.length;
        return text.substring(idx).trim();
      }
    }
    return text;
  }
}
