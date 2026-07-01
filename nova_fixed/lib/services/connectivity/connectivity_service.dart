import 'package:connectivity_plus/connectivity_plus.dart';

/// Detects online/offline status and routes commands accordingly.
/// Nova uses this to decide: "do I use Spotify or local music?"
class ConnectivityService {
  ConnectivityService._();
  static final ConnectivityService instance = ConnectivityService._();

  final Connectivity _connectivity = Connectivity();

  Future<bool> isOnline() async {
    final result = await _connectivity.checkConnectivity();
    return result.any((r) =>
      r == ConnectivityResult.wifi ||
      r == ConnectivityResult.mobile ||
      r == ConnectivityResult.ethernet,
    );
  }

  Stream<List<ConnectivityResult>> get onConnectivityChanged =>
      _connectivity.onConnectivityChanged;
}
