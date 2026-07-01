import 'package:flutter_overlay_window/flutter_overlay_window.dart';
import 'package:flutter/material.dart';

/// Controls Furina's floating overlay on Android.
/// "Nova" → she appears. "Nova hide" → she vanishes.
class OverlayService {
  OverlayService._();
  static final OverlayService instance = OverlayService._();

  bool _isShowing = false;
  bool get isShowing => _isShowing;

  /// Request SYSTEM_ALERT_WINDOW permission from user.
  Future<bool> requestPermission() async {
    final granted = await FlutterOverlayWindow.isPermissionGranted();
    if (!granted) {
      await FlutterOverlayWindow.requestPermission();
      return await FlutterOverlayWindow.isPermissionGranted();
    }
    return true;
  }

  /// Show Furina on screen (animated entrance).
  Future<void> show() async {
    if (_isShowing) return;
    final hasPermission = await FlutterOverlayWindow.isPermissionGranted();
    if (!hasPermission) {
      await requestPermission();
      return;
    }
    await FlutterOverlayWindow.showOverlay(
      enableDrag: true,
      overlayTitle: "Nova",
      overlayContent: "Nova is listening...",
      flag: OverlayFlag.defaultFlag,
      visibility: NotificationVisibility.visibilityPublic,
      positionGravity: PositionGravity.auto,
      height: 280,
      width: 180,
      alignment: OverlayAlignment.topCenter,
    );
    _isShowing = true;
  }

  /// Hide Furina from screen (animated exit).
  Future<void> hide() async {
    if (!_isShowing) return;
    await FlutterOverlayWindow.closeOverlay();
    _isShowing = false;
  }

  /// Send data to the overlay widget (e.g. trigger animation state).
  Future<void> sendToOverlay(Map<String, dynamic> data) async {
    await FlutterOverlayWindow.shareData(data);
  }

  /// Listen for data sent back from overlay to main app.
  Stream<dynamic> get overlayStream => FlutterOverlayWindow.overlayListener;
}
