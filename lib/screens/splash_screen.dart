import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;
import 'package:webview_master_app/config/app_config.dart';
import 'package:webview_master_app/utils/prefs_util.dart';
import 'package:webview_master_app/utils/status_bar_util.dart';
import 'package:webview_master_app/utils/permission_handler_util.dart';
import 'package:webview_master_app/utils/notification_service.dart';

import 'package:webview_master_app/screens/webview_screen.dart';

/// Splash Screen - Shows logo and app name for configured duration
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateAfterDelay();
  }

  Future<void> _navigateAfterDelay() async {
    // Total duration slightly longer than animation to enjoy the view
    await Future.delayed(
      const Duration(seconds: AppConfig.splashDurationSeconds),
    );

    if (!mounted) return;

    // Request permissions early for better UX
    await _requestInitialPermissions();

    // Navigate directly to WebViewScreen
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const WebViewScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 800),
      ),
    );
  }

  /// Request initial permissions during splash
  Future<void> _requestInitialPermissions() async {
    if (!mounted) return;
    try {
      await PermissionHandlerUtil.requestAllPermissions();
    } catch (e) {
      debugPrint('Initial permission request: $e');
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Set system UI to immersive
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
    );

    return Scaffold(
      backgroundColor: Colors.black, // Dark background while loading GIF
      body: SizedBox.expand(
        child: Image.asset(
          AppConfig.splashGifPath,
          fit: BoxFit.cover, // Fill the entire screen
        ),
      ),
    );
  }
}
