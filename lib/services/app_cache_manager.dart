import 'doctor_cache_service.dart';
import 'user_cache_service.dart';

/// A utility class for managing application cache across different services
class AppCacheManager {
  /// Clears all application caches
  static Future<void> clearAllCaches() async {
    await UserCacheService.clearUserCache();
    await DoctorCacheService.clearAllDoctorCache();
    print('All application caches cleared');
  }

  /// Clears only doctor-related caches
  static Future<void> clearDoctorCaches() async {
    await DoctorCacheService.clearAllDoctorCache();
    print('Doctor caches cleared');
  }

  /// Clears only user-related caches
  static Future<void> clearUserCaches() async {
    await UserCacheService.clearUserCache();
    print('User caches cleared');
  }
}
