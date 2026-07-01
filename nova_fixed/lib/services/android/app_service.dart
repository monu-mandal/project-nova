import 'package:android_intent_plus/android_intent.dart';
import 'package:device_apps/device_apps.dart';

/// Manages app launching, listing, and uninstalling.
class AppService {
  AppService._();
  static final AppService instance = AppService._();

  // Common app package names
  static const Map<String, String> _knownApps = {
    'spotify':   'com.spotify.music',
    'youtube':   'com.google.android.youtube',
    'whatsapp':  'com.whatsapp',
    'telegram':  'org.telegram.messenger',
    'chrome':    'com.android.chrome',
    'instagram': 'com.instagram.android',
    'twitter':   'com.twitter.android',
    'x':         'com.twitter.android',
    'tiktok':    'com.zhiliaoapp.musically',
    'netflix':   'com.netflix.mediaclient',
    'camera':    'android.media.action.IMAGE_CAPTURE',
    'settings':  'com.android.settings',
    'maps':      'com.google.android.apps.maps',
    'gmail':     'com.google.android.gm',
    'photos':    'com.google.android.apps.photos',
    'calculator':'com.android.calculator2',
    'clock':     'com.android.deskclock',
    'files':     'com.google.android.documentsui',
  };

  /// Launch an app by fuzzy name (e.g. "spotify", "whatsapp")
  Future<bool> openApp(String appName) async {
    final lower = appName.toLowerCase().trim();

    // Check known apps first
    final package = _knownApps[lower];
    if (package != null) {
      return await DeviceApps.openApp(package);
    }

    // Search installed apps by name
    final apps = await DeviceApps.getInstalledApplications(
      includeAppIcons: false,
      includeSystemApps: false,
      onlyAppsWithLaunchIntent: true,
    );
    final match = apps.firstWhere(
      (a) => a.appName.toLowerCase().contains(lower),
      orElse: () => apps.first, // fallback — won't match
    );
    if (match.appName.toLowerCase().contains(lower)) {
      return await DeviceApps.openApp(match.packageName);
    }

    return false; // App not found
  }

  /// Uninstall an app by name
  Future<void> uninstallApp(String appName) async {
    final lower = appName.toLowerCase().trim();
    final package = _knownApps[lower];
    if (package != null) {
      final intent = AndroidIntent(
        action: 'android.intent.action.DELETE',
        data: 'package:$package',
      );
      await intent.launch();
      return;
    }
    // Search by name
    final apps = await DeviceApps.getInstalledApplications(
      includeSystemApps: false,
      onlyAppsWithLaunchIntent: true,
    );
    for (final app in apps) {
      if (app.appName.toLowerCase().contains(lower)) {
        final intent = AndroidIntent(
          action: 'android.intent.action.DELETE',
          data: 'package:${app.packageName}',
        );
        await intent.launch();
        return;
      }
    }
  }

  /// List all installed user apps
  Future<List<Application>> getInstalledApps() async {
    return await DeviceApps.getInstalledApplications(
      includeSystemApps: false,
      onlyAppsWithLaunchIntent: true,
    );
  }
}
