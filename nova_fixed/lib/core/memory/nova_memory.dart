import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

/// Nova's local memory system.
/// Stores: conversation history, user preferences, learned patterns, facts.
/// Fully offline. Nothing leaves the device.
class NovaMemory {
  NovaMemory._();
  static final NovaMemory instance = NovaMemory._();

  Database? _db;

  // ─── Init ────────────────────────────────────────────────────────────────

  Future<void> init() async {
    final dbPath = await getDatabasesPath();
    _db = await openDatabase(
      join(dbPath, 'nova_memory.db'),
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // Conversation history
    await db.execute('''
      CREATE TABLE messages (
        id        INTEGER PRIMARY KEY AUTOINCREMENT,
        role      TEXT NOT NULL,        -- "user" | "nova"
        content   TEXT NOT NULL,
        timestamp INTEGER NOT NULL,
        session   TEXT NOT NULL
      )
    ''');

    // Long-term facts Nova learns about the user
    await db.execute('''
      CREATE TABLE user_facts (
        id        INTEGER PRIMARY KEY AUTOINCREMENT,
        key       TEXT NOT NULL UNIQUE, -- e.g. "user_name", "favorite_song"
        value     TEXT NOT NULL,
        updated   INTEGER NOT NULL
      )
    ''');

    // User preferences (settings Nova remembers)
    await db.execute('''
      CREATE TABLE preferences (
        key   TEXT PRIMARY KEY,
        value TEXT NOT NULL
      )
    ''');

    // Learned patterns (time-based habits)
    await db.execute('''
      CREATE TABLE patterns (
        id          INTEGER PRIMARY KEY AUTOINCREMENT,
        pattern     TEXT NOT NULL,      -- e.g. "plays lofi at 22:00"
        confidence  REAL DEFAULT 0.5,
        last_seen   INTEGER NOT NULL
      )
    ''');
  }

  // ─── Messages ────────────────────────────────────────────────────────────

  Future<void> saveMessage({
    required String role,
    required String content,
    required String session,
  }) async {
    await _db!.insert('messages', {
      'role': role,
      'content': content,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
      'session': session,
    });
  }

  Future<List<Map<String, dynamic>>> getRecentMessages({
    int limit = 20,
    String? session,
  }) async {
    if (session != null) {
      return await _db!.query(
        'messages',
        where: 'session = ?',
        whereArgs: [session],
        orderBy: 'timestamp DESC',
        limit: limit,
      );
    }
    return await _db!.query('messages', orderBy: 'timestamp DESC', limit: limit);
  }

  // ─── User Facts ──────────────────────────────────────────────────────────

  Future<void> learnFact(String key, String value) async {
    await _db!.insert(
      'user_facts',
      {'key': key, 'value': value, 'updated': DateTime.now().millisecondsSinceEpoch},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<String?> getFact(String key) async {
    final rows = await _db!.query('user_facts', where: 'key = ?', whereArgs: [key]);
    return rows.isNotEmpty ? rows.first['value'] as String : null;
  }

  Future<Map<String, String>> getAllFacts() async {
    final rows = await _db!.query('user_facts');
    return {for (final r in rows) r['key'] as String: r['value'] as String};
  }

  // ─── Preferences ─────────────────────────────────────────────────────────

  Future<void> setPref(String key, String value) async {
    await _db!.insert(
      'preferences',
      {'key': key, 'value': value},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<String?> getPref(String key) async {
    final rows = await _db!.query('preferences', where: 'key = ?', whereArgs: [key]);
    return rows.isNotEmpty ? rows.first['value'] as String : null;
  }

  // ─── Patterns ────────────────────────────────────────────────────────────

  Future<void> recordPattern(String pattern) async {
    final existing = await _db!.query('patterns', where: 'pattern = ?', whereArgs: [pattern]);
    if (existing.isEmpty) {
      await _db!.insert('patterns', {
        'pattern': pattern,
        'confidence': 0.5,
        'last_seen': DateTime.now().millisecondsSinceEpoch,
      });
    } else {
      final current = existing.first['confidence'] as double;
      await _db!.update(
        'patterns',
        {
          'confidence': (current + 0.1).clamp(0.0, 1.0),
          'last_seen': DateTime.now().millisecondsSinceEpoch,
        },
        where: 'pattern = ?',
        whereArgs: [pattern],
      );
    }
  }

  Future<List<Map<String, dynamic>>> getTopPatterns({int limit = 10}) async {
    return await _db!.query('patterns', orderBy: 'confidence DESC', limit: limit);
  }
}
