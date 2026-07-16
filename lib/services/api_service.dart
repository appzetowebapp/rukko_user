import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:webview_master_app/config/app_config.dart';
import 'package:webview_master_app/utils/prefs_util.dart';
import 'dart:io' show Platform;

/// API Service - Handles all API calls to the backend
class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  /// Get the full API URL for an endpoint
  String _getApiUrl(String endpoint) {
    // Remove leading slash if present to avoid double slashes
    final cleanEndpoint =
        endpoint.startsWith('/') ? endpoint.substring(1) : endpoint;
    return '${AppConfig.apiBaseUrl}/$cleanEndpoint';
  }

  /// Save FCM token to backend
  ///
  /// [token] - The FCM token to save
  /// [phone] - Phone number (10-digit without +91)
  /// [platform] - Platform identifier (defaults to "android" for Android)
  ///
  /// Returns true if successful, false otherwise
  Future<bool> saveFCMToken({
    required String token,
    String? platform,
  }) async {
    try {
      // Determine platform if not provided
      final platformValue =
          platform ?? (Platform.isAndroid ? 'app' : 'app');

      // Validate token
      if (token.isEmpty) {
        debugPrint('❌ FCM token is empty');
        return false;
      }

      final url = _getApiUrl('/users/fcm-token');

      debugPrint('📤 Saving FCM token to: $url');

      final accessToken = PrefsUtil.getAccessToken();
      final headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };

      if (accessToken != null && accessToken.isNotEmpty) {
        headers['Authorization'] = 'Bearer $accessToken';
        debugPrint('🔑 Using Access Token for FCM update: ${accessToken.substring(0, 10)}...');
      } else {
        debugPrint('⚠️ No Access Token available for FCM update');
      }

      final requestBody = {
        'fcmToken': token,
        'platform': platformValue, // Use provided or default 'app'
      };

      final response = await http
          .put(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode(requestBody),
      )
          .timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          debugPrint('❌ Request timeout while saving FCM token');
          throw Exception('Request timeout');
        },
      );

      debugPrint('📥 Request Body: $requestBody');
      debugPrint('📥 Response Status: ${response.statusCode}');

      if (response.statusCode >= 200 && response.statusCode < 300) {
        debugPrint('✅ FCM token updated successfully');
        return true;
      } else {
        debugPrint(
            '❌ Failed to update FCM token. Status: ${response.statusCode}');
        debugPrint('❌ Error Body: ${response.body}');
        return false;
      }
    } catch (e, stackTrace) {
      debugPrint('❌ Error saving FCM token: $e');
      debugPrint('❌ Stack trace: $stackTrace');
      return false;
    }
  }
}

