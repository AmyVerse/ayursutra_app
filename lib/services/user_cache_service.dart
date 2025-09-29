import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'auth_service.dart';

/// A service that handles caching of user details
/// to reduce API calls and improve performance.
class UserCacheService {
  // Keys used for storing data in SharedPreferences
  static const String _userCacheKey = 'user_cache';
  static const String _userCacheTimeKey = 'user_cache_time';

  // Cache expiration time (in milliseconds)
  // Default to 1 hour
  static const int _cacheExpirationMs = 60 * 60 * 1000;

  /// Saves user details to cache
  static Future<void> cacheUserDetails(User user) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Convert user object to JSON string
      final Map<String, dynamic> userMap = {
        'id': user.id,
        'ayursutraId': user.ayursutraId,
        'name': user.name,
        'email': user.email,
        'phone': user.phone,
        'role': user.role,
        'emailVerified': user.emailVerified,
        'phoneVerified': user.phoneVerified,
        'createdAt': user.createdAt.toIso8601String(),
      };

      // Save user data and timestamp
      await prefs.setString(_userCacheKey, jsonEncode(userMap));
      await prefs.setInt(
        _userCacheTimeKey,
        DateTime.now().millisecondsSinceEpoch,
      );

      print('User details cached successfully');
    } catch (e) {
      print('Error caching user details: $e');
    }
  }

  /// Retrieves user details from cache
  /// Returns null if cache is expired or not available
  static Future<User?> getCachedUserDetails() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Check if cache exists and not expired
      final cachedTime = prefs.getInt(_userCacheTimeKey);
      final userJson = prefs.getString(_userCacheKey);

      if (cachedTime == null || userJson == null) {
        print('No cached user data found');
        return null;
      }

      // Check if cache is expired
      final currentTime = DateTime.now().millisecondsSinceEpoch;
      if (currentTime - cachedTime > _cacheExpirationMs) {
        print('Cached user data expired');
        return null;
      }

      // Parse and return user data
      final Map<String, dynamic> userMap = jsonDecode(userJson);
      print('Retrieved user details from cache');
      return User.fromJson(userMap);
    } catch (e) {
      print('Error retrieving cached user details: $e');
      return null;
    }
  }

  /// Clears the user cache
  static Future<void> clearUserCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_userCacheKey);
      await prefs.remove(_userCacheTimeKey);
      print('User cache cleared');
    } catch (e) {
      print('Error clearing user cache: $e');
    }
  }

  /// Checks if cached user data is available and still valid
  static Future<bool> hasCachedUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cachedTime = prefs.getInt(_userCacheTimeKey);
      final userJson = prefs.getString(_userCacheKey);

      if (cachedTime == null || userJson == null) {
        return false;
      }

      final currentTime = DateTime.now().millisecondsSinceEpoch;
      return (currentTime - cachedTime <= _cacheExpirationMs);
    } catch (e) {
      print('Error checking cached user data: $e');
      return false;
    }
  }
}
