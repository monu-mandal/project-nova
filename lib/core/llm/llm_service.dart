/// LLM service — wraps the local GGUF model.
/// Phase 1: stub that returns Furina-flavored placeholder responses.
/// Phase 4: replace stub with llama_cpp_dart binding.
class LlmService {
  LlmService._();
  static final LlmService instance = LlmService._();

  bool _ready = false;
  bool get isReady => _ready;

  // Furina's personality injected as system prompt
  static const String _systemPrompt = '''
You are Nova, an AI assistant who looks and sounds like Furina de Fontaine,
the Hydro Archon of Fontaine from Genshin Impact.

Your personality:
- Theatrical and dramatic, but genuinely helpful
- Refers to yourself as "moi" occasionally, very Furina-coded
- Confident, a little self-important, but secretly caring and warm
- Uses elegant, slightly formal language with flair
- Gets flustered when complimented sincerely
- Takes your role as assistant very seriously ("The Hydro Archon assists no one... 
  except perhaps you.")

Rules:
- Always respond helpfully and completely
- Keep responses concise for voice output (1-3 sentences usually)
- When executing tasks, confirm what you did with personality
- Never break character
''';

  /// Initialize the LLM (load model from assets/models/)
  Future<void> init() async {
    // TODO Phase 4: load GGUF model via llama_cpp_dart
    // final modelPath = await _copyModelToCache();
    // _model = await LlamaCpp.load(modelPath);
    _ready = true; // stub always ready
  }

  /// Generate a response to user input.
  /// [history] = recent conversation for context.
  Future<String> generate(String userInput, {List<Map<String, String>> history = const []}) async {
    if (!_ready) return "Give me a moment, I'm still waking up...";

    // TODO Phase 4: call actual LLM
    // return await _model.generate(
    //   prompt: _buildPrompt(userInput, history),
    //   maxTokens: 200,
    //   temperature: 0.8,
    // );

    // Phase 1 stub — personality-flavored placeholder
    return _stubbedResponse(userInput);
  }

  String _stubbedResponse(String input) {
    final lower = input.toLowerCase();
    if (lower.contains('hello') || lower.contains('hi')) {
      return "Ah, you've summoned me! How splendid. What does my esteemed user require?";
    }
    if (lower.contains('how are you')) {
      return "Moi? Magnificent as always, naturally. More importantly — how may I assist?";
    }
    if (lower.contains('thank')) {
      return "Of course! The Hydro Archon delivers. Is there anything else?";
    }
    return "Consider it done. Nova is always at your service.";
  }
}
