import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

/// A service that handles caching of doctor data
/// to reduce API calls and improve performance.
class DoctorCacheService {
  // Keys used for storing data in SharedPreferences
  static const String _doctorsListCacheKey = 'doctors_list_cache';
  static const String _doctorsListCacheTimeKey = 'doctors_list_cache_time';
  static const String _doctorDetailsCacheKeyPrefix = 'doctor_details_';
  static const String _doctorDetailsCacheTimeKeyPrefix = 'doctor_details_time_';

  // Cache expiration time (in milliseconds)
  // Default to 1 hour for list, 2 hours for individual doctors
  static const int _listCacheExpirationMs = 60 * 60 * 1000;
  static const int _detailsCacheExpirationMs = 2 * 60 * 60 * 1000;

  /// Saves a list of doctors to cache
  static Future<void> cacheDoctorsList(List<dynamic> doctors) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      await prefs.setString(_doctorsListCacheKey, jsonEncode(doctors));
      await prefs.setInt(
        _doctorsListCacheTimeKey,
        DateTime.now().millisecondsSinceEpoch,
      );

      print('Doctors list cached successfully (${doctors.length} doctors)');
    } catch (e) {
      print('Error caching doctors list: $e');
    }
  }

  /// Retrieves cached list of doctors
  /// Returns null if cache is expired or not available
  static Future<List<dynamic>?> getCachedDoctorsList() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      final cachedTime = prefs.getInt(_doctorsListCacheTimeKey);
      final doctorsJson = prefs.getString(_doctorsListCacheKey);

      if (cachedTime == null || doctorsJson == null) {
        print('No cached doctors list found');
        return null;
      }

      final currentTime = DateTime.now().millisecondsSinceEpoch;
      if (currentTime - cachedTime > _listCacheExpirationMs) {
        print('Cached doctors list expired');
        return null;
      }

      final List<dynamic> doctors = jsonDecode(doctorsJson);
      print('Retrieved ${doctors.length} doctors from cache');
      return doctors;
    } catch (e) {
      print('Error retrieving cached doctors list: $e');
      return null;
    }
  }

  /// Caches details for a specific doctor
  static Future<void> cacheDoctorDetails(
    int doctorId,
    Map<String, dynamic> doctorDetails,
  ) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      await prefs.setString(
        '$_doctorDetailsCacheKeyPrefix$doctorId',
        jsonEncode(doctorDetails),
      );
      await prefs.setInt(
        '$_doctorDetailsCacheTimeKeyPrefix$doctorId',
        DateTime.now().millisecondsSinceEpoch,
      );

      print('Doctor details cached successfully for doctor ID: $doctorId');
    } catch (e) {
      print('Error caching doctor details: $e');
    }
  }

  /// Retrieves cached details for a specific doctor
  /// Returns null if cache is expired or not available
  static Future<Map<String, dynamic>?> getCachedDoctorDetails(
    int doctorId,
  ) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      final cachedTime = prefs.getInt(
        '$_doctorDetailsCacheTimeKeyPrefix$doctorId',
      );
      final doctorJson = prefs.getString(
        '$_doctorDetailsCacheKeyPrefix$doctorId',
      );

      if (cachedTime == null || doctorJson == null) {
        print('No cached doctor details found for ID: $doctorId');
        return null;
      }

      final currentTime = DateTime.now().millisecondsSinceEpoch;
      if (currentTime - cachedTime > _detailsCacheExpirationMs) {
        print('Cached doctor details expired for ID: $doctorId');
        return null;
      }

      final Map<String, dynamic> doctor = jsonDecode(doctorJson);
      print('Retrieved doctor details from cache for ID: $doctorId');
      return doctor;
    } catch (e) {
      print('Error retrieving cached doctor details: $e');
      return null;
    }
  }

  /// Clears all doctor cache data
  static Future<void> clearAllDoctorCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Get all keys
      final keys = prefs.getKeys();

      // Filter and remove doctor-related keys
      for (var key in keys) {
        if (key == _doctorsListCacheKey ||
            key == _doctorsListCacheTimeKey ||
            key.startsWith(_doctorDetailsCacheKeyPrefix) ||
            key.startsWith(_doctorDetailsCacheTimeKeyPrefix)) {
          await prefs.remove(key);
        }
      }

      print('All doctor cache cleared');
    } catch (e) {
      print('Error clearing doctor cache: $e');
    }
  }
}
