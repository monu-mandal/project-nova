import 'package:android_intent_plus/android_intent.dart';
import '../connectivity/connectivity_service.dart';

/// Handles all media commands.
/// Online: launches Spotify / YouTube.
/// Offline: launches local music app.
class MediaService {
  MediaService._();
  static final MediaService instance = MediaService._();

  Future<void> playMusic(String query) async {
    final online = await ConnectivityService.instance.isOnline();

    if (online) {
      await _playOnSpotify(query);
    } else {
      await _playOnLocalMusic(query);
    }
  }

  Future<void> _playOnSpotify(String query) async {
    // Try Spotify deep link first
    final intent = AndroidIntent(
      action: 'android.intent.action.VIEW',
      data: 'spotify:search:$query',
      package: 'com.spotify.music',
    );
    try {
      await intent.launch();
    } catch (_) {
      // Spotify not installed — fall back to YouTube
      await _playOnYouTube(query);
    }
  }

  Future<void> _playOnYouTube(String query) async {
    final encoded = Uri.encodeComponent(query);
    final intent = AndroidIntent(
      action: 'android.intent.action.VIEW',
      data: 'https://www.youtube.com/results?search_query=$encoded',
    );
    await intent.launch();
  }

  Future<void> _playOnLocalMusic(String query) async {
    // Open default music player with search
    final intent = AndroidIntent(
      action: 'android.intent.action.PICK',
      type: 'audio/*',
    );
    try {
      await intent.launch();
    } catch (_) {
      // Try generic media intent
      final fallback = AndroidIntent(
        action: 'android.intent.action.MUSIC_PLAYER',
      );
      await fallback.launch();
    }
  }

  Future<void> controlPlayback(String action) async {
    // TODO Phase 5: use MediaSession API via platform channel
    // actions: play, pause, skip, previous
  }
}
